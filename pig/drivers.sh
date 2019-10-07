## Download intogen_cancer_drivers-2014.12 from https://www.intogen.org/downloads
## Use `Drivers_type_role.tsv` file to obtain list of driver genes 

## Clean up the list to get a single column where you have `Name=DRIVERNAME` 
## This prevents matches with the driver name in a description 


## Intersect list with Sus_scrofa 11.1 gene annotation file
## https://useast.ensembl.org/Sus_scrofa/Info/Index
# -w matches whole words only 
# -F searches for fixed strings 

grep -w -F -f drivers_.txt Sus_scrofa.Sscrofa11.1.97.chr.gff3 > Sus_driver_genes_v2.gff3

## Now, we have a list of driver genes in Sscrofa. We can intersect 
## this list with our list of SNPs obtained from moss 
# -wa -wb combines lines from both files 
# intersect -a and -b means only overlapping rows from both files are included 
bedtools intersect -a moss_new_filtered.vcf -b Sus_scrofa.driver_genes.gff3 -header -wa -wb > output_v2.vcf


## Next, we can get the mutation type annotations from SnpEff 
## in the snpEff folder...
## Note, we used Sscrofa10.2.86 because Sscrofa11.1 was not part of snpEff yet 
java -Xmx4g -jar snpEff.jar -v Sscrofa10.2.86 /scratch/data/oncopig/sigs/drivers/output_v2.vcf > Sus_drivers_annotated.vcf

