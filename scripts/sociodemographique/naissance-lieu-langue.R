# ==============================================================================
# Naissance - Lieu de naissance, langues et statut générationnel
# Adapté de Dictionnaire_ofelie_sociodemo.R. Trois sources documentent le lieu
# de naissance et la langue : RED-Naissance, le dossier MEQ (caractéristiques
# + fréquentation) et, en dernier recours, MED-ECHO (voir scripts/sante-physique/naissance-clinique.R
# pour ME_LNAISENF). Les variables COMB_* combinent ces sources par priorité.
#
# La correction des appariements incertains de RED-Naissance avec MED-ECHO
# (naissances multiples) n'est pas reproduite ici - voir le script original ;
# RED_naiss_clean est le fichier déjà corrigé.
# ==============================================================================

library(data.table)
library(dplyr)

RED_naiss_clean <- fread("RED_naiss_clean.csv")  # red_naiss_40255, après correction des appariements incertains
EDU_caract <- fread("BD/EDU_caract.csv")          # mes_meq_caract_ind_40255
EDU_freq <- fread("BD/EDU_freq.csv")              # meq_pps_freq_40255

#-------------------------------------------------------------------------------
#                    RED-Naissance : lieu de naissance
#-------------------------------------------------------------------------------

# @dict: REDNAIS_RANAIS | Région administrative de naissance de l'enfant | Code de région administrative | red_naiss_40255 | RANAIS
RED_naiss_clean$REDNAIS_RANAIS <- RED_naiss_clean$RANAIS

# @dict: REDNAIS_LNAISENF | Lieu de naissance de l'enfant, variable originale | Code de lieu de naissance | red_naiss_40255 | LNAISENF
RED_naiss_clean$REDNAIS_LNAISENF <- RED_naiss_clean$LNAISENF

# @dict: REDNAIS_LNAISENF_cat | Lieu de naissance de l'enfant, recatégorisé | 1=Québec [924], 2=reste du Canada, 3=hors Canada, NA=inconnu [999] | red_naiss_40255 | LNAISENF
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LNAISENF_cat = case_when(
    LNAISENF == 924 ~ 1,
    LNAISENF %in% c(909, 910, 911, 912, 913, 935, 946, 947, 948, 959, 960, 961, 962) ~ 2,
    LNAISENF == 999 ~ NA,
    TRUE ~ 3))

# @dict: REDNAIS_LNAISMER | Lieu de naissance de la mère, variable originale | Code de lieu de naissance | red_naiss_40255 | LNAISMER
RED_naiss_clean$REDNAIS_LNAISMER <- RED_naiss_clean$LNAISMER

# @dict: REDNAIS_LNAISMER_cat | Lieu de naissance de la mère, recatégorisé | 1=Québec [924], 2=reste du Canada, 3=hors Canada, NA=inconnu [999] | red_naiss_40255 | LNAISMER
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LNAISMER_cat = case_when(
    LNAISMER == 924 ~ 1,
    LNAISMER %in% c(909, 910, 911, 912, 913, 935, 946, 947, 948, 959, 960, 961, 962) ~ 2,
    LNAISMER == 999 ~ NA,
    TRUE ~ 3))

# @dict: REDNAIS_LNAISPER | Lieu de naissance du père, variable originale | Code de lieu de naissance | red_naiss_40255 | LNAISPER
RED_naiss_clean$REDNAIS_LNAISPER <- RED_naiss_clean$LNAISPER

# @dict: REDNAIS_LNAISPER_cat | Lieu de naissance du père, recatégorisé | 1=Québec [924], 2=reste du Canada, 3=hors Canada, NA=inconnu [999] | red_naiss_40255 | LNAISPER
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LNAISPER_cat = case_when(
    LNAISPER == 924 ~ 1,
    LNAISPER %in% c(909, 910, 911, 912, 913, 935, 946, 947, 948, 959, 960, 961, 962) ~ 2,
    LNAISPER == 999 ~ NA,
    TRUE ~ 3))

