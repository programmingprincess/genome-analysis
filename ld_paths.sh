/software/gcc-8.2.0/lib64:/software/gcc-8.2.0/lib:/scratch/software/htslib-1.9/lib:/scratch/software/boost_1_69_0/lib:


LD_LIBRARY_PATH="/scratch/software/boost_1_69_0/lib:$LD_LIBRARY_PATH"

export LD_LIBRARY_PATH

LD_LIBRARY_PATH="/scratch/software/boost_1_69_0/lib:/scratch/software/htslib-1.9/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH

LD_LIBRARY_PATH="/scratch/software/htslib-1.9/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH

LD_LIBRARY_PATH="/software/gcc-8.2.0/lib64:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH

# all 
LD_LIBRARY_PATH="/software/gcc-8.2.0/lib64:/software/gcc-8.2.0/lib:/scratch/software/htslib-1.9/lib:/scratch/software/boost_1_69_0/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH

[jiaqiwu6@ada htslib-1.9]$ echo $LD_LIBRARY_PATH
/scratch/software/boost_1_69_0/lib:/scratch/software/htslib-1.9/lib:/scratch/software/boost_1_69_0/lib:/scratch/software/htslib-1.9/:/scratch/software/boost_1_69_0/lib:/scratch/software/htslib-1.9/:/scratch/software/boost_1_69_0/lib:/scratch/software/src/boost_1_69_0/libs:/scratch/software/src/boost_1_69_0/libs:/scratch/software/src/boost_1_69_0/libs
