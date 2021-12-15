Description du projet

Première étape: téléchargement des données.
On utilise la fonction fastq-dump pour télécharger les données SRA facilement
on zip et on split les reads toujours en deux fichiers, les reads gauches et les reads droits (pentre autre parce que la qualité de lecture n'est pas la même au début et à la fin du read --> très utile de pouvoir orienter les reads selon leur sens de lecture)
nom du script: "download_data.sh"

Deuxième étape: visualisation des reads avec fastqc et multifastqc
on regarde la fiabilité des lectures le long du read, les taux de GC (pour voir s'il n'y a rien d'anormal). On peut visualiser sur les rapport fastqc les reads un peu extrèmes, pas mal pour repérer s'il y a des outliers avec un mauvaise qualité de lecture, et le rapport multiqc pour avoir une vision d'ensemble sur les 6 échantillons

Troisième étape : trimmomatic, i.e. nettoyage des reads en coupant les portions peu fiables en début et fin de read (en pratique uniquement ou quasi uniquement les fins de reads parce que les débuts sont de suffisamment bonne qualité). Il retire également toutes les amorces de fin de séquençage restantes (on voyait qu'il en resait sur le multiqc report)

Quatrième étape: téléchargement du génome de référence et quasi mapping avec Salmon des reads nettoyés. On commence par faire un index Salmon en hachant le génome de référence et en triant chaque mot haché (longueur à fixer de qq dizaines )