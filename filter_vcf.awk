#!/usr/bin/env awk

BEGIN { FS=OFS="\t" }


{	
		cov=1
    for (i=10;i<=15;i++) {
       n=split($i,a,":");
       if(a[1] <= 10.0) {
       		cov = 0;
       }
    }
    if(NR<=5 || NR==27 || cov) { 
    	print 
    } 
}