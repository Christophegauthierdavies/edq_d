# ==============================================================================
# Exemple annoté : profil sociodémographique (RAMQ - FIPA, RPAM)
# Adapté de Dictionnaire_ofelie_sociodemo.R pour illustrer la convention de
# tags "# @dict:". La logique de dérivation est inchangée ; seuls les tags
# de documentation ont été ajoutés.
# ==============================================================================

library(data.table)
library(dplyr)
library(lubridate)

#-------------------------------------------------------------------------------
#                               RAMQ - FIPA
#-------------------------------------------------------------------------------

# @dict: NOINDIV | Numéro unique de l'individu créé par l'ISQ | | ramq_fipa_40255 | NOINDIV
FIPA <- fread("BD/FIPA.csv")

# Extraction et renommage des variables pour la table (sexe, date de naissance et date de deces)

# @dict: FIPA_NAISS_AAAA | Année de naissance | Années (2006-2023) | ramq_fipa_40255 | NAIS_AAAAMMJJ_FIPA
FIPA$FIPA_NAISS_AAAA <- as.factor(year(FIPA$NAIS_AAAAMMJJ_FIPA))

# @dict: FIPA_NAISS_AAAAMMJJ | Date de naissance (AAAA-MM-JJ) | Date | ramq_fipa_40255 | NAIS_AAAAMMJJ_FIPA
# @dict: FIPA_SEXE | Sexe | M/F | ramq_fipa_40255 | SEXE
FIPA <- rename(FIPA, FIPA_NAISS_AAAAMMJJ = NAIS_AAAAMMJJ_FIPA, FIPA_DECES_AAAAMM = DECES_AAAAMM_FIPA, FIPA_SEXE = SEXE)

#-------------------------------------------------------------------------------
#          RAMQ - RPAM (Régime public d'assurance médicament)
#-------------------------------------------------------------------------------

RPAM <- fread("BD/RPAM.csv")
RPAM <- as.data.table(RPAM)

# @dict: RPAM_ADMISS | Inscription au RPAM pour au moins une journée | Oui/Non | ramq_admis_ass_med_40255 | (présence/absence dans le fichier)
# Inscription au RPAM pour au moins une journee (oui/non = présence/absence dans le fichier)
RPAM$RPAM_ADMISS <- 1

# @dict: RPAM_ADMISS_PS | Prestataire d'assurance-emploi au moins une fois durant le suivi | 0/1 | ramq_admis_ass_med_40255 | COD_PGM
RPAM[, RPAM_ADMISS_PS := as.integer(cumsum(COD_PGM %in% c("PS")) > 0), by = NOINDIV]
