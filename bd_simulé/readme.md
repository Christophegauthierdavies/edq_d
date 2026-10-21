# Bases de données simulées

Données fictives, générées par simulation pour 1000 participants.

Couverture 2012-04-01 au 2024-03-31

Types comme `haven::read_sas()` : Numérique → `double` ; Alphanumérique → `character`
  (valeur à blanc = `""`, jamais `NA`) ; Date → `Date` avec `attr(, "format.sas") = "YYMMDD10"`.

Codes tirés des domaines de valeurs de la RAMQ (I-CLSC), complétés par le cadre normatif I-CLSC du MSSS.

## edq_ofeli

Variables issues de la table des participants. Mêmes 1000 enfants que les tables I-CLSC.

Format comme si on fait un `read.csv()` sur les données csv : `data.frame` ; codes, âges, poids et indicateurs → `integer` ;
  texte et dates (AAAA-MM-JJ, AAAA-MM) → `character` ; `NA` → `NA`, champ texte vide → `""`. 