#-------------------------------------------------------------------------------
#                    RED-Naissance : langues
#-------------------------------------------------------------------------------

# @dict: REDNAIS_LANGMAIS | Langue parlée à la maison, variable originale | Code de langue | red_naiss_40255 | LANGMAIS
RED_naiss_clean$REDNAIS_LANGMAIS <- RED_naiss_clean$LANGMAIS

# @dict: REDNAIS_LANGMAIS_cat | Langue parlée à la maison, recatégorisée | 1/2/3/4/5/6 selon les codes originaux [1,2,50,51,52,53], 7=autre, NA=inconnu [99] | red_naiss_40255 | LANGMAIS
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LANGMAIS_cat = case_when(
    LANGMAIS == 1 ~ 1,
    LANGMAIS == 2 ~ 2,
    LANGMAIS == 50 ~ 3,
    LANGMAIS == 51 ~ 4,
    LANGMAIS == 52 ~ 5,
    LANGMAIS == 53 ~ 6,
    LANGMAIS == 99 ~ NA,
    TRUE ~ 7))

# @dict: REDNAIS_LANGMAIS_cat2 | Langue parlée à la maison, regroupée | 1=français, 2=anglais, 3=bilingue (français+anglais), 4=autres | red_naiss_40255 (dérivé de REDNAIS_LANGMAIS_cat) |
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LANGMAIS_cat2 = case_when(
    REDNAIS_LANGMAIS_cat %in% c(1, 4) ~ 1,
    REDNAIS_LANGMAIS_cat %in% c(2, 5) ~ 2,
    REDNAIS_LANGMAIS_cat %in% c(3, 6) ~ 3,
    REDNAIS_LANGMAIS_cat %in% c(7) ~ 4,
    TRUE ~ NA))

# @dict: REDNAIS_LANGMERE | Langue maternelle de la mère, variable originale | Code de langue | red_naiss_40255 | LANGMERE
RED_naiss_clean$REDNAIS_LANGMERE <- RED_naiss_clean$LANGMERE

# @dict: REDNAIS_LANGMERE_cat | Langue maternelle de la mère, recatégorisée | 1/2/3/4/5/6 selon les codes originaux [1,2,50,51,52,53], 7=autre, NA=inconnu [99] | red_naiss_40255 | LANGMERE
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LANGMERE_cat = case_when(
    LANGMERE == 1 ~ 1,
    LANGMERE == 2 ~ 2,
    LANGMERE == 50 ~ 3,
    LANGMERE == 51 ~ 4,
    LANGMERE == 52 ~ 5,
    LANGMERE == 53 ~ 6,
    LANGMERE == 99 ~ NA,
    TRUE ~ 7))

# @dict: REDNAIS_LANGMERE_cat2 | Langue maternelle de la mère, regroupée | 1=français, 2=anglais, 3=bilingue (français+anglais), 4=autres | red_naiss_40255 (dérivé de REDNAIS_LANGMERE_cat) |
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LANGMERE_cat2 = case_when(
    REDNAIS_LANGMERE_cat %in% c(1, 4) ~ 1,
    REDNAIS_LANGMERE_cat %in% c(2, 5) ~ 2,
    REDNAIS_LANGMERE_cat %in% c(3, 6) ~ 3,
    REDNAIS_LANGMERE_cat %in% c(7) ~ 4,
    TRUE ~ NA))

# @dict: REDNAIS_LANGPERE | Langue maternelle du père, variable originale | Code de langue | red_naiss_40255 | LANGPERE
RED_naiss_clean$REDNAIS_LANGPERE <- RED_naiss_clean$LANGPERE

# @dict: REDNAIS_LANGPERE_cat | Langue maternelle du père, recatégorisée | 1/2/3/4/5/6 selon les codes originaux [1,2,3,51,52,53] (attention : codage différent de LANGMAIS/LANGMERE), 7=autre, NA=inconnu [99] | red_naiss_40255 | LANGPERE
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LANGPERE_cat = case_when(
    LANGPERE == 1 ~ 1,
    LANGPERE == 2 ~ 2,
    LANGPERE == 3 ~ 3,
    LANGPERE == 51 ~ 4,
    LANGPERE == 52 ~ 5,
    LANGPERE == 53 ~ 6,
    LANGPERE == 99 ~ NA,
    TRUE ~ 7))

