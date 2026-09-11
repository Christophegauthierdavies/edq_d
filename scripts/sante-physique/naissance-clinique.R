# ==============================================================================
# Naissance - Variables cliniques (poids, gestation, prématurité, hospitalisation)
# Adapté de Dictionnaire_ofelie_sociodemo.R. Deux sources : RED-Naissance et
# MED-ECHO (utilisé en complément quand RED-Naissance est manquant). Les
# variables COMB_* combinent les deux par priorité (RED-Naissance d'abord).
# ==============================================================================

library(data.table)
library(dplyr)

RED_naiss_clean <- fread("RED_naiss_clean.csv")  # red_naiss_40255, après correction des appariements incertains
ME_sejour_clean <- fread("BD/ME_sejour_clean.csv")  # me_sejours_40255, un enregistrement par séjour (doublons retirés)

#-------------------------------------------------------------------------------
#                    RED-Naissance : poids et gestation
#-------------------------------------------------------------------------------

# @dict: REDNAIS_POIDSENF | Poids de l'enfant à la naissance, en grammes | Grammes, NA=inconnu [9999] | red_naiss_40255 | POIDSENF
RED_naiss_clean$REDNAIS_POIDSENF <- as.numeric(RED_naiss_clean$POIDSENF)
RED_naiss_clean[REDNAIS_POIDSENF == 9999, REDNAIS_POIDSENF := NA]

# @dict: REDNAIS_GESTA | Nombre de semaines de gestation | Semaines, NA=inconnu [99] | red_naiss_40255 | DUREGROS
RED_naiss_clean$REDNAIS_GESTA <- as.numeric(RED_naiss_clean$DUREGROS)
RED_naiss_clean[REDNAIS_GESTA == 99, REDNAIS_GESTA := NA]

#-------------------------------------------------------------------------------
#          MED-ECHO : lieu de naissance, poids et gestation (complément)
#-------------------------------------------------------------------------------

# Premier lieu de naissance valide dans le dossier hospitalier (exclut le code 17)
ME_lieu <- subset(ME_sejour_clean, !(LIEU_NAISS == 17))
ME_lieu_first <- ME_lieu[, .SD[.N], by = NOINDIV]
ME_lieu_first <- rename(ME_lieu_first, ME_LNAISENF = LIEU_NAISS)

# @dict: ME_LNAISENF_cat | Lieu de naissance de l'enfant selon MED-ECHO, recatégorisé (utilisé en dernier recours dans COMB_LNAISENF_cat - voir scripts/sociodemographique/naissance-lieu-langue.R) | 1=Québec [1], 2=reste du Canada [2,3,4], 3=hors Canada, NA=inconnu [17] | me_sejours_40255 | LIEU_NAISS
ME_lieu_first <- ME_lieu_first %>%
  mutate(ME_LNAISENF_cat = case_when(
    ME_LNAISENF == 1 ~ 1,
    ME_LNAISENF %in% c(2, 3, 4) ~ 2,
    ME_LNAISENF %in% c(NA, 17) ~ NA,
    TRUE ~ 3))

# Premier poids valide (exclut 0/8888/9999 et les poids <200g sans décès à l'hôpital)
hospit_poids_1 <- subset(ME_sejour_clean, !(NB_GR_NAISS_1 %in% c(0, 8888, 9999)) & !(NB_GR_NAISS_1 < 200 & is.na(TYP_DECES)))
hospit_poids_1 <- as.data.table(setorder(hospit_poids_1, NOINDIV, IND_NOUV_NE, -DAT_ADMIS))
hospit_poids_1_first <- hospit_poids_1[, .SD[.N], by = NOINDIV]

# @dict: ME_POIDSENF | Poids de l'enfant à la naissance selon MED-ECHO, en grammes (utilisé pour corriger les appariements incertains de RED-Naissance, et en complément dans COMB_POIDSENF) | Grammes | me_sejours_40255 | NB_GR_NAISS_1
hospit_poids_1_first <- rename(hospit_poids_1_first, ME_POIDSENF = NB_GR_NAISS_1)

# Premier nombre de semaines de gestation valide (exclut <16 semaines)
hospit_gesta_1 <- subset(ME_sejour_clean, !(NB_SEM_GESTA < 16),
                          select = c(NOINDIV, NO_SEQ_SEJ_BAN, DAT_ADMIS, IND_NOUV_NE,
                                     NB_GR_NAISS_1, NB_SEM_GESTA, TYP_DECES, TYP_ADMIS))
hospit_gesta_1 <- as.data.table(setorder(hospit_gesta_1, NOINDIV, IND_NOUV_NE, -DAT_ADMIS))
hospit_gesta_1_first <- hospit_gesta_1[, .SD[.N], by = NOINDIV]

# @dict: ME_GESTA | Nombre de semaines de gestation selon MED-ECHO (utilisé en complément dans COMB_GESTA) | Semaines | me_sejours_40255 | NB_SEM_GESTA
hospit_gesta_1_first <- rename(hospit_gesta_1_first, ME_GESTA = NB_SEM_GESTA)

#-------------------------------------------------------------------------------
#     Variables combinées (priorité RED-Naissance, puis MED-ECHO)
#-------------------------------------------------------------------------------
# Suppose une table où REDNAIS_POIDSENF/REDNAIS_GESTA et ME_POIDSENF/ME_GESTA
# ont déjà été fusionnées (voir ci-dessus).

