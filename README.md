Description du projet

Première étape: téléchargement des données.
On utilise la fonction fastq-dump pour télécharger les données SRA facilement
on zip et on split les reads toujours en deux fichiers, les reads gauches et les reads droits (pentre autre parce que la qualité de lecture n'est pas la même au début et à la fin du read --> très utile de pouvoir orienter les reads selon leur sens de lecture)
nom du script: "download_data.sh"

Deuxième étape: visualisation des reads avec fastqc et multifastqc
on regarde la fiabilité des lectures le long du read, les taux de GC (pour voir s'il n'y a rien d'anormal). On peut visualiser sur les rapport fastqc les reads un peu extrèmes, pas mal pour repérer s'il y a des outliers avec un mauvaise qualité de lecture, et le rapport multiqc pour avoir une vision d'ensemble sur les 6 échantillons

Troisième étape : trimmomatic, i.e. nettoyage des reads en coupant les portions peu fiables en début et fin de read (en pratique uniquement ou quasi uniquement les fins de reads parce que les débuts sont de suffisamment bonne qualité). Il retire également toutes les amorces de fin de séquençage restantes (on voyait qu'il en resait sur le multiqc report)

Quatrième étape: téléchargement du génome de référence et quasi mapping avec Salmon des reads nettoyés. à la fin on récu^ère une table de comptages des reads

Cinquième étape: on analyse les log fold change WT//Mutant: on les plots et on fait un test stat (wald test = test paramétrique ou likelihood ration threshold à partir de simulations). Ca nous donne les gènes downs régulés et les gènes up-régulés.

Sixième étape: GO pour chercher les fonctions sureprésentées parmis les gènes down et up régulés. ça n'apparait pas dans les scripts puisqu'on copie simplement les gènes up et down régulés obtenues à l'étape 5 sur l'outil en ligne de gene ontology de wormbase. 

Septième étape: on utilise l'outil Raptor  pour vérifier que les ages développementaux sont bien identiques entre les réplicats et entre mutant / WT

Huitième étape: plot des log fold change WT// mutant et des log fold change ref(pseudoage du WT)//ref(pseudoage du mutant) pour visualiser si les différences de niveau d'expression observées entre mutant et WT sont explicables par les différences d'age développementale