# @dict: REDNAIS_LANGPERE_cat2 | Langue maternelle du père, regroupée | 1=français, 2=anglais, 3=bilingue (français+anglais), 4=autres | red_naiss_40255 (dérivé de REDNAIS_LANGPERE_cat) |
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_LANGPERE_cat2 = case_when(
    REDNAIS_LANGPERE_cat %in% c(1, 4) ~ 1,
    REDNAIS_LANGPERE_cat %in% c(2, 5) ~ 2,
    REDNAIS_LANGPERE_cat %in% c(3, 6) ~ 3,
    REDNAIS_LANGPERE_cat %in% c(7) ~ 4,
    TRUE ~ NA))

#-------------------------------------------------------------------------------
#              MEQ - Fichier caractéristiques : lieu de naissance et langue
#-------------------------------------------------------------------------------

# @dict: EDU_LNAISENF | Lieu de naissance de l'enfant selon le dossier scolaire (MEQ), variable originale | Code de lieu de naissance | mes_meq_caract_ind_40255 | CD_LIEU_NAISN_ATTES
EDU_caract$EDU_LNAISENF <- EDU_caract$CD_LIEU_NAISN_ATTES

# @dict: EDU_LNAISENF_cat | Lieu de naissance de l'enfant (MEQ), recatégorisé | 1=Québec [16], 2=reste du Canada, 3=hors Canada | mes_meq_caract_ind_40255 | CD_LIEU_NAISN_ATTES
EDU_caract <- EDU_caract %>%
  mutate(EDU_LNAISENF_cat = case_when(
    CD_LIEU_NAISN_ATTES <= 24 & !(CD_LIEU_NAISN_ATTES == 16) ~ 2,
    CD_LIEU_NAISN_ATTES == 16 ~ 1,
    CD_LIEU_NAISN_ATTES > 24 ~ 3,
    TRUE ~ NA))

# @dict: EDU_LNAISPAR1 | Lieu de naissance du parent 1 selon le dossier scolaire (MEQ), variable originale | Code de lieu de naissance | mes_meq_caract_ind_40255 | CD_LIEU_NAISN_PARNT_1
EDU_caract$CD_LIEU_NAISN_PARNT_1 <- as.integer(EDU_caract$CD_LIEU_NAISN_PARNT_1)
EDU_caract$EDU_LNAISPAR1 <- EDU_caract$CD_LIEU_NAISN_PARNT_1

# @dict: EDU_LNAISPAR1_cat | Lieu de naissance du parent 1 (MEQ), recatégorisé | 1=Québec [16], 2=reste du Canada, 3=hors Canada, NA=inconnu [999] | mes_meq_caract_ind_40255 | CD_LIEU_NAISN_PARNT_1
EDU_caract <- EDU_caract %>%
  mutate(EDU_LNAISPAR1_cat = case_when(
    CD_LIEU_NAISN_PARNT_1 <= 24 & !(CD_LIEU_NAISN_PARNT_1 == 16) ~ 2,
    CD_LIEU_NAISN_PARNT_1 == 16 ~ 1,
    CD_LIEU_NAISN_PARNT_1 > 24 & CD_LIEU_NAISN_PARNT_1 < 999 ~ 3,
    TRUE ~ NA))

# @dict: EDU_LNAISPAR2 | Lieu de naissance du parent 2 selon le dossier scolaire (MEQ), variable originale | Code de lieu de naissance | mes_meq_caract_ind_40255 | CD_LIEU_NAISN_PARNT_2
EDU_caract$CD_LIEU_NAISN_PARNT_2 <- as.integer(EDU_caract$CD_LIEU_NAISN_PARNT_2)
EDU_caract$EDU_LNAISPAR2 <- EDU_caract$CD_LIEU_NAISN_PARNT_2