# @dict: COMB_POIDSENF | Poids de l'enfant à la naissance, combiné : priorise RED-Naissance, complète avec MED-ECHO si manquant | Grammes | red_naiss_40255, me_sejours_40255 (dérivé de REDNAIS_POIDSENF, ME_POIDSENF) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_POIDSENF = case_when(
    !(is.na(REDNAIS_POIDSENF)) ~ REDNAIS_POIDSENF,
    is.na(REDNAIS_POIDSENF) ~ ME_POIDSENF,
    TRUE ~ NA))

# @dict: COMB_POIDSENF_cat | Poids de l'enfant à la naissance, catégorisé | 1=<2500g (petit poids), 2=>=2500g, NA=inconnu | (dérivé de COMB_POIDSENF) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_POIDSENF_cat = case_when(
    COMB_POIDSENF < 2500 ~ 1,
    COMB_POIDSENF >= 2500 ~ 2,
    TRUE ~ NA))

# @dict: COMB_GESTA | Nombre de semaines de gestation, combiné : priorise RED-Naissance, complète avec MED-ECHO si manquant | Semaines | red_naiss_40255, me_sejours_40255 (dérivé de REDNAIS_GESTA, ME_GESTA) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_GESTA = case_when(
    !(is.na(REDNAIS_GESTA)) ~ REDNAIS_GESTA,
    is.na(REDNAIS_GESTA) ~ ME_GESTA,
    TRUE ~ NA))

# @dict: COMB_GESTA_cat | Nombre de semaines de gestation, catégorisé | 1=<28, 2=28-31, 3=32-36, 4=37-42 (terme), 5=>42, NA=inconnu | (dérivé de COMB_GESTA) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_GESTA_cat = case_when(
    COMB_GESTA < 28 ~ 1,
    COMB_GESTA >= 28 & COMB_GESTA < 32 ~ 2,
    COMB_GESTA >= 32 & COMB_GESTA < 37 ~ 3,
    COMB_GESTA >= 37 & COMB_GESTA <= 42 ~ 4,
    COMB_GESTA > 42 ~ 5,
    TRUE ~ NA))

# @dict: COMB_PREMA | Prématurité (naissance avant 37 semaines de gestation) | 0=non-prématuré, 1=prématuré, NA=inconnu | (dérivé de COMB_GESTA) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(COMB_PREMA = case_when(
    COMB_GESTA < 37 ~ 1,
    COMB_GESTA >= 37 ~ 0,
    TRUE ~ NA))

#-------------------------------------------------------------------------------
#                    Hospitalisation à la naissance (MED-ECHO)
#-------------------------------------------------------------------------------
# Identification des épisodes de soin dont l'admission correspond à la date ou
# à l'indicateur de naissance (IND_NOUV_NE) - voir scripts/services/utilisation-services.R
# pour la construction des épisodes de soin (NO_EPISO, LOS_TOTAL).

# @dict: ME_HOSPNAIS_NBJR | Durée (en jours) de l'épisode de soin à la naissance (hospitalisation initiale) | Jours | me_sejours_40255 (dérivé de LOS_TOTAL pour l'épisode de naissance) | DAT_ADMIS, DAT_DEPAR, IND_NOUV_NE
# Créée en renommant LOS_TOTAL -> ME_HOSPNAIS_NBJR pour l'épisode de soin identifié comme la naissance
# (voir scripts/services/utilisation-services.R pour la construction de LOS_TOTAL par épisode)

# @dict: ME_HOSPNAIS_NBJR_cat | Durée d'hospitalisation à la naissance, catégorisée | 1=1 jour, 2=2 jours, 3=3 jours, 4=4 jours, 5=5 jours et plus, NA=inconnu | me_sejours_40255 (dérivé de ME_HOSPNAIS_NBJR) |
table_naiss_combine$ME_HOSPNAIS_NBJR <- as.integer(table_naiss_combine$ME_HOSPNAIS_NBJR)
table_naiss_combine <- table_naiss_combine %>%
  mutate(ME_HOSPNAIS_NBJR_cat = case_when(
    ME_HOSPNAIS_NBJR == 1 ~ 1,
    ME_HOSPNAIS_NBJR == 2 ~ 2,
    ME_HOSPNAIS_NBJR == 3 ~ 3,
    ME_HOSPNAIS_NBJR == 4 ~ 4,
    ME_HOSPNAIS_NBJR >= 5 ~ 5,
    TRUE ~ NA))

# @dict: ME_HOSPNAIS_NBJR_cat2 | Durée d'hospitalisation à la naissance, regroupée | 1=1-2 jours, 2=3-4 jours, 3=5 jours et plus, NA=inconnu | me_sejours_40255 (dérivé de ME_HOSPNAIS_NBJR_cat) |
table_naiss_combine <- table_naiss_combine %>%
  mutate(ME_HOSPNAIS_NBJR_cat2 = case_when(
    ME_HOSPNAIS_NBJR_cat %in% c(1, 2) ~ 1,
    ME_HOSPNAIS_NBJR_cat %in% c(3, 4) ~ 2,
    ME_HOSPNAIS_NBJR_cat %in% c(5) ~ 3,
    TRUE ~ NA))

# Note : un indicateur ME_HOSPNAIS_IND (0/1, présence d'une hospitalisation à la
# naissance) est calculé dans le script original mais retiré de la table finale
# ("inutile et confondante" - des naissances multiples semblent manquer
# l'hospitalisation dans MED-ECHO). Non repris dans le dictionnaire.
