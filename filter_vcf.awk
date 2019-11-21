#!/usr/bin/env awk

BEGIN { FS=OFS="\t" }


{
    cov=1;
    alt_rev=0;
    alt_for=0;

    for (i=10;i<=16;i++) {
       n=split($i,a,":");
       # if DP is less than 10, set cov to false
       if(a[1] <= 10.0) {
                cov = 0;
       }

      #print(a[6])
      temp=split(a[6],sb,",");
      # sb = ref in forward, ref in reverse, alt in forward, alt in reverse
      alt_for+=sb[3]
      alt_rev+=sb[4]
    }

    # DP for all samples must be 10+, and qual is PASS 
    # Additional: rev/forward strand bias must be > 0 (otherwise SNV is preferred in one strand...means it is a 
    if(NR<=41 || (cov && $7 == "PASS" && alt_for != 0 && alt_rev != 0)) {
        print
    }
}