# genome-analysis
Genome analysis pipeline that follows GATK best practices from Broad Institute. This pipeline goes through: alignment, processing BAM files, variant calling, and copy number calling. 

See the [scripts](https://github.com/programmingprincess/genome-analysis/tree/master/scripts) folder for ready-to-run scripts. 

## Contents ## 
1. [Requirements](#requirments)
2. [Pipeline](https://github.com/programmingprincess/genome-analysis/tree/master/scripts)
    - [Alignment](#alignment)
    - [Variant calling](#variantcalling)
    - [Copy number calling](#copynumbercalling)
3. [Useful commands](#commands)

## Requirements: 
<a name="requirments"></a>
* BWA (Alignment) https://github.com/lh3/bwa
* SAMtools (Alignment) http://www.htslib.org/
* Octopus (SNV-calling) https://github.com/luntergroup/octopus/
* Strelka2 (SNV-calling also) https://github.com/Illumina/strelka
* HATCHet (Copy-number calling) https://github.com/raphael-group/hatchet


## Alignment (FASTQ to BAM)
<a name="alignment"></a>
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



## Variant calling 
<a name="variantcalling"></a>

#### Useful commands in general

See bcftools documentation: https://samtools.github.io/bcftools/bcftools.html

Take union of all SNVs from samples 1 through 4. `--force-samples` will combine sample columns that have the same name, and append an index in front of the new colun (according to their order in the command)

`bcftools merge -Ov -m none sample1/somatic.snvs.vcf.gz sample2/somatic.snvs.vcf.gz sample3/somatic.snvs.vcf.gz sample4/somatic.snvs.vcf.gz -o combined.vcf --force-samples` 

Get intersection of VCF files. `dir` is the name of a new directory this command will create. Inside, read `README.md` for more information about what each file is. Usually, if you have two files, there will be four files created: 
- 1. All SNVs unique to file1, taken from file1. 
- 2. All SNVs unique to file2, taken from file2. 
- 3. SNVs common to both file1 and file2, taken from file 1.
- 4. SNVs common to both file1 and file2, taken from file 2.

`bcftools isec -p dir -f PASS sample3/somatic.snvs.vcf.gz sample4/somatic.snvs.vcf.gz` 


#### Using octopus 

Supports multi-sample. Use script `run_octopus.sh`. 
`--fast` sacrifices some accuracy for speed. 

#### Using strelka2 

Does not support multi-sample (but has a workaround that improves recall: https://github.com/Illumina/strelka/issues/59/.
Use script `run_strelka2.sh`. 


#### Annotating VCF file with snpEff 

This provides the following information: 
- 1. What gene does the SNV occur in.
- 2. What is the type/function of the mutation (i.e., synonymous, missense, stop_gained?)
- 3. The actual nucleotide change and/or protein change

snpEff also lets you use your own reference genome if needed. This script uses a downloaded genome. 

`java -Xmx4g -jar snpEff.jar -v sus11.1 /scratch/data/output.vcf > Sus11.1_annotated.vcf` 

## Copy Number Calling 
<a name="copynumbercalling"></a>
(documentation incomplete)
We use [HATCHet](https://github.com/programmingprincess/genome-analysis/tree/master/scripts) for copy number calling. 

## Mutational signatures 
(documentation incomplete)
Python implementation: https://github.com/lrgr/signature-estimation-py/tree/master/example

R implementation (heuristic): https://github.com/raerose01/deconstructSigs

I used deconstructSigs to create and normalize a trinucleotide count matrix. Then, I used that as input for signature-estimation-py. 


## General useful commands 
<a name="commands"></a>

Be sure to grant access to your script before running it with bash. For instance:

`chmod u+x`

`bash XYZ.sh` 

u means user 
x means executable 

Finding matching genes from a genelist. 

`grep -w -F -f genelist.txt Sus11.1_genes.gff3 > overlapping_genes.gff3`

Take one column from a file, use a delimiter to split up a column, sort, and count each unique value. 

`grep -v "\#" output_concat_annotated.vcf | cut -f8 | cut -d'|' -f2 | sort | uniq -c`

Manipulate files using awk (i.e., appending "chr" in front of every value in a column)

`awk '{  print "sample\t" $1"\t"$2"\t"$3"\t"$4"\t"  }' desig_strelka2_concat_input_header.txt | less`

Print something in the first line of a file (i.e., a header)

`awk 'BEGIN { print"chr\tpos\tref\talt\tgene\ttype" } {split($8,a,"|"); print $1"\t"$2"\t"$4"\t"$5"\t"a[4]"\t"a[2]  }' output_concat_annotated.vcf | grep -v "\#"`

## Todo
- [] Document how to find statistics for bam/vcf files 
- [x] Clarify difference between `bcftools` and `vcftools`
- [x] Copy number calling pipeline 
- [] Finish documentation for mutational signatures 
- [] Finish documentation for CNA calling and SNVs 