# @dict: EDU_LNAISPAR2_cat | Lieu de naissance du parent 2 (MEQ), recatégorisé | 1=Québec [16], 2=reste du Canada, 3=hors Canada, NA=inconnu [999] | mes_meq_caract_ind_40255 | CD_LIEU_NAISN_PARNT_2
EDU_caract <- EDU_caract %>%
  mutate(EDU_LNAISPAR2_cat = case_when(
    CD_LIEU_NAISN_PARNT_2 <= 24 & !(CD_LIEU_NAISN_PARNT_2 == 16) ~ 2,
    CD_LIEU_NAISN_PARNT_2 == 16 ~ 1,
    CD_LIEU_NAISN_PARNT_2 > 24 & CD_LIEU_NAISN_PARNT_2 < 999 ~ 3,
    TRUE ~ NA))

# @dict: EDU_LANGMERE | Langue maternelle déclarée au dossier scolaire (MEQ), variable originale | Code de langue | mes_meq_caract_ind_40255 | CD_LANG_MATRN_DETL
EDU_caract$CD_LANG_MATRN_DETL <- as.integer(EDU_caract$CD_LANG_MATRN_DETL)
EDU_caract$EDU_LANGMERE <- EDU_caract$CD_LANG_MATRN_DETL

# @dict: EDU_LANGMERE_cat | Langue maternelle (MEQ), recatégorisée | 1=français, 2=anglais, 3=autre, NA=inconnu [999] | mes_meq_caract_ind_40255 | CD_LANG_MATRN_DETL
EDU_caract <- EDU_caract %>%
  mutate(EDU_LANGMERE_cat = case_when(
    CD_LANG_MATRN_DETL == 1 ~ 1,
    CD_LANG_MATRN_DETL == 2 ~ 2,
    CD_LANG_MATRN_DETL == 999 | is.na(CD_LANG_MATRN_DETL) ~ NA,
    TRUE ~ 3))

#-------------------------------------------------------------------------------
#              MEQ - Fichier fréquentation : langue à la première rentrée scolaire
#-------------------------------------------------------------------------------

EDU_freq <- as.data.table(setorder(EDU_freq, NOINDIV, DT_DEBUT_FREQN))
EDU_freq_first <- EDU_freq[, .SD[1], by = .(NOINDIV)]  # première entrée (première rentrée scolaire) pour chaque individu

# @dict: EDU_LANGMAIS | Langue parlée le plus souvent à la maison au moment de la première rentrée scolaire, variable originale | Code de langue | meq_pps_freq_40255 | CD_LANG_USAGE_DETL
EDU_freq_first$CD_LANG_USAGE_DETL <- as.numeric(EDU_freq_first$CD_LANG_USAGE_DETL)
EDU_freq_first$EDU_LANGMAIS <- EDU_freq_first$CD_LANG_USAGE_DETL

# @dict: EDU_LANGMAIS_cat | Langue à la maison à la première rentrée scolaire, recatégorisée | 1=français, 2=anglais, 3=autre, NA=inconnu [999] | meq_pps_freq_40255 | CD_LANG_USAGE_DETL
EDU_freq_first <- EDU_freq_first %>%
  mutate(EDU_LANGMAIS_cat = case_when(
    CD_LANG_USAGE_DETL == 1 ~ 1,
    CD_LANG_USAGE_DETL == 2 ~ 2,
    CD_LANG_USAGE_DETL == 999 | is.na(CD_LANG_USAGE_DETL) ~ NA,
    TRUE ~ 3))

#-------------------------------------------------------------------------------
#     Variables combinées (priorité RED-Naissance, puis MEQ, puis MED-ECHO)
#-------------------------------------------------------------------------------
# Nécessite ME_LNAISENF_cat (voir scripts/sante-physique/naissance-clinique.R),
# déjà fusionnées dans une même table avec les variables ci-dessus.

