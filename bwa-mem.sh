bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F13\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R2_001.fastq > 043F13.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F14\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/043F14_ATGTAAGT-ACTCTATG_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F14_ATGTAAGT-ACTCTATG_L002_R2_001.fastq > 043F14.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F15\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/043F15_GCACGGAC-GTCTCGCA_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F15_GCACGGAC-GTCTCGCA_L002_R2_001.fastq > 043F15.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F14\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/045F14_GGTACCTT-AAGACGTC_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F14_GGTACCTT-AAGACGTC_L002_R2_001.fastq > 045F14.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F15\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/045F15_AACGTTCC-GGAGTACT_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F15_AACGTTCC-GGAGTACT_L002_R2_001.fastq > 045F15.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F16\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/045F16_GCAGAATT-ACCGGCCA_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F16_GCAGAATT-ACCGGCCA_L002_R2_001.fastq > 045F16.bam


# repeat x6 
samtools sort 045F16.bam -o 045F16.sorted.bam

samtools index 045F16.sorted.bam

# mark duplicates
gatk --java-options -Xmx12G MarkDuplicates -I 045F16.sorted.bam -O 045F16.dedup.bam -M 045F16.dedup.metrics.txt

# use this one to store tmp files in scratch, otherwise running into "No space left on device" error
gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx12G" MarkDuplicates -I 043F13.sorted.bam -O 043F13.dedup.bam -M 043F13.dedup.metrics.txt

gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx12G" MarkDuplicates -I 045F16.sorted.bam -O 045F16.dedup.bam -M 045F16.dedup.metrics.txt

#gatk --java-options -Xmx4G BaseRecalibrator \ -R $\ -I $bam \ --known-sites dbsnp_138.b37.vcf.gz \ --known-sites Mills_and_1000G_gold_standard.indels.b37.vcf.gz \ --known-sites 1000G_phase1.indels.b37.vcf.gz \ -O $bam_recal_table
#gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator -R hg19/ucsc.hg19.fasta -I 043F13.dedup.bam --known-sites hg19/dbsnp_138.hg19.vcf.gz --known-sites hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --known-sites hg19/1000G_phase1.indels.hg19.sites.vcf.gz -O 043F13.recal.table.bam
#gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator -R hg19/ucsc.hg19.fasta -I 043F13.dedup.bam --known-sites gatk_bundle/dbsnp_138.hg19.vcf.gz --known-sites gatk_bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --known-sites gatk_bundle/1000G_phase1.indels.hg19.sites.vcf.gz -O 043F13.recal.table.bam

gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" BaseRecalibrator \
-R hg19/ucsc.hg19.fasta -I 045F16.dedup.bam \
--known-sites gatk_bundle/dbsnp_138.hg19.vcf \
--known-sites gatk_bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
--known-sites gatk_bundle/1000G_phase1.indels.hg19.sites.vcf \
-O 045F16.recal.table


# applybqsr

gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx4G" ApplyBQSR \
-R hg19/ucsc.hg19.fasta \
-I 045F14.dedup.bam \
--bqsr-recal-file 045F14.recal.table \
-O 045F14.recal.bam

octopus \
-R hg19/ucsc.hg19.fasta \
-I 045F14.dedup.bam 045F15.dedup.bam 045F16.dedup.bam  \
-t hg19/chr.list \
-C cancer \
--forest /scratch/software/src/octopus/resources/forests/germline.v0.6.3-beta.forest \
--somatic-forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
--threads 8 \
-o 045F.vcf

octopus \
-R hg19/ucsc.hg19.fasta \
-I 043F13.dedup.bam 043F14.dedup.bam 043F15.dedup.bam  \
-t hg19/chr.list \
-C cancer \
--forest /scratch/software/src/octopus/resources/forests/germline.v0.6.3-beta.forest \
--somatic-forest /scratch/software/src/octopus/resources/forests/somatic.v0.6.3-beta.forest \
--threads 8 \
-o 043F.vcf

LD_LIBRARY_PATH="/software/gcc-8.2.0/lib64:/software/gcc-8.2.0/lib:/scratch/software/htslib-1.9/lib:/scratch/software/boost_1_69_0/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH



samtools flagstat 043F13.sorted.bam && samtools flagstat 043F14.sorted.bam && samtools flagstat 043F15.dedup.bam && samtools flagstat 045F14.dedup.bam && samtools flagstat 045F15.dedup.bam && samtools flagstat 045F16.dedup.bam  








###### INSTALLING OCTOPUS 
git clone --recursive -b master https://github.com/luntergroup/octopus.git && cd octopus
cd build 
/scratch/software/cmake-3.10/bin/cmake -DCMAKE_INSTALL_PREFIX=/scratch/software/octopus -DCMAKE_C_COMPILER=/software/gcc-8.2.0/bin/gcc -DCMAKE_CXX_COMPILER=/software/gcc-8.2.0/bin/g++ -DBOOST_ROOT=/scratch/software/boost_1_69_0/ -DHTSLIB_ROOT=/scratch/software/htslib-1.9/ --clean ..
make install -j 16 