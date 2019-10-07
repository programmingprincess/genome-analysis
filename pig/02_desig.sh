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
# R deconstruct.R 