# @dict: COMB_LNAISENF_cat | Lieu de naissance de l'enfant, combiné : priorise RED-Naissance, puis le dossier scolaire (MEQ), puis MED-ECHO | 1=Québec, 2=reste du Canada, 3=hors Canada, NA=inconnu | red_naiss_40255, mes_meq_caract_ind_40255, me_sejours_40255 (dérivé de REDNAIS_LNAISENF_cat, EDU_LNAISENF_cat, ME_LNAISENF_cat) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_LNAISENF_cat = case_when(
    !(is.na(REDNAIS_LNAISENF_cat)) ~ REDNAIS_LNAISENF_cat,
    is.na(REDNAIS_LNAISENF_cat) & !(is.na(EDU_LNAISENF_cat)) ~ EDU_LNAISENF_cat,
    is.na(REDNAIS_LNAISENF_cat) & is.na(EDU_LNAISENF_cat) ~ ME_LNAISENF_cat,
    TRUE ~ NA))

# @dict: COMB_LNAISMER_cat | Lieu de naissance de la mère, combiné : priorise RED-Naissance, puis le lieu de naissance du parent 1 au dossier scolaire (MEQ) | 1=Québec, 2=reste du Canada, 3=hors Canada, NA=inconnu | red_naiss_40255, mes_meq_caract_ind_40255 (dérivé de REDNAIS_LNAISMER_cat, EDU_LNAISPAR1_cat) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_LNAISMER_cat = case_when(
    !(is.na(REDNAIS_LNAISMER_cat)) ~ REDNAIS_LNAISMER_cat,
    is.na(REDNAIS_LNAISMER_cat) ~ EDU_LNAISPAR1_cat))

# @dict: COMB_LNAISPER_cat | Lieu de naissance du père, combiné : priorise RED-Naissance, puis le lieu de naissance du parent 2 au dossier scolaire (MEQ) | 1=Québec, 2=reste du Canada, 3=hors Canada, NA=inconnu | red_naiss_40255, mes_meq_caract_ind_40255 (dérivé de REDNAIS_LNAISPER_cat, EDU_LNAISPAR2_cat) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_LNAISPER_cat = case_when(
    !(is.na(REDNAIS_LNAISPER_cat)) ~ REDNAIS_LNAISPER_cat,
    is.na(REDNAIS_LNAISPER_cat) ~ EDU_LNAISPAR2_cat))

# @dict: COMB_STATGEN | Statut générationnel | 1=enfant né hors Canada, 2=enfant né au Canada avec au moins un parent né hors Canada (2e génération), 3=enfant et les deux parents nés au Canada (3e génération ou plus), NA=indéterminé | (dérivé de COMB_LNAISENF_cat, COMB_LNAISMER_cat, COMB_LNAISPER_cat) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_STATGEN = case_when(
    COMB_LNAISENF_cat == 3 ~ 1,
    COMB_LNAISENF_cat %in% c(1, 2) & (COMB_LNAISMER_cat == 3 | COMB_LNAISPER_cat == 3) ~ 2,
    COMB_LNAISENF_cat %in% c(1, 2) & COMB_LNAISMER_cat %in% c(1, 2) & COMB_LNAISPER_cat %in% c(1, 2) ~ 3,
    TRUE ~ NA))

# @dict: COMB_LNAISPAR_cat | Lieu de naissance des parents combiné | 1=les deux parents nés au Canada, 2=un seul parent né hors Canada, 3=les deux parents nés hors Canada, NA=indéterminé | (dérivé de COMB_LNAISMER_cat, COMB_LNAISPER_cat) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_LNAISPAR_cat = case_when(
    COMB_LNAISMER_cat %in% c(1, 2) & COMB_LNAISPER_cat %in% c(1, 2) ~ 1,
    xor(COMB_LNAISMER_cat == 3, COMB_LNAISPER_cat == 3) ~ 2,
    COMB_LNAISMER_cat == 3 & COMB_LNAISPER_cat == 3 ~ 3,
    TRUE ~ NA))
