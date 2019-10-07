# Input: a VCF file 
# Ouptut: a file where each row is an SNV in a sample
# Uses desig_input.awk

# filter SNVs 
awk -f filter_vcf.awk moss_filtered_1.vcf > test.vcf

# put SNVs into deconstructSigs format 

# TODO: remove contigs 

awk -f desig_input.awk moss_new_filtered.vcf > desig_input_awk.txt
{ echo -e 'sample\tchr\tpos\tref\talt'; cat desig_input_awk.txt; } >desig_input_final.txt

## Run deconstruct.R! 

## First, make sure you have the trinucleotide counts for your
## genome. We are using Sscrofa11.1. Since deconstructSigs does not 
## automatically provide support for this, we wrote our own function
## to retrieve this. It is called `getTriFreq.R`, and the output 
## matches the tri.counts.genome.rda that deconstructSigs uses 
## for the human genome. 

## These counts are stored as Sscrofa.rda  and Sscrofa.all.rda, where
## Sscrofa.all.rda includes the contigs from Sscrofa11.1 

# R deconstruct.R 
