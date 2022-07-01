#!/bin/bash 
#===================================
#  Bourne-Again shell script
#
#  Description:
#    1. create a python sample program (> py_crt.sh -s|-start)
#
#  Usage:
#    > sh_crt.sh [options]
#
#  History:
#
#  Author:
#    Yi-Hsuan Chen
#    yihsuan@umich.edu
#===================================

#homepath="/ncrc/home2/Yi-hsuan.Chen/"
homepath="/ncrc/home2/Yi-hsuan.Chen/"
#homepath="/ncrc/home2/Yi-hsuan.Chen/"
#homepath="/ncrc/home2/Yi-hsuan.Chen/"

homepath_work="$homepath/script/shell/application/create/"

cases=(
      test_case1
      )
       #newcase

usage="(-c OR -case ${cases[@]}) (-d OR -dir dir1) (-f OR -file file1) (-h OR -help) (-a OR -add file1.sh case_name) (-func) ooo.sh"

#=================
#  program start
#=================

# temperory files
temp=`date +%Y%m%d%H%M%S`
ftemp="./ggmmiirr.$temp"
ftemp01="$ftemp.temp01"

# get total number of parameters
# set meaingful indexes in command line 
pram_num=$#
pram_idx=(-c -case -d -dir -s -start -a -add -f -file)

