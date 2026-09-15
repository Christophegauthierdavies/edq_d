# Dictionnaire de données et dépôt de scripts (équipe)

Plusieurs personnes travaillent sur des projets différents mais réutilisent souvent les mêmes variables (RAMQ, MED-ÉCHO, MEQ, BDCU, etc.), sans endroit central pour les partager. Ce dépôt sert de :

- **Dictionnaire de données**, généré automatiquement à partir des scripts eux-mêmes, pas des données (auxquelles on n'a jamais accès ici).
- **Répertoire de scripts**, classés par thématique, consultables et téléchargeables directement sur GitHub.


## Le principe


### La convention `# @dict:`

Une ligne de commentaire, placée juste au-dessus du code qui crée la variable :

```r
# @dict: NOM_VARIABLE | Description | Domaine de valeurs | Fichier(s) source | Variable(s) source
```

Exemple, tiré de `scripts/sociodemographique/fipa-rpam-exemple.R` (adapté de ton script) :

```r
# @dict: RPAM_ADMISS | Inscription au RPAM pour au moins une journée | Oui/Non | ramq_admis_ass_med_40255 | (présence/absence dans le fichier)
RPAM$RPAM_ADMISS <- 1
```

Un script peut avoir plusieurs tags à la suite, juste au-dessus d'une même ligne de code (utile pour un `rename()` qui crée plusieurs variables d'un coup). Un champ vide reste possible (ex. domaine de valeurs pour un identifiant), mais les 4 séparateurs `|` doivent toujours être présents.

À partir de ces tags, `R/build_dictionary.R` compile automatiquement `dictionnaire/dictionnaire.csv`, `.json` et `.md` ; `R/export_excel.R` produit ensuite `dictionnaire/dictionnaire.xlsx`.

## Structure du dépôt

```
scripts/
├── sociodemographique/
├── sante-mentale/
├── sante-physique/
├── education/
├── services/                      <- utilisation des services (hospitalisations, urgences...)
├── enquetes/                      <- participation aux enquêtes de la cohorte
└── _template/script_template.R   <- point de départ pour un nouveau script
R/
├── build_dictionary.R    <- scanne scripts/, produit dictionnaire.csv/json/md
└── export_excel.R        <- produit dictionnaire.xlsx à partir du json
dictionnaire/              <- généré automatiquement, ne pas éditer à la main
```

Un sous-dossier sous un thème devient un sous-thème (ex. `scripts/sociodemographique/naissance/`). Le thème et le sous-thème d'une variable dans le dictionnaire sont déduits directement de l'emplacement du script : pas besoin de les répéter dans le tag.

## Ajouter un script

1. Copier `scripts/_template/script_template.R` dans le bon dossier thématique (en créer un nouveau si besoin).
2. Écrire le script normalement, et ajouter un tag `# @dict:` au-dessus de chaque variable qui doit apparaître dans le dictionnaire.
3. Ouvrir une pull request (le gabarit rappelle les règles : aucune donnée individuelle, aucun chemin local propre à ton poste).
4. Après la revue (contrôle de divulgation, voir plus bas), la fusion vers `main` régénère automatiquement le dictionnaire.

Détails pas à pas dans `CONTRIBUTING.md`.

## Sorties

Trois sorties visées, alimentées par la même source :

- **GitHub** : ce dépôt, scripts et dictionnaire (`dictionnaire.csv`/`.md`, lisibles nativement dans l'interface GitHub) versionnés et téléchargeables directement.
- **Excel** : `dictionnaire/dictionnaire.xlsx`, un onglet par thème, pour consultation hors GitHub.
- **CADRISQ** : après chaque diffusion, déposer une copie de `dictionnaire/dictionnaire.xlsx` (ou `.json`) dans l'enceinte sécurisée pour l'archivage de conformité. Cette étape reste manuelle, l'enceinte n'étant pas jointe à Internet.

## Contrôle de divulgation (étape 4)

Avant toute fusion vers `main`, donc avant toute diffusion, une revue humaine est requise. Qui valide et selon quels critères reste à déterminer. En attendant, la protection de branche GitHub (revue obligatoire avant fusion) sert de verrou minimal. Mettre à jour cette section une fois le processus arrêté avec CADRISQ.

## Prochaines étapes

- Configurer la protection de la branche `main` (revue obligatoire avant fusion).
- Régler qui valide le contrôle de divulgation, et selon quels critères.
- Étendre le parseur pour les scripts SAS/STATA quand ils arriveront ; la convention de tag reste la même, seul le caractère de commentaire change (`*` en SAS, par exemple).
