library(deconstructSigs)
library(BSgenome.Sscrofa.UCSC.susScr11)
sample.mut.ref=read.table("desig_input_final_rmcontigs.txt", header=TRUE, stringsAsFactors=FALSE)
print(head(sample.mut.ref))

pig=get(load("Sscrofa.all.rda"))
#pig=get(load("Sscrofa.rda"))

# Convert to deconstructSigs input
sigs.input <- mut.to.sigs.input(mut.ref = sample.mut.ref, 
                                sample.id = "sample", 
                                chr = "chr", 
                                pos = "pos", 
                                ref = "ref", 
                                alt = "alt",
				bsg = BSgenome.Sscrofa.UCSC.susScr11)

sample_cosmic_1 = whichSignatures(tumor.ref = sigs.input,
     signatures.ref = signatures.cosmic,
     sample.id = 'tumor1',
     contexts.needed = TRUE,
     tri.counts.method = 'default')

sample_1_cosmic_norm = whichSignatures(tumor.ref = sigs.input,
     signatures.ref = signatures.cosmic,
     sample.id = 'tumor1',
     contexts.needed = TRUE,
     tri.counts.method = pig)

sample_2_cosmic_norm = whichSignatures(tumor.ref = sigs.input,
     signatures.ref = signatures.cosmic,
     sample.id = 'tumor2',
     contexts.needed = TRUE,
     tri.counts.method = pig)

sample_3_cosmic_norm = whichSignatures(tumor.ref = sigs.input,
     signatures.ref = signatures.cosmic,
     sample.id = 'tumor3',
     contexts.needed = TRUE,
     tri.counts.method = pig)

sample_4_cosmic_norm = whichSignatures(tumor.ref = sigs.input,
     signatures.ref = signatures.cosmic,
     sample.id = 'tumor4',
     contexts.needed = TRUE,
     tri.counts.method = pig)

sample_5_cosmic_norm = whichSignatures(tumor.ref = sigs.input,
     signatures.ref = signatures.cosmic,
     sample.id = 'tumor5',
     contexts.needed = TRUE,
     tri.counts.method = pig)

sample_0_cosmic_norm = whichSignatures(tumor.ref = sigs.input,
     signatures.ref = signatures.cosmic,
     sample.id = 'tumor0',
     contexts.needed = TRUE,
     tri.counts.method = pig)

plotSignatures(sample_1_cosmic_norm, sub = 'tumor1')
makePie(sample_1_cosmic_norm, sub = 'tumor1')

plotSignatures(sample_2_cosmic_norm, sub = 'tumor2')
makePie(sample_2_cosmic_norm, sub = 'tumor2')

plotSignatures(sample_3_cosmic_norm, sub = 'tumor3')
makePie(sample_3_cosmic_norm, sub = 'tumor3')

plotSignatures(sample_4_cosmic_norm, sub = 'tumor4')
makePie(sample_4_cosmic_norm, sub = 'tumor4')

plotSignatures(sample_5_cosmic_norm, sub = 'tumor5')
makePie(sample_5_cosmic_norm, sub = 'tumor5')

plotSignatures(sample_0_cosmic_norm, sub = 'tumor0')
makePie(sample_0_cosmic_norm, sub = 'tumor0')


# make sure to use this after pdf is done
dev.off()
