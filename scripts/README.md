## Scripts for the pipeline 
* `align.sh` 
	* Align FASTA files using BWA-MEM 
	* Input: .fasta or .fastq files 
	* Output: .bam files 

* `process_bam.sh`
	* Sort, index, mark duplicated reads, and recalibrate base qualities in bam files
	* Input: .bam files 
	* Output: .dedup.bam, .recal.table, .recal.bam, and some .bai index files. 

* `run_octopus.sh`
	* Uses [Octopus](https://github.com/luntergroup/octopus/wiki/Variant-filtering) to filter variants from .bam files. 
	* You can also use `make_chr.sh` at this step to create a directory of chromosome lists that you want Octopus to look at (the script uses all 23 pairs).
	* Input: .fa (reference genome), .bam files (processed from previous step)
	* Output: .vcf 

* Copy number calling using [HATCHet](https://github.com/raphael-group/hatchet) (in progress)
