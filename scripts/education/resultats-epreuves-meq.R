# ==============================================================================
# Résultats aux épreuves ministérielles (MEQ)
# Note brute obtenue à l'épreuve du ministère, par cours spécifique (CD_COURS_REF),
# pour les élèves de 4e et 5e secondaire. Plusieurs matières ont une variable
# combinée (volets anglais + français réunis) et des variables séparées par volet
# linguistique de l'épreuve.
# ==============================================================================

library(dplyr)

# df_appr : fichier de résultats aux épreuves (meq_appre_40255), une ligne par
# élève x cours x année. Variables sources : CD_COURS_REF (code de cours),
# NOTE_MINST_BRUT (note brute à l'épreuve).

#Mathématique: Technico-sciences - 4e secondaire
# @dict: Math_4e_ts | Mathématique : Technico-sciences, 4e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_ts = case_when(
    CD_COURS_REF %in% c("064420", "564420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Culture, société et technique - 4e secondaire
# @dict: Math_4e_cst | Mathématique : Culture, société et technique, 4e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_cst = case_when(
    CD_COURS_REF %in% c("063420", "563420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Sciences naturelles - 4e secondaire
# @dict: Math_4e_sn | Mathématique : Sciences naturelles, 4e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_sn = case_when(
    CD_COURS_REF %in% c("065420", "565420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Technico-sciences - 4e secondaire - anglais
# @dict: Math_4e_ts_ang | Mathématique : Technico-sciences, 4e secondaire (volet anglais) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_ts_ang = case_when(
    CD_COURS_REF %in% c("564420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Technico-sciences - 4e secondaire - français
# @dict: Math_4e_ts_fr | Mathématique : Technico-sciences, 4e secondaire (volet français) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_ts_fr = case_when(
    CD_COURS_REF %in% c("064420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Culture, société et technique - 4e secondaire - anglais
# @dict: Math_4e_cst_ang | Mathématique : Culture, société et technique, 4e secondaire (volet anglais) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_cst_ang = case_when(
    CD_COURS_REF %in% c("563420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Culture, société et technique - 4e secondaire - français
# @dict: Math_4e_cst_fr | Mathématique : Culture, société et technique, 4e secondaire (volet français) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_cst_fr = case_when(
    CD_COURS_REF %in% c("063420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Sciences naturelles - 4e secondaire - anglais
# @dict: Math_4e_sn_ang | Mathématique : Sciences naturelles, 4e secondaire (volet anglais) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_sn_ang = case_when(
    CD_COURS_REF %in% c("565420") ~ NOTE_MINST_BRUT
  ))
#Mathématique: Sciences naturelles - 4e secondaire - français
# @dict: Math_4e_sn_fr | Mathématique : Sciences naturelles, 4e secondaire (volet français) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Math_4e_sn_fr = case_when(
    CD_COURS_REF %in% c("065420") ~ NOTE_MINST_BRUT
  ))
#Science et technologie - 4e secondaire
# @dict: Sc_4e_ST | Science et technologie, 4e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Sc_4e_ST = case_when(
    CD_COURS_REF %in% c("055410", "555410") ~ NOTE_MINST_BRUT
  ))
#Applications technologiques et scientifiques - 4e secondaire
# @dict: Sc_4e_ATS | Applications technologiques et scientifiques, 4e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Sc_4e_ATS = case_when(
    CD_COURS_REF %in% c("057410", "557410") ~ NOTE_MINST_BRUT
  ))
#Science et technologie - 4e secondaire - anglais
# @dict: Sc_4e_ST_eng | Science et technologie, 4e secondaire (volet anglais) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Sc_4e_ST_eng = case_when(
    CD_COURS_REF %in% c("555410") ~ NOTE_MINST_BRUT
  ))
#Science et technologie - 4e secondaire - français
# @dict: Sc_4e_ST_fr | Science et technologie, 4e secondaire (volet français) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Sc_4e_ST_fr = case_when(
    CD_COURS_REF %in% c("055410") ~ NOTE_MINST_BRUT
  ))
