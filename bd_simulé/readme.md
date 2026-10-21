# Bases de données simulées

Données fictives, générées par simulation pour 1000 participants.
Couverture 2012-04-01 au 2024-03-31
Types comme `haven::read_sas()` : Numérique → `double` ; Alphanumérique → `character`
  (valeur à blanc = `""`, jamais `NA`) ; Date → `Date` avec `attr(, "format.sas") = "YYMMDD10"`.
- Codes tirés des domaines de valeurs de la RAMQ (I-CLSC), complétés par le cadre normatif
  I-CLSC du MSSS. 

```r
load("bd_simulé/iclsc_interv_40255.RData")   # crée l'objet iclsc_interv_40255
```
