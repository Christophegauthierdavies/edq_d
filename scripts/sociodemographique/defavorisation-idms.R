# ==============================================================================
# IDMS - Indice de défavorisation matérielle et sociale
# Adapté de Dictionnaire_ofelie_sociodemo.R (combine idms2006/2011/2016/2021_40255).
# Pour chaque individu : l'indice le plus fréquent durant le suivi, le plus
# récent, et celui le plus proche de la naissance (dans la première année de
# vie, en utilisant FIPA_NAISS_AAAAMMJJ - voir scripts/sociodemographique/fipa-rpam-exemple.R).
# ==============================================================================

library(data.table)
library(dplyr)

# IDMS : idms2006/2011/2016/2021_40255, combinés (NOINDIV, ANNEE, DAT_REF, CP3, ZONE, QUINTMAT, QUINTSOC)
IDMS <- fread("BD/IDMS.csv")

# table_naissance : NOINDIV + FIPA_NAISS_AAAAMMJJ, pour retrouver la naissance de chaque individu
table_naissance <- fread("table_naissance.csv")

get_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#-------------------------------------------------------------------------------
# Quintiles matériel et social : valeur la plus fréquente durant le suivi

IDMS_clean <- subset(IDMS, !(is.na(QUINTMAT)))  # QUINTSOC toujours présent si QUINTMAT l'est
IDMS_clean <- as.data.table(setorder(IDMS_clean, NOINDIV, -QUINTMAT))

# @dict: IDMS_QUINTMAT_L | Quintile de défavorisation matérielle le plus fréquent durant le suivi | Quintile (1-5), voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | QUINTMAT
QUINTMAT_longue <- IDMS_clean %>%
  group_by(NOINDIV) %>%
  summarise(IDMS_QUINTMAT_L = get_mode(QUINTMAT))

IDMS_clean <- as.data.table(setorder(IDMS_clean, NOINDIV, -QUINTSOC))

# @dict: IDMS_QUINTSOC_L | Quintile de défavorisation sociale le plus fréquent durant le suivi | Quintile (1-5), voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | QUINTSOC
QUINTSOC_longue <- IDMS_clean %>%
  group_by(NOINDIV) %>%
  summarise(IDMS_QUINTSOC_L = get_mode(QUINTSOC))

#-------------------------------------------------------------------------------
# Quintiles matériel et social : valeur la plus récente (dernière observation)

IDMS_clean <- as.data.table(setorder(IDMS_clean, NOINDIV, DAT_REF))
IDMS_R <- IDMS_clean[, .SD[.N], by = NOINDIV]

# @dict: IDMS_QUINTMAT_R | Quintile de défavorisation matérielle le plus récent (dernière observation dans le suivi) | Quintile (1-5), voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | QUINTMAT
IDMS_R$IDMS_QUINTMAT_R <- IDMS_R$QUINTMAT
# @dict: IDMS_QUINTSOC_R | Quintile de défavorisation sociale le plus récent (dernière observation dans le suivi) | Quintile (1-5), voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | QUINTSOC
IDMS_R$IDMS_QUINTSOC_R <- IDMS_R$QUINTSOC

#-------------------------------------------------------------------------------
# Quintiles matériel et social : valeur la plus proche de la naissance (première année de vie)

IDMS_clean_N <- merge(IDMS_clean, table_naissance, by = "NOINDIV", all.x = TRUE)
IDMS_clean_N <- as.data.table(setorder(IDMS_clean_N, NOINDIV, -DAT_REF))
IDMS_N <- IDMS_clean_N[, .SD[.N], by = NOINDIV]
IDMS_N <- IDMS_N %>%
  mutate(an_1 = case_when(DAT_REF - FIPA_NAISS_AAAAMMJJ <= 366 ~ 1, TRUE ~ 0))
IDMS_N <- subset(IDMS_N, an_1 == 1)

# @dict: IDMS_QUINTMAT_N | Quintile de défavorisation matérielle dans la première année de vie (observation la plus proche de la naissance, ≤366 jours) ; mis à NA si l'enfant n'est pas né au Québec (voir COMB_LNAISENF_cat) | Quintile (1-5), voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | QUINTMAT
IDMS_N$IDMS_QUINTMAT_N <- IDMS_N$QUINTMAT
# @dict: IDMS_QUINTSOC_N | Quintile de défavorisation sociale dans la première année de vie (même logique) | Quintile (1-5), voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | QUINTSOC
IDMS_N$IDMS_QUINTSOC_N <- IDMS_N$QUINTSOC

#-------------------------------------------------------------------------------
# Zone (urbain/rural) : la plus fréquente, la plus récente, la plus proche de la naissance

IDMS_clean_zone <- subset(IDMS, !(is.na(ZONE)))
IDMS_clean_zone <- as.data.table(setorder(IDMS_clean_zone, NOINDIV, ANNEE))

# @dict: IDMS_ZONE_L | Zone (urbain/rural) la plus fréquente durant le suivi | Voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | ZONE
Z_longue <- IDMS_clean_zone %>%
  group_by(NOINDIV) %>%
  summarise(IDMS_ZONE_L = get_mode(ZONE))

Z_R <- IDMS_clean_zone[, .SD[.N], by = NOINDIV]
# @dict: IDMS_ZONE_R | Zone (urbain/rural) la plus récente (dernière observation dans le suivi) | Voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | ZONE
Z_R$IDMS_ZONE_R <- Z_R$ZONE

IDMS_clean_zone <- as.data.table(setorder(IDMS_clean_zone, NOINDIV, -DAT_REF))
ZONE_clean_N <- merge(IDMS_clean_zone, table_naissance, by = "NOINDIV", all.x = TRUE)
ZONE_clean_N <- as.data.table(setorder(ZONE_clean_N, NOINDIV, -DAT_REF))
ZONE_N <- ZONE_clean_N[, .SD[.N], by = NOINDIV]
ZONE_N <- ZONE_N %>%
  mutate(an_1 = case_when(DAT_REF - FIPA_NAISS_AAAAMMJJ <= 366 ~ 1, TRUE ~ 0))
ZONE_N <- subset(ZONE_N, an_1 == 1)

# @dict: IDMS_ZONE_N | Zone (urbain/rural) dans la première année de vie (observation la plus proche de la naissance) | Voir codification IDMS | idms_40255 (2006/2011/2016/2021 combinés) | ZONE
ZONE_N$IDMS_ZONE_N <- ZONE_N$ZONE
