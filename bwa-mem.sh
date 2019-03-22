bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F13\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R2_001.fastq > 043F13.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F14\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/043F14_ATGTAAGT-ACTCTATG_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F14_ATGTAAGT-ACTCTATG_L002_R2_001.fastq > 043F14.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F15\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/043F15_GCACGGAC-GTCTCGCA_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F15_GCACGGAC-GTCTCGCA_L002_R2_001.fastq > 043F15.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F14\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/045F14_GGTACCTT-AAGACGTC_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F14_GGTACCTT-AAGACGTC_L002_R2_001.fastq > 045F14.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F15\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/045F15_AACGTTCC-GGAGTACT_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F15_AACGTTCC-GGAGTACT_L002_R2_001.fastq > 045F15.bam

bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:045F16\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/045F16_GCAGAATT-ACCGGCCA_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/045F16_GCAGAATT-ACCGGCCA_L002_R2_001.fastq > 045F16.bam


# repeat x6 
samtools sort 045F16.bam -o 045F16.sorted.bam

