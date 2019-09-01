bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F13\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg38/hg38.fa.gz  /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R2_001.fastq \
| samtools view -bh | samtools sort -o 043F13.bam -


bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F14\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg38/hg38.fa.gz /data/compbio/melkebir/ElKebir/043F14_ATGTAAGT-ACTCTATG_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F14_ATGTAAGT-ACTCTATG_L002_R2_001.fastq \
| samtools view -bh | samtools sort -o 043F14.bam -

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F15\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg38/hg38.fa.gz /data/compbio/melkebir/ElKebir/043F15_GCACGGAC-GTCTCGCA_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F15_GCACGGAC-GTCTCGCA_L002_R2_001.fastq \
| samtools view -bh | samtools sort -o 043F15.bam -

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F14\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg38/hg38.fa.gz /data/compbio/melkebir/ElKebir/045F14_GGTACCTT-AAGACGTC_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F14_GGTACCTT-AAGACGTC_L002_R2_001.fastq \
| samtools view -bh | samtools sort -o 045F14.bam -

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F15\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg38/hg38.fa.gz /data/compbio/melkebir/ElKebir/045F15_AACGTTCC-GGAGTACT_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F15_AACGTTCC-GGAGTACT_L002_R2_001.fastq \
| samtools view -bh | samtools sort -o 045F15.bam -

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F16\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg38/hg38.fa.gz /data/compbio/melkebir/ElKebir/045F16_GCAGAATT-ACCGGCCA_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F16_GCAGAATT-ACCGGCCA_L002_R2_001.fastq \
| samtools view -bh | samtools sort -o 045F16.bam - 


# -- for matched normal samples
bwa mem -t 4 -R "@RG\tID:171001_I050_CL100037213_L2_WHPYAABRGAA170825-24\tPL:ILLUMINA\tPU:CL100037213_L2\tLB:WHPYAABRGAA170825-24\tSM:043F17" \
../mayo/hg19/ucsc.hg19.fasta.gz \
043F17_R1_1.fastq 043F17_R2_1.fastq \
| samtools view -bh | samtools sort -o ../mayo/043F17.bam -

bwa mem -t 4 -R "@RG\tID:171001_I202_CL100038389_L2_WHPYAACFGAA170825-9\tPL:ILLUMINA\tPU:CL100038389_L2\tLB:WHPYAACFGAA170825-9\tSM:045F19" \
../mayo/hg19/ucsc.hg19.fasta.gz \
045F19_R1_1.fastq 045F19_R2_1.fastq \
| samtools view -bh | samtools sort -o ../mayo/045F19.bam -


# repeat x6 
samtools sort 045F16.bam -o 045F16.sorted.bam

samtools index 045F16.sorted.bam

# mark duplicates
gatk --java-options -Xmx12G MarkDuplicates -I 045F16.sorted.bam -O 045F16.dedup.bam -M 045F16.dedup.metrics.txt

# use this one to store tmp files in scratch, otherwise running into "No space left on device" error
gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx12G" MarkDuplicates \
-I 045F16.bam  \
-O 045F16.dedup.bam \
-M 045F16.dedup.metrics.txt

gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx12G" MarkDuplicates -I 045F16.sorted.bam -O 045F16.dedup.bam -M 045F16.dedup.metrics.txt

#gatk --java-options -Xmx4G BaseRecalibrator \ -R $\ -I $bam \ --known-sites dbsnp_138.b37.vcf.gz \ --known-sites Mills_and_1000G_gold_standard.indels.b37.vcf.gz \ --known-sites 1000G_phase1.indels.b37.vcf.gz \ -O $bam_recal_table
#gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator -R hg19/ucsc.hg19.fasta -I 043F13.dedup.bam --known-sites hg19/dbsnp_138.hg19.vcf.gz --known-sites hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --known-sites hg19/1000G_phase1.indels.hg19.sites.vcf.gz -O 043F13.recal.table.bam
#gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator -R hg19/ucsc.hg19.fasta -I 043F13.dedup.bam --known-sites gatk_bundle/dbsnp_138.hg19.vcf.gz --known-sites gatk_bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --known-sites gatk_bundle/1000G_phase1.indels.hg19.sites.vcf.gz -O 043F13.recal.table.bam

gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator \
-R ref/hg38.fa -I 043F17.dedup.bam \
--known-sites ref/dbsnp_138.hg38.vcf.gz \
--known-sites ref/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
--known-sites ref/1000G_phase1.snps.high_confidence.hg38.vcf.gz \
-O 043F17.recal.table

gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator \
-R ref/hg38.fa -I 043F17.dedup.bam \
--known-sites ref/dbsnp_138.hg38.vcf.gz \
--known-sites ref/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
--known-sites ref/1000G_phase1.snps.high_confidence.hg38.vcf.gz \
-O 043F17.recal.table



gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator \
-R hg19/ucsc.hg19.fasta -I 045F19.dedup.bam \
--known-sites gatk_bundle/dbsnp_138.hg19.vcf \
--known-sites gatk_bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
--known-sites gatk_bundle/1000G_phase1.indels.hg19.sites.vcf \
-O 045F19.recal.table


# applybqsr

gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" ApplyBQSR \
-R hg19/ucsc.hg19.fasta \
-I 045F19.dedup.bam \
--bqsr-recal-file 045F19.recal.table \
-O 045F19.recal.bam

octopus \
-R hg19/ucsc.hg19.fasta \
-I 045F14.dedup.bam 045F15.dedup.bam 045F16.dedup.bam  \
-t hg19/chr.list \
-C cancer \
--forest /scratch/software/src/octopus/resources/forests/germline.v0.6.3-beta.forest \
--somatic-forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
--threads 8 \
-o 045F.vcf

/scratch/software/octopus-beta/octopus \
-R hg19/ucsc.hg19.fasta \
-I 043F13.dedup.bam 043F14.dedup.bam 043F15.dedup.bam  \
-t hg19/chr1.list \
-C cancer \
--very-fast \
--legacy \
--forest /scratch/software/src/octopus/resources/forests/germline.v0.6.3-beta.forest \
--somatic-forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
--threads 8 \
-o 043F.vf.1.vcf

/scratch/software/octopus-beta/octopus \
-R hg19/ucsc.hg19.fasta \
-I 045F14.recal.bam 045F15.recal.bam 045F16.recal.bam   \
-t hg19/chr-ind.list \
-C cancer \
--very-fast \
--forest /scratch/software/src/octopus/resources/forests/germline.v0.6.3-beta.forest \
--somatic-forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
--threads 8 \
-o 045F.vf.1.vcf

###### NORMAL SAMPLES

/scratch/software/octopus-beta/octopus \
-R hg19/ucsc.hg19.fasta \
-I 043F17.recal.bam 043F13.recal.bam 043F14.recal.bam 043F15.recal.bam \
-t hg19/chr1.list \
-N 043F17 \
--forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
--somatics-only \
--annotations AD ADP AF \
--threads 8 \
-o vcf/043F.hg19.test.vcf


## 8 threads, Chr 1, 2 hours ttc --fast
## 8 threads, Chr 1, 
## 8 threads, Chr 1, 


# all 
LD_LIBRARY_PATH="/software/gcc-8.2.0/lib64:/software/gcc-8.2.0/lib:/scratch/software/htslib-1.9/lib:/scratch/software/boost_1_69_0/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH

/scratch/software/octopus-beta/octopus \
-R hg19/ucsc.hg19.fasta \
-I 045F19.recal.bam 045F14.recal.bam 045F15.recal.bam 045F16.recal.bam \
-t hg19/chr1.list \
-N 045F19 \
--forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
--somatics-only \
--annotations AD ADP AF \
--fast \
--threads 8 \
-o vcf/045F.hg19.1.vcf


LD_LIBRARY_PATH="/software/gcc-8.2.0/lib64:/software/gcc-8.2.0/lib:/scratch/software/htslib-1.9/lib:/scratch/software/boost_1_69_0/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH



samtools flagstat 043F13.sorted.bam && samtools flagstat 043F14.sorted.bam && samtools flagstat 043F15.dedup.bam && samtools flagstat 045F14.dedup.bam && samtools flagstat 045F15.dedup.bam && samtools flagstat 045F16.dedup.bam  








###### INSTALLING OCTOPUS 
git clone --recursive -b master https://github.com/luntergroup/octopus.git && cd octopus
cd build 
/scratch/software/cmake-3.10/bin/cmake -DCMAKE_INSTALL_PREFIX=/scratch/software/octopus -DCMAKE_C_COMPILER=/software/gcc-8.2.0/bin/gcc -DCMAKE_CXX_COMPILER=/software/gcc-8.2.0/bin/g++ -DBOOST_ROOT=/scratch/software/boost_1_69_0/ -DHTSLIB_ROOT=/scratch/software/htslib-1.9/ --clean ..
make install -j 16 