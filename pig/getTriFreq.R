
# Get reverse complements 
getComplement <-function(basepairs=NULL) {
  bp = {}
  bp["A"] = "T"
  bp["T"] = "A"
  bp["G"] = "C"
  bp["C"] = "G"

  comp = ""
  basepairs = strsplit(basepairs,"")[[1]]
  for(i in basepairs) {
    comp = paste0(comp, bp[i], sep="")
  }
  return (comp)
}

# contains half of all trinucleotide trios 
# we get the complement of the other half 
template=get(load("deconstructSigs/data/tri.counts.genome.rda"))

trinuc_complements = {}
for (i in rownames(template)) {
  if (!(i %in% trinuc_complements)) {
    comp = getComplement(i)
    trinuc_complements[i] = getComplement(i)
    trinuc_complements[comp] = i
  }
}


triFreq <- function(genome=NULL, count=FALSE){
  if(missing(genome)){
    cat("No genome specfied, defaulting to 'BSgenome.Sscrofa.UCSC.susScr11'\n")
    library(BSgenome.Sscrofa.UCSC.susScr11, quietly = TRUE)
    genome <- BSgenome.Sscrofa.UCSC.susScr11
  }

  contigs=seqnames(genome)
  contigs=contigs[21:length(contigs)]
  
  params <- new("BSParams", X = Sscrofa, FUN = trinucleotideFrequency, exclude = contigs, simplify = TRUE)
  snv_data<-as.data.frame(bsapply(params))
  snv_data$genome<-as.integer(rowSums(snv_data))
  
  tri = get(load("deconstructSigs/data/tri.counts.genome.rda"))
  for (i in rownames(tri)) {
    tri[i,'x'] = 0
  }
  for (i in rownames(snv_data)) {
    # add current to complement 
    if(is.na(tri[i,'x'])) {
      comp = getComplement(i)
      if(is.na(tri[comp,'x'])) {
        print("ERROR")
      } 
      
      temp = tri[comp,'x'] + snv_data[i,'genome'] 
      print(paste("Adding ", comp, " to ", i))
      print(paste(tri[comp,'x'], " + ", snv_data[i,'genome'], " = ", temp))
      
      tri[comp,'x'] = temp
    } else {
      temp = tri[i,'x'] + snv_data[i,'genome']  
      print(paste(i, ":\t ", temp))
      tri[i,'x'] = temp
    }
  }

  tri$x_norm <- (1/tri$x)
  scaling_factor<-tri['x_norm']
  return(scaling_factor)
}

# plotSignatures(sample_1_norm, sub = 'sus')

# plotSignatures(plot_example, sub = 'example')