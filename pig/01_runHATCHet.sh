#!/usr/bin/bash



REF="/scratch/data/oncopig/ref/sus_trim_11.1.fa"
SAM="/home/jiaqiwu6/samtools/bin"
BCF="/home/jiaqiwu6/bcftools/bin"
BNPY="/scratch/software/bnpy-dev"

HATCHET_HOME="/home/jiaqiwu6/hatchet"
HATCHET="${HATCHET_HOME}/bin/HATCHet.py"
UTILS="${HATCHET_HOME}/utils/"
SOLVER="${HATCHET_HOME}/build/solve"

XDIR="/scratch/data/oncopig/hatchet_script/"
NORMAL="/scratch/data/oncopig/kidney_RG.dedup.bam"
BAMS="/scratch/data/oncopig/tumor1_RG.dedup.bam /scratch/data/oncopig/tumor2_RG.dedup.bam /scratch/data/oncopig/tumor3_RG.dedup.bam /scratch/data/oncopig/tumor4_RG.dedup.bam /scratch/data/oncopig/tumor5_RG.dedup.bam /scratch/data/oncopig/cell_line_RG.dedup.bam"
ALLNAMES="Normal tumor1 tumor2 tumor3 tumor4 tumor5 tumor0"
NAMES="tumor1 tumor2 tumor3 tumor4 tumor5 tumor0"
J=22

set -e
set -o xtrace
PS4='\''[\t]'\'
export PATH=$PATH:${SAM}
export PATH=$PATH:${BCF}
#source /path/to/virtualenv-python2.7/bin/activate

BIN=${XDIR}bin/
mkdir -p ${BIN}
BAF=${XDIR}baf/
mkdir -p ${BAF}
BB=${XDIR}bb/
mkdir -p ${BB}
BBC=${XDIR}bbc/
mkdir -p ${BBC}
ANA=${XDIR}analysis/
mkdir -p ${ANA}
RES=${XDIR}results/
mkdir -p ${RES}
EVA=${XDIR}evaluation/
mkdir -p ${EVA}

cd ${XDIR}

#\time -v python ${UTILS}binBAM.py -N ${NORMAL} -T ${BAMS} -S ${ALLNAMES} -b 50kb -g hg19 -j ${J} -q 20 -O ${BIN}normal.bin -o ${BIN}bulk.bin -v &> ${BIN}bins.log

#\time -v python ${UTILS}deBAF.py  -N ${NORMAL} -T ${BAMS} -S ${ALLNAMES} -r ${REF} -j ${J} -q 20 -Q 20 -U 20 -c 4 -C 300 -O ${BAF}normal.baf -o ${BAF}bulk.baf -v &> ${BAF}bafs.log

#\time -v python ${UTILS}comBBo.py -c ${BIN}normal.bin -C ${BIN}bulk.bin -B ${BAF}bulk.baf -m MIRROR -e 12 > ${BB}bulk.bb

#\time -v python ${UTILS}cluBB.py ${BB}bulk.bb -by ${BNPY} -o ${BBC}bulk.seg -O ${BBC}bulk.bbc -e ${RANDOM} -tB 0.04 -tR 0.15 -d 0.08

cd ${ANA}
#\time -v python2 ${UTILS}BBot.py -c RD --figsize 6,3 ${BBC}bulk.bbc &
#\time -v python2 ${UTILS}BBot.py -c CRD --figsize 6,3 ${BBC}bulk.bbc &
#\time -v python2 ${UTILS}BBot.py -c BAF --figsize 6,3 ${BBC}bulk.bbc &
#\time -v python2 ${UTILS}BBot.py -c BB ${BBC}bulk.bbc &
#\time -v python2 ${UTILS}BBot.py -c CBB ${BBC}bulk.bbc &
#wait

cd ${RES}
\time -v python2 ${HATCHET} ${SOLVER} -i ${BBC}bulk -n2,8 -p 400 -v 3 -u 0.03 -r ${RANDOM} -j ${J} -eD 6 -eT 12 -g 0.35 -l 0.6 &> >(tee >(grep -v Progress > hatchet.log))
#\time -v python2 ${HATCHET} ${SOLVER} -i ${BBC}bulk -n2,8 -p 400 -v 3 -u 0.05 -r ${RANDOM} -j ${J} -eD 6 -eT 12 -g 0.35 -l 0.6 &> >(tee >(grep -v Progress > hatchet.log))

## Increase -l to 0.6 to decrease the sensitivity in high-variance or noisy samples, and decrease it to -l 0.3 in low-variance samples to increase the sensitivity and explore multiple solutions with more clones.
## Increase -u if solutions have clone proportions equal to the minimum threshold -u
## Decrease the number of restarts to 200 or 100 for fast runs, as well as user can decrease the number of clones to -n 2,6 when appropriate or when previous runs suggest fewer clones.
## Increase the single-clone confidence to `-c 0.6` to increase the confidence in the presence of a single tumor clone and further increase this value when interested in a single clone.

cd ${EVA}
\time -v python ${UTILS}BBeval.py ${RES}best.bbc.ucn