## res_available=(cn xy)
pram_idx_num=${#pram_idx[@]}

#check whether bash script name is given
if [ -z $1 ]; then
  echo "Warning: bash sciprt name is not define!"
  echo "program stop"
  echo "Usage: > sh sh_crt.sh $usage"
  #cat $bash_usage || eeit 1
  #rm -f $bash_usage
  exit 101
fi

#----------------------------------
# read parameters from command line
#----------------------------------

k=1
for ((i=1; i<=$pram_num; i=i+1))
do
  # read every parameters
  pram[i]=$1
  shift

  # read position of indexes
  for ((j=0; j<=$pram_idx_num-1; j=j+1))
  do
    pram[$i]=`echo ${pram[$i]} | sed "s/ /\\\\ /g"`

    if [ "${pram[$i]}" == ${pram_idx[$j]} ]; then
      idx_pos[k]=$i
      k=$(($k+1))
    fi
  done
done

#--------------------------
# read indexes parameters
#--------------------------

# bash script name
py_name=${pram[$pram_num]}

if [ $py_name == "-h" ] || [ $py_name == "-help" ] ; then
  #cat $bash_usage || exit 1
  exit 0

elif [ $py_name == "-f" ] || [ $py_name == "-func" ]; then

  date00=`date +%Y/%m/%d`

  #--- wrtie sample python file
  cat > $ftemp01 << EOF

========================
 Sample my Python function
========================

def :
    """
    ----------------------
    Description: 
    

    Input arguments:


    Return:


    Example:

      
    Date created: $date00
    ----------------------
    """

    func_name = ""

    #--- 

    return

EOF


  #--- print out on screen
  cat $ftemp01
  rm $ftemp01

  exit 0

elif [ $py_name == "-s" ] || [ $py_name == "-start" ] ; then

  #--- wrtie sample python file
  cat > $ftemp01 << EOF

========================
 Sample Python program
========================

#--- import 
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.pyplot as plt
import numpy as np
import xarray as xr
import io, os, sys, types

# import my jupynote notebook file as a module
import nb_finder as nbf
sys.meta_path.append(nbf.NotebookFinder())
import yhc_module as yhc

#--- read data
datapath = ""
filename = ""

files_input = datapath+"/"+filename

#--- use xarray to open the files
#data = xr.open_dataset(files_input)

EOF

  #--- print out on screen
  cat $ftemp01
  rm $ftemp01

  exit 0

fi

# do not allow script name started with "-" because it is hard to delete, e.g -r.bash
if [ ${py_name:0:1} == "-" ]; then
  echo ""
  echo "WARNING: bash script name [$py_name] start with [-]"
  echo "please re-enter the script name"
  echo "program stop"
  exit 0
  echo ""
fi

if [ -f $py_name ]; then
  echo "[$py_name] is already exist!"
  read -p "Do you want to overwrite it? (y/n) " choice

  if [ $choice -a $choice == "y" ]; then
    rm -f $py_name && echo "Done. remove [$py_name]" || exit 203
  else
    echo "[$py_name] can not overwrite!"
    echo "program stop"
    exit 201
  fi
fi

# add bash script name index to extra index position
nn=${#idx_pos[@]}
idx_pos[$nn+1]=$pram_num
idx_num=${#idx_pos[@]}

# divide parameters to used varibles 
for ((i=1; i<$idx_num; i=i+1))
do

   n1=${idx_pos[$i]}
   n2=${idx_pos[$i+1]}
   nn=$(($n2-$n1-1))

   idx_name=${pram[$n1]}
   kk=0

   if [ $nn -ge 1 ]; then

     if [ $idx_name == "-c" ] || [ $idx_name == "-case" ]; then
       for ((j=$n1+1; j<$n2; j=j+1))
       do
         casename=${pram[$j]}
       done

     elif [ $idx_name == "-d" ] || [ $idx_name == "-dir" ] ; then
       for ((j=$n1+1; j<$n2; j=j+1))
       do
         indir[kk]=${pram[$j]}
         kk=$(($kk+1))
       done

     elif [ $idx_name == "-f" ] || [ $idx_name == "-file" ] ; then
       for ((j=$n1+1; j<$n2; j=j+1))
       do
         infile[kk]=${pram[$j]}
         kk=$(($kk+1))
       done

     elif [ $idx_name == "-s" ] || [ $idx_name == "-suffix" ] ; then
       for ((j=$n1+1; j<$n2; j=j+1))
       do
         suffix[kk]=${pram[$j]}
         suffixnames="${suffixnames}${suffix[kk]},"
         kk=$(($kk+1))
       done

     elif [ $idx_name == "-a" ] || [ $idx_name == "-add" ]; then
       for ((j=$n1+1; j<$n2; j=j+1))
       do
         option_add="T"
         add_parameter[kk]=${pram[$j]}
         kk=$(($kk+1))
       done

     fi
   fi
done

#==============================================
# create sample scripts based on input NCL file
#==============================================

temp=`date +%Y%m%d%H%M%S`
ftemp="./ggmmiirr.$temp"
ftemp01="$ftemp.temp01"
ftemp02="$ftemp.temp02"
ftemp03="$ftemp.temp03"

if [ $option_add -a $option_add == "T" ]; then

  sample_file=${add_parameter[0]}
  sample_case=${add_parameter[1]}

  # if sample_file does not exist
  if [ ! $sample_file ] || [ ! -f $sample_file ]; then
    echo ""
    echo "ERROR: file [$sample_file] does not exist!"
    echo "Usage: bash_case.sh -a (file name) (case name) output.sh"
    echo "program stop"
    exit 1

  # if casename does not exist
  elif [ ! $sample_case ]; then
    echo ""
    echo "ERROR: case name [$sample_case] is not given!"
    echo "Usage: bash_case.sh -a (file name) (case name) output.sh"
    echo "program stop"
    exit 1

  fi

  # write check part
  cat >> $ftemp01 << EOF11
#*** check case == "$sample_case" ***
elif [ \$casename_work -a \$casename_work == "$sample_case" ]; then

#*** case: "$sample_case" start ***
elif [ \$casename_work -a \$casename_work == "$sample_case" ]; then
cat >> \$py_name << EOF

#**********************
#  Description:
#
#**********************

EOF11

  # create template file
  cat $sample_file >> $ftemp02

  # replace '\' to '\\'
  sed -i 's,\\,\\\\,g' $ftemp02 || exit 3

  # replace '`' to '\`'
  sed -i "s/\`/\\\\\`/g" $ftemp02 || exit 3

  # replace '$' to '\$'
  sed -i 's,\$,\\\$,g' $ftemp02 || exit 3

  # remove work files
  cat $ftemp02 >> $ftemp01  || exit 5
  echo "EOF" >> $ftemp01 || exit 5
  echo "#*** case: "$sample_case" end ***" >> $ftemp01 || exit 5

  # remove work files
  cp -i $ftemp01 $py_name || exit 5
  rm $ftemp.*

  #*********************
  # echo information
  #*********************
  echo ' '
  echo '----------------------------'
  echo 'Transform Sample bash script to sh_crt.sh'
  echo ' '
  echo "out file name is [$py_name]"
  echo ' '
  echo "read file     is [$sample_file]"
  echo "out case name is [$sample_case]"
  echo '----------------------------'
  echo ' '

  exit 0

# end if of option_add
fi

#=====================================================
# create bash scripts based on user-given information
#=====================================================

#--------------------
# check case name
#--------------------
num_case=${#cases[@]}
casename_work=""

# set casename_work
for((i=0; i<$num_case; i=i+1))
do
  if [ $casename -a $casename == ${cases[$i]} ]; then
    casename_work=$casename
  fi
done

# check whether available case name
if [ ! $casename_work ]; then
  echo ""
  echo "ERROR: unvalid case name [$casename]"
  echo ""
  echo "available case names :"
    for ((i=0; i<$num_case; i=i+1))
    do
      echo "                       $(($i+1)), ${cases[$i]}"    
    done
  echo "set to default setup"
  casename_work="default"
  echo ""
fi

#*** check case == "list-files-dir" ***
if [ $casename_work -a $casename_work == "list-files-dir" ]; then
  dir01=${indir[0]}

#*** check case == "files_move" ***
elif [ $casename_work -a $casename_work == "test_case1" ]; then
  aa=0

# newcase

#*** end of check case ***
fi

# check dir01
if [ ! $dir01 ] || [ ! -d $dir01 ]; then
  dir01="./"
fi

#--------------------
# write bash script
#--------------------

#***************
# script start
#***************

cat > $py_name << EOF
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib.pyplot as plt
import numpy as np
import xarray as xr
EOF

#*************
# script case
#*************

#*** case "default" start ***
if [ $casename_work -a $casename_work == "default" ]; then
cat >> $py_name << EOF || exit 1

datapath = ""
filename = ""

files_input = datapath+"/"+filename

#--- use xarray to open the files
#data = xr.open_dataset(files_input)

EOF
#*** case "default" end ***

#**********************************
# check whether sh_name is created
#**********************************

if [ $py_name -a -f $py_name ]; then
  chmod 755 $py_name || exit 2
  echo ' '
  echo '------------------------------------'
  echo "bash script name is  [$py_name]"
  echo "case             is  [$casename_work]"
  echo '------------------------------------'

  exit 0

else

  echo ""
  echo "Fail. create bash script demo [$py_name]"
  exit 9
fi

exit 0
