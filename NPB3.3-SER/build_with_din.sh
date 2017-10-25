#!/bin/bash

echo "Please source this script in the selected benchmark's directory for building"
echo "For example: source ./build_with_din.sh"

# Change the following 2 variables to your the correct value
WORKING_DIR="/mnt/scratch/DINAMITE/LLVM" # directory containing both LLVM build and LLVM source
LLVM_SOURCE="$WORKING_DIR/llvm-3.5.0.src" # directory contaning LLVM source

#for build with dinamite:
DIN_LLVM_PATH="$WORKING_DIR/build/bin"
export INST_LIB="$LLVM_SOURCE/projects/dinamite/library"
if [[ $PATH != *"$DIN_LLVM_PATH"* ]]; then
    export PATH="$DIN_LLVM_PATH:$PATH"
fi
# export DIN_FILTERS="$LLVM_SOURCE/projects/dinamite/function_filter.json"
# export ALLOC_IN="$LLVM_SOURCE/projects/dinamite"
export ALLOC_IN=`pwd`
export DIN_MAPS=`pwd`/din_maps
#export DIN_JSON_FORMAT="num_to_name"

#for runtime
export DINAMITE_TRACE_PREFIX=`pwd`/din_traces
export LD_LIBRARY_PATH=$INST_LIB
export DYLD_LIBRARY_PATH=$INST_LIB

OPT_LEVEL="-O0"
export DIN_FLAGS="$OPT_LEVEL -v -g -Xclang -load -Xclang $LLVM_SOURCE/Release+Asserts/lib/AccessInstrument.so"
export DIN_LINKFLAGS="-L$LLVM_SOURCE/projects/dinamite/library -linstrumentation"

mkdir $DINAMITE_TRACE_PREFIX
mkdir $DIN_MAPS

#
#debug_flags="-DDEBUG"
##debug_flags=""
#cmd="make CC=clang EXTRA_FLAGS=\"$debug_flags $DIN_FLAGS\" EXTRA_LIBS=\"$DIN_INST_LIBS\""
#echo "cmd = ------"
#echo "$cmd"
#echo "------------"
#eval "$cmd"
#
# Note: If you are having troubles "Loading external functions..." while building your program (The error usually shows a bunch of back-trace prints), it is probably because you are using the default gcc/clang on your machine in building the instrumentation library. Please try to build the instrumentation library with the newly built LLVM clang, and then build your program.

