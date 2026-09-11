# ==============================================================================
# RAMQ - Territoire de résidence (CLSC / RSS)
# Adapté de Dictionnaire_ofelie_sociodemo.R. Le nettoyage des RSS manquants
# (déduction à partir du code postal CP3) n'est pas reproduit ici - voir le
# script original ; seule la logique de création des variables finales, à
# partir du fichier déjà nettoyé, est montrée.
# ==============================================================================

library(data.table)
library(dplyr)

# RAMQ_tert_clean : ramq_tert_clsc_40255, après déduction des RSS manquants à
# partir du CP3 quand c'est possible (un CP3 associé à une seule RSS)
RAMQ_tert_clean <- fread("BD/RAMQ_tert_clean.csv")

get_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#-------------------------------------------------------------------------------
# RSS où l'individu a résidé le plus longtemps (excluant les RSS inconnues, code 99)

RAMQ_tert_L <- subset(RAMQ_tert_clean, !(RSS == "99"))
RAMQ_tert_L <- as.data.table(setorder(RAMQ_tert_L, NOINDIV, ANNEE))

# @dict: RAMQ_TERT_RSS_L | Région sociosanitaire (RSS) où l'individu a résidé le plus longtemps durant le suivi (valeur la plus fréquente ; en cas d'égalité, la première rencontrée une fois les données triées par année) | Code RSS (exclut 99 = inconnu) | ramq_tert_clsc_40255 | RSS
RSS_longue <- RAMQ_tert_L %>%
  group_by(NOINDIV) %>%
  summarise(RAMQ_TERT_RSS_L = get_mode(RSS))

#-------------------------------------------------------------------------------
# RSS où l'individu a résidé le plus récemment (dernière apparition dans le fichier, 99 inclus)

RAMQ_tert_R <- as.data.table(setorder(RAMQ_tert_clean, NOINDIV, ANNEE))
RSS_recent <- RAMQ_tert_R[, .SD[.N], by = NOINDIV]

# @dict: RAMQ_TERT_RSS_R | Région sociosanitaire (RSS) où l'individu a résidé le plus récemment (dernière observation dans le fichier) | Code RSS (99 = inconnu) | ramq_tert_clsc_40255 | RSS
RSS_recent <- rename(RSS_recent, RAMQ_TERT_RSS_R = RSS)
