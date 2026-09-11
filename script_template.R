# ==============================================================================
# <titre du script>
# Auteur : <ton nom>
# Thème  : <dossier parent, ex. sociodemographique>
# ==============================================================================

library(data.table)
# ... autres librairies

# ------------------------------------------------------------------------
# <nom de la source, ex. RAMQ - FIPA>
# ------------------------------------------------------------------------

# @dict: NOM_VARIABLE | Description en une phrase | Domaine de valeurs (ex. Oui/Non, M/F, Années 2006-2023) | fichier_source_sas | variable(s)_source
# <ton code habituel qui crée la variable>

# Ajoute un tag @dict: pour chaque variable qui doit apparaître dans le
# dictionnaire. Plusieurs tags peuvent précéder une même ligne de code
# (utile pour un rename() qui crée plusieurs variables d'un coup).
# Un champ peut rester vide (ex. domaine de valeurs d'un identifiant),
# mais les 4 séparateurs "|" doivent toujours être présents.
