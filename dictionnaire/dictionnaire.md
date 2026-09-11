# Dictionnaire de données

_Généré automatiquement à partir des scripts sous `scripts/`. Ne pas éditer à la main._

## sociodemographique

| Variable | Description | Domaine de valeurs | Fichier source | Variable(s) source | Script |
|---|---|---|---|---|---|
| `FIPA_NAISS_AAAA` | Année de naissance | Années (2006-2023) | ramq_fipa_40255 | NAIS_AAAAMMJJ_FIPA | [fipa-rpam-exemple.R](../scripts/sociodemographique/fipa-rpam-exemple.R) |
| `FIPA_NAISS_AAAAMMJJ` | Date de naissance (AAAA-MM-JJ) | Date | ramq_fipa_40255 | NAIS_AAAAMMJJ_FIPA | [fipa-rpam-exemple.R](../scripts/sociodemographique/fipa-rpam-exemple.R) |
| `FIPA_SEXE` | Sexe | M/F | ramq_fipa_40255 | SEXE | [fipa-rpam-exemple.R](../scripts/sociodemographique/fipa-rpam-exemple.R) |
| `NOINDIV` | Numéro unique de l'individu créé par l'ISQ |  | ramq_fipa_40255 | NOINDIV | [fipa-rpam-exemple.R](../scripts/sociodemographique/fipa-rpam-exemple.R) |
| `RPAM_ADMISS` | Inscription au RPAM pour au moins une journée | Oui/Non | ramq_admis_ass_med_40255 | (présence/absence dans le fichier) | [fipa-rpam-exemple.R](../scripts/sociodemographique/fipa-rpam-exemple.R) |
| `RPAM_ADMISS_PS` | Prestataire d'assurance-emploi au moins une fois durant le suivi | 0/1 | ramq_admis_ass_med_40255 | COD_PGM | [fipa-rpam-exemple.R](../scripts/sociodemographique/fipa-rpam-exemple.R) |
