#!/bin/sh
set -eux

source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

# Check final exec folder exists
if [ ! -d "../exec" ]; then
  mkdir ../exec
fi

USE_PREINST_LIBS=${USE_PREINST_LIBS:-"true"}

### gdas_trpsfcmv
 cd $cwd
 source $cwd/ncl.setup                   > /dev/null 2>&1
 export NCARG_LIB=$NCARG_ROOT/lib        > /dev/null 2>&1

 if [ $USE_PREINST_LIBS = true ]; then
   export MOD_PATH=/scratch3/NCEPDEV/nwprod/lib/modulefiles
   source ../modulefiles/gdas_trpsfcmv.$target             > /dev/null 2>&1
 else
   export MOD_PATH=${cwd}/lib/modulefiles
   if [ $target = wcoss_cray ]; then
     source ../modulefiles/gdas_trpsfcmv.${target}_userlib > /dev/null 2>&1
   else
     source ../modulefiles/gdas_trpsfcmv.$target           > /dev/null 2>&1
   fi
 fi
 cd $cwd/gdas_trpsfcmv.fd
 make -f makefile.$target
 make -f makefile.$target clean
 mv gdas_trpsfcmv ../../exec/

echo "Build complete"
exit