#Applications technologiques et scientifiques - 4e secondaire - anglais
# @dict: Sc_4e_ATS_eng | Applications technologiques et scientifiques, 4e secondaire (volet anglais) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Sc_4e_ATS_eng = case_when(
    CD_COURS_REF %in% c("557410") ~ NOTE_MINST_BRUT
  ))
#Applications technologiques et scientifiques - 4e secondaire - français
# @dict: Sc_4e_ATS_fr | Applications technologiques et scientifiques, 4e secondaire (volet français) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Sc_4e_ATS_fr = case_when(
    CD_COURS_REF %in% c("057410") ~ NOTE_MINST_BRUT
  ))
#Français, langue d'enseignement - 5e secondaire
# @dict: Fr_5e | Français, langue d'enseignement, 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Fr_5e = case_when(
    CD_COURS_REF %in% c("132520") ~ NOTE_MINST_BRUT
  ))
#Français, langue seconde, programme de base - 5e secondaire
# @dict: Fr_5e_ls_base | Français, langue seconde, programme de base, 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Fr_5e_ls_base = case_when(
    CD_COURS_REF %in% c("634510", "634520", "634530") ~ NOTE_MINST_BRUT
  ))
#Français, langue seconde, programme enrichi - 5e secondaire
# @dict: Fr_5e_ls_enr | Français, langue seconde, programme enrichi, 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Fr_5e_ls_enr = case_when(
    CD_COURS_REF %in% c("635520", "635530") ~ NOTE_MINST_BRUT
  ))
#Français, langue seconde (base + enrichi) - 5e secondaire
# @dict: Fr_ls | Français, langue seconde (base + enrichi combinés), 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Fr_ls = case_when(
    CD_COURS_REF %in% c("634510", "634520", "634530", "635520", "635530") ~ NOTE_MINST_BRUT
  ))
#English Language Arts - 5e secondaire
# @dict: Ang_5e | English Language Arts, 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Ang_5e = case_when(
    CD_COURS_REF %in% c("612520", "612530") ~ NOTE_MINST_BRUT
  ))
#Anglais, langue seconde, programme de base - 5e secondaire
# @dict: Ang_5e_ls_base | Anglais, langue seconde, programme de base, 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Ang_5e_ls_base = case_when(
    CD_COURS_REF %in% c("134510", "134530") ~ NOTE_MINST_BRUT
  ))
#Anglais, langue seconde, programme enrichi - 5e secondaire
# @dict: Ang_5e_ls_enr | Anglais, langue seconde, programme enrichi, 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Ang_5e_ls_enr = case_when(
    CD_COURS_REF %in% c("136540", "136550") ~ NOTE_MINST_BRUT
  ))
#Anglais, langue seconde (base + enrichi) - 5e secondaire
# @dict: Ang_ls | Anglais, langue seconde (base + enrichi combinés), 5e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (Ang_ls = case_when(
    CD_COURS_REF %in% c("134510", "134530", "136540", "136550") ~ NOTE_MINST_BRUT
  ))
#Histoire - 4e secondaire
# @dict: hist_4e | Histoire, 4e secondaire | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (hist_4e = case_when(
    CD_COURS_REF %in% c("085404", "585404") ~ NOTE_MINST_BRUT
  ))
#Histoire - 4e secondaire - anglais
# @dict: hist_4e_eng | Histoire, 4e secondaire (volet anglais) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (hist_4e_eng = case_when(
    CD_COURS_REF %in% c("585404") ~ NOTE_MINST_BRUT
  ))
#Histoire - 4e secondaire - français
# @dict: hist_4e_fr | Histoire, 4e secondaire (volet français) | Note brute (NOTE_MINST_BRUT), transmise telle quelle par le ministère | meq_appre_40255 | CD_COURS_REF, NOTE_MINST_BRUT
df_appr <- df_appr %>%
  mutate (hist_4e_fr = case_when(
    CD_COURS_REF %in% c("085404") ~ NOTE_MINST_BRUT
  ))
