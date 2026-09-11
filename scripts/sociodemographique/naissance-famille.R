# ==============================================================================
# Naissance - Famille, scolarité des parents, appariement et cohorte scolaire
# Adapté de Dictionnaire_ofelie_sociodemo.R. RED_naiss_clean est le fichier
# red_naiss_40255 après correction des appariements incertains avec MED-ECHO
# pour les naissances multiples (voir le script original pour cette logique).
# ==============================================================================

library(data.table)
library(dplyr)
library(lubridate)

RED_naiss_clean <- fread("RED_naiss_clean.csv")

#-------------------------------------------------------------------------------
#                    Indicateurs d'appariement RED-Naissance
#-------------------------------------------------------------------------------

# @dict: REDNAIS_IND | Indicateur de présence dans le registre des naissances (RED) | 1=présent (0 après remplacement des NA lors de la fusion avec la table principale) | red_naiss_40255 | (présence/absence dans le fichier)
RED_naiss_clean$REDNAIS_IND <- 1

# @dict: NO_NAIS_MULT | Numéro de naissance multiple, utilisé pour l'appariement des naissances multiples entre RED-Naissance et MED-ECHO | Identifiant | red_naiss_40255, res_app_fipa_nais_40255 | NO_NAIS_MULT
# @dict: REDNAIS_TYPAPP | Indicateur du type d'appariement RED-Naissance ("O" = certain ; corrigé avec MED-ECHO quand l'appariement était incertain) | O = certain | res_app_fipa_nais_40255 (corrigé avec me_sejours_40255) | indic_red_nais
# @dict: REDNAIS_TYPCONFLIT | Type de conflit d'appariement pour les naissances multiples (vide si aucun conflit) | 1vsN, NvsN, Nvs1, vide=aucun conflit | res_app_fipa_nais_40255 | type_nais_mult
# Ces trois variables proviennent de la fusion RED_naiss_app décrite dans le script original ; non reproduites ici.

#-------------------------------------------------------------------------------
#                    Scolarité et âge des parents
#-------------------------------------------------------------------------------

# @dict: REDNAIS_SCOLMERE | Scolarité de la mère, en années, variable originale | Années de scolarité, NA=inconnu [99] | red_naiss_40255 | SCOLMERE
RED_naiss_clean$REDNAIS_SCOLMERE <- RED_naiss_clean$SCOLMERE
RED_naiss_clean[REDNAIS_SCOLMERE == 99, REDNAIS_SCOLMERE := NA]

# @dict: REDNAIS_SCOLMERE_cat | Scolarité de la mère, catégorisée | 1=<11 ans, 2=11-13 ans, 3=14-15 ans, 4=16+ ans, NA=inconnu | red_naiss_40255 | SCOLMERE
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_SCOLMERE_cat = case_when(
    SCOLMERE == 99 ~ NA,
    SCOLMERE < 11 ~ 1,
    SCOLMERE %in% c(11, 12, 13) ~ 2,
    SCOLMERE %in% c(14, 15) ~ 3,
    SCOLMERE >= 16 ~ 4))

# @dict: REDNAIS_AGEMERE | Âge de la mère à la naissance, en années | Années | red_naiss_40255 | AGEMERE
RED_naiss_clean$REDNAIS_AGEMERE <- as.numeric(RED_naiss_clean$AGEMERE)

# @dict: REDNAIS_AGEMERE_cat | Âge de la mère à la naissance, catégorisé | 1=<20, 2=20-24, 3=25-29, 4=30-34, 5=35+, NA=inconnu | red_naiss_40255 (dérivé de REDNAIS_AGEMERE) |
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_AGEMERE_cat = case_when(
    REDNAIS_AGEMERE < 20 ~ 1,
    REDNAIS_AGEMERE >= 20 & REDNAIS_AGEMERE < 25 ~ 2,
    REDNAIS_AGEMERE >= 25 & REDNAIS_AGEMERE < 30 ~ 3,
    REDNAIS_AGEMERE >= 30 & REDNAIS_AGEMERE < 35 ~ 4,
    REDNAIS_AGEMERE >= 35 ~ 5,
    TRUE ~ NA))

# @dict: REDNAIS_AGEPERE | Âge du père à la naissance, en années | Années | red_naiss_40255 | AGEPERE
RED_naiss_clean$REDNAIS_AGEPERE <- as.numeric(RED_naiss_clean$AGEPERE)

# @dict: REDNAIS_AGEPERE_cat | Âge du père à la naissance, catégorisé (mêmes tranches que la mère) | 1=<20, 2=20-24, 3=25-29, 4=30-34, 5=35+, NA=inconnu | red_naiss_40255 (dérivé de REDNAIS_AGEPERE) |
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_AGEPERE_cat = case_when(
    REDNAIS_AGEPERE < 20 ~ 1,
    REDNAIS_AGEPERE >= 20 & REDNAIS_AGEPERE < 25 ~ 2,
    REDNAIS_AGEPERE >= 25 & REDNAIS_AGEPERE < 30 ~ 3,
    REDNAIS_AGEPERE >= 30 & REDNAIS_AGEPERE < 35 ~ 4,
    REDNAIS_AGEPERE >= 35 ~ 5,
    TRUE ~ NA))

