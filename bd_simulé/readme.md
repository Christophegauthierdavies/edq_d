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

## BDCU

Épisodes de soins d'urgence (`bdcu_soin_durg_40255`), consultations (`bdcu_cnsul_durg_40255`) et occupations de civière (`bdcu_occu_civie_40255`). Mêmes 1000 enfants que les tables I-CLSC.

Couverture 2014-04-01 au 2024-03-31

Types comme `haven::read_sas()`, comme I-CLSC ; Date-heure (format SAS E8601DT.) → `POSIXct` UTC avec `attr(, "format.sas") = "E8601DT"`.

Codes tirés des domaines de valeurs de la RAMQ (BDCU). 

## MED-ÉCHO

Séjours hospitaliers (`me_sejours_40255`), diagnostics (`me_diag_40255`), soins intensifs (`me_soins_40255`), interventions (`me_inter_40255`), services (`me_serv_40255`) et consultations (`me_consul_40255`). Mêmes 1000 enfants que les tables I-CLSC.

Couverture 2006-01-01 au 2024-03-31

Types comme `haven::read_sas()`, comme I-CLSC.

Codes tirés des domaines de valeurs de la RAMQ (MED-ÉCHO), complétés par les fichiers de l'ISQ et le cadre normatif MED-ÉCHO.
Diagnostics : 173 codes CIM-10-CA fréquents chez l'enfant (Gill et al., JAMA Netw Open 2022), 32 causes externes et des codes CIM-9 pour les séjours terminés avant le 2006-04-01.
Interventions : 88 codes CCI fréquents chez l'enfant (CCADTC avant le 2006-04-01). `COD_INTER` garde le code CCI complet (jusqu'à 10 caractères), même si va_v10 le déclare `$7`.

Cohérent avec `edq_ofeli` (séjour de naissance, poids, gestation, lieu de naissance, décès à l'hôpital) et avec la BDCU (admissions et transferts au départ de l'urgence).

## IDMS

Indice de défavorisation matérielle et sociale (INSPQ) de l'aire de diffusion de l'adresse de l'enfant, une table par recensement : `idms2006_40255`, `idms2011_40255`, `idms2016_40255` et `idms2021_40255`. Une ligne par enfant et par année. Mêmes 1000 enfants que les tables I-CLSC.

Années : recensement le plus proche (2006 → 2006-2008, 2011 → 2009-2013, 2016 → 2014-2018, 2021 → 2019-2023). Date de référence : 1er juillet de chaque année (date des extraits annuels du FIPA reçus par l'ISQ).

Types comme `haven::read_sas()`, comme I-CLSC.

Valeurs selon va_v10 et le guide du programme d'assignation de l'indice de l'INSPQ : quintiles 1 à 5 (1 = plus favorisé), « quartiles » 1 à 3 (les deux quartiles centraux regroupés), centiles 1 à 100.
Aire de diffusion sans indice (dont les RSS 17 et 18) : indices `NA`. Code postal non apparié : indices à 0, `TRAITEMENT` vide.
`CP3` cohérent avec la RSS de résidence de l'enfant ; indices stables à une même adresse dans une même table.
