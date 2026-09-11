# ==============================================================================
# Participation aux enquêtes
# Adapté de Dictionnaire_ofelie_sociodemo.R. Indicateurs de participation de
# chaque individu aux différentes vagues d'enquête de la cohorte.
# ==============================================================================

library(data.table)
library(dplyr)

Enquete <- fread("BD/Enquete.csv")  # d40255_cohorte_enq
Enquete <- rename(Enquete, NOINDIV = noindiv)

# @dict: IND_OPES_COMB | Participation à l'enquête OPES, questionnaire combiné | 0=n'a pas participé, 1=a participé | d40255_cohorte_enq | IND_OPES_COMB
# @dict: IND_OPES_ENS | Participation à l'enquête OPES, questionnaire enseignant | 0=n'a pas participé, 1=a participé | d40255_cohorte_enq | IND_OPES_ENS
# @dict: IND_OPES_PAR | Participation à l'enquête OPES, questionnaire parent | 0=n'a pas participé, 1=a participé | d40255_cohorte_enq | IND_OPES_PAR
# @dict: IND_EQDEM17 | Participation à l'Enquête québécoise sur le développement des enfants à la maternelle (EQDEM) 2017 | 0=n'a pas participé, 1=a participé | d40255_cohorte_enq | IND_EQDEM17
# @dict: IND_EQDEM22 | Participation à l'Enquête québécoise sur le développement des enfants à la maternelle (EQDEM) 2022 | 0=n'a pas participé, 1=a participé | d40255_cohorte_enq | IND_EQDEM22
# @dict: IND_ELDEQ2 | Participation à l'Étude longitudinale du développement des enfants du Québec (ÉLDEQ), 2e cohorte | 0=n'a pas participé, 1=a participé | d40255_cohorte_enq | IND_ELDEQ2

# Absence dans le fichier d'enquête = absence de participation (NA -> 0)
Enquete[is.na(IND_OPES_COMB), IND_OPES_COMB := 0]
Enquete[is.na(IND_OPES_ENS), IND_OPES_ENS := 0]
Enquete[is.na(IND_OPES_PAR), IND_OPES_PAR := 0]
Enquete[is.na(IND_EQDEM17), IND_EQDEM17 := 0]
Enquete[is.na(IND_EQDEM22), IND_EQDEM22 := 0]
Enquete[is.na(IND_ELDEQ2), IND_ELDEQ2 := 0]
