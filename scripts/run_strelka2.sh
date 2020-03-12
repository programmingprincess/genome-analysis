#!/bin/bash
STRELKA_INSTALL_PATH=/scratch/software/strelka-2.9.10.centos6_x86_64

${STRELKA_INSTALL_PATH}/bin/configureStrelkaSomaticWorkflow.py \
    --normalBam kidney_RG.dedup.bam \
    --tumorBam cell_line_RG.dedup.bam \
    --referenceFasta ref/sus11.1.fa \
    --callRegions ref/sus11.1.bed.gz \
    --runDir cell_line

# execution on a single local machine with 20 parallel jobs
cell_line/runWorkflow.py -m local -j 20

for i in {1..5}
do
	${STRELKA_INSTALL_PATH}/bin/configureStrelkaSomaticWorkflow.py \
	    --normalBam kidney_RG.dedup.bam \
	    --tumorBam tumor${i}_RG.dedup.bam \
	    --referenceFasta ref/sus11.1.fa \
            --callRegions ref/sus11.1.bed.gz \
	    --runDir tumor${i}

	# execution on a single local machine with 20 parallel jobs
	tumor${i}/runWorkflow.py -m local -j 20
done
