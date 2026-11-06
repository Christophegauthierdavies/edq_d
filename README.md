GitHub d'enfants du Québec. Dictionnaire de données, scripts et projets.

## Deux dictionnaires

- [`dictionnaire_brut/`](dictionnaire_brut/) : **données brutes**. `va_v10.xlsx` décrit les tables telles qu'elles se trouvent au CADRISQ (noms des tables et des variables, formats, domaines de valeurs). Fichier fourni avec les données, non modifié.
- [`dictionnaire/`](dictionnaire/) : **variables dérivées**. Variables créées par les scripts de `scripts/` à partir des données brutes, compilées automatiquement à partir des tags `# @dict:`.

Exemple : `DUREGROS` (table red_naiss) est une variable brute, décrite dans va_v10. `REDNAIS_GESTA` et `COMB_GESTA`, créées à partir d'elle par `scripts/sante-physique/naissance-clinique.R`, sont des variables dérivées, décrites dans `dictionnaire/`.
