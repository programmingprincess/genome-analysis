#!/usr/bin/env awk

# Usage: turn a VCF file into the correct format for deconstructSigs input
# If sample (col 11-16) has a 1 z-value in VCF file, then we put the following
# information in the new file:
# 	* CHR 
# 	* POS 
# 	* REF 
# 	* ALT 
# 	* SAMPLE.ID 
# Thus, for each row in the VCF file, we can have up to N rows in the new
# input file, where N is the number of samples described in the VCF file. 


#chrom = 1
#pos = 2
#ref = 4
#alt = 5
#tumor1 = 11
#cellline = 16
BEGIN { FS=OFS="\t" }

{
	for (i=11;i<=16;i++) {
		n=split($i,a,":");
		z=a[3]
		sample="tumor"(i-10)
		if(i==16){
			sample="tumor0"
		}

		if(z==1) {
			print sample"\tchr"$1"\t"$2"\t"$4"\t"$5
		}
	}
#print "tumor1\t"$5"\t"$6
}
