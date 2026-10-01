# ==============================================================================
# build_dictionary.R
# Compile le dictionnaire de données à partir des tags "# @dict:" trouvés
# dans tous les scripts sous scripts/. Ne lit et ne touche jamais aux données.
#
# Convention (une ligne par variable, placée au-dessus du code qui la crée) :
#   # @dict: NOM_VARIABLE | Description | Domaine de valeurs | Fichier(s) source | Variable(s) source
#
# Thème      = premier sous-dossier sous scripts/
# Sous-thème = deuxième sous-dossier sous scripts/, s'il existe
# ==============================================================================

library(fs)
library(stringr)
library(dplyr)
library(purrr)
library(readr)
library(jsonlite)

TAG_PREFIX  <- "# @dict:"
SCRIPTS_DIR <- "scripts"

blank <- function(x) ifelse(is.na(x), "", x)

parse_dict_line <- function(line) {
  content <- str_trim(str_remove(line, fixed(TAG_PREFIX)))
  parts   <- str_trim(str_split(content, "\\|")[[1]])
  length(parts) <- 5  # complete avec NA si des champs manquent
  tibble(
    variable         = parts[1],
    description      = parts[2],
    domaine_valeurs  = parts[3],
    fichier_origine  = parts[4],
    variables_source = parts[5]
  )
}

extract_theme <- function(path, scripts_dir = SCRIPTS_DIR) {
  segs <- as.character(path_split(path_rel(path, scripts_dir))[[1]])
  list(
    theme      = if (length(segs) >= 2) segs[1] else NA_character_,
    sous_theme = if (length(segs) >= 3) segs[2] else NA_character_
  )
}

parse_script <- function(path) {
  lines   <- read_lines(path)
  tag_idx <- which(str_starts(str_trim(lines), fixed(TAG_PREFIX)))
  if (length(tag_idx) == 0) return(NULL)

  rows  <- map_dfr(tag_idx, ~ parse_dict_line(lines[.x]))
  theme <- extract_theme(path)

  rows %>%
    mutate(theme = theme$theme, sous_theme = theme$sous_theme,
           script = path_rel(path, SCRIPTS_DIR), .before = 1)
}

# ---- Construction -------------------------------------------------------
scripts <- dir_ls(SCRIPTS_DIR, recurse = TRUE, glob = "*.R", type = "file")
scripts <- scripts[!str_detect(scripts, "_template")]

dictionnaire <- map_dfr(scripts, parse_script)

if (nrow(dictionnaire) == 0) {
  stop("Aucun tag '# @dict:' trouvé sous scripts/. Rien à compiler.")
}

dictionnaire <- dictionnaire %>% arrange(theme, sous_theme, variable)

# ---- Controles minimaux --------------------------------------------------
dir_create("dictionnaire")

manquants <- dictionnaire %>%
  filter(is.na(variable) | variable == "" | is.na(description) | description == "")
if (nrow(manquants) > 0) {
  write_csv(manquants, "dictionnaire/tags_incomplets.csv")
  warning(sprintf("%d tag(s) incomplet(s) : voir dictionnaire/tags_incomplets.csv", nrow(manquants)))
}

doublons <- dictionnaire %>% count(variable) %>% filter(n > 1)
if (nrow(doublons) > 0) {
  message("Variable(s) documentee(s) dans plus d'un script (normal si reutilisees) : ",
          paste(doublons$variable, collapse = ", "))
}

# ---- Ecriture des sorties -------------------------------------------------
write_json(dictionnaire, "dictionnaire/dictionnaire.json", pretty = TRUE, na = "null")
write_csv(dictionnaire, "dictionnaire/dictionnaire.csv", na = "")

md <- c("# Dictionnaire de donnees", "",
        paste0("_Genere automatiquement le ", Sys.Date(),
               " a partir des scripts sous `scripts/`. Ne pas editer a la main._"), "")

# Table des matieres : libelle lisible par theme, nom du dossier sinon
THEME_LABELS <- c(
  "education"          = "Éducation",
  "enquetes"           = "Enquêtes",
  "sante-physique"     = "Santé physique",
  "services"           = "Services",
  "sociodemographique" = "Sociodémographique"
)
themes <- sort(unique(dictionnaire$theme))
labels <- ifelse(themes %in% names(THEME_LABELS), THEME_LABELS[themes], themes)
md <- c(md, "**Table des matières**", "",
        sprintf("- [%s](#%s)", labels, themes), "")

for (th in themes) {
  bloc <- filter(dictionnaire, theme == th)
  md <- c(md, paste0("## ", th), "",
          "| Variable | Description | Domaine de valeurs | Fichier source | Variable(s) source | Script |",
          "|---|---|---|---|---|---|",
          pmap_chr(bloc, function(variable, description, domaine_valeurs,
                                   fichier_origine, variables_source, script, ...) {
            sprintf("| `%s` | %s | %s | %s | %s | [%s](../scripts/%s) |",
                    variable, blank(description), blank(domaine_valeurs),
                    blank(fichier_origine), blank(variables_source),
                    basename(script), script)
          }),
          "")
}
writeLines(md, "dictionnaire/dictionnaire.md")

cat(sprintf("Dictionnaire compile : %d variable(s), %d script(s).\n",
            nrow(dictionnaire), length(scripts)))
cat("Fichiers ecrits : dictionnaire/dictionnaire.json, .csv, .md\n")
