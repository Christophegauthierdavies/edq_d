# Dictionnaire des données brutes

`va_v10.xlsx` (version 10) décrit les tables brutes d'Enfants du Québec, telles qu'elles se trouvent au CADRISQ, avant tout traitement par les scripts du dépôt. Le fichier est déposé tel quel.

Un onglet par banque :

| Onglet | Banque | Tables |
|---|---|---|
| RAMQ-MSSS | RAMQ : inscription (FIPA), admissibilité, services pharmaceutiques et médicaux, territoire CLSC | 7 |
| MED-ECHO | Hospitalisations (MED-ÉCHO) | 6 |
| RED | Registre des événements démographiques : naissances, appariement FIPA-RED, décès | 3 |
| BDCU | Urgences | 3 |
| iCLSC | Services des CLSC (I-CLSC) | 6 |
| IDMS | Indice de défavorisation matérielle et sociale | 4 |
| SIRTQ | Traumatismes : événements, séjours, blessures, complications | 6 |
| EDU_PPS | Éducation : caractéristiques, fréquentation, résultats scolaires et épreuves ministérielles | 9 |

Pour chaque table : description, unité (ex. 1 ligne par individu) et tri. Pour chaque variable : ordre de livraison, libellé, nom dans le fichier SAS, description, format (numérique, alphanumérique et longueur, date) et domaine de valeurs (souvent un lien vers la liste de valeurs de l'ISQ).

## Données brutes et variables dérivées

| | `dictionnaires/données_bruts/` (ce dossier) | [`dictionnaires/dictionnaire.md`](../dictionnaire.md) (et `.csv`, `.json`, `.xlsx`) |
|---|---|---|
| Décrit | les variables des tables brutes | les variables créées par les scripts de `scripts/` |
| Exemple | `DUREGROS` (table red_naiss) | `REDNAIS_GESTA`, `COMB_GESTA` (créées à partir de `DUREGROS`) |
| Source | `va_v10.xlsx`, fourni avec les données | tags `# @dict:` des scripts |
| Mise à jour | à chaque nouvelle version de va (v11, …) | automatique, à chaque modification des scripts |

Les tables simulées de [`bd_simulé/`](../../bd_simulé/) reprennent les noms des tables et des variables de ce dictionnaire.
