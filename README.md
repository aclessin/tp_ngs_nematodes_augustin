Description du projet

Première étape: téléchargement des données.
On utilise la fonction fastq-dump pour télécharger les données SRA facilement
on zip et on split les reads toujours en deux fichiers, les reads gauches et les reads droits (pentre autre parce que la qualité de lecture n'est pas la même au début et à la fin du read --> très utile de pouvoir orienter les reads selon leur sens de lecture)
