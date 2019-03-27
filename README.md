# genome-analysis
Genome analysis pipeline that follows GATK best practices from Broad Institute 

## Data Pre-processing 

#### Mapping to reference genome 

Human reference genome downloaded from:
http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/

Index the files (not sure if necessary, but was running into a `[E::bwa_idx_load_from_disk] fail to locate the index files` error when I didn't)

`$ bwa index hg19/ucsc.hg19.fasta.gz` 

Read groups example:  
`-R "@RG\tID:HG5H.2\tSM:045F16\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2"`  
`tID`, `tPU` are obtained from fastq files.   
`tSM` is name of the fastq file. 


Use `bwa-mem` to map to reference  

`$ bwa mem -t 4 -R "@RG\tID:HG5H.2\tSM:043F13\tLB:library1\tPL:illumina\tPU:HG5HWDSXX.2" hg19/ucsc.hg19.fasta.gz /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R1_001.fastq /data/compbio/melkebir/ElKebir/043F13_CGGCGTGA-GCGCCTGT_L002_R2_001.fastq > 043F13.bam`

#### Sort and index 

`samtools sort bamfile.bam -o bamfile.sorted.bam`

`samtools index bamfile.bam` 

#### Mark duplicates using gatk command line tools

`gatk --java-options -Xmx12G MarkDuplicates -I 045F16.sorted.bam -O 045F16.dedup.bam -M 045F16.dedup.metrics.txt`
`gatk --java-options "-Djava.io.tmpdir=/scratch/tmp -Xmx12G" MarkDuplicates -I 043F13.sorted.bam -O 043F13.dedup.bam -M 043F13.dedup.metrics.txt`
