# Bases de données simulées

**Données entièrement fictives**, générées par simulation pour 1000 participants.
Aucune donnée réelle ni individuelle. Elles reproduisent la structure des tables
du CADRISQ telles que lues dans R avec `haven::read_sas()`, pour développer et
tester les scripts hors de l'environnement protégé.

## I-CLSC (onglet iCLSC de va_v10.xlsx), couverture 2012-04-01 au 2024-03-31

| Fichier | Contenu | Lignes |
|---|---|---|
| `iclsc_interv_40255.RData` | Interventions en CLSC | 15 224 |
| `iclsc_inter_doss_40255.RData` | Dossiers des interventions | 12 177 |
| `iclsc_dem_serv_40255.RData` | Demandes de services | 2 457 |
| `iclsc_assign_40255.RData` | Assignations de services | 2 381 |
| `iclsc_episo_serv_40255.RData` | Épisodes de services | 2 079 |
| `iclsc_doss_usag_40255.RData` | Dossiers de l'usager | 1 413 |

## Format

- Noms des tables et des variables, ordre de livraison, libellés et tri : ceux de va_v10.xlsx.
- Chaque fichier contient un seul objet `tibble`, nommé comme le fichier.
- Types comme `haven::read_sas()` : Numérique → `double` ; Alphanumérique → `character`
  (valeur à blanc = `""`, jamais `NA`) ; Date → `Date` avec `attr(, "format.sas") = "YYMMDD10"`.
- Codes tirés des domaines de valeurs de la RAMQ (I-CLSC), complétés par le cadre normatif
  I-CLSC du MSSS. Chaque code en vigueur pendant la couverture apparaît au moins une fois :
  les fréquences des codes rares ne sont donc pas réalistes.
- `COD_CTRE_ACTIV` sur 5 caractères avec zéros de tête (ex. `06570` Aire ouverte).

## Utilisation

```r
load("bd_simulé/iclsc_interv_40255.RData")   # crée l'objet iclsc_interv_40255
```
