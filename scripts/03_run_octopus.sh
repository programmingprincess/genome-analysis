#!/bin/bash

# Stop on errors! 
set -ueo pipefail

for i in {1..22} {X..Y}
do
	echo "Variant calling for chromosome ${i}"
  /scratch/software/octopus-beta/octopus \
	-R ref/hg38.fa \
	-I 045F19.recal.bam 045F14.recal.bam 045F15.recal.bam 045F16.recal.bam \
	-t ref/chr$i.list \
	-N 045F19 \
	--forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
	--fast \
	--somatics-only \
	--annotations AD ADP AF \
	--threads 10 \
	-o vcf/045F.hg38.fast.$i.vcf
done
