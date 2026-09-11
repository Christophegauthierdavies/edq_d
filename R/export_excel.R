# ==============================================================================
# export_excel.R
# Construit dictionnaire/dictionnaire.xlsx a partir de dictionnaire/dictionnaire.json
# (produit par build_dictionary.R). Un onglet "Toutes les variables" + un
# onglet par theme.
# ==============================================================================

library(openxlsx)
library(jsonlite)
library(dplyr)

dictionnaire <- fromJSON("dictionnaire/dictionnaire.json") %>% as_tibble()

cols <- c("variable", "description", "domaine_valeurs", "fichier_origine",
          "variables_source", "sous_theme", "script")
noms <- c("Nom de la variable", "Description", "Domaine de valeurs",
          "Fichier(s) d'origine", "Variable(s) source", "Sous-theme", "Script")

wb <- createWorkbook()

add_sheet <- function(wb, nom_onglet, df) {
  addWorksheet(wb, nom_onglet)
  df <- df %>% select(all_of(cols))
  names(df) <- noms
  writeData(wb, nom_onglet, df, headerStyle = createStyle(textDecoration = "bold"))
  setColWidths(wb, nom_onglet, cols = seq_along(df), widths = "auto")
  freezePane(wb, nom_onglet, firstRow = TRUE)
}

add_sheet(wb, "Toutes les variables", dictionnaire %>% arrange(theme, sous_theme, variable))

for (th in sort(unique(dictionnaire$theme))) {
  add_sheet(wb, substr(th, 1, 31),
            dictionnaire %>% filter(theme == th) %>% arrange(sous_theme, variable))
}

saveWorkbook(wb, "dictionnaire/dictionnaire.xlsx", overwrite = TRUE)
cat("Fichier ecrit : dictionnaire/dictionnaire.xlsx\n")
