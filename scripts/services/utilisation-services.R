# ==============================================================================
# Utilisation des services (hors naissance)
# Adapté de Dictionnaire_ofelie_sociodemo.R. Deux sources indépendantes :
# MED-ECHO (hospitalisations, en excluant la naissance et les chirurgies d'un
# jour) et BDCU (visites à l'urgence). Elles ne sont pas combinées, car elles
# documentent deux types d'utilisation de services distincts.
# ==============================================================================

library(data.table)
library(dplyr)

ME_sejour <- fread("BD/ME_sejour.csv")  # me_sejours_40255
BDCU <- fread("BD/BDCU_soin.csv")       # bdcu_soin_durg_40255

#-------------------------------------------------------------------------------
#          MED-ECHO : construction des épisodes de soin (regroupe les transferts)
#-------------------------------------------------------------------------------

ME_sejour_clean <- as.data.table(setorder(ME_sejour, NOINDIV, DAT_ADMIS, DAT_DEPAR, -IND_NOUV_NE))

# Détection des transferts (admission incluse dans le séjour précédent, ou
# admission le lendemain d'une sortie vers un centre hospitalier)
ME_sejour_clean[, lag_discharge := shift(DAT_DEPAR, n = 1, type = "lag"), by = NOINDIV]
ME_sejour_clean[, lag_LIEU_DESTI := shift(TYP_LIEU_DESTI, n = 1, type = "lag"), by = NOINDIV]
ME_sejour_clean[, interval := as.numeric(DAT_ADMIS - lag_discharge)]
ME_sejour_clean[, transfer := FALSE]
ME_sejour_clean[lag_LIEU_DESTI == 1 & interval %in% c(0, 1) | interval < 0 |
                   NOINDIV == lag(NOINDIV) & DAT_ADMIS == lag(DAT_ADMIS), transfer := TRUE]

# NO_EPISO regroupe toutes les admissions d'un même épisode de soin (transferts inclus)
ME_sejour_clean <- ME_sejour_clean %>%
  mutate(NO_EPISO = case_when(transfer == TRUE ~ lag(NO_SEQ_SEJ_BAN), TRUE ~ NO_SEQ_SEJ_BAN))
# (répété pour les transferts multiples - voir le script original)
ME_sejour_clean <- ME_sejour_clean %>%
  mutate(NO_EPISO = case_when(transfer == TRUE ~ lag(NO_EPISO), TRUE ~ NO_EPISO))

# Durée totale de l'épisode de soin (les durées de 0 jour sont fixées à 1)
ME_sejour_clean[, FIRST_ADMIS := min(DAT_ADMIS), by = NO_EPISO]
ME_sejour_clean[, LAST_DISCH := max(DAT_DEPAR), by = NO_EPISO]
ME_sejour_clean[, LOS_TOTAL := as.numeric(LAST_DISCH - FIRST_ADMIS), by = NO_EPISO]
ME_sejour_clean[LOS_TOTAL == 0, LOS_TOTAL := 1]

#-------------------------------------------------------------------------------
#          MED-ECHO : hospitalisations au cours de la vie (hors naissance)
#-------------------------------------------------------------------------------
# Les épisodes de soin à la naissance (identifiés via IND_NOUV_NE ou date
# d'admission = date de naissance - voir scripts/sante-physique/naissance-clinique.R)
# sont exclus ici, de même que les chirurgies d'un jour (TYP_SOIN == 27).

episodes_naissance <- unique(ME_sejour_clean$NO_EPISO)  # cf. ME_N_2 dans le script original

ME_vie <- subset(ME_sejour_clean, !(NO_EPISO %in% episodes_naissance))
ME_vie <- subset(ME_vie, TYP_SOIN != 27)
ME_vie_u <- ME_vie[, .SD[.N], by = NO_EPISO]
ME_vie_u[, ME_HOSP_NBJR := sum(LOS_TOTAL, na.rm = TRUE), by = NOINDIV]
ME_vie_final <- ME_vie_u[, .SD[.N], by = NOINDIV]

# @dict: ME_HOSP_NBJR | Nombre total de jours d'hospitalisation au cours de la vie, en excluant les hospitalisations à la naissance et les chirurgies d'un jour (0 si aucune hospitalisation) | Jours | me_sejours_40255 | DAT_ADMIS, DAT_DEPAR, TYP_SOIN
# ME_HOSP_NBJR est déjà calculée ci-dessus (ME_vie_final)

# Note : un indicateur ME_HOSP_IND (0/1, présence d'une hospitalisation) est
# calculé dans le script original mais retiré de la table finale en même temps
# que ME_HOSPNAIS_IND ("inutile et confondante"). Non repris dans le dictionnaire.

#-------------------------------------------------------------------------------
#                    BDCU : visites à l'urgence
#-------------------------------------------------------------------------------
# Aucun nettoyage des doublons ou des transferts n'est appliqué ici (décision
# prise après discussion avec l'équipe - voir le script original).

BDCU <- setorder(BDCU, NOINDIV)
BDCU <- BDCU %>% add_count(NOINDIV)
BDCU_u <- BDCU[, .SD[.N], by = NOINDIV]

# @dict: BDCU_VISIT_NB | Nombre de visites à l'urgence par individu (0 si aucune visite) | Nombre de visites | bdcu_soin_durg_40255 | (compte des lignes par NOINDIV)
BDCU_u <- rename(BDCU_u, BDCU_VISIT_NB = n)
