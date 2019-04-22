# Index BAM 
# Get duplicates 
# Recalibrate base qualities 

# Stop on errors! 
set -ueo pipefail

SAMPLE=$1

echo "Indexing ${SAMPLE}.bam"
samtools index ${SAMPLE}.bam

echo "Getting duplicates for ${SAMPLE}.bam"
gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx12G" MarkDuplicates \
-I ${SAMPLE}.bam  \
-O ${SAMPLE}.dedup.bam \
-M ${SAMPLE}.dedup.metrics.txt

echo "Getting recalibrated base qualities for ${SAMPLE}.bam"
gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator \
-R hg19/ucsc.hg19.fasta -I ${SAMPLE}.dedup.bam \
--known-sites gatk_bundle/dbsnp_138.hg19.vcf \
--known-sites gatk_bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
--known-sites gatk_bundle/1000G_phase1.indels.hg19.sites.vcf \
-O ${SAMPLE}.recal.table

echo "Applying base quality recalibration on ${SAMPLE}.bam"
gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" ApplyBQSR \
-R hg19/ucsc.hg19.fasta \
-I ${SAMPLE}.dedup.bam \
--bqsr-recal-file ${SAMPLE}.recal.table \
-O ${SAMPLE}.recal.bam

echo "Indexing ${SAMPLE}.recal.bam"
samtools index ${SAMPLE}.recal.bam

