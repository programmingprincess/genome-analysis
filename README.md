# genome-analysis
Genome analysis pipeline that follows GATK best practices from Broad Institute. This pipeline goes through: alignment, processing BAM files, variant calling, and copy number calling. 

See the [scripts](https://github.com/programmingprincess/genome-analysis/tree/master/scripts) folder for ready-to-run scripts. 

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


#### base recallibrator 
Get the following `.vcf` files and their corresponding index files (`.dict`, `.idx`) from GATK resource bundle: 
`dbsnp_138.hg19.vcf`
`Mills_and_1000G_gold_standard.indels.hg19.sites.vcf`
`1000G_phase1.indels.hg19.sites.vcf`

(dbsnp and 1000G were also avaialble in original UCSC ftp server, but I got them all from GATK bundle for consistency)

`gunzip` and `IndexFeatureFiles` for `dbsnp_138.hg19.vcf` (to solve block compression format error...see here: https://gatkforums.broadinstitute.org/gatk/discussion/11908/variantrecalibrator-error-using-gatk-bundle-vcf-files)

Deviation from Octopus paper: the Octopus paper uses `.vcf.gz` files but we used unzipped `.vcf` files because of block compression error, and GATK doesnt support zipped files (GATK documentation also does it this way)



#### Variant calling using octopus 

Use script `run_octopus.sh`. 
`--fast` sacrifices some accuracy for speed. 


## Todo
[] Document how to find statistics for bam/vcf files 
[] Clarify difference between `bcftools` and `vcftools`
[] Copy number calling pipeline 