#-------------------------------------------------------------------------------
#                    Type de naissance et situation familiale
#-------------------------------------------------------------------------------

# @dict: REDNAIS_TYPNAIS | Type de naissance, variable originale | Voir codification RED | red_naiss_40255 | TYPNAIS
RED_naiss_clean$REDNAIS_TYPNAIS <- RED_naiss_clean$TYPNAIS

# @dict: REDNAIS_TYPNAIS_cat | Type de naissance, binaire | 1=unique, 2=multiple | red_naiss_40255 (dérivé de REDNAIS_TYPNAIS) |
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_TYPNAIS_cat = case_when(
    REDNAIS_TYPNAIS == 1 ~ 1,
    REDNAIS_TYPNAIS %in% c(2, 3, 4) ~ 2,
    TRUE ~ NA))

# @dict: REDNAIS_ETMATMER | État matrimonial de la mère à la naissance de l'enfant, variable originale | Voir codification RED | red_naiss_40255 | ETMATMER
RED_naiss_clean$REDNAIS_ETMATMER <- RED_naiss_clean$ETMATMER

# @dict: REDNAIS_ETCIVMER | État civil de la mère au moment de la naissance, recatégorisé | 1=mariée/unie de fait, 2=autre, NA=inconnu [99] | red_naiss_40255 | ETMATMER
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_ETCIVMER = case_when(
    ETMATMER %in% c(1, 3, 4, 5) ~ 1,
    ETMATMER %in% c(2, 6) ~ 2,
    ETMATMER == 99 ~ NA))

# @dict: REDNAIS_SITUACOUP | Situation de couple de la mère au moment de la naissance | 1/2, NA=inconnu [9] | red_naiss_40255 | SITUACOUP
RED_naiss_clean <- RED_naiss_clean %>%
  mutate(REDNAIS_SITUACOUP = case_when(
    SITUACOUP == 1 ~ 1,
    SITUACOUP == 2 ~ 2,
    SITUACOUP == 9 ~ NA))

#-------------------------------------------------------------------------------
#                    Cohorte scolaire (dérivée de la date de naissance)
#-------------------------------------------------------------------------------
# Nécessite FIPA_NAISS_AAAAMMJJ (voir scripts/sociodemographique/fipa-rpam-exemple.R).

# @dict: cohorte_scolaire | Cohorte scolaire d'appartenance selon la date de naissance, coupure au 30 septembre (ex. né le 15 mars 2010 -> cohorte 2009-2010) | Années scolaires "AAAA-AAAA" de 2005-2006 à 2023-2024, NA si hors plage | ramq_fipa_40255 (dérivé de FIPA_NAISS_AAAAMMJJ) | FIPA_NAISS_AAAAMMJJ
table_cohorte <- table_cohorte %>%
  mutate(cohorte_scolaire = case_when(
    FIPA_NAISS_AAAAMMJJ >= ymd("2005-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2006-09-30") ~ "2005-2006",
    FIPA_NAISS_AAAAMMJJ >= ymd("2006-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2007-09-30") ~ "2006-2007",
    FIPA_NAISS_AAAAMMJJ >= ymd("2007-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2008-09-30") ~ "2007-2008",
    FIPA_NAISS_AAAAMMJJ >= ymd("2008-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2009-09-30") ~ "2008-2009",
    FIPA_NAISS_AAAAMMJJ >= ymd("2009-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2010-09-30") ~ "2009-2010",
    FIPA_NAISS_AAAAMMJJ >= ymd("2010-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2011-09-30") ~ "2010-2011",
    FIPA_NAISS_AAAAMMJJ >= ymd("2011-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2012-09-30") ~ "2011-2012",
    FIPA_NAISS_AAAAMMJJ >= ymd("2012-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2013-09-30") ~ "2012-2013",
    FIPA_NAISS_AAAAMMJJ >= ymd("2013-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2014-09-30") ~ "2013-2014",
    FIPA_NAISS_AAAAMMJJ >= ymd("2014-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2015-09-30") ~ "2014-2015",
    FIPA_NAISS_AAAAMMJJ >= ymd("2015-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2016-09-30") ~ "2015-2016",
    FIPA_NAISS_AAAAMMJJ >= ymd("2016-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2017-09-30") ~ "2016-2017",
    FIPA_NAISS_AAAAMMJJ >= ymd("2017-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2018-09-30") ~ "2017-2018",
    FIPA_NAISS_AAAAMMJJ >= ymd("2018-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2019-09-30") ~ "2018-2019",
    FIPA_NAISS_AAAAMMJJ >= ymd("2019-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2020-09-30") ~ "2019-2020",
    FIPA_NAISS_AAAAMMJJ >= ymd("2020-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2021-09-30") ~ "2020-2021",
    FIPA_NAISS_AAAAMMJJ >= ymd("2021-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2022-09-30") ~ "2021-2022",
    FIPA_NAISS_AAAAMMJJ >= ymd("2022-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2023-09-30") ~ "2022-2023",
    FIPA_NAISS_AAAAMMJJ >= ymd("2023-10-01") & FIPA_NAISS_AAAAMMJJ <= ymd("2024-09-30") ~ "2023-2024",
    TRUE ~ NA_character_
  ))
