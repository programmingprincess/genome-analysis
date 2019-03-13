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

