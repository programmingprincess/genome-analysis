# Aligh paired end reads with BWA-MEM

# Stop on errors! 
set -ueo pipefail

R1=$1
R2=$2
SAMPLE=$3

echo "Aligning ${R1} and ${R2}"
bwa mem -t 4 -R "@RG\tID:171001_I202_CL100038389_L2_WHPYAACFGAA170825-9\tPL:ILLUMINA\tPU:CL100038389_L2\tLB:WHPYAACFGAA170825-9\tSM:045F19" \
../mayo/hg19/ucsc.hg19.fasta.gz \
${R1}.fastq ${R2}.fastq \
| samtools view -bh | samtools sort -o ${SAMPLE}.bam -
