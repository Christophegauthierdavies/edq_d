# Comment contribuer

## Ajouter ou modifier une variable

1. `git checkout -b ajout-<nom-variable>` (ou directement via l'interface GitHub).
2. Placer le script dans `scripts/<thème>/` (créer un sous-dossier pour un sous-thème si utile).
3. Documenter chaque variable destinée au dictionnaire avec un tag `# @dict:` juste au-dessus du code qui la crée (voir le README pour la syntaxe, et `scripts/_template/script_template.R` pour un gabarit).
4. Si R est installé localement, vérifier que les tags sont bien reconnus :
   ```r
   source("R/build_dictionary.R")
   source("R/export_excel.R")
   ```
   Les tags incomplets (variable ou description manquante) sont listés dans `dictionnaire/tags_incomplets.csv`.
5. Ouvrir une pull request avec le gabarit fourni.

## Avant d'ouvrir la pull request

- Aucun fichier de données (`.sas7bdat`, `.csv` de données individuelles, etc.) dans le commit.
- Aucun chemin local propre à ton poste (ex. `C:/Users/...`, `OneDrive`) dans le script final.
- Chaque variable destinée au dictionnaire a un tag `# @dict:` complet.

## Proposer une variable sans écrire le script tout de suite

Ouvrir une issue avec le gabarit « Nouvelle variable », pour éviter qu'une même variable soit recréée en double dans deux projets.
