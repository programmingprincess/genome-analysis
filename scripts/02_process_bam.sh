# Index BAM 
# Get duplicates 
# Recalibrate base qualities 

# Stop on errors! 
set -ueo pipefail

SAMPLE=$1

# echo "Indexing ${SAMPLE}.bam"
# samtools index ${SAMPLE}.bam

# echo "Getting duplicates for ${SAMPLE}.bam"
# gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx12G" MarkDuplicates \
# -I ${SAMPLE}.bam  \
# -O ${SAMPLE}.dedup.bam \
# -M ${SAMPLE}.dedup.metrics.txt

echo "Getting recalibrated base qualities for ${SAMPLE}.bam"
gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator \
-R ref/hg38.fa -I ${SAMPLE}.dedup.bam \
--known-sites ref/dbsnp_138.hg38.vcf.gz \
--known-sites ref/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
--known-sites ref/1000G_phase1.snps.high_confidence.hg38.vcf.gz \
-O ${SAMPLE}.recal.table

echo "Applying base quality recalibration on ${SAMPLE}.bam"
gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" ApplyBQSR \
-R ref/hg38.fa \
-I ${SAMPLE}.dedup.bam \
--bqsr-recal-file ${SAMPLE}.recal.table \
-O ${SAMPLE}.recal.bam

echo "Indexing ${SAMPLE}.recal.bam"
samtools index ${SAMPLE}.recal.bam

