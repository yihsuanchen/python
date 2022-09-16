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
      "test_case1"
      "plot-scm-xy"
      "MERRA2_interp2scm"
      ) 
       #newcase

cases_notes=(
      "MERRA2_interp2scm: interpolate MERRA-2 data on GFDL SCM levels"
      "test_case1 	: a test case"
      "plot-scm-xy	: read SCM files and plot XY profiles"
            )

#usage="(-c OR -case ${cases[@]}) (-d OR -dir dir1) (-f OR -file file1) (-h OR -help) (-a OR -add file1.sh case_name) (-func) ooo.sh"
usage="(-c OR -case ${cases[@]}) (-s|-start) (-f|-func) (-exe) (-a OR -add file1.sh case_name) ooo.sh"

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
pram_idx=(-c -case -d -dir -s -start -a -add -f -func -exe)  # for some reason, -e doesn't work

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

#--- convert yhc_module.ipynb to yhc_module.py, and copy .py file to a folder that can be imported
elif [ $py_name == "-exe" ]; then
  
  machine="Mac"
  #machine="analysis"

  #--- deterimine machine
  if [ $machine == "Mac" ]; then
    py_source_dir=`pwd`
    yhc_module_ipynb="$py_source_dir/yhc_module.ipynb"
    yhc_module_py="$py_source_dir/yhc_module.py"
    py_targe_dir="/Users/yihsuan/.ipython"

  elif [ $machine == "analysis" ]; then
    py_source_dir=`pwd`
    yhc_module_ipynb="$py_source_dir/yhc_module.ipynb"
    yhc_module_py="$py_source_dir/yhc_module.py"
    py_targe_dir="$py_source_dir"

  else
    echo "ERROR: [$machine] is not supported. STOP"
    exit 1
  fi  

  #--- commands
  cmd1="jupyter nbconvert $yhc_module_ipynb --to python && Done. create yhc_module.py || exit 3"
  cmd2="cp -i $yhc_module_py $py_targe_dir && echo"

  #--- check with the user
  echo "-------------"
  echo ""
  echo "Convert yhc_module.ipynb to yhc_module.py, and copy .py file to [${py_targe_dir}]"
  echo "  Machine      : [$machine]"
  echo "  Source ipynb : [$yhc_module_ipynb]"
  echo "  Target folder: [${py_targe_dir}]"
  echo ""
  read -p "Is it correct? (y/n) " choice

  if [ $choice -a $choice == "y" ]; then
    jupyter nbconvert $yhc_module_ipynb --to python && echo "Done. create yhc_module.py" || exit 3
    cp -i $yhc_module_py $py_targe_dir && echo "Done. copy yhc_module.py" || exit 5
    echo "ls -l $py_targe_dir/yhc_module.py"

  else
    echo "program stop"
    exit 1
  fi

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
      import yhc_module as yhc
       = yhc.()
     
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
#import cartopy.crs as ccrs
#import cartopy.feature as cfeature
import matplotlib.pyplot as plt
import numpy as np
import xarray as xr
import io, os, sys, types

import yhc_module as yhc

xr.set_options(keep_attrs=True)  # keep attributes after xarray operation

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

##############
# deleted
# # import my jupynote notebook file as a module
#import nb_finder as nbf
#sys.meta_path.append(nbf.NotebookFinder())
#
##############

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

cat >> \$py_name << EOF || exit 1
EOF11

  # create template file
  cat $sample_file >> $ftemp02

  # replace '\' to '\\'
  #sed -i 's,\\,\\\\,g' $ftemp02 || exit 3

  # replace '`' to '\`'
  #sed -i "s/\`/\\\\\`/g" $ftemp02 || exit 3

  # replace '$' to '\$'
  #sed -i 's,\$,\\\$,g' $ftemp02 || exit 3

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
      echo "                       $(($i+1)), ${cases_notes[$i]}"    
    done

  echo ""
  exit 1
  #echo "set to default setup"
  #casename_work="default"
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

#*************
# script case
#*************

#*** case "default" start ***
if [ $casename_work -a $casename_work == "default" ]; then
cat >> $py_name << EOF || exit 1
#import cartopy.crs as ccrs
#import cartopy.feature as cfeature
import matplotlib.pyplot as plt
import numpy as np
import xarray as xr

datapath = ""
filename = ""

files_input = datapath+"/"+filename

#--- use xarray to open the files
#data = xr.open_dataset(files_input)

EOF
#*** case "default" end ***

#*** case: "plot-scm-xy" start ***
elif [ $casename_work -a $casename_work == "plot-scm-xy" ]; then
cat >> $py_name << EOF || exit 1
{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "b3707dae",
   "metadata": {},
   "source": [
    "# Program - plot XY profiles in SCM\n",
    "\n",
    "**Content:**\n",
    "\n",
    "- Open and Read a SCM netCDF file\n",
    "- Open and Read other dataset\n",
    "- Plot XY profile\n",
    "\n",
    "**Author**: Yi-Hsuan Chen (yihsuan@umich.edu)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "1bb2aed2",
   "metadata": {},
   "outputs": [],
   "source": [
    "import matplotlib.pyplot as plt\n",
    "import numpy as np\n",
    "import xarray as xr\n",
    "import io, os, sys, types\n",
    "\n",
    "import yhc_module as yhc\n",
    "\n",
    "xr.set_options(keep_attrs=True)  # keep attributes after xarray operation"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c98ba131",
   "metadata": {},
   "source": [
    "## Open SCM file\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "b227e675",
   "metadata": {},
   "outputs": [],
   "source": [
    "#--- open SCM file\n",
    "datapath = \"\"\n",
    "filename_scm = \"\"\n",
    "file_scm = datapath+\"/\"+filename_scm\n",
    "\n",
    "da_scm = xr.open_dataset(file_scm)\n",
    "da_scm"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3a2f99be",
   "metadata": {},
   "source": [
    "## Open other dataset\n",
    "\n"
   ]
  },
  {
   "cell_type": "raw",
   "id": "dc6e3b90",
   "metadata": {},
   "source": [
    "#--- open SCM file\n",
    "datapath = \"~/Desktop/CGILS_forcing\"\n",
    "filename_cgils = \"ctl_s12.nc\"\n",
    "file_cgils = datapath+\"/\"+filename_cgils\n",
    "\n",
    "da_cgils = xr.open_dataset(file_cgils)\n",
    "da_cgils"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9311452d",
   "metadata": {},
   "source": [
    "## Plot XY profiles"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "efadc4b4",
   "metadata": {},
   "outputs": [],
   "source": [
    "#==============================\n",
    "def ax_def_xy (ax, var):\n",
    "\n",
    "    #--- set grids\n",
    "    ax.grid(True)\n",
    "    ax.minorticks_on()\n",
    "    \n",
    "    #--- inverse axes\n",
    "    ax.invert_yaxis()\n",
    "    \n",
    "    #--- legend\n",
    "    ax.legend([\"SCM\"])\n",
    "    \n",
    "    #--- set x or y labels\n",
    "    ax.set_ylabel(\"Pressure (hPa)\")\n",
    "\n",
    "    #--- set title\n",
    "    ax.set_title(var.attrs['long_name'], loc='left')\n",
    "    ax.set_title(var.attrs['units'], loc='right')\n",
    "    ax.set_xlabel(var.attrs['long_name']+\" (\"+var.attrs['units']+\")\")\n",
    "#============================== \n",
    "\n",
    "do_plot=True\n",
    "\n",
    "if (do_plot):\n",
    "    fig, (ax1, ax2, ax3) = plt.subplots(1,3, figsize=(18, 6))\n",
    "\n",
    "    #--- setting\n",
    "    tt = 3000   # time step\n",
    "    fig.suptitle(\"SCM, time step=\"+str(tt))\n",
    "\n",
    "    #--- ax1\n",
    "    var1_scm = da_scm.vcomp[tt,:,0,0]\n",
    "    yy_scm  = da_scm.pfull_tv[tt,:,0,0]\n",
    "\n",
    "    ax1.plot(var1_scm, yy_scm, 'r-o',\n",
    "             da_cgils.v[0,:,0,0], da_cgils.lev[:],'b^'\n",
    "            )\n",
    "    ax_def_xy(ax1, var1_scm)\n",
    "\n",
    "#print(da_scm.time)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "2d7a2ae2",
   "metadata": {},
   "outputs": [],
   "source": []
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "a4200008",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.8"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
EOF
#*** case: plot-scm-xy end ***

#*** case: "MERRA2_interp2scm" start ***
elif [ $casename_work -a $casename_work == "MERRA2_interp2scm" ]; then

cat >> $py_name << EOF || exit 1
{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "4437ba08-569a-4250-b304-1589511f417a",
   "metadata": {},
   "source": [
    "# Interpolate MERRA-2 data on SCM levels\n",
    "\n",
    "- MERRA-2 data can be on model levels (72 levels) or pressure levels (42 levels). It is very important to make sure that what levels are the variables of interests on. For model levels, MERRA-2 can provide pressure on each grid point (variable name is \"PL\").\n",
    "\n",
    "- The SCM pressure levels (33 levels) are computed using surface pressure and hybrid coefficients in AM4. \n",
    "\n",
    "- In this example, the horizontal advective tendencies are computed using NCL advect_variable and advect_variable_cfd functions, and then saved to a netCDF file. \n",
    "\n",
    "Yi-Hsuan Chen\n",
    "\n",
    "September 16, 2022"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "04372b9c-6925-413d-9078-33efdd9ac895",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "<xarray.core.options.set_options at 0x2b85bfd34970>"
      ]
     },
     "execution_count": 2,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "import matplotlib.pyplot as plt\n",
    "import numpy as np\n",
    "import xarray as xr\n",
    "import io, os, sys, types\n",
    "import yhc_module as yhc\n",
    "from datetime import date\n",
    "\n",
    "xr.set_options(keep_attrs=True)  # keep attributes after xarray operation"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "ba5dcf43-2a41-4526-b0b1-91866094a99d",
   "metadata": {},
   "source": [
    "## Read MERRA-2 data"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 108,
   "id": "11e913d2-bbf8-49f5-8870-55f12005c3f7",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/html": [
       "<div><svg style=\"position: absolute; width: 0; height: 0; overflow: hidden\">\n",
       "<defs>\n",
       "<symbol id=\"icon-database\" viewBox=\"0 0 32 32\">\n",
       "<path d=\"M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z\"></path>\n",
       "<path d=\"M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z\"></path>\n",
       "<path d=\"M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z\"></path>\n",
       "</symbol>\n",
       "<symbol id=\"icon-file-text2\" viewBox=\"0 0 32 32\">\n",
       "<path d=\"M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z\"></path>\n",
       "<path d=\"M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z\"></path>\n",
       "<path d=\"M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z\"></path>\n",
       "<path d=\"M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z\"></path>\n",
       "</symbol>\n",
       "</defs>\n",
       "</svg>\n",
       "<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.\n",
       " *\n",
       " */\n",
       "\n",
       ":root {\n",
       "  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));\n",
       "  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));\n",
       "  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));\n",
       "  --xr-border-color: var(--jp-border-color2, #e0e0e0);\n",
       "  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);\n",
       "  --xr-background-color: var(--jp-layout-color0, white);\n",
       "  --xr-background-color-row-even: var(--jp-layout-color1, white);\n",
       "  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);\n",
       "}\n",
       "\n",
       "html[theme=dark],\n",
       "body.vscode-dark {\n",
       "  --xr-font-color0: rgba(255, 255, 255, 1);\n",
       "  --xr-font-color2: rgba(255, 255, 255, 0.54);\n",
       "  --xr-font-color3: rgba(255, 255, 255, 0.38);\n",
       "  --xr-border-color: #1F1F1F;\n",
       "  --xr-disabled-color: #515151;\n",
       "  --xr-background-color: #111111;\n",
       "  --xr-background-color-row-even: #111111;\n",
       "  --xr-background-color-row-odd: #313131;\n",
       "}\n",
       "\n",
       ".xr-wrap {\n",
       "  display: block !important;\n",
       "  min-width: 300px;\n",
       "  max-width: 700px;\n",
       "}\n",
       "\n",
       ".xr-text-repr-fallback {\n",
       "  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-header {\n",
       "  padding-top: 6px;\n",
       "  padding-bottom: 6px;\n",
       "  margin-bottom: 4px;\n",
       "  border-bottom: solid 1px var(--xr-border-color);\n",
       "}\n",
       "\n",
       ".xr-header > div,\n",
       ".xr-header > ul {\n",
       "  display: inline;\n",
       "  margin-top: 0;\n",
       "  margin-bottom: 0;\n",
       "}\n",
       "\n",
       ".xr-obj-type,\n",
       ".xr-array-name {\n",
       "  margin-left: 2px;\n",
       "  margin-right: 10px;\n",
       "}\n",
       "\n",
       ".xr-obj-type {\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-sections {\n",
       "  padding-left: 0 !important;\n",
       "  display: grid;\n",
       "  grid-template-columns: 150px auto auto 1fr 20px 20px;\n",
       "}\n",
       "\n",
       ".xr-section-item {\n",
       "  display: contents;\n",
       "}\n",
       "\n",
       ".xr-section-item input {\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-section-item input + label {\n",
       "  color: var(--xr-disabled-color);\n",
       "}\n",
       "\n",
       ".xr-section-item input:enabled + label {\n",
       "  cursor: pointer;\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-section-item input:enabled + label:hover {\n",
       "  color: var(--xr-font-color0);\n",
       "}\n",
       "\n",
       ".xr-section-summary {\n",
       "  grid-column: 1;\n",
       "  color: var(--xr-font-color2);\n",
       "  font-weight: 500;\n",
       "}\n",
       "\n",
       ".xr-section-summary > span {\n",
       "  display: inline-block;\n",
       "  padding-left: 0.5em;\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:disabled + label {\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-section-summary-in + label:before {\n",
       "  display: inline-block;\n",
       "  content: '►';\n",
       "  font-size: 11px;\n",
       "  width: 15px;\n",
       "  text-align: center;\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:disabled + label:before {\n",
       "  color: var(--xr-disabled-color);\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:checked + label:before {\n",
       "  content: '▼';\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:checked + label > span {\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-section-summary,\n",
       ".xr-section-inline-details {\n",
       "  padding-top: 4px;\n",
       "  padding-bottom: 4px;\n",
       "}\n",
       "\n",
       ".xr-section-inline-details {\n",
       "  grid-column: 2 / -1;\n",
       "}\n",
       "\n",
       ".xr-section-details {\n",
       "  display: none;\n",
       "  grid-column: 1 / -1;\n",
       "  margin-bottom: 5px;\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:checked ~ .xr-section-details {\n",
       "  display: contents;\n",
       "}\n",
       "\n",
       ".xr-array-wrap {\n",
       "  grid-column: 1 / -1;\n",
       "  display: grid;\n",
       "  grid-template-columns: 20px auto;\n",
       "}\n",
       "\n",
       ".xr-array-wrap > label {\n",
       "  grid-column: 1;\n",
       "  vertical-align: top;\n",
       "}\n",
       "\n",
       ".xr-preview {\n",
       "  color: var(--xr-font-color3);\n",
       "}\n",
       "\n",
       ".xr-array-preview,\n",
       ".xr-array-data {\n",
       "  padding: 0 5px !important;\n",
       "  grid-column: 2;\n",
       "}\n",
       "\n",
       ".xr-array-data,\n",
       ".xr-array-in:checked ~ .xr-array-preview {\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-array-in:checked ~ .xr-array-data,\n",
       ".xr-array-preview {\n",
       "  display: inline-block;\n",
       "}\n",
       "\n",
       ".xr-dim-list {\n",
       "  display: inline-block !important;\n",
       "  list-style: none;\n",
       "  padding: 0 !important;\n",
       "  margin: 0;\n",
       "}\n",
       "\n",
       ".xr-dim-list li {\n",
       "  display: inline-block;\n",
       "  padding: 0;\n",
       "  margin: 0;\n",
       "}\n",
       "\n",
       ".xr-dim-list:before {\n",
       "  content: '(';\n",
       "}\n",
       "\n",
       ".xr-dim-list:after {\n",
       "  content: ')';\n",
       "}\n",
       "\n",
       ".xr-dim-list li:not(:last-child):after {\n",
       "  content: ',';\n",
       "  padding-right: 5px;\n",
       "}\n",
       "\n",
       ".xr-has-index {\n",
       "  font-weight: bold;\n",
       "}\n",
       "\n",
       ".xr-var-list,\n",
       ".xr-var-item {\n",
       "  display: contents;\n",
       "}\n",
       "\n",
       ".xr-var-item > div,\n",
       ".xr-var-item label,\n",
       ".xr-var-item > .xr-var-name span {\n",
       "  background-color: var(--xr-background-color-row-even);\n",
       "  margin-bottom: 0;\n",
       "}\n",
       "\n",
       ".xr-var-item > .xr-var-name:hover span {\n",
       "  padding-right: 5px;\n",
       "}\n",
       "\n",
       ".xr-var-list > li:nth-child(odd) > div,\n",
       ".xr-var-list > li:nth-child(odd) > label,\n",
       ".xr-var-list > li:nth-child(odd) > .xr-var-name span {\n",
       "  background-color: var(--xr-background-color-row-odd);\n",
       "}\n",
       "\n",
       ".xr-var-name {\n",
       "  grid-column: 1;\n",
       "}\n",
       "\n",
       ".xr-var-dims {\n",
       "  grid-column: 2;\n",
       "}\n",
       "\n",
       ".xr-var-dtype {\n",
       "  grid-column: 3;\n",
       "  text-align: right;\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-var-preview {\n",
       "  grid-column: 4;\n",
       "}\n",
       "\n",
       ".xr-var-name,\n",
       ".xr-var-dims,\n",
       ".xr-var-dtype,\n",
       ".xr-preview,\n",
       ".xr-attrs dt {\n",
       "  white-space: nowrap;\n",
       "  overflow: hidden;\n",
       "  text-overflow: ellipsis;\n",
       "  padding-right: 10px;\n",
       "}\n",
       "\n",
       ".xr-var-name:hover,\n",
       ".xr-var-dims:hover,\n",
       ".xr-var-dtype:hover,\n",
       ".xr-attrs dt:hover {\n",
       "  overflow: visible;\n",
       "  width: auto;\n",
       "  z-index: 1;\n",
       "}\n",
       "\n",
       ".xr-var-attrs,\n",
       ".xr-var-data {\n",
       "  display: none;\n",
       "  background-color: var(--xr-background-color) !important;\n",
       "  padding-bottom: 5px !important;\n",
       "}\n",
       "\n",
       ".xr-var-attrs-in:checked ~ .xr-var-attrs,\n",
       ".xr-var-data-in:checked ~ .xr-var-data {\n",
       "  display: block;\n",
       "}\n",
       "\n",
       ".xr-var-data > table {\n",
       "  float: right;\n",
       "}\n",
       "\n",
       ".xr-var-name span,\n",
       ".xr-var-data,\n",
       ".xr-attrs {\n",
       "  padding-left: 25px !important;\n",
       "}\n",
       "\n",
       ".xr-attrs,\n",
       ".xr-var-attrs,\n",
       ".xr-var-data {\n",
       "  grid-column: 1 / -1;\n",
       "}\n",
       "\n",
       "dl.xr-attrs {\n",
       "  padding: 0;\n",
       "  margin: 0;\n",
       "  display: grid;\n",
       "  grid-template-columns: 125px auto;\n",
       "}\n",
       "\n",
       ".xr-attrs dt,\n",
       ".xr-attrs dd {\n",
       "  padding: 0;\n",
       "  margin: 0;\n",
       "  float: left;\n",
       "  padding-right: 10px;\n",
       "  width: auto;\n",
       "}\n",
       "\n",
       ".xr-attrs dt {\n",
       "  font-weight: normal;\n",
       "  grid-column: 1;\n",
       "}\n",
       "\n",
       ".xr-attrs dt:hover span {\n",
       "  display: inline-block;\n",
       "  background: var(--xr-background-color);\n",
       "  padding-right: 10px;\n",
       "}\n",
       "\n",
       ".xr-attrs dd {\n",
       "  grid-column: 2;\n",
       "  white-space: pre-wrap;\n",
       "  word-break: break-all;\n",
       "}\n",
       "\n",
       ".xr-icon-database,\n",
       ".xr-icon-file-text2 {\n",
       "  display: inline-block;\n",
       "  vertical-align: middle;\n",
       "  width: 1em;\n",
       "  height: 1.5em !important;\n",
       "  stroke-width: 0;\n",
       "  stroke: currentColor;\n",
       "  fill: currentColor;\n",
       "}\n",
       "</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;\n",
       "Dimensions:  (lon: 576, time: 8, lat: 361, lev: 72)\n",
       "Coordinates:\n",
       "  * lon      (lon) float64 0.625 1.25 1.875 2.5 ... 358.1 358.8 359.4 360.0\n",
       "  * time     (time) datetime64[ns] 2001-07-10T01:30:00 ... 2001-07-10T22:30:00\n",
       "  * lat      (lat) float64 -90.0 -89.5 -89.0 -88.5 -88.0 ... 88.5 89.0 89.5 90.0\n",
       "  * lev      (lev) float64 1.0 2.0 3.0 4.0 5.0 6.0 ... 68.0 69.0 70.0 71.0 72.0\n",
       "Data variables: (12/14)\n",
       "    CLOUD    (time, lev, lat, lon) float32 ...\n",
       "    DELP     (time, lev, lat, lon) float32 ...\n",
       "    H        (time, lev, lat, lon) float32 ...\n",
       "    OMEGA    (time, lev, lat, lon) float32 ...\n",
       "    PL       (time, lev, lat, lon) float32 ...\n",
       "    PS       (time, lat, lon) float32 ...\n",
       "    ...       ...\n",
       "    QV       (time, lev, lat, lon) float32 ...\n",
       "    RH       (time, lev, lat, lon) float32 ...\n",
       "    SLP      (time, lat, lon) float32 ...\n",
       "    T        (time, lev, lat, lon) float32 ...\n",
       "    U        (time, lev, lat, lon) float32 ...\n",
       "    V        (time, lev, lat, lon) float32 ...\n",
       "Attributes: (12/32)\n",
       "    CDI:                               Climate Data Interface version 1.9.8 (...\n",
       "    Conventions:                       CF-1\n",
       "    History:                           Original file generated: Sat Jun 14 01...\n",
       "    Comment:                           GMAO filename: d5124_m2_jan00.tavg3_3d...\n",
       "    Filename:                          MERRA2_300.tavg3_3d_asm_Nv.20010710.nc4\n",
       "    Institution:                       NASA Global Modeling and Assimilation ...\n",
       "    ...                                ...\n",
       "    RangeBeginningDate:                2001-07-10\n",
       "    RangeBeginningTime:                00:00:00.000000\n",
       "    RangeEndingDate:                   2001-07-10\n",
       "    RangeEndingTime:                   23:59:59.000000\n",
       "    history_L34RS:                     &#x27;Created by L34RS v1.4.2 @ NASA GES DI...\n",
       "    CDO:                               Climate Data Operators version 1.9.8 (...</pre><div class='xr-wrap' style='display:none'><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-14ece2d8-a1ed-4ade-99d5-d8750a51e2d3' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-14ece2d8-a1ed-4ade-99d5-d8750a51e2d3' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>lon</span>: 576</li><li><span class='xr-has-index'>time</span>: 8</li><li><span class='xr-has-index'>lat</span>: 361</li><li><span class='xr-has-index'>lev</span>: 72</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-a79e8a23-dfb2-48ad-a6f3-f4b7d7920abb' class='xr-section-summary-in' type='checkbox'  checked><label for='section-a79e8a23-dfb2-48ad-a6f3-f4b7d7920abb' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>0.625 1.25 1.875 ... 359.4 360.0</div><input id='attrs-493e5321-55e9-4892-9e93-d6b84cf65267' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-493e5321-55e9-4892-9e93-d6b84cf65267' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9887d36f-78a4-4698-b838-cc60993c6014' class='xr-var-data-in' type='checkbox'><label for='data-9887d36f-78a4-4698-b838-cc60993c6014' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>longitude</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd></dl></div><div class='xr-var-data'><pre>array([  0.625,   1.25 ,   1.875, ..., 358.75 , 359.375, 360.   ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>datetime64[ns]</div><div class='xr-var-preview xr-preview'>2001-07-10T01:30:00 ... 2001-07-...</div><input id='attrs-e9ac521a-3700-40c6-82f2-40bfd8703e81' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e9ac521a-3700-40c6-82f2-40bfd8703e81' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c37e4032-7489-47f6-bef2-5ba596664794' class='xr-var-data-in' type='checkbox'><label for='data-c37e4032-7489-47f6-bef2-5ba596664794' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>time</dd><dt><span>long_name :</span></dt><dd>time</dd><dt><span>axis :</span></dt><dd>T</dd></dl></div><div class='xr-var-data'><pre>array([&#x27;2001-07-10T01:30:00.000000000&#x27;, &#x27;2001-07-10T04:30:00.000000000&#x27;,\n",
       "       &#x27;2001-07-10T07:30:00.000000000&#x27;, &#x27;2001-07-10T10:30:00.000000000&#x27;,\n",
       "       &#x27;2001-07-10T13:30:00.000000000&#x27;, &#x27;2001-07-10T16:30:00.000000000&#x27;,\n",
       "       &#x27;2001-07-10T19:30:00.000000000&#x27;, &#x27;2001-07-10T22:30:00.000000000&#x27;],\n",
       "      dtype=&#x27;datetime64[ns]&#x27;)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-90.0 -89.5 -89.0 ... 89.5 90.0</div><input id='attrs-6335e4fc-50c6-4291-a706-f15f66bb9457' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6335e4fc-50c6-4291-a706-f15f66bb9457' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7798b90a-5f83-406c-833d-5d54773898ec' class='xr-var-data-in' type='checkbox'><label for='data-7798b90a-5f83-406c-833d-5d54773898ec' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd></dl></div><div class='xr-var-data'><pre>array([-90. , -89.5, -89. , ...,  89. ,  89.5,  90. ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lev</span></div><div class='xr-var-dims'>(lev)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.0 2.0 3.0 4.0 ... 70.0 71.0 72.0</div><input id='attrs-8842cd4f-c780-4734-88c8-ba50e1417db3' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8842cd4f-c780-4734-88c8-ba50e1417db3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-03cc23db-d606-4c07-84e0-1f2f2b7e7320' class='xr-var-data-in' type='checkbox'><label for='data-03cc23db-d606-4c07-84e0-1f2f2b7e7320' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>vertical level</dd><dt><span>units :</span></dt><dd>layer</dd><dt><span>positive :</span></dt><dd>down</dd><dt><span>axis :</span></dt><dd>Z</dd><dt><span>coordinate :</span></dt><dd>eta</dd><dt><span>standard_name :</span></dt><dd>model_layers</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>array([ 1.,  2.,  3.,  4.,  5.,  6.,  7.,  8.,  9., 10., 11., 12., 13., 14.,\n",
       "       15., 16., 17., 18., 19., 20., 21., 22., 23., 24., 25., 26., 27., 28.,\n",
       "       29., 30., 31., 32., 33., 34., 35., 36., 37., 38., 39., 40., 41., 42.,\n",
       "       43., 44., 45., 46., 47., 48., 49., 50., 51., 52., 53., 54., 55., 56.,\n",
       "       57., 58., 59., 60., 61., 62., 63., 64., 65., 66., 67., 68., 69., 70.,\n",
       "       71., 72.])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-a0779533-5fc8-41f9-8233-0cda84d7f568' class='xr-section-summary-in' type='checkbox'  checked><label for='section-a0779533-5fc8-41f9-8233-0cda84d7f568' class='xr-section-summary' >Data variables: <span>(14)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>CLOUD</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4aabf84a-079d-4a48-b860-17e63cf51413' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4aabf84a-079d-4a48-b860-17e63cf51413' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-001982aa-9e7c-4d9f-91df-2660f49d0c90' class='xr-var-data-in' type='checkbox'><label for='data-001982aa-9e7c-4d9f-91df-2660f49d0c90' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>cloud_fraction_for_radiation</dd><dt><span>long_name :</span></dt><dd>cloud_fraction_for_radiation</dd><dt><span>units :</span></dt><dd>1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>DELP</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-659b7cf6-9198-4fbc-bf40-9c8e65e25573' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-659b7cf6-9198-4fbc-bf40-9c8e65e25573' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9d881734-6f2b-447a-b300-2ff98fef5103' class='xr-var-data-in' type='checkbox'><label for='data-9d881734-6f2b-447a-b300-2ff98fef5103' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>pressure_thickness</dd><dt><span>long_name :</span></dt><dd>pressure_thickness</dd><dt><span>units :</span></dt><dd>Pa</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>H</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-a2bada6a-9ab0-4636-9d8f-a3c0d41f93c4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a2bada6a-9ab0-4636-9d8f-a3c0d41f93c4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f0836ae2-9462-41bf-8a21-3ea1aa4a10d8' class='xr-var-data-in' type='checkbox'><label for='data-f0836ae2-9462-41bf-8a21-3ea1aa4a10d8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>mid_layer_heights</dd><dt><span>long_name :</span></dt><dd>mid_layer_heights</dd><dt><span>units :</span></dt><dd>m</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>OMEGA</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-53eb3acb-bf83-4f36-a9b6-14af5606e2c6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-53eb3acb-bf83-4f36-a9b6-14af5606e2c6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b54d1e52-464c-4a06-9ea3-839d6e3a5062' class='xr-var-data-in' type='checkbox'><label for='data-b54d1e52-464c-4a06-9ea3-839d6e3a5062' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>vertical_pressure_velocity</dd><dt><span>long_name :</span></dt><dd>vertical_pressure_velocity</dd><dt><span>units :</span></dt><dd>Pa s-1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>PL</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8f9350a0-b121-4d2b-9205-37a7a2f652a5' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8f9350a0-b121-4d2b-9205-37a7a2f652a5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9324274e-821b-42a4-aaba-bf3fbd18e287' class='xr-var-data-in' type='checkbox'><label for='data-9324274e-821b-42a4-aaba-bf3fbd18e287' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>mid_level_pressure</dd><dt><span>long_name :</span></dt><dd>mid_level_pressure</dd><dt><span>units :</span></dt><dd>Pa</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>PS</span></div><div class='xr-var-dims'>(time, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3b517f9a-3887-433e-9271-7bb3c2f07075' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3b517f9a-3887-433e-9271-7bb3c2f07075' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bf1ef955-a839-4ff2-9a14-c3d78294ccd0' class='xr-var-data-in' type='checkbox'><label for='data-bf1ef955-a839-4ff2-9a14-c3d78294ccd0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>surface_pressure</dd><dt><span>long_name :</span></dt><dd>surface_pressure</dd><dt><span>units :</span></dt><dd>Pa</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[1663488 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QI</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3cc0262e-098b-41c0-b2d8-d7ee47469953' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3cc0262e-098b-41c0-b2d8-d7ee47469953' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1ca1f1de-78a9-45f4-b9a7-09566a264179' class='xr-var-data-in' type='checkbox'><label for='data-1ca1f1de-78a9-45f4-b9a7-09566a264179' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>mass_fraction_of_cloud_ice_water</dd><dt><span>long_name :</span></dt><dd>mass_fraction_of_cloud_ice_water</dd><dt><span>units :</span></dt><dd>kg kg-1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QL</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3a28e83f-82ae-4b68-881a-35e40c6d0101' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3a28e83f-82ae-4b68-881a-35e40c6d0101' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e9af56ce-3fee-4bf4-82bd-eefc0fbcc137' class='xr-var-data-in' type='checkbox'><label for='data-e9af56ce-3fee-4bf4-82bd-eefc0fbcc137' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>mass_fraction_of_cloud_liquid_water</dd><dt><span>long_name :</span></dt><dd>mass_fraction_of_cloud_liquid_water</dd><dt><span>units :</span></dt><dd>kg kg-1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QV</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-fc6fcd5f-99e9-46c5-97dc-288cb670823d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fc6fcd5f-99e9-46c5-97dc-288cb670823d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-11b7db7c-9e32-44e3-afbd-6e5c683618a6' class='xr-var-data-in' type='checkbox'><label for='data-11b7db7c-9e32-44e3-afbd-6e5c683618a6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>specific_humidity</dd><dt><span>long_name :</span></dt><dd>specific_humidity</dd><dt><span>units :</span></dt><dd>kg kg-1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>RH</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d68b7fe1-d795-4101-835f-6e983644b81e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d68b7fe1-d795-4101-835f-6e983644b81e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6f6eadea-201c-49ef-9c76-58dbf66340d3' class='xr-var-data-in' type='checkbox'><label for='data-6f6eadea-201c-49ef-9c76-58dbf66340d3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>relative_humidity_after_moist</dd><dt><span>long_name :</span></dt><dd>relative_humidity_after_moist</dd><dt><span>units :</span></dt><dd>1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SLP</span></div><div class='xr-var-dims'>(time, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-0a30b48e-7a93-416c-bfea-9946a31e837a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0a30b48e-7a93-416c-bfea-9946a31e837a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-104480a6-f309-4175-9e49-6e548121f9b1' class='xr-var-data-in' type='checkbox'><label for='data-104480a6-f309-4175-9e49-6e548121f9b1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>sea_level_pressure</dd><dt><span>long_name :</span></dt><dd>sea_level_pressure</dd><dt><span>units :</span></dt><dd>Pa</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[1663488 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>T</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-095909c6-8b43-449f-aec7-e578d4332818' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-095909c6-8b43-449f-aec7-e578d4332818' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e349b1aa-91a0-4a2c-9fd5-135748e5c632' class='xr-var-data-in' type='checkbox'><label for='data-e349b1aa-91a0-4a2c-9fd5-135748e5c632' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>long_name :</span></dt><dd>air_temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>U</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-ce4e2b28-d197-44ab-90ba-ff4feb5a4eab' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ce4e2b28-d197-44ab-90ba-ff4feb5a4eab' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a5226198-6549-4603-ae02-c365f41f4cf6' class='xr-var-data-in' type='checkbox'><label for='data-a5226198-6549-4603-ae02-c365f41f4cf6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>eastward_wind</dd><dt><span>long_name :</span></dt><dd>eastward_wind</dd><dt><span>units :</span></dt><dd>m s-1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>V</span></div><div class='xr-var-dims'>(time, lev, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9d98c172-2c4d-4418-88c8-db72031acd01' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9d98c172-2c4d-4418-88c8-db72031acd01' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9f74626f-d6be-4cef-84ed-c45e4df13b1f' class='xr-var-data-in' type='checkbox'><label for='data-9f74626f-d6be-4cef-84ed-c45e4df13b1f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>northward_wind</dd><dt><span>long_name :</span></dt><dd>northward_wind</dd><dt><span>units :</span></dt><dd>m s-1</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>[119771136 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-fcd555c1-5017-4f9b-9cae-752861b158d3' class='xr-section-summary-in' type='checkbox'  ><label for='section-fcd555c1-5017-4f9b-9cae-752861b158d3' class='xr-section-summary' >Attributes: <span>(32)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>CDI :</span></dt><dd>Climate Data Interface version 1.9.8 (https://mpimet.mpg.de/cdi)</dd><dt><span>Conventions :</span></dt><dd>CF-1</dd><dt><span>History :</span></dt><dd>Original file generated: Sat Jun 14 01:53:48 2014 GMT</dd><dt><span>Comment :</span></dt><dd>GMAO filename: d5124_m2_jan00.tavg3_3d_asm_Nv.20010710.nc4</dd><dt><span>Filename :</span></dt><dd>MERRA2_300.tavg3_3d_asm_Nv.20010710.nc4</dd><dt><span>Institution :</span></dt><dd>NASA Global Modeling and Assimilation Office</dd><dt><span>References :</span></dt><dd>http://gmao.gsfc.nasa.gov</dd><dt><span>Format :</span></dt><dd>NetCDF-4/HDF-5</dd><dt><span>SpatialCoverage :</span></dt><dd>global</dd><dt><span>VersionID :</span></dt><dd>5.12.4</dd><dt><span>TemporalRange :</span></dt><dd>1980-01-01 -&gt; 2016-12-31</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org/</dd><dt><span>ShortName :</span></dt><dd>M2T3NVASM</dd><dt><span>GranuleID :</span></dt><dd>MERRA2_300.tavg3_3d_asm_Nv.20010710.nc4</dd><dt><span>ProductionDateTime :</span></dt><dd>Original file generated: Sat Jun 14 01:53:48 2014 GMT</dd><dt><span>LongName :</span></dt><dd>MERRA2 tavg3_3d_asm_Nv: 3d,3-Hourly,Time-Averaged,Model-Level,Assimilation,Assimilated Meteorological Fields</dd><dt><span>Title :</span></dt><dd>MERRA2 tavg3_3d_asm_Nv: 3d,3-Hourly,Time-Averaged,Model-Level,Assimilation,Assimilated Meteorological Fields</dd><dt><span>SouthernmostLatitude :</span></dt><dd>-90.0</dd><dt><span>NorthernmostLatitude :</span></dt><dd>90.0</dd><dt><span>WesternmostLongitude :</span></dt><dd>-180.0</dd><dt><span>EasternmostLongitude :</span></dt><dd>179.375</dd><dt><span>LatitudeResolution :</span></dt><dd>0.5</dd><dt><span>LongitudeResolution :</span></dt><dd>0.625</dd><dt><span>DataResolution :</span></dt><dd>0.5 x 0.625 (72 native layers)</dd><dt><span>Contact :</span></dt><dd>http://gmao.gsfc.nasa.gov</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/SUOQESM06LPK</dd><dt><span>RangeBeginningDate :</span></dt><dd>2001-07-10</dd><dt><span>RangeBeginningTime :</span></dt><dd>00:00:00.000000</dd><dt><span>RangeEndingDate :</span></dt><dd>2001-07-10</dd><dt><span>RangeEndingTime :</span></dt><dd>23:59:59.000000</dd><dt><span>history_L34RS :</span></dt><dd>&#x27;Created by L34RS v1.4.2 @ NASA GES DISC on June 16 2022 14:48:49. Variables: CLOUD DELP H OMEGA PL PS QI QL QV RH SLP T U V&#x27;</dd><dt><span>CDO :</span></dt><dd>Climate Data Operators version 1.9.8 (https://mpimet.mpg.de/cdo)</dd></dl></div></li></ul></div></div>"
      ],
      "text/plain": [
       "<xarray.Dataset>\n",
       "Dimensions:  (lon: 576, time: 8, lat: 361, lev: 72)\n",
       "Coordinates:\n",
       "  * lon      (lon) float64 0.625 1.25 1.875 2.5 ... 358.1 358.8 359.4 360.0\n",
       "  * time     (time) datetime64[ns] 2001-07-10T01:30:00 ... 2001-07-10T22:30:00\n",
       "  * lat      (lat) float64 -90.0 -89.5 -89.0 -88.5 -88.0 ... 88.5 89.0 89.5 90.0\n",
       "  * lev      (lev) float64 1.0 2.0 3.0 4.0 5.0 6.0 ... 68.0 69.0 70.0 71.0 72.0\n",
       "Data variables: (12/14)\n",
       "    CLOUD    (time, lev, lat, lon) float32 ...\n",
       "    DELP     (time, lev, lat, lon) float32 ...\n",
       "    H        (time, lev, lat, lon) float32 ...\n",
       "    OMEGA    (time, lev, lat, lon) float32 ...\n",
       "    PL       (time, lev, lat, lon) float32 ...\n",
       "    PS       (time, lat, lon) float32 ...\n",
       "    ...       ...\n",
       "    QV       (time, lev, lat, lon) float32 ...\n",
       "    RH       (time, lev, lat, lon) float32 ...\n",
       "    SLP      (time, lat, lon) float32 ...\n",
       "    T        (time, lev, lat, lon) float32 ...\n",
       "    U        (time, lev, lat, lon) float32 ...\n",
       "    V        (time, lev, lat, lon) float32 ...\n",
       "Attributes: (12/32)\n",
       "    CDI:                               Climate Data Interface version 1.9.8 (...\n",
       "    Conventions:                       CF-1\n",
       "    History:                           Original file generated: Sat Jun 14 01...\n",
       "    Comment:                           GMAO filename: d5124_m2_jan00.tavg3_3d...\n",
       "    Filename:                          MERRA2_300.tavg3_3d_asm_Nv.20010710.nc4\n",
       "    Institution:                       NASA Global Modeling and Assimilation ...\n",
       "    ...                                ...\n",
       "    RangeBeginningDate:                2001-07-10\n",
       "    RangeBeginningTime:                00:00:00.000000\n",
       "    RangeEndingDate:                   2001-07-10\n",
       "    RangeEndingTime:                   23:59:59.000000\n",
       "    history_L34RS:                     'Created by L34RS v1.4.2 @ NASA GES DI...\n",
       "    CDO:                               Climate Data Operators version 1.9.8 (..."
      ]
     },
     "execution_count": 108,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "#--- MERRA-2 data\n",
    "datapath_merra2 = \"/work/Yi-hsuan.Chen/research/edmf_CM4/data_plot.AM4/data.MERRA-2.tavg3_3d_asm_Nv.200107\"\n",
    "filename_merra2 = \"MERRA2_300.tavg3_3d_asm_Nv.20010710.SUB.nc\"\n",
    "files_input_merra2 = datapath_merra2+\"/\"+filename_merra2\n",
    "\n",
    "data_merra2 = xr.open_dataset(files_input_merra2)\n",
    "data_merra2 = yhc.wrap360(data_merra2)   # change lon from -180~180 to 0-360\n",
    "data_merra2\n",
    "\n",
    "#--- MERRA-2 tdt data\n",
    "datapath_merra2_tdt = \"/work/Yi-hsuan.Chen/research/edmf_CM4/data_plot.AM4/data.MERRA-2.tavg3_3d_tdt_Np.200107\"\n",
    "filename_merra2_tdt = \"MERRA2_300.tavg3_3d_tdt_Np.20010710.SUB.nc\"\n",
    "files_input_merra2_tdt = datapath_merra2_tdt+\"/\"+filename_merra2_tdt\n",
    "\n",
    "data_merra2_tdt = xr.open_dataset(files_input_merra2_tdt)\n",
    "data_merra2_tdt = yhc.wrap360(data_merra2_tdt)\n",
    "data_merra2_tdt\n",
    "\n",
    "#--- MERRA-2 qdt data\n",
    "datapath_merra2_qdt = \"/work/Yi-hsuan.Chen/research/edmf_CM4/data_plot.AM4/data.MERRA-2.tavg3_3d_qdt_Np.200107\"\n",
    "filename_merra2_qdt = \"MERRA2_300.tavg3_3d_qdt_Np.20010710.SUB.nc\"\n",
    "files_input_merra2_qdt = datapath_merra2_qdt+\"/\"+filename_merra2_qdt\n",
    "\n",
    "data_merra2_qdt = xr.open_dataset(files_input_merra2_qdt)\n",
    "data_merra2_qdt = yhc.wrap360(data_merra2_qdt)\n",
    "#data_merra2_qdt\n",
    "\n",
    "#--- MERRA-2 slv data\n",
    "datapath_merra2_slv = \"/work/Yi-hsuan.Chen/research/edmf_CM4/data_plot.AM4/data.MERRA-2.tavg1_2d_slv_Nx.200107\"\n",
    "filename_merra2_slv = \"MERRA2_300.tavg1_2d_slv_Nx.20010710.SUB.nc\"\n",
    "files_input_merra2_slv = datapath_merra2_slv+\"/\"+filename_merra2_slv\n",
    "\n",
    "data_merra2_slv = xr.open_dataset(files_input_merra2_slv)\n",
    "data_merra2_slv = yhc.wrap360(data_merra2_slv)\n",
    "#data_merra2_slv\n",
    "\n",
    "#--- MERRA-2 horizontal advection data\n",
    "datapath_merra2_tadv = \"/work/Yi-hsuan.Chen/research/edmf_CM4/data_plot.AM4/data.MERRA-2.tavg3_3d_asm_Nv.200107\"\n",
    "filename_merra2_tadv = \"data01-MERRA2_300.tavg3_3d_asm_Nv.20010710.SUB-T_hadv.nc\"\n",
    "files_merra2_tadv = datapath_merra2_tadv+\"/\"+filename_merra2_tadv\n",
    "data_merra2_tadv = xr.open_dataset(files_merra2_tadv)\n",
    "data_merra2_tadv = yhc.wrap360(data_merra2_tadv)\n",
    "\n",
    "datapath_merra2_qadv = \"/work/Yi-hsuan.Chen/research/edmf_CM4/data_plot.AM4/data.MERRA-2.tavg3_3d_asm_Nv.200107\"\n",
    "filename_merra2_qadv = \"data01-MERRA2_300.tavg3_3d_asm_Nv.20010710.SUB-QV_hadv.nc\"\n",
    "files_merra2_qadv = datapath_merra2_qadv+\"/\"+filename_merra2_qadv\n",
    "data_merra2_qadv = xr.open_dataset(files_merra2_qadv)\n",
    "data_merra2_qadv = yhc.wrap360(data_merra2_qadv)\n",
    "\n",
    "\n",
    "data_merra2"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "013f5d3b-0c87-402e-820b-c29b59743420",
   "metadata": {},
   "source": [
    "## Read MERRA-2 variables"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 93,
   "id": "e631443e-0ddc-4ace-b936-91e6b7e6d290",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/html": [
       "<div><svg style=\"position: absolute; width: 0; height: 0; overflow: hidden\">\n",
       "<defs>\n",
       "<symbol id=\"icon-database\" viewBox=\"0 0 32 32\">\n",
       "<path d=\"M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z\"></path>\n",
       "<path d=\"M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z\"></path>\n",
       "<path d=\"M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z\"></path>\n",
       "</symbol>\n",
       "<symbol id=\"icon-file-text2\" viewBox=\"0 0 32 32\">\n",
       "<path d=\"M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z\"></path>\n",
       "<path d=\"M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z\"></path>\n",
       "<path d=\"M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z\"></path>\n",
       "<path d=\"M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z\"></path>\n",
       "</symbol>\n",
       "</defs>\n",
       "</svg>\n",
       "<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.\n",
       " *\n",
       " */\n",
       "\n",
       ":root {\n",
       "  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));\n",
       "  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));\n",
       "  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));\n",
       "  --xr-border-color: var(--jp-border-color2, #e0e0e0);\n",
       "  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);\n",
       "  --xr-background-color: var(--jp-layout-color0, white);\n",
       "  --xr-background-color-row-even: var(--jp-layout-color1, white);\n",
       "  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);\n",
       "}\n",
       "\n",
       "html[theme=dark],\n",
       "body.vscode-dark {\n",
       "  --xr-font-color0: rgba(255, 255, 255, 1);\n",
       "  --xr-font-color2: rgba(255, 255, 255, 0.54);\n",
       "  --xr-font-color3: rgba(255, 255, 255, 0.38);\n",
       "  --xr-border-color: #1F1F1F;\n",
       "  --xr-disabled-color: #515151;\n",
       "  --xr-background-color: #111111;\n",
       "  --xr-background-color-row-even: #111111;\n",
       "  --xr-background-color-row-odd: #313131;\n",
       "}\n",
       "\n",
       ".xr-wrap {\n",
       "  display: block !important;\n",
       "  min-width: 300px;\n",
       "  max-width: 700px;\n",
       "}\n",
       "\n",
       ".xr-text-repr-fallback {\n",
       "  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-header {\n",
       "  padding-top: 6px;\n",
       "  padding-bottom: 6px;\n",
       "  margin-bottom: 4px;\n",
       "  border-bottom: solid 1px var(--xr-border-color);\n",
       "}\n",
       "\n",
       ".xr-header > div,\n",
       ".xr-header > ul {\n",
       "  display: inline;\n",
       "  margin-top: 0;\n",
       "  margin-bottom: 0;\n",
       "}\n",
       "\n",
       ".xr-obj-type,\n",
       ".xr-array-name {\n",
       "  margin-left: 2px;\n",
       "  margin-right: 10px;\n",
       "}\n",
       "\n",
       ".xr-obj-type {\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-sections {\n",
       "  padding-left: 0 !important;\n",
       "  display: grid;\n",
       "  grid-template-columns: 150px auto auto 1fr 20px 20px;\n",
       "}\n",
       "\n",
       ".xr-section-item {\n",
       "  display: contents;\n",
       "}\n",
       "\n",
       ".xr-section-item input {\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-section-item input + label {\n",
       "  color: var(--xr-disabled-color);\n",
       "}\n",
       "\n",
       ".xr-section-item input:enabled + label {\n",
       "  cursor: pointer;\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-section-item input:enabled + label:hover {\n",
       "  color: var(--xr-font-color0);\n",
       "}\n",
       "\n",
       ".xr-section-summary {\n",
       "  grid-column: 1;\n",
       "  color: var(--xr-font-color2);\n",
       "  font-weight: 500;\n",
       "}\n",
       "\n",
       ".xr-section-summary > span {\n",
       "  display: inline-block;\n",
       "  padding-left: 0.5em;\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:disabled + label {\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-section-summary-in + label:before {\n",
       "  display: inline-block;\n",
       "  content: '►';\n",
       "  font-size: 11px;\n",
       "  width: 15px;\n",
       "  text-align: center;\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:disabled + label:before {\n",
       "  color: var(--xr-disabled-color);\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:checked + label:before {\n",
       "  content: '▼';\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:checked + label > span {\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-section-summary,\n",
       ".xr-section-inline-details {\n",
       "  padding-top: 4px;\n",
       "  padding-bottom: 4px;\n",
       "}\n",
       "\n",
       ".xr-section-inline-details {\n",
       "  grid-column: 2 / -1;\n",
       "}\n",
       "\n",
       ".xr-section-details {\n",
       "  display: none;\n",
       "  grid-column: 1 / -1;\n",
       "  margin-bottom: 5px;\n",
       "}\n",
       "\n",
       ".xr-section-summary-in:checked ~ .xr-section-details {\n",
       "  display: contents;\n",
       "}\n",
       "\n",
       ".xr-array-wrap {\n",
       "  grid-column: 1 / -1;\n",
       "  display: grid;\n",
       "  grid-template-columns: 20px auto;\n",
       "}\n",
       "\n",
       ".xr-array-wrap > label {\n",
       "  grid-column: 1;\n",
       "  vertical-align: top;\n",
       "}\n",
       "\n",
       ".xr-preview {\n",
       "  color: var(--xr-font-color3);\n",
       "}\n",
       "\n",
       ".xr-array-preview,\n",
       ".xr-array-data {\n",
       "  padding: 0 5px !important;\n",
       "  grid-column: 2;\n",
       "}\n",
       "\n",
       ".xr-array-data,\n",
       ".xr-array-in:checked ~ .xr-array-preview {\n",
       "  display: none;\n",
       "}\n",
       "\n",
       ".xr-array-in:checked ~ .xr-array-data,\n",
       ".xr-array-preview {\n",
       "  display: inline-block;\n",
       "}\n",
       "\n",
       ".xr-dim-list {\n",
       "  display: inline-block !important;\n",
       "  list-style: none;\n",
       "  padding: 0 !important;\n",
       "  margin: 0;\n",
       "}\n",
       "\n",
       ".xr-dim-list li {\n",
       "  display: inline-block;\n",
       "  padding: 0;\n",
       "  margin: 0;\n",
       "}\n",
       "\n",
       ".xr-dim-list:before {\n",
       "  content: '(';\n",
       "}\n",
       "\n",
       ".xr-dim-list:after {\n",
       "  content: ')';\n",
       "}\n",
       "\n",
       ".xr-dim-list li:not(:last-child):after {\n",
       "  content: ',';\n",
       "  padding-right: 5px;\n",
       "}\n",
       "\n",
       ".xr-has-index {\n",
       "  font-weight: bold;\n",
       "}\n",
       "\n",
       ".xr-var-list,\n",
       ".xr-var-item {\n",
       "  display: contents;\n",
       "}\n",
       "\n",
       ".xr-var-item > div,\n",
       ".xr-var-item label,\n",
       ".xr-var-item > .xr-var-name span {\n",
       "  background-color: var(--xr-background-color-row-even);\n",
       "  margin-bottom: 0;\n",
       "}\n",
       "\n",
       ".xr-var-item > .xr-var-name:hover span {\n",
       "  padding-right: 5px;\n",
       "}\n",
       "\n",
       ".xr-var-list > li:nth-child(odd) > div,\n",
       ".xr-var-list > li:nth-child(odd) > label,\n",
       ".xr-var-list > li:nth-child(odd) > .xr-var-name span {\n",
       "  background-color: var(--xr-background-color-row-odd);\n",
       "}\n",
       "\n",
       ".xr-var-name {\n",
       "  grid-column: 1;\n",
       "}\n",
       "\n",
       ".xr-var-dims {\n",
       "  grid-column: 2;\n",
       "}\n",
       "\n",
       ".xr-var-dtype {\n",
       "  grid-column: 3;\n",
       "  text-align: right;\n",
       "  color: var(--xr-font-color2);\n",
       "}\n",
       "\n",
       ".xr-var-preview {\n",
       "  grid-column: 4;\n",
       "}\n",
       "\n",
       ".xr-var-name,\n",
       ".xr-var-dims,\n",
       ".xr-var-dtype,\n",
       ".xr-preview,\n",
       ".xr-attrs dt {\n",
       "  white-space: nowrap;\n",
       "  overflow: hidden;\n",
       "  text-overflow: ellipsis;\n",
       "  padding-right: 10px;\n",
       "}\n",
       "\n",
       ".xr-var-name:hover,\n",
       ".xr-var-dims:hover,\n",
       ".xr-var-dtype:hover,\n",
       ".xr-attrs dt:hover {\n",
       "  overflow: visible;\n",
       "  width: auto;\n",
       "  z-index: 1;\n",
       "}\n",
       "\n",
       ".xr-var-attrs,\n",
       ".xr-var-data {\n",
       "  display: none;\n",
       "  background-color: var(--xr-background-color) !important;\n",
       "  padding-bottom: 5px !important;\n",
       "}\n",
       "\n",
       ".xr-var-attrs-in:checked ~ .xr-var-attrs,\n",
       ".xr-var-data-in:checked ~ .xr-var-data {\n",
       "  display: block;\n",
       "}\n",
       "\n",
       ".xr-var-data > table {\n",
       "  float: right;\n",
       "}\n",
       "\n",
       ".xr-var-name span,\n",
       ".xr-var-data,\n",
       ".xr-attrs {\n",
       "  padding-left: 25px !important;\n",
       "}\n",
       "\n",
       ".xr-attrs,\n",
       ".xr-var-attrs,\n",
       ".xr-var-data {\n",
       "  grid-column: 1 / -1;\n",
       "}\n",
       "\n",
       "dl.xr-attrs {\n",
       "  padding: 0;\n",
       "  margin: 0;\n",
       "  display: grid;\n",
       "  grid-template-columns: 125px auto;\n",
       "}\n",
       "\n",
       ".xr-attrs dt,\n",
       ".xr-attrs dd {\n",
       "  padding: 0;\n",
       "  margin: 0;\n",
       "  float: left;\n",
       "  padding-right: 10px;\n",
       "  width: auto;\n",
       "}\n",
       "\n",
       ".xr-attrs dt {\n",
       "  font-weight: normal;\n",
       "  grid-column: 1;\n",
       "}\n",
       "\n",
       ".xr-attrs dt:hover span {\n",
       "  display: inline-block;\n",
       "  background: var(--xr-background-color);\n",
       "  padding-right: 10px;\n",
       "}\n",
       "\n",
       ".xr-attrs dd {\n",
       "  grid-column: 2;\n",
       "  white-space: pre-wrap;\n",
       "  word-break: break-all;\n",
       "}\n",
       "\n",
       ".xr-icon-database,\n",
       ".xr-icon-file-text2 {\n",
       "  display: inline-block;\n",
       "  vertical-align: middle;\n",
       "  width: 1em;\n",
       "  height: 1.5em !important;\n",
       "  stroke-width: 0;\n",
       "  stroke: currentColor;\n",
       "  fill: currentColor;\n",
       "}\n",
       "</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;PL&#x27; (lev: 72)&gt;\n",
       "array([1.50000012e+00, 2.63500118e+00, 4.01425123e+00, 5.67925215e+00,\n",
       "       7.76725245e+00, 1.04524040e+01, 1.39599009e+01, 1.85422039e+01,\n",
       "       2.44937534e+01, 3.21783485e+01, 4.20423584e+01, 5.46292686e+01,\n",
       "       7.05956650e+01, 9.07287292e+01, 1.15997536e+02, 1.47564987e+02,\n",
       "       1.86788071e+02, 2.35259109e+02, 2.94832062e+02, 3.67650024e+02,\n",
       "       4.56168671e+02, 5.63179993e+02, 6.91832092e+02, 8.45638916e+02,\n",
       "       1.02849219e+03, 1.24601550e+03, 1.50502502e+03, 1.81243506e+03,\n",
       "       2.17610059e+03, 2.60491040e+03, 3.10889062e+03, 3.69927124e+03,\n",
       "       4.39096631e+03, 5.20159180e+03, 6.14956445e+03, 7.25578564e+03,\n",
       "       8.54390234e+03, 1.00514365e+04, 1.18250010e+04, 1.39115010e+04,\n",
       "       1.63661553e+04, 1.92603589e+04, 2.26827885e+04, 2.67303425e+04,\n",
       "       3.14384734e+04, 3.58675137e+04, 3.96955512e+04, 4.35269779e+04,\n",
       "       4.73614388e+04, 5.11982325e+04, 5.50365245e+04, 5.88770341e+04,\n",
       "       6.27182371e+04, 6.65604279e+04, 6.97631384e+04, 7.23253708e+04,\n",
       "       7.48884430e+04, 7.74510449e+04, 8.00143153e+04, 8.23213256e+04,\n",
       "       8.41169319e+04, 8.56539193e+04, 8.71932632e+04, 8.87304668e+04,\n",
       "       9.02690587e+04, 9.18077401e+04, 9.33466789e+04, 9.48855757e+04,\n",
       "       9.64237712e+04, 9.79628774e+04, 9.95019535e+04, 1.01033833e+05])\n",
       "Coordinates:\n",
       "    time     datetime64[ns] 2001-07-10T10:30:00\n",
       "  * lev      (lev) float64 1.0 2.0 3.0 4.0 5.0 6.0 ... 68.0 69.0 70.0 71.0 72.0\n",
       "Attributes:\n",
       "    standard_name:   mid_level_pressure\n",
       "    long_name:       mid_level_pressure\n",
       "    units:           Pa\n",
       "    fmissing_value:  1000000000000000.0\n",
       "    vmax:            1000000000000000.0\n",
       "    vmin:            -1000000000000000.0</pre><div class='xr-wrap' style='display:none'><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'PL'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>lev</span>: 72</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-63a6108c-30b9-4426-8f0b-6131322cfd78' class='xr-array-in' type='checkbox' checked><label for='section-63a6108c-30b9-4426-8f0b-6131322cfd78' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1.5 2.635 4.014 5.679 7.767 ... 9.642e+04 9.796e+04 9.95e+04 1.01e+05</span></div><div class='xr-array-data'><pre>array([1.50000012e+00, 2.63500118e+00, 4.01425123e+00, 5.67925215e+00,\n",
       "       7.76725245e+00, 1.04524040e+01, 1.39599009e+01, 1.85422039e+01,\n",
       "       2.44937534e+01, 3.21783485e+01, 4.20423584e+01, 5.46292686e+01,\n",
       "       7.05956650e+01, 9.07287292e+01, 1.15997536e+02, 1.47564987e+02,\n",
       "       1.86788071e+02, 2.35259109e+02, 2.94832062e+02, 3.67650024e+02,\n",
       "       4.56168671e+02, 5.63179993e+02, 6.91832092e+02, 8.45638916e+02,\n",
       "       1.02849219e+03, 1.24601550e+03, 1.50502502e+03, 1.81243506e+03,\n",
       "       2.17610059e+03, 2.60491040e+03, 3.10889062e+03, 3.69927124e+03,\n",
       "       4.39096631e+03, 5.20159180e+03, 6.14956445e+03, 7.25578564e+03,\n",
       "       8.54390234e+03, 1.00514365e+04, 1.18250010e+04, 1.39115010e+04,\n",
       "       1.63661553e+04, 1.92603589e+04, 2.26827885e+04, 2.67303425e+04,\n",
       "       3.14384734e+04, 3.58675137e+04, 3.96955512e+04, 4.35269779e+04,\n",
       "       4.73614388e+04, 5.11982325e+04, 5.50365245e+04, 5.88770341e+04,\n",
       "       6.27182371e+04, 6.65604279e+04, 6.97631384e+04, 7.23253708e+04,\n",
       "       7.48884430e+04, 7.74510449e+04, 8.00143153e+04, 8.23213256e+04,\n",
       "       8.41169319e+04, 8.56539193e+04, 8.71932632e+04, 8.87304668e+04,\n",
       "       9.02690587e+04, 9.18077401e+04, 9.33466789e+04, 9.48855757e+04,\n",
       "       9.64237712e+04, 9.79628774e+04, 9.95019535e+04, 1.01033833e+05])</pre></div></div></li><li class='xr-section-item'><input id='section-806c07e5-14b2-4c0e-95af-25f7a2b8779d' class='xr-section-summary-in' type='checkbox'  checked><label for='section-806c07e5-14b2-4c0e-95af-25f7a2b8779d' class='xr-section-summary' >Coordinates: <span>(2)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>time</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>datetime64[ns]</div><div class='xr-var-preview xr-preview'>2001-07-10T10:30:00</div><input id='attrs-1ea44fb9-758c-4307-aab2-7499a4138b15' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1ea44fb9-758c-4307-aab2-7499a4138b15' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92c6e4cd-ae06-481e-b279-ab849ab85899' class='xr-var-data-in' type='checkbox'><label for='data-92c6e4cd-ae06-481e-b279-ab849ab85899' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>time</dd><dt><span>long_name :</span></dt><dd>time</dd><dt><span>axis :</span></dt><dd>T</dd></dl></div><div class='xr-var-data'><pre>array(&#x27;2001-07-10T10:30:00.000000000&#x27;, dtype=&#x27;datetime64[ns]&#x27;)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lev</span></div><div class='xr-var-dims'>(lev)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.0 2.0 3.0 4.0 ... 70.0 71.0 72.0</div><input id='attrs-7895383e-61a1-4ac7-9e0b-43fc75c2046f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7895383e-61a1-4ac7-9e0b-43fc75c2046f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ce3117b5-f5c9-4cc6-8747-8747ae2888f3' class='xr-var-data-in' type='checkbox'><label for='data-ce3117b5-f5c9-4cc6-8747-8747ae2888f3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>vertical level</dd><dt><span>units :</span></dt><dd>layer</dd><dt><span>positive :</span></dt><dd>down</dd><dt><span>axis :</span></dt><dd>Z</dd><dt><span>coordinate :</span></dt><dd>eta</dd><dt><span>standard_name :</span></dt><dd>model_layers</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div><div class='xr-var-data'><pre>array([ 1.,  2.,  3.,  4.,  5.,  6.,  7.,  8.,  9., 10., 11., 12., 13., 14.,\n",
       "       15., 16., 17., 18., 19., 20., 21., 22., 23., 24., 25., 26., 27., 28.,\n",
       "       29., 30., 31., 32., 33., 34., 35., 36., 37., 38., 39., 40., 41., 42.,\n",
       "       43., 44., 45., 46., 47., 48., 49., 50., 51., 52., 53., 54., 55., 56.,\n",
       "       57., 58., 59., 60., 61., 62., 63., 64., 65., 66., 67., 68., 69., 70.,\n",
       "       71., 72.])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-2d746abf-e672-4f33-9a2d-b7553f32f156' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2d746abf-e672-4f33-9a2d-b7553f32f156' class='xr-section-summary' >Attributes: <span>(6)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>standard_name :</span></dt><dd>mid_level_pressure</dd><dt><span>long_name :</span></dt><dd>mid_level_pressure</dd><dt><span>units :</span></dt><dd>Pa</dd><dt><span>fmissing_value :</span></dt><dd>1000000000000000.0</dd><dt><span>vmax :</span></dt><dd>1000000000000000.0</dd><dt><span>vmin :</span></dt><dd>-1000000000000000.0</dd></dl></div></li></ul></div></div>"
      ],
      "text/plain": [
       "<xarray.DataArray 'PL' (lev: 72)>\n",
       "array([1.50000012e+00, 2.63500118e+00, 4.01425123e+00, 5.67925215e+00,\n",
       "       7.76725245e+00, 1.04524040e+01, 1.39599009e+01, 1.85422039e+01,\n",
       "       2.44937534e+01, 3.21783485e+01, 4.20423584e+01, 5.46292686e+01,\n",
       "       7.05956650e+01, 9.07287292e+01, 1.15997536e+02, 1.47564987e+02,\n",
       "       1.86788071e+02, 2.35259109e+02, 2.94832062e+02, 3.67650024e+02,\n",
       "       4.56168671e+02, 5.63179993e+02, 6.91832092e+02, 8.45638916e+02,\n",
       "       1.02849219e+03, 1.24601550e+03, 1.50502502e+03, 1.81243506e+03,\n",
       "       2.17610059e+03, 2.60491040e+03, 3.10889062e+03, 3.69927124e+03,\n",
       "       4.39096631e+03, 5.20159180e+03, 6.14956445e+03, 7.25578564e+03,\n",
       "       8.54390234e+03, 1.00514365e+04, 1.18250010e+04, 1.39115010e+04,\n",
       "       1.63661553e+04, 1.92603589e+04, 2.26827885e+04, 2.67303425e+04,\n",
       "       3.14384734e+04, 3.58675137e+04, 3.96955512e+04, 4.35269779e+04,\n",
       "       4.73614388e+04, 5.11982325e+04, 5.50365245e+04, 5.88770341e+04,\n",
       "       6.27182371e+04, 6.65604279e+04, 6.97631384e+04, 7.23253708e+04,\n",
       "       7.48884430e+04, 7.74510449e+04, 8.00143153e+04, 8.23213256e+04,\n",
       "       8.41169319e+04, 8.56539193e+04, 8.71932632e+04, 8.87304668e+04,\n",
       "       9.02690587e+04, 9.18077401e+04, 9.33466789e+04, 9.48855757e+04,\n",
       "       9.64237712e+04, 9.79628774e+04, 9.95019535e+04, 1.01033833e+05])\n",
       "Coordinates:\n",
       "    time     datetime64[ns] 2001-07-10T10:30:00\n",
       "  * lev      (lev) float64 1.0 2.0 3.0 4.0 5.0 6.0 ... 68.0 69.0 70.0 71.0 72.0\n",
       "Attributes:\n",
       "    standard_name:   mid_level_pressure\n",
       "    long_name:       mid_level_pressure\n",
       "    units:           Pa\n",
       "    fmissing_value:  1000000000000000.0\n",
       "    vmax:            1000000000000000.0\n",
       "    vmin:            -1000000000000000.0"
      ]
     },
     "execution_count": 93,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "time_step_merra2 = \"2001-07-10T10:30:00.000000000\"\n",
    "#time_step_merra2 = \"2001-07-10T07:30:00.000000000\"\n",
    "#time_step_merra2 = \"2001-07-10T13:30:00.000000000\"\n",
    "\n",
    "\n",
    "region = \"DYCOMS\"\n",
    "\n",
    "#--- read pressure levels\n",
    "pfull_merra2 = yhc.get_area_avg( data_merra2.PL.sel(time=time_step_merra2), region)\n",
    "\n",
    "#--- read divT3d & divq3d\n",
    "divT3d_merra2 = yhc.get_area_avg(data_merra2_tdt.DTDTDYN.sel(time=time_step_merra2), region)\n",
    "divq3d_merra2 = yhc.get_area_avg(data_merra2_qdt.DQVDTDYN.sel(time=time_step_merra2), region)\n",
    "plev_merra2 = data_merra2_qdt.lev.copy()\n",
    "\n",
    "#--- read tdt_hadv & qdt_hadv\n",
    "divT_merra2_sphere = yhc.get_area_avg(data_merra2_tadv.T_adv_sphere.sel(time=time_step_merra2), region)\n",
    "divT_merra2_cfd = yhc.get_area_avg(data_merra2_tadv.T_adv_cfd.sel(time=time_step_merra2), region)\n",
    "\n",
    "divq_merra2_sphere = yhc.get_area_avg(data_merra2_qadv.QV_adv_sphere.sel(time=time_step_merra2), region)\n",
    "divq_merra2_cfd = yhc.get_area_avg(data_merra2_qadv.QV_adv_cfd.sel(time=time_step_merra2), region)\n",
    "\n",
    "\n",
    "pfull_merra2\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7d2e1092-ab17-4ee5-8898-c831574cdc29",
   "metadata": {},
   "source": [
    "## Interpolate MERRA-2 data onto SCM levels"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 94,
   "id": "e97dd678-316d-4e0f-8496-ec2cce667ec3",
   "metadata": {},
   "outputs": [],
   "source": [
    "#--- determine SCM pressure levels\n",
    "Ps_SCM = 101780.  # DYCOMS SCM surface pressure (Pa)\n",
    "model = \"AM4_L33_native\"\n",
    "pfull_merra2_inSCM = yhc.mlevs_to_plevs(Ps_SCM, model, \"pfull\")\n",
    "plev_merra2_inSCM = pfull_merra2_inSCM.to_numpy()\n",
    "\n",
    "# interpolation\n",
    "divT3d_merra2_inSCM = xr.DataArray(np.interp(pfull_merra2_inSCM, plev_merra2[::-1]*100., divT3d_merra2[::-1]), dims=['plev'], \n",
    "                                coords=[plev_merra2_inSCM])\n",
    "divq3d_merra2_inSCM = xr.DataArray(np.interp(pfull_merra2_inSCM, plev_merra2[::-1]*100., divq3d_merra2[::-1]), dims=['plev'], \n",
    "                                coords=[plev_merra2_inSCM])\n",
    "\n",
    "divT_merra2_sphere_inSCM = xr.DataArray(np.interp(pfull_merra2_inSCM, pfull_merra2, divT_merra2_sphere), dims=['plev'], \n",
    "                                coords=[plev_merra2_inSCM])\n",
    "divT_merra2_cfd_inSCM = xr.DataArray(np.interp(pfull_merra2_inSCM, pfull_merra2, divT_merra2_cfd), dims=['plev'], \n",
    "                                coords=[plev_merra2_inSCM])\n",
    "divq_merra2_sphere_inSCM = xr.DataArray(np.interp(pfull_merra2_inSCM, pfull_merra2, divq_merra2_sphere), dims=['plev'], \n",
    "                                coords=[plev_merra2_inSCM])\n",
    "divq_merra2_cfd_inSCM = xr.DataArray(np.interp(pfull_merra2_inSCM, pfull_merra2, divq_merra2_cfd), dims=['plev'], \n",
    "                                coords=[plev_merra2_inSCM])\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "24a74dc6-4c26-4360-b169-70afe570fa5c",
   "metadata": {},
   "source": [
    "## Plot"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 95,
   "id": "263f358e-02a5-433a-97da-5a589084e6ac",
   "metadata": {},
   "outputs": [],
   "source": [
    "def ax_def (ax, var):\n",
    "\n",
    "    #--- set grids\n",
    "    ax.grid(True)\n",
    "    ax.minorticks_on()\n",
    "    \n",
    "    #--- inverse axes\n",
    "    ax.invert_yaxis()\n",
    "    \n",
    "    #--- legend\n",
    "    #ax.legend([\"L33, sphere_harmo\",\"L72, sphere_harmo\", \"L33, cfd\",\"L72, cfd\", ])    \n",
    "\n",
    "    #--- set x or y labels\n",
    "    ax.set_ylabel(\"Pressure (hPa)\")\n",
    "\n",
    "    #--- set title\n",
    "    ax.set_title(var.attrs['long_name'], loc='left')\n",
    "    ax.set_title(var.attrs['units'], loc='right')\n",
    "    ax.set_xlabel(var.attrs['long_name']+\" (\"+var.attrs['units']+\")\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 103,
   "id": "52b26631-c65e-49a9-9ac3-760d5768b9c6",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "<matplotlib.legend.Legend at 0x2b86082712e0>"
      ]
     },
     "execution_count": 103,
     "metadata": {},
     "output_type": "execute_result"
    },
    {
     "data": {
      "image/png": "iVBORw0KGgoAAAANSUhEUgAAAtoAAAGeCAYAAACqz6bUAAAAOXRFWHRTb2Z0d2FyZQBNYXRwbG90bGliIHZlcnNpb24zLjUuMiwgaHR0cHM6Ly9tYXRwbG90bGliLm9yZy8qNh9FAAAACXBIWXMAAAsTAAALEwEAmpwYAAEAAElEQVR4nOzdd3wURf/A8c/k0guh15CEIiCBEAihSAtKUxBF1FAUxIKK+oj+LCAqUeGx8VgQkQcL6EMUlKKgFAUJAlIkJrQkNEkgEFqAJKRfbn5/7Oa4JJdeLiTzfr3ulbud3dnvzu1O5nZnZ4WUEkVRFEVRFEVRKpedrQNQFEVRFEVRlNpINbQVRVEURVEUpQqohraiKIqiKIqiVAHV0FYURVEURVGUKqAa2oqiKIqiKIpSBVRDW1EURVEURVGqgGpoK4qiKIqiKEoVUA1tRaliQog4IUS2EKJxgelRQggphPDVPy/V57tm8dqvp/nq8+ZNjxNCzLCyngw9/Zyen3uBedz09PWliHueEOKYECJVCBErhJhUhm0OFULk6MumCiGOCiEWCCFa6OlhQoivCiwzSAiRJIRoIYRw1PM4JoRI07ftq7yy0ucfJYTYq6cn6Xl6WaQ/pJfZBwXWc7c+fanFtEf0bUwVQpwXQvwihPAoxXY2FUJ8J4Q4K4RIFkLsFEL0LjDPBCFEvB7nj0KIhhZpTvp2pejf2fMFll0shDgihDAJIR4qRTwBQogIIUS6/jfAIm1RgX0rSwiRWkxeXYQQm4QQl4QQhR64IIRoKIRYo29XvBBigj59osU6MvTYzevV53laCLFPj2Gplbxv07+PdCHEViGETzFxThdC/KOX4VkhxIdCCHuLdF89j3Q9zyEllGG5v6/KzKu471JPf05fLlnPx8kizep3Y5FeZPkKzbtCO6aShBDvCSFEacuzuG1WlDpJSqle6qVeVfgC4oAjwDMW07rq0yTgq09bCswpIg9ffV57/XNPIA0YWmA9Q/T3zYH9wNwC+UwGkgAj0KKEuN8AOqH9IO8NXAFuKeU2hwLL9PcOgB+wEjgLtAAaAefy4gecgaPAQ/rntcDfQBBgD3gCTwGP6On3AinARMBF396v9DJooM/zEHAcOJNXbvr01XrZL9U/DwLOA931zw31cvIoxXa2BZ7Xt8kATAUuAe56uh+QCgwE3IFvgeUWy78NbAcaADfrZTLCIv0p4DZgX17ZFBOLIxAPPAc4Af/SPzsWMf9S4Kti8usIPALcBUgr6d8BK/Tt6g8kA34F5gkGEqwsew9wN/BZ3vdgkdZYz+s+fb94H9hdTJztgPoW393vwPMW6buAD/T9ZCxwFWhSRF4V+r4qK6+SvktguL7P+unLhwPvlOa7Kal8gcfRjg8voBUQDTxRmvIsaZvVS73q4svmAaiXetX2F1rj71XgL4tp84BZlLOhrU/bC7xYYD1DLD6/B/xSIJ/fgblojdgXyrgda4H/K+W8oegNbYtpBrTG/zz9833AScBNb3Rs0KcPATKA1kXkLfRGx0sFptsBh4A39c8PATuAjcBIfVpDvUHzPtcb2i8AP1bi950CBOrv/w18a5HWDshGb8Sj/QgYZpH+lrWGib4dD5Ww3mF6fsJi2imsNAT1Mk8FBpVie9pToKGtL58NdLCY9j8sGnv6tGCsNLQt0udQuKE9FfizwLoygE6liLURsBlYqH/uAGRh8aMJrXH7RBHLV8r3VdG8Svou0Rqw/7ZIuw04V5rvpqTyBf4EplqkP4LeEC+pPEvaZvVSr7r4Ul1HFKV67AbqCSFuFkIYgBBgWXkzE0L0AbqgnbG1lu4F3G6ZLoTwRmv4hOmvsnQFcUE7u3y4vDFLKXOBn4AB+ucfgAi0s29T0c6kgdbQ3iulPF1EVh0Bb+CHAvmbgFXA0ALzf8P1bR2nx5Blkb4HGC6EeEMI0c/yEnxZ6Zf3Hble7n5oPy7yYjyB3ggSQjQAWlqm6+/9yrl6P+CAlNKym8eBIvIbC1wE/ijnujoAuVLKoxbTKhK7pYJllgacyMtb75pwwHIBfVoK2tWEbsB/LfL6R0pp2UVmv0Ve3kKIq/qxYW3dFfm+KpJXSd+ln5VlmwkhGlHyd1Ns+RaRt2VakeVZ3DajKHWUamgrSvX5H1qDbygQi3bGqqAX9H/8ea+vC6RfEkJkoF2+XQj8WCD9R6H1uz0NXABmW6RNQvvnHY3WuPUTQnQvZeyL0P6Bbirl/EU5i3ZWOc9TwK1oZ6FP6dMaAYnF5JHX193aPIkW6XnWAMFCCE+0MvjGMlFKuR2tK0MP4BcgSQjxgf6DqNSEEPXQvuM3pJTJ+mR3tMv0lpIBDz2NAul5aeVR3LoKmgx8U6AhV1XrqtS8pZTfSin9LRP1afXQGnSL0LpVlCavU1LK+hb7XmV+XxXJq6TyLZie997DSlpl5O2u99OuaN6KUueohraiVJ//ARPQujR8U8Q88/R//HmvyQXSG6P9M3sB7ey0Q4H0u6WUHnpaJ/I3OiehnclGSnkW2IbW4Cp4o9wrlhkKId5HO3t+fwUaZnlaAZfzPkgpz6OdhbQ8U56E1ue5KJf0v9bmaWGRnreODLQG9KtAYynlzoILSSk3SCnvRPsRcBfad/RoCdtipp/xX4d2if1ti6RrQL0Cs9dD67ZxzeJzwbTSrNPyxkbvEtZluVxrtH7p31hMs7yBcUMpVl+qdZVTufOWUh5D25cWljOvyvy+KpJXSXEXTM97n2olrTLyvqYf+xXNW1HqHNXQVpRqIqWMR+uTfAfaDXnlzSdXSvkfIBOYVsQ829D6fM8DEELcAtwEzNRHKjiHdoPjeCGEvZTyCSmlu/76d14+Qog30LqgDJNSppQ3Zj0vO+BOtD6dxdkM9BIWI4gUcARIQOvjXTD/scAWK8t8A/wf2o+dIkkpTVLKLWh92buUEGfeep3Qriyc4Xr3lzyH0boy5M3bFu3mtqNSyitoZ+C7WczfjVJ2z7H4vtz1M7KHAX/LESIAfyv5TULro/uPRV5hFnndXorVHwXshRA3lSf2EhQsMze0vr6lzdtenz8vr7Yi/wgyxcVZmd9XRfIq6bs8bGXZ81LKJEr+bkoqX2t5W6YVV55FbjOKUlfZupO4eqlXbX+RfzSQdkBP/b09FbsZchRaVwznguvRPzdBG5kkAK3P6q9oo3PkvdqgnWm6s4h1zgSOUcToJPr6HioiLZT8o47cjDYKwjmgZVHlYzFtLfAXEKiXkwfwBPCwnh6CdtPhBPKPOnIKaKTP8xCwQ38v0G4Ya6h/Nt+Eh3YGexza6A0C6IXWf3miRT5xRWynA9qZ7B8tvxuLdD89zgFoN50tI//IE++gXVlogHYFIpH8o444oo0MsRN4TH9vV0QseSNVPIvWuHkaK6OOoP1QebgU+63Q19dZ3/ecASeL9OVoXZDcgH6UbdQRez2/t9F+/DhzfUSdJnpeY/Xp71L8qCOPAk31953RGnsfWKTvRvvB6QyMoeRRR8r9fVVWXiV9l8AItGOps7787+QfdaTI76ak8kU7zmLQrj611MvzidKUZ0nbrF7qVRdfNg9AvdSrtr+w0pDUp1traGejXX7Ne13S03wp3NAW+j/BZ4paD9rwaavQhuYr1KBGu8S+soi4JdpNg5bxvKKnOaI10q2OBIHW0M7Rl0lDa7AvBFqVpnz0/N9Au6kwTW9kfAF4W8xzF1pjPA2tO8p3WIxUgkVD28o6LRvaA9HOgl/St+koFiOaAK8BYUXkM0gvp/QC5TTAYp4JaD8A0tBuxGxokeaE9gMhBa1f8fMF8g/X87d8BRezr3VHu8E0A21kme4F0vvqcZRm6EJfK+uOs0hviPYDI03fvglW8gjGekM71EreoRbpQ9DuY8jQy8DXIm0icNji8xK97NL0fel99B+fFtsRrud1hPw/RvO63FjuVxX5virzuy/pu3xeXy5FLwPLH0HFfjcllK9AG7Hosv56j/yjnxRZniVts3qpV118CSkliqIoZSGE6A88JaUcb+tYqpoQ4lfgWSlljK1jURRFUW4sqqGtKIqiKIqiKFVA3QypKIqiKIqiKFVANbQVRVEURVEUpQqohraiKIqiKIqiVAHV0FYURVEURVGUKqAa2oqiKIqiKIpSBVRDW1EURVEURVGqgGpoK4qiKIqiKEoVUA1tRVEURVEURakCqqGtKIqiKIqiKFVANbQVRVEURVEUpQqohraiKIqiKIqiVAHV0FYURVEURVGUKqAa2oqiKIqiKIpSBVRDW1EURVEURVGqgGpoK4qiKIqiKEoVUA3tMhJCLBJCvGbrOCwJIeKEEENsHYdSdkKIYCFEgq3jUCqHOhZrHlVnl6xgGQkhnhRCnBdCXBNCNNL/trVljKUhhDgshAguIi1fXVvcvDWNECJcCPGoreOwlar8PymEeEgIsaMq8s5Tqxva1iqzihaqlPIJKeVbFY/OOiGErxBCCiHsKyGvDXoFeU0IkSOEyLb4vKgy4q1uQoilQog51bg+1RCuYwrWG0KIcUKIK0KIQfrnCUKIb20XYe1V1+tsPT8vIcQqIcQlIUSyEOKgEOKhysi7KJZlJIRwAD4Ahkkp3aWUSfrff8qSZ1F1Z1U2GqWUflLK8LLOK4QIFUIsK+9663pDuKoIIV4RQvy7kvI6KoToUBl5lVWlVAx1hRDCIKXMtXUcpSWlvD3vvRBiKZAgpXzVdhEVTwhhL6U03ujrUGoPIcRktEbHSCnln/rkO4D1totKKa0brc7W/Q/YD/gAWUBXoHk1rr8Z4AwcrsZ1Koo1dwAzqGBbVQjRDrCTUh6tlKjKqFaf0S4NIcTN+q/Rq/qlpNEWaUuFEJ8JIdYLIdKAwZZnVIUQ6yzOEF8TQpjyzjwIIW4RQvyln5H4Swhxi0W+4UKIt4QQO4UQqUKIX4UQjfXkP/S/V/U8+woh2gkhfhdCJOlnOcKEEPUruN2jhBBR+nb/KYTwt0iLE0K8KIQ4IIRIE0J8KYRopp8hTxVCbBZCNNDnzTubM1UIcVYIkSiE+D+LvOyEEDOEECf0+L8XQjQssOwjQohTwO/69B+EEOf0svtDCOGnT58KTARe0stmnT5dCiHaF/je8r6jYCFEghDiZSHEOWBJcTEVKCM3YAPQ0uI7blnKbZoshDilf1+zLPJ00eO7IoSIBoIKrLOl0M5mXRRCnBRC/MsiLVRf1zf693BYCNHTIr21EGK1vmySEGKBEMJJCHFZCNHVYr6mQogMIUSTMuwydY6+v/0HGJ7XyBZC2AFDgY365weFEPF6ec8qsHwvIcQu/RhL1L8PRz3tUyHEfwrMv04IMb0aNu2GJmp/nR0ELJVSpkkpjVLKSCnlBj2Octe3enp/odX3V4UQpy22fakQYo7QzvgdsdievDrZXMfqddh/9P0+WQixQwjhUspty0dYuVpRYF1LhRALxfWrszuFEM2FEB/pdWisEKK7xbLmKyKi5Lo2TggxRAgxAngFCNHXsV8IcZ8QIqLA/P8nhPjRyjbMBQYAC/TlF+jTOwkhftPr3yNCiPstllmq1wG/6PvTHqE1BvPSh+rblqznJwqs82EhRIy+bZuEED4Fyu8JIcQxPf1TIYSwSH9MXzZVCBEthOghtP/3qwqs4xMhxEfWv7nKoa87Uo/lByHECnH9WG0AdAB2WVnuX3rsXvrnl/Rj4awQ4lFRoE0AjEQ/OSK0rlBrhRApQoi9QLsCeX+sHxspQogIIcQAfXpzIUS6EKKRxbyBQvt/61Dshkopa+0LiAOGFJj2ELBDf+8AHEc7yByBW4FUoKOevhRIBvqh/Shx1qfNsbKuEcBZoDXQELgCPIj2S2y8/rmRPm84cELfiVz0z+/oab6ABOwt8m6P9s/dCWiCVrF/VNx2WonPHDfQA7gA9AYMwGQ9DyeL/Hajndlopc/7N9Bdj+F3YHaBeL8D3NDOvlzMiweYruflpS/7X+C7Ast+oy/rok9/GPDQ5/8IiLK2HRbTJNC+iG0NBozAu3p+LsXFZKXcgtGuBFhOK802fa6vqxvaWamb9fR3gO1o+0hr4FBe/mj7WATwOtr+2Bb4B62hBxAKZKL9yjcAbwO79TQD2lmwD/WydAb662kLgXct4n8WWGfr47OmvvT9fxVwHuhWIK0PsEt/3xm4BgzU94MP9H0tb98P1Oe31/eLGGC6ntYLrb6w0z83BtKBZrbe/hpQ9nW6zgY2AzuBcYB3gbS8dZWnvvXWy2q8Xo6NgACLcptTzPaY61jgU337W6HVO7eg/+8oEGswBepOi7J8tOB3W8S6lgKX0I4lZ7T/PSeBSfq65wBbrZUrxdS1VuYNBZZZpDkBl9HrbX1aJDC2iO/MvE36ZzfgNDAFbX/qoW+Hn8V2XUarB+yBMGC5RV2QAtyrf0/PodUreWV2N9oxcLO+7KvAnwXK72egvv6dXwRG6Gn3AWfQfnQItP3UB2gBpAH19fns0f7vB1bhse4IxKP9P3IA7gGyub4fjuP6vmvel4DX0NojTSyO43OAH+CKdkWoYJtgI9f/jy4Hvte/oy56eeywmPcBtGPDHvg/PW9nPW098KTFvB8Cn5S4rVVViDXhpR9I14CrFq90rlfaA/RCtLNY5jsg1OJg+KZAnksp3NDroO+UA/TPDwJ7C8yzC3jI4qB81SJtGrBRf+9LgUrOynbdDUQW2M6yNLQ/A94qkH4EGGSR30SLtFXAZxafnwF+LBBvJ4v094Av9fcxwG0WaS2AHK43PiTQtpi46+vzeBZT/iU1tLPzDpSSYrKy/mAKN7RLs01eFul7gXH6+3/QKz3981SuVyC9gVMF1jUTWKK/DwU2W6R1BjL0933RKlRr29AbrdLPa9TtA+639fFZU1/6/p8C/IRF3aCnvQW8pr9/Hf2fo/7ZTd/XimpATQfWFNiPhurvnwbW23rbbf1C1dkADdAaiYeBXCAKCCqwrvLUtzMt97+iysja9uif26P9eMmgwA/QIvIMBkwFvsur5G80PkTJDe3PLdKeAWIsPncFrlorV4qpa63MG4pFQ1uf9hkwV3/vh/bDq9APCov9w7KhHQJsLzDPf7l+gmop8IVF2h1ArP5+EvoJFP2zABIsymwD8IhFuh3aMeJjUX79LdK/B2bo7zcBzxaxDRuAx/T3o4Doyjy2raxvIFojV1hM22GxH/4PeNBiXzqDdjJjB3p7QE/7Cnjb4nP7AvuQK5CE9kPNgHY8WB4//y64DxaI8wr6/q5/rzv19wa0uqhXSdtaF7qO3C2lrJ/3Qqsg87QETkspTRbT4tF+qec5XVzmQghPtH/Ir0kpt1vkG19g1oL5nrN4nw64F7OOpkKI5UKIM0KIFGAZ2q/e8vIB/k+/fHhVCHEV7Rd/S4t5zlu8z7DyuWC8luUUb5GXD7DGYj0xaP88mllbVghhEEK8I7RLnylolSFUbHsvSikzLT6XJqbilGb5or7flhQuK8t8Wxb4Xl4pIV9nod2E1RqIl1b6n0sp96CdrRgkhOiEVhGtLeW21lVPoDXGvrC87Er+/tn5vkspZRpahQ6AEKKDEOJnoXWDSkGr0C3346/Rzp6g//1fpW/FjalO19lSyitSyhlSSj+0Yz8K+LHAflie+rY12ln5imiM1mApbT5nLb9L/fss642tZf1flKe4urY0vgYm6OX+IPC9lDKrlMv6AL0L1OUTyd/XvlT/I6TWqrPcDh/gY4t8L6M1xkuzrxa3D1R3fdQSOKNvX57TULiLnq4+2o+lt6WUyQXysSyfgsf/bWhn/DPRri7ZU8x+oXcRitG77VwFPLl+7P4EdBbaCDxDgWQp5d6SNrQuNLSLcxZorX+pebzRfjnlkRRBX+5btEtX/y2Qr0+B2QvmWxRr63tbn+4vpayHdhAIK/OV1mm0X+qWFaCrlPK7CuTZ2uK9N1oZ5K3r9gLrcpZSFlXGE4C7gCFoO7ivPl1YmTdPOtqv1jwFbxwquExpYipq2bIuX1AihcvKMt+TBfL1kFLeUYp8TwPeouiRD/Iq0QeBlQV+eCiFXUCroAegdb1BCNEc7Qzh3/o8+b5LIYQr2iXHPJ8BscBN+nH7CvmP22XAXUKIbmiXgX+sig2pZepUnS2lvATMQ2tMWN5HUp769jQF+qOWwyW07msVzSdPGhZ1t36MVZbi6tqCCn2HUsrdaFeoBqD9Xyqu4Wntf8y2At+Du5TyybLGrTf0LbfjNPB4gbxd5PWbtYtT3D7wI+AvhOiCdkY7rBT5VUQi0KrAD8i87QwC4qSUFy3SruhxLRFC9CuQj5eVPPLcAfyiv7+IdkXF6n6h98d+GbgfaKD/MExGP3b1/5vfo/1oepBS/hip6w3tvDN9LwkhHIQ2puadaH14SmMu2uXiZwtMXw90ENowYPZCiBC0y/w/lyLPi2iX2yzHLPVAv5wqhGgFvFjK+IryOfCEEKK30LgJIUYKITwqkOdrQghXod24OAVYoU9fBMwV+s0aQogmQoi7isnHA61PcxJaBVxwaJ/z5C8b0M74TNDPho8ABpUQa1liOg800s+ClWf5gr4HZgohGug3cjxjkbYXSBHajZsu+vZ0EUIEWc8qn71oFc47+vfpXKAy+h8wBu0f/jeljLVOk1KeResDPEII8SFahb3R4gzMSmCU0G4wcwTeJH+d6oHWBeWafiUh3z9ZKWUC8Bfad7NKSplRpRtUO9T6OlsI8a5+3NvrdfKTwHEpZZLFbOWpb8OAIUKI+/W8GwkhAkobF4B+JeEr4AOh3bhtENrNn05lycfCfsBPCBEghHBG68JRWYqraws6D/gW+AEHWl25ADBKKYs7E1/w/9LPaPvTg/p+6iCECBJC3FyKuH9BK5N79BMn/yL/yaNF+nblDRLgKYS4rxT5AnwBvCC0m/iEEKJ93r6iNyJXov0Q3SulPFXKPMtrF9rVlqf1/fEutD7rYHHzoiWpDcc4Ee2qTW998vfAFKHdJO2K1qXP0u15eUltBKLVQKh+/HRGu0ctjwdaQ/wiYC+EeB2oVyC/b9C6PI1GO1lSojrd0JZSZqMV1u1ov9QXApOklLGlzGI82s1OV8T1u9gn6hXiKLSO9EnAS8Ao/exESTGlo/0z2KlfGuoDvIF2M0Uy2kG4uizbaWUd+4DH0CqQK2g3VjxUkTyBbXo+W4B5Uspf9ekfo3VT+FUIkYp2o05v61kA2k4cj3YmKVqf39KXaJdurorrd4A/i/bP9iraQfgjxSt1TPq+8B3wj77OluXYJktv6Nt3EvgVi1/EeiVwJxCgp19Cqxg9C+VSOM68ZdsDp9D69IVYpCegnYmVaDcIKaUgpTyN1ti+F61811ukHQaeQvvHlIh2LFmOG/wC2pmwVLQftyso7Gu0fqaq20gp1JE62xVYg1af/YN2pn10gXnKXN/qDac79G28jHaColsZ4srzAnAQ7UfiZbQbzcvVlpDacGtvot0AeoyydyspTpF1rRU/6H+ThBB/W0z/H9oNcyUdnx8D9wptlI/5UspUYBjaDX1n0bpy5N2QXyx9n7sPrZ9+EnAT2s2xeelr9LyWC61b0iG046FEUsof0PbVb9HqpR/Jf6Wk2uoj/Vi+B3gEbV9/AO0HShbFDKEqpfwN7cflWiFEoNRG5JkPbEU7JvJGKcnSz85fK/Cj4Wm0rjTn0PrKL7FI24TWV/0o2r6TSYGuKFLKnWg/rP+WUsaVZltF/u4xilI2QghftIrMwVr/YKXmEEJ8hdZnssaOpV5T6WeWzgHtCvQPrGi+A9HOivgW6HesKIWo+rZ6CW3YwgtADynlMVvHU9WEEN5o3d2aSylTbLD+PWg/SqcDLWU5Gqj6VYNDaD9qngcaSylfquQ4fwe+lVJ+UZr56/QZbUWpK/R/0PegXRFQyq4h2s1zldnIdkC7GvOFamQrSo30JPBXHWlk26E1TJdXVyNbCDFIaONT2wvt4WD+aFdhni9LI1sIMUYI4Si0sbffRRu+1og2mMKSYhcue8xBaFerrF2htEo9GVJRajkhxFtoY7G+LaU8aet4bkRSygtoNzdWCv2syz60PqpTKitfRVEqhxAiDu0muLttG0nVE9rD2c6jdZcYUY2r7ojWx9odbTSUe6WU28qRz+No3UBy0bpVTQOQUn5fOWFqhBBfo+0Pz+rdg0q3nOo6oiiKoiiKoiiVT3UdURRFURRFUZQqoBraiqIoiqIoilIFal0fbSHEncCdHh4ej3Xo0KFK15WWloabm1uVrqOmU2WgUeWgUeVQOWUQERFxSUrZpJJCqtHKW2fX5H1NxVY+KrbyUbGVX2XFV2ydLavwWfa2fAUGBsqqtnXr1ipfR02nykCjykGjyqFyygDYJ2tAPVqdr7LW2TV5X1OxlY+KrXxUbOVXWfEVV2erriOKoiiKoiiKUgVUQ1tRFEVRFEVRqoBqaCuKoiiKoihKFah1N0MqiqIoimI7OTk5JCQkkJmZWablPD09iYmJqaKoKkbFVj41OTYoe3zOzs54eXnh4OBQ6mVUQ1tRFEVRlEqTkJCAh4cHvr6+CCFKvVxqaioeHh5VGFn5qdjKpybHBmWLT0pJUlISCQkJtGnTptTrUF1HFEVRFEWpNJmZmTRq1KhMjWxFqemEEDRq1KjMV2pUQ1tRFEVRlEqlGtlKbVSe/Vo1tBVFURRFURSlCqiGtqIoiqIothMWBr6+uHt6gq+v9rkaxMXF0aVLFwCioqJYv359sfOHhoYyb968cq9v6dKlPP300+Vevizc3d2rZT1Q8XKpStbKYdGiRXTt2pWAgACGDRtGdHQ0APHx8QQGBhIQEICfnx+LFi2qlBhumIa2EGKEEOKIEOK4EGJGVawjLvU0gduXEp+aUBXZ1wjVvY21rUxr2/ZU1I1YHjdizDei6qizlbKZEbmEwUheifra1qFcFxYGU6dCfDxCSoiP1z5XU2M7T2ka2nWF0Wis1vXl5uZW6/omTJjAwYMHiYqKYvr06Tz//PMAtGjRgj///JOoqCj27NnDO++8w9mzZyu8vhuioS2EMACfArcDnYHxQojOlb2emTGbiMz15pWYjZWddY1R3dtY28q0urenuEZhRRqMZVk2b97jlyP5NWIkAzb9wqftX8RXxDHqp438bfQhYN9fldJwtRZXWWLNykrUYozYw7msLKvzVOZ3mJWVyLd7xuAevoG/LsflS6vLDfrqqrOV0gubtoN3r/qAhLevtCZs2o7qWfH06RAcXPTrkUcgPT3/Munp2vSilpk+vcTVzp07l44dOzJkyBDGjx9vPuMaERFBt27d6Nu3L59++ikA2dnZvP7666xYsYKAgABWrFhRZL7R0dEEBwfTtm1b5s+fb55+9913ExgYiJ+fH4sXLzZPX7JkCR06dGDQoEHs3LkTgOTkZHx9fTGZTPrmptO6dWtycnKKXO+2bdsICAggICCA7t27k5qaSnh4OAMHDmTChAl07tyZJ554wpwnwKxZs+jWrRt9+vTh/PnzAFy8eJGxY8cSFBREUFCQOabQ0FCmTp3KsGHDmDRpUpHzlbVcxo8fb7Vc3N3def311+nduze7du3C3d2dl19+mcDAQIYMGcLevXvN+a1duxbQbrKdMmUKXbt2pXv37mzdurXYmIpSr1498/u0tDRzv2tHR0ecnJwAyMrKyleWFXGjDO/XCzgupfwHQAixHLgLiK6sFcSlnmZ1emskdqxI9yV7z+e42Wm/Q3ydHejs0ZxRrfrx85mdRF+7TFxGGtdIZelfJ2jn4kQn96bc3rIf68/u5EBqEgmZ1yuOjq7OdHRvwm0tbmHT2T+JSLnI+azrd636ubnS0b0x/Zr1YkviHvYmXyAp53ojwd/NnU7uTejRuBvbzkew6+p5rhqzzemB7h509GjKzfU7sfPifnZcOU+q8foB29uzPp3cm+JgcGNluk+hbexXvwGdPFrQzLUlkZdj2ZyUSI7p+i/M4AaN6OjRgvpOjTlw9TibLiViklr6NVI5fSKVTh4tcbL34HDySX5NOouUJq6ZTKzJaIvEjh/Svfl3agIt3Vqy9vTvgMxX/h3dm9OlUVfSjTlsOBNe6Pvxq+dFpwY3k5KTwW9nC/+D6Fbfh/aeHUjKSiX83O5C6YEN2uFbry3nM66w48K+Qul9GnWklbs3CWkX2XMpqlB6/yZ+ZOTmsird27w9A4+uobGTdlnKBe37Pp6awP7LhcfkHNIsEE/nhsQmx3P46rFC6be3CMLV0ZPDV08Qm3zSPH1+Qjx/57bh8YPrWdhlCAeSE0jMSsMgs/j8XBJ/57ZlVOQWPr3pJho6NWB/8hmu5RpxFDmkZqdwLicXBwEjmnbG1d6ViOQEpIQliaeJzG3D6MjNhDSyp0s9L2acPMVoT3t+uAozWroiTRmcyzGx9koWkbm+PHnoVy7l3sZ+RxcOTx9Ou8u/s69VOxCCq7I+IXs2MsDexPk4bZ1n0s9yyShoYG9P30YdAfjjyhnchJF5p1Jp/ddVkk31cUvJ4dbmuazs4YxBQLTJm8kHNjK6vj1XTAZ+vZpDZK4vjx/cSL8Gzejq5oqUkuOpp7lissfLyZmu9X0xSVgb9yO7Mm9hN+nc/fcmbnW7io+zKzfX8yZHwoaLceZj4Pt0H+r//RUBHp60d29FljQRkXyJru4emEyZHEw5T7q0o72LB23cm3PNmEN0WjJ+bh6YctOITLlI0rUYVmSPIw1n7jq4n+eaR+PIWVLi03g1/iKHTFqDPqzXo4W+81quyutspfTCpu3gvVZHgLYgBEh4t/lRmAYTF/a3bXBF/CAucnopREREsHz5ciIjIzEajfTo0YPAwEAApkyZwieffMKgQYN48cUXAa2B9eabb7Jv3z4WLFhQbN6xsbFs3bqV1NRUOnbsyJNPPomDgwNfffUVDRs2JCMjg6CgIMaOHUt2djazZ88mIiICT09PBg8eTPfu3fH09KRbt25s27aNwYMHs27dOoYPH17s2Mzz5s3j008/pV+/fly7dg1nZ2cA9u7dy969e/Hz82PEiBGsXr2ae++9l7S0NPr06cPcuXN56aWX+Pzzz3n11Vd59tlnee655+jfvz+nTp1i+PDh5nGkIyIi2LFjBy4uLkyYMKHI+cpSLp9++ik+Pj75yqVRo0akpaXRpUsX3nzzTUBr8AYHB/Puu+8yZswYXn31VX777Teio6OZPHkyo0ePNv8wOnjwILGxsQwbNoyjR4+ay6IsPv30Uz744AOysrLyNdhPnz7NyJEjOX78OO+//z4tW7Ysc94F3SgN7VbAaYvPCUDvgjMJIaYCUwGaNWtGeHh4qVfwIfsxcTMAudizMuOm64lpQBKsivuFEJoCzfOnpYHdpVy+M6e3yJ95GrhfTOWTkxuYQhN9c/KnN71wgdn/bOQpmgFe+dOvgc/5Uzxz4gwv0BponS956TW4+dwxJnCS12gDeOdL/zoNenAQiQNGbiq0jV+nQX/2EogTH9MJ8C20/FB20AYXFtO5UPqq03AXm6mHB/+jM1B4fMlcDDwbsYpH6Ma9Vna7h/mZB0niPDmMo3Bl8xRruJfznCSVhyk85uWLrOIO+hJNEk/RqFD67JM/EExvIkjkhYLfD/Duye/pRU+2E8/r+BRKn39yBZuxw4QfADk48sRZR3P6gszjhIeHs4ZjzOemQsuHnVxJSzrwLUf4nI6F0tecXEN9fPmSWJbRySKlHQCbsjvQ7u9T+jQX/VUfgEMmHwYdyQbOox3S9oAzWJTTm0nXgGtAXsxavgdMvhy4CFwE8CbmipY69Qzm/PNsNvUG/YbrK13s2Efb64lCsMe+PXsA4vImWuyn55P1N3p/Ofv6nOx7Pf1P0H576b+/tuW0Z9vFfKtnU3Z7Np23nGKxnyWm6W+GmiftyarHniz9zMXZvB++Tc3pRhxYmNIWUgDyfvjW04oRF/Lv53n/9PPK1E1/XZ8nUXryUiJAeziZNw+sSm/N2PA1NKQBdUiV19nXrl0r0/zVqabF9q/PunD59+x80w4O8OVft3ai1f3hlb4+T09PUlNTtQ9vvVXsvG5+ftidPl1ouql1a9LWrSt6wbz8rfjtt9+44447yM3NRQjBiBEjyMrKIiEhgStXrtCjRw9SU1O55557+OWXX0hNTSUzM5Ps7OzrcReQm5tLVlYWQ4YMITs7GycnJxo3bsyJEydo1aoV77//Pj///DOgNdaioqK4cOEC/fr1w9nZmaysLO666y6OHz9Oamoqo0ePZtmyZfTs2ZNly5bx6KOPFrlugJ49e/Lss89y//33M3r0aFq1akV6ejqBgYF4e3uTnp7OmDFj+P333xk+fDiOjo4MGjSI1NRUOnfubG4E//bbbxw6dMicb3JyMmfPniUrK4vhw4djNBqLnc/amNPFlctnn33GL7/8kq9cevXqhcFgYNiwYeZtdnR0pF+/fqSmptKhQwecnJzIzMzE19eXuLg48xn8xx9/nNTUVFq1aoWXlxeRkZHmfvZFsVaukyZNYtKkSSxfvpzZs2fz3//+F4D69euzc+dOEhMTGT9+PCNGjKBp06b5ls3MzCzT8X2jNLStjaciC02QcjGwGKBnz54yODi4VJnHpZ5mY0QWRq43nAwYecYzgXr2DrRydqGtW3P6N72T3y5E8k96EmcyUkhKukijRk3wdnHDx7Up/fT0o2kXOZ95zZxXGxcPfFwbE9QkAK+LUcSkXuBSdpo5vb1rPbxdvejW0J8OSQc4lHKOKznXz4h3cKuPj2sHbq7fiW6Xo9mfkkhKToY5/Wb3hvi6BdDWox23XD1CxNUzXDNePxvQxaMRTnYduO+f/JdB8rZxQMOW+LoNoolzc0annmTX5dNkm66fEe/h2Rxft6F4OjUiJPUU25PizWe0k5Iucns7f3zdRuFk78HktDNsT4rjak4mC5Jbk6vvYiYMbKQTH/Rox6bUU4W+vjZuY7mpfgcyc41ssnJGur1HCG3rtaNnTiatrJyR7ugxHp96vgRkpdH+UmShdD/PCbRyb03XrGS6XjpYKL1bg4k0c23BzRmX6X258Em3ps638sLBc+btAXAgm6+8jTR1qkfusY7aZa60Toy8erzQ8rc0uR93x/p4p7ZnbMrJQumDmo7F2cGDlilteCBVa1C/F3eEbTm++jpN9LA7SR8PB07lehJ5LZMzNCGv91cjLvNaswz+yYJjOS5k5VwmMdtEDB0ACLQ7ypRmnhzLNPH9FUfO0QCZr+eYxPphVnMYMNLe7iIftG0F0sSupMOcy3WmuYOBju5NSbq8gQXXunKSNuTigB25dHS4Rki9ZNq7NeZcVjovn6+f7zs0YOT/6p8mwLMFmSZJTEYWg+rXx5ibzvbLp0k1OdDWxRkfl0akm3I5kZlDn3qe5OamsvHMdr7LuYUUPNHKTtKINF7hLD/Zww5jO0wYyEWwyjWJsF5jbFZ2NlCldTZAeHg4ZZm/OtW02FrOWcJlfLWz2WA+q93ijV8IDp5c6euLiYkp/UNK3n5b65Nt2X3E1RW7t98u94NOnJ2dcXZ2Ni+f1yXA3d0dOzs783Q3NzfzZ2dnZxwdHYtcZ2pqqjmPvHkcHBxwdnYmIiKC7du3s2fPHlxdXQkODsZgMODi4pIvT8t1hISE8Oabb5KTk8P+/fsZNWoUBoOhyG2aPXs299xzD+vXr2fIkCFs3rwZV1dX7O3tMRgM5m1wcnLCw8MDBwcHcxcJd3d3hBB4eHggpWTPnj24uLjky7/gthU1nzXFlcu2bdsKlUterPXr1zfnYRmvi4tLvvyMRiMeHh4YDAZcXV3N0w0GA25ubiXuJ8Wl33///bzwwguF5vHw8MDf35/IyEjuvffefGnOzs507969xHLJc6M0tBPIfxrXC6h4D3XdzJhNmAqcBRaYuJBj5MPuD+WbPqTlLeb34eHhBHcNLpQ+pJh1lSq9mCsVJaXf6tKXWwufsGX83i+K3MZ7fIaZp7V2b86tLfoWmb+ve6t86eHh4QS3DjZ/bl/Pm9ta9GX83i8Q5G/Y5yJ4LXZTsZfRnQ32DGtV9KVMdwfnYtPrO7kVm97IybPY9GYuDa2mWys/CWy4dJawXncQfiwcAG+35ni7NS+0fJ62Hl609fAqMr1DPR861PMhLvU0O3LSLRqFdhw2ebG6vR8SSceIaCxvsbiGG3d79cKnyLyDAe1H5WcR0fka2XYYsUNixIG8BreBHAJFDPukHyaKqPylvP6P24JBGhm1YS8e3c4Q1nIsUli/FcRO5mISRf9jcSQLCeSg9ZnLxZ44U0P8PNvi4+HFHRb7XVZWIutPP8opRpGrXxExYSAutz6PdxhBcycnfZ+sl28dAhMJ2bm822ZEofXfVfjCRr71JcW9zH+5nettSkESboAru41NzOVmxJFV6a35d2pCMd9PrVOldbZSNodusb4zHx7Q2ur0ajVxovZ31izkqVMIb2+YO/f69HIYOHAgDz30EDNmzMBoNLJu3Toef/xx6tevj6enJzt27KB///6EWdxw6eHhUewZ5eIkJyfToEEDXF1diY2NZfdu7WRR7969efbZZ0lKSqJevXr88MMPdOvWDdAav7169eLZZ5/N18jO67pScHSSEydO0LVrV7p27cquXbuIjY2lfv367N27l7i4OPz8/FixYgVTp04tNtZhw4axYMECc7eZqKgoAgICyj1fSeVSv379QuVSXgMHDiQsLIxbb72Vo0ePcurUKTp27MiZM2eYNGkSW7ZsKVU+x44d46abtCvPmzZtMr9PSEigUaNGuLi4cOXKFXbu3Gm+UbIiboibIYG/gJuEEG2EEI7AOGBtZWX+d4ZzvrPZoP1z3JdR9n4/NVV1b2NtK9Pq3h7tx1/+RmwugldiNhabVp58TRj0RjbkNRpzcWCf9ENQzN3gRQzcnyvsOXO7gbAHP6blCy1okpxMA9NlhMz/w8skDNjLbAzS+h3uOdhjLHAuoKjtjIt7i6VyfKFtM5qMvBUfD1TudxgX9xZzeMFq2mzql/v7qUWqtM5WykoUPl6FoMZcxZo4EeLiuJacDHFxFWpkA/To0YOQkBACAgIYO3YsAwYMMKctWbKEp556ir59++Y7Wzt48GCio6NLvBnSmhEjRmA0GvH39+e1116jT58+gDaKRWhoKH379mXIkCH06NEj33IhISEsW7aMkJAQ87TY2FgaNSrc/fGjjz6iS5cudOvWDRcXF26//XYA+vbtS2hoKF26dKFNmzaMGVP8lbP58+ezb98+/P396dy5c5FD2JV2vuIUVS7lNW3aNHJzc+natSshISEsXboUJycnEhMTsbe3ft44PT0dLy8v8+uDDz5gwYIF+Pn5ERAQwIIFC/j6a20UnpiYGHr37k23bt0YNGgQL7zwAl27dq1QzABCykJX82okIcQdwEeAAfhKSjm3uPl79uwp9+0r3MWgMtW0y4O2oMpAU9nl0HHbMo7Kwmc/OwhtBIui0o4MeqBc+Vpnory/xR1lFq6PdOLKP9rZ+Y4R0WTrZ6YtCb0LkizmzHZB1rbzr7+6MyFtGset9I8PcHMjMiiojFtQvL/+6k7/tLfJxloj3Xq5leb7ySOEiJBS9qxYlLZV1XV2Ta57alpsYutW6z+MpUQOHlzp64uJieHmm28u83Kpqanl7i5SnNDQUNzd3XnhBes/jkujqmIraNSoUaxevRpHR8cS5w0PD2fevHl899131RJbeVRHuS1YsABvb29Gjx5d5mXLE5+1/bu4OvtG6TqClHI9oAa5VOqE0jbIKppv8Q1vO3Pj0Nc+AfelGzjcqr3+D1vSyHiJJEMjrJ0ty0XQ7tX1wJNWu2blKaqBXZZGKUBQUCSFx3KpOkFBkRQ1JkJNa2TZiqqzFaXs8m6oVEqvuh4CVF43TENbUZTKV9rGbIpPLqdbtbFoUAuS7Jtob61cFcsVjlz11kbdsNZlA8remFYUpXwEuUgr/+6L7RpWi4SGhpZp/iVLlvDxxx/nmxYUFMTnn39eiVFVXHBwMMHBweXuW15W1sqlX79+5mH3FOtUQ1tRlBJ5v7Ge/fmGHeT6zZBWLkm3M57i+JBJQNWdnVcUpXRcZTppop7V6UphU6ZMYcqUKfmmVVdjtiazVi5KyW6UmyEVRbGhk61aFnEzlU5KkBK/08dY9r29uZGtKIqiKHWZamgrilKi5nYlnM3Rz2zHeLXhhY3Nqu/xzoqiKIpSg6mGtqIoJToy6AFkcDAyOJgOpvgi5zNhoMG/w5m12Lf6glMUpVhF/aNXDQBFqXrqOFMUpUyO3Dq56Ma2EMQ0a0eyt8l6uqIo1c4jx/oVqaKmK4pSeVRDW1GUMjty62RkcDD+CbFWRh0ReP1bjeqmKDVFk4sphY9TKWl6IcU2ARUQFga+vuDp6Y6vr/a5OsTFxdGlSxdAe/Lh+vXF11uhoaHMmzev3OtbunSpzYeiCw8P588//6zUPIODg8kbA/+OO+7g6tWrgPbQm549ezJx4kSysrIYMmRIiQ8EslbGmZmZ9OrVi27duuHn58fs2bPNaa+99hr+/v4EBAQwbNgwzp6teQ+gVQ1tRVHKLC71NF1//YITLa3fJHmkWRvbBKYoSiH/FHGcnmjV0jYBWQgLg6lTIT4epBTEx2ufq6uxnac0De3aoDwNbaPR+tN7rVm/fj3169cHYOHChaxcuZKwsDAiIyPJyckhKioq35MwS8PJyYnff/+d/fv3ExUVxcaNG82Pc3/xxRc5cOAAUVFRjBo1ijfffLNMeVcH1dBWFKXMZsZs4rBDWzKFi9V0o3AgPjWhmqNSFMWaekV0ESlqemWaPh2Cg4t+PfIIpBcYZTA9XZte1DLTp5e83rlz59KxY0eGDBnC+PHjzWdJIyIi6NatG3379jWP/5ydnc3rr7/OihUrSjzjGh0dTXBwMG3btmX+/Pnm6XfffTeBgYH4+fmxePFi8/QlS5bQoUMHBg0axM6dOwFITk7G19cXk8mkb286rVu3Jicnp8j1Xrt2jSlTptC1a1f8/f1ZtWoVAL/++iu33XYbPXr04L777uPatWsA+Pr6Mnv2bHr06EHXrl2JjY0lLi6ORYsW8eGHHxIQEMD27du5ePEiY8eOJSgoiKCgIHOMoaGhTJ06lWHDhjFpUv5RpDIyMhg3bhz+/v6EhISQkZFhTvP19eXSpUs88cQT/PPPP4wbN453332XBx54gKioKAICAjhx4kQJ315+Qgjc3d0ByMnJIScnB6H/cKxX7/qwlWlpaebpNUmtG0dbCHEncGf79u1tHYqi1EpxqadZle6NFHbkSkHrjHgSnVtgFNcfSmPAyCsxGwnr9agNI1VuBKrOrnoNz2Rwrk02uZbHqMym0ZlMG0alySriEatFTS+NiIgIli9fTmRkJEajkR49ehAYGAhoY0F/8sknDBo0iBdffBEAR0dH3nzzTfbt28eCBQuKzTs2NpatW7eSmppKx44defLJJ3FwcOCrr76iYcOGZGRkEBQUxNixY8nOzmb27NlERETg6enJ4MGD6d69O56ennTr1o1t27YxePBg1q1bx/Dhw3FwcChyvW+99Raenp4cPHgQgCtXrnDp0iXmzJnD2rVrad68Oe+++y4ffPABr7/+OgCNGzfm77//ZuHChcybN48vvviCJ554It/j6CdMmMBzzz1H//79OXXqFMOHDycmJsZcjjt27MDFJf8Jlc8++wxXV1cOHDjAgQMH6NGjR6F4Fy1axMaNG/nll1/w9fWld+/ezJs3r9xPvszNzSUwMJDjx4/z1FNP0bt3b3ParFmz+Oabb/D09GTr1q3lyr8q1bqGtpRyHbCuZ8+ej9k6FkWpbcKm7eDDoINI3/agnzg459w8XyMbwIgj+zKcbRChcqNRdXbVS27pnK+RDfrTW1s6Vfm6P/qo+HRfX63bSEE+PhAeXr51bt++nTFjxuDq6grA6NGjAe1M8tWrVxk0aBAADz74IBs2bChT3iNHjsTJyQknJyeaNm3K+fPn8fLyYv78+axZswaA06dPc+zYMc6dO0dwcDBNmmhP0Q0JCeHo0aPm9ytWrGDw4MEsX76cadOmFbvezZs3s3z5cvPnBg0a8PPPPxMdHc2wYcOws7MjOzubvn37mue55557AAgMDGT16tVF5hsdHW3+nJKSYn44z+jRows1sgH++OMP/vWvfwHg7++Pv79/8YVWCQwGA1FRUVy9epUxY8Zw6NAhc//6uXPnMnfuXN5++20WLFjAG2+8UeXxlIXqOqIoSqmETdvBC5uactC3LUahn3kRghwcaflaPRgcjOvgIJZ9b48MDlZPhFSUGmL4B244yPyniB1kFiP+426jiK6bOxf09rCZq6s2vSKsdSGQUla4a4GT0/UfJwaDAaPRSHh4OJs3b2bXrl3s37+f7t27k5mZWWQcoDViN2zYwOXLl4mIiODWW28tdr3WYpdSMnToUHbu3ElUVBTR0dF8+eWXhWLNi9Mak8nErl27iIqKIioqijNnzuDh4QGAm5sbAGvWrCEgIICAgADzTY+26qJRv359goOD2bhxY6G0CRMmmLvU1CSqoa0oSqnMWuxLk1l/YMJKBftqDD6GBGbf9QsTF/av/uAURSnS3+PPYyxwAduIPRHjz9koousmToTFi7Uz2EJIfHy0zxMnlj/PgQMHsmbNGjIyMkhNTWXdunWA1kjz9PRkxw7tgVphFndcenh4lPsx68nJyTRo0ABXV1diY2PNN+r17t2b8PBwkpKSyMnJ4YcffjAv4+7uTq9evXj22WcZNWoUBoMBgAULFljtvjJs2LB8069cuUKfPn3YuXOnuc9zenq6+Yx5UQpuZ8F8o6KiCi0zZswYc0O8Z8+eDBw40Fx2hw4d4sCBAyUVUSEzZ840XwEoycWLF80jmWRkZLB582Y6deoEwLFjx8zzrV271jy9JlENbUVRipSVlcivESMZELEH4+BETvo2K9RNBCFIdGrBtivQa3pT2wSqKEqRElvWQwpDvmlSGEhsVa+IJarXxIkQFwfJydeIi6tYIxugR48ehISEEBAQwNixYxkwYIA5bcmSJTz11FP07ds3X7eIwYMHEx0dXeLNkNaMGDECo9GIv78/r732Gn369AGgRYsWhIaG0rdvX4YMGVKoL3NISAjLli3LNwpHbGwsjRo1KrSOV199lStXrtClSxe6devG1q1badKkCUuXLuXhhx/G39+fPn36EBsbW2ysd955p/kM9fbt25k/fz779u3D39+fzp07s2jRohK398knn+TatWv4+/vz3nvv0atXr9IUUz4HDx6kefPmVtPmzJmDl5eX+ZWYmMjgwYPx9/cnKCiIoUOHMmrUKABmzJhBly5d8Pf359dff+Xjjz8ucyxVTchCY+DWDj179pR5lziqSnh4OMHBwVW6jppOlYGmtpbDkSPTmJbYiN+5FZA4yhyaZF3ivFOTfA1ue7K53/UUj6W3r5XlUBaVsS8IISKklD0rJ6IbQ1nr7Jp8zNW02Hou+Yz9vu3yH7Mym24nT7Dv4ScrfX0xMTHcfPPNZV4uNTXV3G2hMoWGhua7AbA8qiq2gkaNGsXq1atxdHQseWZddcVWHkXFNnz4cDZt2mSDiPIrT9lZ27+Lq7PVGW1FUazKykrk98Q/9Ua2QJjA8EwX7JDq5kdFuYFcbe1W+JgVjlz1drNRREpRfv755zI1sm9UNaGRXV1q3agjiqJUjt1H32AmswETYMBOSjo/eIxLo4IRuS3xNpxl7tS4fH2yw8s7TICiKFXm+JBJ3PHTx/xa72ZyhSMGmc3w5Bh+uftZW4dWLUJDQ8s0/5IlSwp1QQgKCuLzzz+vxKiUukI1tBVFKeS7539kyagGJNvVJ28cv1yDgei+gn/SmtDcyQ7w0l+KotRkcamn2VKvk3mIv1zhyGbPTsSnJuDjoY7hgqZMmcKUKVPyTSvvjZKKorqOKIqST9i0Hex2/5ktYggUGGHEaDLylrVBbxVFqbGm/b6a3ALHci6CaVtq3lBoilLbqIa2oij5vLLYl6P9GmMShauHHAz8mZxsg6gURSmvw04NrT6w5pBzQxtFpCh1h+o6oiiKWeT/DpHiU4/fHQdjeTbbUWbh+sjNXPnH23bBKYpSLqlPDcTxi1iyxfWHrTjKLFKmDYJ/bBiYotQB6oy2oigk/p3Iw+3/IHBSZ1rP2lTooTS5CNq9+ouNolMUpSLavrq+0DFtUse0olQL1dBWlDos43IGc4ds5aZAD5ad6MP/9dpBmrdToaHActVQYIpyw7oRhvfLykrkyJHbycqqvqdVxsXF0aVLF0B7IuL69euLnT80NJR58+aVe31Lly7l6aefLvfyZeHu7l4t64GKl0tVslYOzz33nPmR8t27d6d+/fqAtg/07dsXPz8//P39y/zgoqKohrai1EHSJFn+7C46NU3i1S2DGdbyENFbzhG6oydr/X34YVsknd83mud3lFls6X2rDSNWFKW8jg+ZxKebkhEyF9CO54WbUjg+ZJKNI7suLu4trl3bRXz8WzZZf2ka2nWF0WgseaZKlJubW63r+/DDD82PlH/88ce55557AHB1deWbb77h8OHDbNy4kenTp5sf/V4Rta6hLYS4UwixOFndsKUogDaKiK99AnbChK99Am/cGk6/+ocYP78vnvVSePd/39J8XQz3O/xOg507mBz9F74jw/CfHYcdWoVrEoJXYjbaeEuU2kjV2dXj5z5xGNAaNCYEP/c+WW3rjowMLvQ6c2YhALm56URE9CUx8b+AibNnFxERcQuJiUsByM6+VGjZ0pg7dy4dO3ZkyJAhjB8/3nzGNSIigm7dutG3b18+/fRTfR3ZvP7666xYsaLER7BHR0cTHBxM27ZtmT9/vnn63XffTWBgIH5+fixevNg8fcmSJXTo0IFBgwaxc+dOAJKTk/H19cVkMgGQnp5O69atycnJKXK927Zty3cWNjU1lfDwcAYOHMiECRPo3LkzTzzxhDlPgFmzZtGtWzf69OnD+fPnAbh48SJjx44lKCiIoKAgc0yhoaFMnTqVYcOGMWnSpCLnK2u5jB8/3mq5uLu78/rrr9O7d2927dqFu7s7L7/8MoGBgQwZMoS9e/ea81u7di0AmZmZTJkyha5du9K9e3e2bt1abEylsXLlSsaPHw9Ahw4duOmmmwBo2bIlTZs25eLFixVeR61raEsp10kpp3p6eto6FEWxubBpO5j6WXfic72Q2JHU0p4fWl/D7+7lfPHgNppsyeZlr5b8N8WbLGngQfcEXvDpTIN2S1id3hqTfr+0EUdWpbcmPjXBxluk1Daqzq56C2f+xJZ6nczdR4z6ONqfzVxr48g0WVnxgNQ/Sf1z+UVERLB8+XIiIyNZvXo1f/31lzltypQpzJ8/n127dpmnOTo68uabbxISEkJUVBQhISFF5h0bG8umTZvYu3cvb7zxhrlx/NVXXxEREcG+ffuYP38+SUlJJCYmMnv2bHbu3Mlvv/1GdHQ0AJ6ennTr1o1t27YBsG7dOoYPH46Dg0OR6503bx6ffvopUVFRbN++HRcXFwD27t3L3LlzOXjwICdOnGD16tUApKWl0adPH/bv38/AgQPND9t59tlnee655/jrr79YtWoVjz76aL5y++mnn/j222+Lna8s5fLpp58WKpe8+Lp06cKePXvo378/aWlpBAcHExERgYeHB6+++iq//fYba9as4fXXXzfnBXDw4EG+++47Jk+eTGZmZrFxFSc+Pp74+HhuvbXw1dq9e/eSnZ1Nu3btyp1/HjXqiKLUAnGppxkbtYXVAUPyPYDi5VVeeD4URdtBR7jU0pVzjs2JwYW3sj9j1ODnaXvNjv/LduWW+s2o73S9oTN+7xeYyD/CSC7aWe2wXsVXuIqi1CxfdTiLifwNBhOCL286w5PVsP7u3cOLTDMakzEar2DZ0DYar9Cw4QgAHB0bF7u8Ndu3b2fMmDG4uroCMHr0aEA7k3z16lUGDRoEwIMPPsiGDRvKlPfIkSNxcnLCycmJpk2bcv78eby8vJg/fz5r1qwB4PTp0xw7doxz584RHBxMkyZNAAgJCeHo0aPm9ytWrGDw4MEsX76cadOmFbvefv368fzzzzNx4kTuuecevLy0er5Xr160adMGg8HA+PHj2bFjB/feey+Ojo6MGjUKgMDAQH777TcANm/ebG7wA6SkpJgfxjN69GhzA76o+Tw8PMpULosWLTJ3yckrl0aNGmEwGBg7dqx5eUdHR0aM0L7zrl274uTkhIODA127diUuLg6AHTt28MwzzwDQqVMnfHx8OHr0KP7+/sWWXVGWL1/OXXfdhcFgyDc9MTGRBx98kK+//ho7u4qfj1YNbUWpBWbGbCIyty1PHtrIQE9PBsjf6d7mOc4McIHJOaTIprS+eo7mkfGk7GhLyG8JZGe6MrgBQINC+f2d4YyRAjdP4ci+DOfq2SBFUSrNhRYeVm+GvNDSeqOpOsXFvYWUpnzTpMwlPv4tOnT4tNz5CiEKTZNSWp1eFk5O14dINBgMGI1GwsPD2bx5M7t27cLV1ZXg4GDzmdai1jd69GhmzpzJ5cuXiYiIsHpW1dKMGTMYOXIk69evp0+fPmzevNlq/nmfHRwczO/z4gQwmUzs2rXL3KC25OZ2/ebY4uazpqhyCQ8Pt1ouzs7O+Rq4lvHa2dmZ87OzszPHLqWkMi1fvpz3338/37SUlBRGjhzJnDlz6NOnT6Wsp9Z1HVGUuiYu9TQ/pPsisWNDVntmXmhC+OXTZGT8g1d4LvZT/UkfOpzYex4lasZk/vl5AC2Nl4vN88igB5DBwYVeRwY9UE1bpShKZbEbFUz9R9oh9Aato8zC8+H22I0Ktm1gQErKLqTMzjdNymySk/8sd54DBw5kzZo1ZGRkkJqayrp16wCoX78+np6e7NixA4CwsDDzMh4eHuV+zHpycjINGjTA1dWV2NhYdu/eDUDv3r0JDw8nKSmJnJwcfvjhB/My7u7u9OrVi2effZZRo0aZG50LFixgwYIFhdZx4sQJunbtyssvv0zPnj2JjY0FtC4OcXFxmEwmVqxYQf/+/YuNddiwYfnyj4qKqtB8xUlOTqZ+/fqFyqW8Bg4caP7Ojh49yqlTp+jYsSNnzpzhtttuK1NeR44c4cqVK/Tq1cs8LTs7mzFjxjBp0iTuu+++CsVqSTW0FeUGNzNmEyb9UDZgZKTTUWb2W0ujRiN4rPspjMcaInOv9/1zJY25U+NsFK2iKNVt7tQ4fGZtMHfOMCHwfXV9jagHgoIiCQ6WBAdLAgNTzO+DgiLLnWePHj0ICQkhICCAsWPHMmDAAHPakiVLeOqpp+jbt2++s7WDBw8mOjq6xJshrRkxYgRGoxF/f39ee+0185nQFi1aEBoaSt++fRkyZAg9evTIt1xISAjLli3L1yc8NjaWRo0aFVrHRx99RJcuXejWrRsuLi7cfvvtAPTt25fQ0FC6dOlCmzZtGDNmTLGxzp8/n3379uHv70/nzp1ZtGhRheYrTlHlUl7Tpk0jNzeXrl27EhISwtKlS3FyciIxMRF7e+sdNNLT0/Hy8jK/PvjgAwC+++47xo0bl++KwPfff88ff/zB0qVLzTeelucHRkGisk/F1xQ9e/aU+/btq9J1hIeHExwcXKXrqOlUGWhsVQ5xqafpGBFNNtcv2zmRxZFAP7zdWtGvQTSHU7zwNFwjIbcF3oazzJ0ax8SFxZ/1KC+1P1ROGQghIqSUPSsnohtDWevsmryv1bTY4lJP03FfdKEnQx7t6Zfvno7KEhMTw80331zm5YrrA1wRoaGhuLu788ILL5Q7j6qKraBRo0axevVqHB0dS5w3PDycefPm8d1331VLbOVRHeW2YMECvL29zX3xy6I88Vnbv4urs1UfbUW5gWlns63ftDjqu67sSunNFxO38siywXqql/5SFKWumBmzCZPIX0/kDdmpbm6uWX7++Wdbh3DDqa6HAJWXamgryg2suJsWt3/iRXfnGB76ckARSyuKUhfU9ZubQ0NDyzT/kiVL+Pjjj/NNCwoKMg+RV1MEBwcTHBxc7r7lZWWtXPr162cedk+xTjW0FeUGZnlzYs9tnxJh6kzgyVgiHnkCEEzucwSDU9kv4SqKUnscGfQAYdN28F7PGA62aUePk0d4bl9XJi5UNzdbM2XKFKZMmZJvWnU1Zmsya+WilEzdDKkotUBc6mmiTB1BCA60aYdnmzMAfLCzN2HTdtg4OkVRbCls2g5e2NSUQ23aIoUdB9u05YWNzVTdoCjVQDW0FaUWmBmzibwHPuTgQLP//ApAOm7MWuxru8AURbG5WYt9aTLrD0xoIyyYEDR9dZuqGxSlGqiGtqLc4OJST7M6vTW5Qh/CTwiONmiL6wvaCA6nclvaMDpFUWwtxSeXI21ag9D+5RuFI7FtWpPsbSphSUVRKko1tBXlBqeNPFLg6WAyl0ZBx7Gzy6Vr4yjbBKYoSo3Q9tX1heoIE4J2r/5io4gUpe6odQ1tIcSdQojFycnJtg5FUaqFtREFpDBAPSNTHnid28PeZFX8ZhtFpyjFU3V21bva2s3qI9iversVsUT1S8zK4vYjRziXlVVt64yLi6NLly6A9uTD9evXFzt/aGgo8+bNK/f6li5davOh6MLDw/nzz/I/ddOa4OBg8sbAv+OOO7h69SqgPfSmZ8+eTJw4kaysLIYMGVLiA4GslfGRI0fMD5AJCAigXr16fPTRRwC8+OKLdOrUCX9/f8aMGWNed01S6xraUsp1Usqpnp6etg5FUaqF5ePSZ83IgcHBiMEDsRsVzG3NO7PWeQz3nbTj2cglGE1G4lJPE7h9KfGpCbYOXVFUnV0Njg+ZxLLv7emScIyGuUnc/Jg7y7635/iQSbYOzeytuDh2XbvGW/HxNll/aRratUF5GtpGo7HU865fv5769esDsHDhQlauXElYWBiRkZHk5OQQFRWV70mYpdGxY0eioqKIiooiIiICV1dX8xMwhw4dyqFDhzhw4AAdOnTg7bffLlPe1aHWNbQVpS7r7Kcd0tFbLxBn9GL8uxPZ02cMdzn/w/zkNvT/8xueO7yRyFxvXonZaONoFUWpLhMX9sctN4srdg3oHhZVZU+HtSY4MrLQa+EZbWSk9Nxc+kZE8N/EREzAorNnuSUigqWJiQBcys4utGxpzJ07l44dOzJkyBDGjx9vPksaERFBt27d6Nu3r3n85+zsbF5//XVWrFhR4hnX6OhogoODadu2LfPnzzdPv/vuuwkMDMTPz4/Fixebpy9ZsoQOHTowaNAgdu7cCUBycjK+vr6YTFof+fT0dFq3bk1OTk6R67127RpTpkyha9eu+Pv7s2rVKgB+/fVXbrvtNnr06MF9993HtWvXAPD19WX27Nn06NGDrl27EhsbS1xcHIsWLeLDDz8kICCA7du3c/HiRcaOHUtQUBBBQUHmGENDQ5k6dSrDhg1j0qT8P8gyMjIYN24c/v7+hISEkJGRYU7z9fXl0qVLPPHEE/zzzz+MGzeOd999lwceeICoqCgCAgI4ceJECd9e0bZs2UK7du3w8fEBYNiwYebHr/fp04eEhJp3AkmNo60otciZOK2ibtmtiXmah2M9Vvd+hA9iVzLzfCtyjI6AYFV6a/6dmlAlj2BWFKVmiUs9TaT3TUhhV+OO/fisLH3MJG3spPgKdh+JiIhg+fLlREZGYjQa6dGjB4GBgYA2FvQnn3zCoEGDePHFFwFwdHTkzTffZN++fSxYsKDYvGNjY9m6dSupqal07NiRJ598EgcHB7766isaNmxIRkYGQUFBjB07luzsbGbPnk1ERASenp4MHjyY7t274+npSbdu3di2bRuDBw9m3bp1DB8+HAcHhyLX+9Zbb+Hp6cnBgwcBuHLlCpcuXWLOnDmsXbuW5s2b8+677/LBBx/w+uuvA9C4cWP+/vtvFi5cyLx58/jiiy944okn8j2OfsKECTz33HP079+fU6dOMXz4cGJiYszluGPHDlxcXPLF8tlnn+Hq6sqBAwc4cOAAPXr0KBTvokWL2LhxI7/88gu+vr707t2befPmVfjJl8uXL2f8+PFW07766qsyny2vDqqhrSi1yJlEO9zFNeo1cM833Wgy0tc1k0H25/jdeDMm7M2PalePYFaU2m9mzCZyaANQ7cd+ePfuRaYlG41cMRrzNbSvGI2MaNgQgMaOjsUub8327dsZM2YMrq6uAIwePVpbV3IyV69eZdCgQQA8+OCDbNiwoUx5jxw5EicnJ5ycnGjatCnnz5/Hy8uL+fPns2bNGgBOnz7NsWPHOHfuHMHBwTRpop34CAkJ4ejRo+b3K1asYPDgwSxfvpxp06YVu97NmzezfPly8+cGDRrw888/Ex0dzbBhw7CzsyM7O5u+ffua57nnnnsACAwMZPXq1UXmGx0dbf6ckpJifjjP6NGjCzWyAf744w/+9a9/AeDv74+/v3/xhVZJsrOzWbt2rdXuIXPnzsXe3p6JEydWSyxloRrailKLnLnkRCunJEBraJtMuXzzzzrePJNOsnTlGk0x6Ye9Eccad2ZLUZTKlzcEqBQGoGYd+2/FxWGSMt+0XCl5Kz6eTzt0KHe+QohC06SUVqeXhZOTk/m9wWDAaDQSHh7O5s2b2bVrF66urgQHB5OZmVlkHKA1YmfOnMnly5eJiIjg1ltvLXa91mKXUjJ06FAWL16Mh4dHkbHmxWmNyWRi165dVhvUbm7azbJr1qzhjTfeAOCLL74odruq0oYNG+jRowfNmjXLN/3rr7/m559/ZsuWLTaJqySqj7ai1BJh03aw9mJvjmR642ufwOsfLsV/xzKmJNRHYkdH++RCQ3zlndlSFKX2mhmzCZMscOzLmnHs70pJIbtAQztbSv6swCg0AwcOZM2aNWRkZJCamsq6desAqF+/Pp6enuzYoT0RMywszLyMh4dHuR+znpycTIMGDXB1dSU2Npbdu3cD0Lt3b8LDw0lKSiInJ4cffvjBvIy7uzu9evXi2WefZdSoURgM2o+gBQsWWO2+MmzYsHzTr1y5Qp8+fdi5c6e5z3N6err5jHlRCm5nwXyjoqIKLTNmzBjzzYg9e/Zk4MCB5rLLuxGxrGbOnGm+AlBa3333XaFuIxs3buTdd99l7dq15isYNY1qaCtKLRA2bQdTP+tONs7Y2eUSf7MHb3X35YLRjQ+aX+bogHtJynUsNAygEUf2ZTjbKGpFUarDXymOVof325PiWMQS1ScyKMg8alJKYKD5fWRQULnz7NGjByEhIQQEBDB27FgGDBhgTluyZAlPPfUUffv2zXcWd/DgwURHR5d4M6Q1I0aMwGg04u/vz2uvvUafPn0AaNGiBaGhofTt25chQ4YU6sscEhLCsmXL8vUrjo2NpVGjRoXW8eqrr3LlyhW6dOlCt27d2Lp1K02aNGHp0qU8/PDD+Pv706dPH2JjY4uN9c4772TNmjXmmyHnz5/Pvn378Pf3p3PnzixatKjE7X3yySe5du0a/v7+vPfee/Tq1as0xZTPwYMHad68udW0OXPm4OXlZX6B9iPit99+M3eHyfP000+TmprK0KFDCQgI4IknnihzLFVOSlkrX4GBgbKqbd26tcrXUdOpMtDYuhx8DKdlm+BdcuIX/5KPP/6iBJNkSKL0dTtRrXHYuhxqgsooA2CfrAH1aHW+ylpn1+R9rabF5mM4LUHK9quWyrYbl0iQErTpVSE6Orpcy6WkpFRyJJrZs2fL999/v0J5VFVsBY0cOVJmZWWVaZnqiq08iopt2LBh1RyJdeUpO2v7d3F1tuqjrSg3uMNJUTQI+5MDzTpy1TSIfuvPAwI2Nyce9YhlRanrTuW2BMDpHwOO9dMKTVdqjoqOynGj2LRpk61DqDaqoa0oN5i41NOMjdrC4i7BLIjbx7JkT+yatqPjgUROzh3JzxcamOetRypZl+1xalhzngCnKEr18jacJT7XizOfDaLRx1vwbJNA8kkvvA1ngdp/I3RoaGiZ5l+yZAkff/xxvmlBQUF8/vnnlRiVUleoPtqKcoOZcfhnInO9efXIH4SlNOZe93PM22Qi/tkxZFo0sg0YScYT/2bn2DL7D+1qsaIodc7cqXG4kkbrWZv4x80bn1c34koac6fGVdk65Q1c30yZMsV881/e64MPPrB1WEoNUJ79utob2kKI1kKIrUKIGCHEYSHEs/r0hkKI34QQx/S/DSyWmSmEOC6EOCKEGF7dMStKTfFP8nHWZLZFYsdvmS35sFUuYT0m8sw7t7P4yUh8DAkITPgYEvj6yd1s+s8hcu0cGPLmQCa2+J1zfxR/R7qiWKPq7RvbxIX9eX/GZg63aYMUdsS2ac28GVuq7OmQzs7OJCUl3dCNbUUpSEpJUlISzs5lG0DAFl1HjMD/SSn/FkJ4ABFCiN+Ah4AtUsp3hBAzgBnAy0KIzsA4wA9oCWwWQnSQUubaIHZFsalZR7ZiwheAXAw8nSCYk7CGkBY38dwHPYlbmFcBeJF3SfjgY0beCfmLdzb055dBGbx92yqm/jAUQ4N6NtkG5Yak6u0b3PYxF5Fp+vj6QrBjzAWerKJ1eXl5kZCQwMWLF8u0XGZmZpkbMdVFxVY+NTk2KHt8zs7O5pFQSqvaG9pSykQgUX+fKoSIAVoBdwHB+mxfA+HAy/r05VLKLOCkEOI40AvYVb2RK4ptaQ+d8MZI3mN6Bfbk0MY+nc/OXeFxr1z++ecVDmUInD2HcFuL/hgMDrh42PPG+iAm7LrMtHvPM23LWJY2+5tFs8/R/ZXboQYO8K/ULKrevrFV9wNrHBwcaNOmTZmXCw8Pp3sZnwJZXVRs5VOTY4PqiU/Y8tKOEMIX+APoApySUta3SLsipWwghFgA7JZSLtOnfwlskFKutJLfVGAqQLNmzQItH1daFa5du4a7u3vJM9Ziqgw01VEOH7Kf9dycbyxse7IZSQyP0Q3tdsf3mUsPNnMbTbnIQOIJph430wE7tG7aO78xMv9/ASTlNuCJRmHcFyqhi0+lxKj2h8opg8GDB0dIKXtWUkiVqjLr7YrU2TV5X6tpsRVXd0ynmw0jy6+mlZslFVv51OTYoPLiK67OttmoI0IId2AVMF1KmVLMYzOtJVj9dSClXAwsBujZs6cMDg6uhEiLFh4eTlWvo6ZTZaCpjnJ4fFsCRln4gTMxohEjB+WtOxj/rGS+i/+DlZfS+Sm7GytxYICnJ9sCupGU9DMDvxjCU/OceWXsET7b9gA/PXOWj0ds5J6wsYiGDQqttyzU/lC7y6Cy6+2K1Nk1uZxrWmzF1R3B5rrD9mpauVlSsZVPTY4Nqic+mzS0hRAOaJV1mJRytT75vBCihZQyUQjRArigT08AWlss7gWcrb5oFaVmODLogVLN19DJk6c63MlTHeBy1jXWXjqHncGdlJTd7D80hidYTB/nVEKWePHAMXeemii4d+Oj3NH8Nxa8eZk2L90HdmpAIiU/VW/fuPLqjm0Rf/L0kcPcH+XKa+9NtHFUilI32GLUEQF8CcRIKS3Hy1kLTNbfTwZ+spg+TgjhJIRoA9wE7K2ueBXlRtbQyZ2HWrVnUvPmeHj0wqvzr3g7O7Mi04874xtzt+Nu+myNZ8brJ9mWewt+M+/kbe/PyP5zn61DV2oQVW/XDv069uDQxMeQf7cueWZFUSqFLU5b9QMeBG4VQkTprzuAd4ChQohjwFD9M1LKw8D3QDSwEXhK3bmuKGVnZ2dPx6a3saXPRC72G8RiHwPdnE0sSTIyfHp9dka8y5tLQtgw2oWBd13jj1HvEfbwZnztE7ATJnztEwibtsPWm6HYhqq3a4EVL+0DjIT+0Vsdz4pSTWwx6sgOrPffA7itiGXmAnOrLChFqWM8HRx5rM0AHmsDKUYjbgYD59Kb8Xf7bmz3bUvj+y/y+iUjpt/jiTfdBgjiPZvwsN9p7FYO4J47f8DJqbmtN0OpJqrevvGFTdvB1M+603jzGozCgauP9mTqZ92BHVU2nraiKOrJkIpS59Wzt8cgBK1aPcWiPqF81bYeAc527GwYxPb728FXfwESn9fWk9M5k+WNAomPf8vWYSuKUgazFvuSjhtZwpGrwhOfVzeSjhuzFvvaOjRFqdVsNuqIoig1Tz17e6Z492CKdw+EWzaG/hfIdYOG7U+R2M0VKQQbuZ2HEh/Gx+c1dVZbUW4Qp3JbUr/taZKFBwhBbJvWeLZJ4NTJlrYOTVFqNXVGW1EUq3yyLpD7qxes8eLyyEyMUvtdnoMDX8rx6qy2otxAvA1naT1rk3mMRRMCn1c34m1Qg8EoSlVSDW1FUayaOzUOV9KgYRbcfg6TnfZUOYkd67mDiLNryco6Z+MoFUUpjZdejOBIm9YgtH/7RuFIbJvWvPzi3zaOTFFqN9XQVhTFqokL+7P4yUjcJx/Gzt6YL00ieIYPiTn5bxtFpyhKWWwfcxFTgftZTQh2jLlQxBKKolQG1dBWFKVIExf2p/34XEwGQ4EUwWUasP9qHBkZJ2wSm6Iopfd3hjNGUeDpkMKRfRnONopIUeoGdTOkoijFigwKyvf5px+yGXu/Hf08tzF0ZS/27OlIh5u/o2Wz+2wUoaIoJTky6AGWvrKbp75py+73z9B1fHdbh6QodYI6o60oSpncdZ8jXy7I5I/k23j+npvYbPc4w2Iu8M/5dbYOTVGUYoR7JpC+LJqL7Q7YOhRFqTNqXUNbCHGnEGJxcnKyrUNRlFpr8lPufPDqZVakhrDv3QHE0olRMWe4RqStQ1NuMKrOrj7n7HMA6OSlHsGuKNWl1jW0pZTrpJRTPT09bR2KotRqz73VkFcfPcem9eMYM/80x2jPC7iReC3e1qEpNxBVZ1efi65Qj2Tq1/eydSiKUmfUuoa2oijV583FzZl25ylWrnmIyV+c5B/ZjlGxF8kymYhLPU3g9qXEpybYOkxFUYArDezIxoFz2dm2DkVR6gzV0FYUpdyEgE9+9GZc75N8GfYYkxaeZGLTpmSm7uXlQz8SmevNKzEbbR2moijAhcZuZEoXXju629ahKEqdoRraiqJUiJ0dfP1HG27vcJwlK6fg/dwf7Ih5hjVZHZHYsSq9tTqrrSg2djLlNFkGJxBCHZOKUo1UQ1tRlApzdISVf7cjsMERQlaPY/bxSeSgjdmbK4U6q60oNhQWBvf+uAH0B7DnSsEru5bbNihFqSNUQ1tRlErh6iYY2TsGz7ZnONCqo3m6UTiyMk2dQVMUWwgLgxfmnORQax/zA2uMwpGVDl2JX/FfG0enKLWfamgrilJpvvy1F16zfsNUoGoxoc5qK4otzJoFTV7cQi75n+5qQvBKznEbRaUodYd6MqSiKJUmwdQKWjqTK/JXLepRz4piG6dOgVdRx2TjDjaKSlHqDtXQVhSl0njZneH07Q/A64ehYypM7AOAjyGBI8Zg2wanKHWQtzfE3/4AN7+7nNheTfG8vzNXLzbHhziO+DwEcY/ZOkRFqdVU1xFFUSrN03fuwpU0xDfeME/rp+1KGnOnxtk2MEWpo+bOBVdHI/YtUvA0JXP1YnPtmHR4Q0tUFKVKqYa2oiiVptf0pnz+zE5+/rQld7RYhY8hgcVPRjJxYX9bh6YoddLEibD4K3tko1zc0zNpyCUWN5rJxCVDtERFUaqU6jqiKEql6vyKI9/F9ieowTl+MXoB6nHPimJLEyeCe8xNTH/NiSd6/87E3fNtHZKi1BnqjLaiKJXqp1P/8B4v4+DQ1tahKIqiu7P9YOJWDeBalpOtQ1GUOkWd0VYUpVIdSLmKs10GPeo3tHUoiqIAF5Ij2XjpDPUa9yRNNbQVpVrVujPaQog7hRCLk5OTbR2KotRJx4QLjVOv0r5HfVuHotwAVJ1d9SLOrmHyaXfsuyVxLVs1tBWlOtW6hraUcp2Ucqqnp6etQ1GUOucSSRy264CMd8Ond3Nbh6PcAFSdXfX+Tj4PQGO7i1zLVuPZK0p1qnUNbUVRbGcx5zEJA3Yt03Bsq26CVBRbk1LyQ2ZnAFwfiFUNbUWpZqqhrShKpYhLPc022gFwvlFD4jPO2TgiRVGOJu3lEH4ARLduQ3aLVBtHpCh1i2poK4pSKWbGbMKEAMCE4JWYjTaOSFGU2cf3IfX3JuzIefaQTeNRlLpGNbQVRamwuNTTrE5vjRFHAIzCkVXprYlPTbBxZIpSd8WlnmZNZntM+gBjRuHAAZ926rhUlGqkGtqKolSY5dnsPLnqrLai2JS141JdbVKU6qUa2oqiVNjfGc7ms9l5jDiyL0PdeKUotmL1uBSO7LjsRNi0HTaKSlHqFtXQVhSlwl5f4Yvr4CA6x8bjLlNhcDCug4N4fYWvrUNTlDrryKAHkMHBLPvensnLtuAi03EJd+XU7Q8y9bPuqrGtKNVANbQVRamwWYt9SceNs5fakpOmncVOx41Zi31tG5iiKMxa7Mu6NdMIluHk9E8BF6M6PhWlmqiGtqIoFXYqtyUAV9Mbk5XiUWi6oii2cyq3JZcvt6BpRA5Ge3vsh542T1cUpWqphraiKBXmbTgLgMenTWj3piN2dsZ80xVFsZ2843DPkvvxJh6PkJh80xVFqTqqoa0oSoXNnRqHCxncdusKvlgUSL16l3EljblT42wdmqLUeXOnxuFKGrExfWi2LZecyKY42mWo41NRqoG9rQNQFOXGN3Fhf/ZG7eVX/2asZCxtnOP4vyezmbiwv61DU5Q6TzsOdzBrsS/7Qh9CIAlqdlodn4pSDVRDW1GUSuHe0IlznV35msnsO2CkYxP1T1xRaoqJC/szcSGEb9nCH69sZusdzQnY5slPPYbg4+Fl6/AUpdaqdV1HhBB3CiEWJycn2zoURalTIg/Zk9PQxDXcmX3ib1uHo9wgVJ1dzQwG6k+/RvigbhwweauH1yhKFat1DW0p5Top5VRPT09bh6IodYaUcMTZRJq9KyD4MfMm9ZhnpVRUnV39hvQbC1IihR2r0lurY1VRqlCta2grilL9EhNycZ7xF+iPe1aPX1eUmuutc8exwwSAUdqpY1VRqpBqaCuKUmFbfovgqI8XCK2hbcRRnSlTlBooicusTm+NSRgAyBUOrFTHqqJUGdXQVhSlwr723FNomjqrrSg1zzecxqRfecpjQp3VVpSqohraiqJU2HGP+hiFY75pRhzZl+Fso4gURbEmmgYYKXisOqhjVVGqiBreT1GUCktfFECzpw/zqd33jA1ebetwFEUpwud4ExwcrH2Qkgcab+BCj8vc/4HRpnEpSm2lzmgrilIhly5KckedwWCXS0MG2jocRVFKSwieesZA9oREpl7yZuelWFtHpCi1jmpoK4pSIVs3JXC1jSODs/cg8Ld1OIqilEGfmYMxvtUdT5KZFvs3JiltHZKi1Cqqoa0oSoV8F38Gk7DjXnsXVJWiKDcW4eTIQwHZdNh6hQPGlnx6fJOtQ1KUWkX9V1QUpdziUk+zsc8VHM/C6D6v2zocRVHKYfzHfTj+zkg6Zh9n9pks9l8+SuD2pWrIP0WpBDZraAshDEKISCHEz/rnhkKI34QQx/S/DSzmnSmEOC6EOCKEGG6rmBVFuS4sDO5ds55MOydaGM7ynfdMmm7ebOuwlCqi6uzay611Q3p5xJH70U2YTrnwwC/biDSqx7MrSmUocdQRIYQXMA4YALQEMoBDwC/ABimlqZzrfhaIAerpn2cAW6SU7wghZuifXxZCdNbX76evf7MQooOUMresK8zJySEhIYHMzMxyhpyfp6cnMTExlZLXjUqVgcYW5eDs7IyXlxcODg7Vul7QGtkvzDnJ5YW+SGFHYtNGvFDvGd57Zw6dbw6DiROrPSZFU5vqbKV6hE3bQfjlQDI3uNDgxEmOLtIez74yrTX/Tk3Ax8PL1iEqyg2r2Ia2EGIJ0Ar4GXgXuAA4Ax2AEcAsIcQMKeUfZVmp/o9gJDAXeF6ffBcQrL//GggHXtanL5dSZgEnhRDHgV7ArrKsEyAhIQEPDw98fX0RQpS8QAlSU1Px8PCocD43MlUGmuouByklSUlJJCQk0KZNm2pbb55Zs6DJ61u4hA8AJgRNX93Ga4+8wYOzglVD20ZqW52tVI9Zi33JxJl2k3/j/KQMjLgC2nH9SsxGwno9auMIFeXGVdIZ7f9IKQ9ZmX4IWC2EcAS8y7Hej4CXAMuWSTMpZSKAlDJRCNFUn94K2G0xX4I+rRAhxFRgKkCzZs0IDw/Pl+7p6UmjRo24du1aOUIuLDc3l9TU1ErJ60alykBji3JwdHTk6tWrhfbz6pBi35bENq0xCu1sulE4EtumNa5t7JBxp9hmg5hqimvXrtnkO9HVqjq7ODYu52LdaLFlDfOg9bQ/OOHeEqQBhNar1CgcWZXemrHha2hIAyu5VX1sNYWKrXxqcmxQPfEV29AuosK2TM8GjpdlhUKIUcAFKWWEECK4NItYW3UR8SwGFgP07NlTmgfl18XExFCvXj0rS5aPOpuryiCPrcrB2dmZ7t27V/t624Z+wf4C7TUTgnav/ox40+KBGHVQeHi4zba/ttXZxbFlOZfkRopt6sHfOPdSKo1NDrS/doI4t9b5nhyZi2CVaxJhvcZUe2w1iYqtfGpybFA98ZXqZkghxE1CiJVCiGghxD95r3Kusx8wWggRBywHbhVCLAPOCyFa6OtrgXbJE7SzIa0tlvcCzpZz3YqiVIKrLZ0LP3JdOHK1pTPMnWujqJQ8qs5WihOZcolTydpvsp4HnLjlr8Nk3zeQLHunwsc1jurx7IpSAaUddWQJ8BlgBAYD3wD/K88KpZQzpZReUkpftBtmfpdSPgCsBSbrs00GftLfrwXGCSGchBBtgJuAveVZt6IoleP4rQ+w7EwwPvf2RNzRB/t0E0G7E1i74x/VP7tmUHW2UsjRtDTeIpHAvw/w2oGviVq4jZkP+HF61j2EBh/DblQwYvBAfIa0Z9n39sjgYGRwMEcGPWDr0BXlhlXahraLlHILIKSU8VLKUODWSo7lHWCoEOIYMFT/jJTyMPA9EA1sBJ6qtrvXw8LA1xfs7LS/YWEVyu7q1assXLiwyPSHHnqIlStXAvDRRx+Rnp5ebH7u7u4VisfX15dLly5VKI/SCA0NZd68eVW+njwVLZeqYq0cMjMz6dWrF926dcPPz4/Zs2eb01577TX8/f0JCAhg2LBhnD1bs04KTpwIcZfcmeQdhfOPjWh2hz+JQ4bYOixFUzfrbMWq05mZPHQwnM5/7eZP6jPZYSuTj7RmyFN+uDrksHWnE8+t6k+c0QuTtCPO6MXEhf1tHbai1AqlbWhnCiHsgGNCiKeFEGOApiUtVBIpZbiUcpT+PklKeZuU8ib972WL+eZKKdtJKTtKKTdUdL2lEhYGU6dCfDxIqf2dOrVCje2SGtqWStPQrityc6vvf7TRaKy2dQE4OTnx+++/s3//fqKioti4cSO7d2v3kb344oscOHCAqKgoRo0axZtvvlmtsZVW55tyuPZFV97P/Q4Dq2wdjqKpe3W2UqRnYnYTlpTDGMMWwtjL9B19uP+xCbg45hK+x5V2QQ1tHaKi1FqlbWhPB1yBfwGBwANcv2R4Y5o+HYKDi3498ggUbOimp2vT9Xlc7rgj/zLTpxe7yhkzZnDixAkCAgJ48cUXkVLy9NNP07lzZ0aOHMmFC1oXx/nz53P27FkGDx7M4MGDi81z1qxZdOvWjT59+nD+/HkA1q1bR+/evenevTtDhgwxT09KSmLYsGF0796dxx9/HCm1+5NefvnlfD8AQkND+c9//lPkOnNzc3nooYfo0qULffr04cMPPwQgODiY6dOnc8stt9ClSxf27r1+tTg6Oprg4GDatm3L/PnzzdOXLVtGr169CAgI4PHHHzc3qt3d3Xn99dfp3bs3u3btKnK+yiiX0NBQpk6dyrBhw5g0aRKhoaFMnjyZYcOG4evry+rVq3nppZfo2rUrI0aMICcnB4AtW7bQvXt3unbtyrRp08jKyio2JmuEEOYz8Dk5OeTk5JiHnrS8cTctLa1ShqSsCn49nEDacf7MDs6zmbScspeDUummU9vqbKXUko1GZh2PZm/iFgA+6BjEzjYJLL/lNey/qceQGb1wdjSxdY8b7bpX3gABiqIUVmxDWwjRVAjxETAbmAWkSCmnSCnHSil3F7fsDa+oRlM5GlN53nnnHdq1a0dUVBTvv/8+a9as4ciRIxw8eJDPP/+cP//8E4B//etftGzZkq1bt7J169Yi80tLS6NPnz7s37+fgQMH8vnnnwPQv39/du/eTWRkJOPGjeO9994D4I033qB///5ERkYyevRoTp06BcC4ceNYsWKFOd/vv/+e++67r8j1RkVFcebMGQ4dOsTu3buZMmVKvpj+/PNPFi5cyMMPP2yeHhsby6ZNm9i7dy9vvPEGOTk5xMTEsGLFCnbu3ElUVBQGg4Ew/YpBWloaXbp0Yc+ePTRq1KjI+SqjXAAiIiL46aef+PbbbwE4ceIEv/zyCz/99BMPPPAAgwcP5uDBg7i4uPDLL7+QmZnJQw89xIoVKzh48CBGo5HPPvusyJiKk5ubS0BAAE2bNmXo0KH07t3bnDZr1ixat25NWFhYjT2j7TewEQC7D9/HBBbw+cmi91mlatXpOlshPTeXd+P/wefPcP6dcIFvjy0lNzeDtq5u9PKZQvRrP/LIkgdwcoLwfR60D6iZ3ewUpTYpaRztb4AI4BNgFDAfeKiKY6oeH31UfLqvr9ZdpCAfH9DHXMyo4JBuf/zxB+PHj8dgMNCyZUtuvbVsXSgdHR0ZNWoUAIGBgfz222+A9mCekJAQEhMTyc7ONj/Q5I8//mD16tUAjBw5kgYNtHFRu3fvzoULFzh79iwXL16kQYMGeHsXPdRu27Zt+eeff3jmmWcYPHgwd999tzlt/PjxAAwcOJCUlBSuXr1qXp+TkxNOTk40bdqU8+fPs2XLFiIiIggKCgIgIyODpk21q9sGg4GxY8cCFDtfZZQLwOjRo3FxcTF/vv3223FwcKBr167k5uYyYsQIALp27UpcXBxHjhyhTZs2dOjQAYAJEyawZMkSppdwVcMag8FAVFQUV69eZcyYMRw6dIguXboAMHfuXObOncvbb7/NggULeOONN8qcf1XzvsULV9JI/CkA394n+eScK/87v5TVAUPUE+WqX+2ts5VCErOyGBcdzTftG/Nl9Af8N3skF3Lt6c0+nqsXy6iOMzAYtHrt0AtLufU/I7F3hK0RnrT3cywhd0VRKkNJXUeaSylnSSk3SSmfAfyrI6gaYe5ccHXNP83VtdKHLqtIdwAHBwfz8gaDwdy/+JlnnuHpp5/m4MGD/Pe//833yPmi1nfvvfeycuVKVqxYwbhx44pdb4MGDdi/fz/BwcF8/vnnPPro9aeGFcw/77OTk5N5Wl6sUkomT55MVFQUUVFRHDlyhNDQUEAbH9pgMAAUO19llYubm1u+PPLitbOzy5efnZ2dOfbKVr9+fYKDg9m4cWOhtAkTJrBqVc3s/2zn4kRnx+Mc/qcB93CKf0xNiMz15pWYwtuhVLm6W2fXQW/FxbEjOZmZMZuIycihee5hFjt/xHr/QEJ6LMXNzQ+k5PAzi7j1P3fg4Gzg/f8e4ybVyFaUalNSQ1sIIRoIIRoKIRoChgKfa6+JE2HxYu0MthDa38WLKzR0mYeHR76nBw4cOJDly5eTm5tLYmJivm4iBecti+TkZFq10h7E9vXXX+dbX16Xiw0bNnDlyhVz2rhx41i+fDkrV67k3nvvNU/v1KlTofwvXbqEyWRi7NixvPrqq/z999/mtLwuKDt27MDT0xNPT88i47zttttYuXKluW/65cuXibdyFaG085WkqHIpj06dOhEXF8fx49qzP5YvX86gQYMAmDlzJmvWrClVPhcvXjSf9c/IyGDz5s3mMj927Jh5vrVr11r9LmoKv0bnOXy5Od1pDkgkdqxKb018aoKtQ6tr6m6dXcckZmXx1blzmIBV6a25l+/5mJeY1P1TGjYcqs0kJdFTP+LWBWOwd3EgPKIeXr7ZNo1bUeqakrqOeKJdhrQ8TZnXqpJA26oIqsaYOLFSxwRu1KgR/fr1o0uXLtx+++289957/P7773Tt2pUOHTqYG2oAU6dO5fbbb6dFixbF9tO2JjQ0lPvuu49WrVrRp08fTp48CcDs2bMZP348PXr0YNCgQfm6h/j5+ZGamkqrVq1o0aIFoDWorZ25PXPmDFOmTMFkMmEymXj33XfNaQ0aNOCWW24hJSWFr776qtg4O3fuzJw5cxg2bBgmkwkHBwc+/fRTfHx8yjVfeculPJydnVmyZAn33XcfRqORgIAAnnjiCQAOHjzI6NGjrS43Z84cPrLotrR+/XomT55Mbm4uJpOJ+++/39ztZcaMGRw5cgQ7Ozt8fHxYtGhRueOtap190vg6sQnfGtPNtUougldiNhLW69HiF1YqU92us+uQt+LiMOr1swk7vmMCz4nPiI//Nx06fKo1sh98m8Fhj2BwdWLrvnp0uNmOsxdKyFhRlMolpayVr8DAQFlQdHR0oWkVkZKSUqn51TTr1q2TH3/8cbHzWJbBoEGD5F9//VXVYdVIluUwbNiwaltvZe/T5fXzo2tk/banpOPvGyVbt5pfTls3yriU07YOr1pt3bq1wnkA+2QNqEer82Wtzi5OZZRzVanq2M5mZkrnbdsKHGsb5KqtDeS2bS4yMz1BRt/7mmxGomzumixjok3VFltFqNjKR8VWfpUVX3F1dklntM2EEK0AHyzOgksp/6j8pr9SU+SdWVXKZtOmTbYOodr59Xandd9NxJD/Jlp1Vtt2VJ1de70VF4dJ5r/amIsd3zCJ5+RnRP13FHet3ABubmz9y51ON9fMoUEVpS4oVUNbCPEuEIL2pK+8AYwloCrtatC7d+9CYzT/73//o2vXrjaKyLpwfTSW6nKjlEtd4H2LF1dPncMo8t9kZcSRfRnONoqq7lJ1du22KyWF7AINbSOOHMYPKbOJccsBd3e27nWn0802ClJRFKCUDW3gbqCjlLLGP4lCCHEncGf79u1tHUql2bNnj61DqJFUudQcdu3a0MwvlVu+WM2KdsM51acPrZ1VA9uG7kbV2bVWpD7U6fi/f+S3FCOnevnjaufNkRHfEbztLCb3emzd48bNqpGtKDZX2idD/gM4VGUglUVKuU5KObW40S4URalkTk74ucWTVs8OgaS5oxo+zMZUnV0HTK9/ko+dv8TF1JKjtz7B4G2zMXl4snWPG5072zo6RVGghDPaQohP0C43pgNRQogtgPkMiZTyX1UbnqIoN4rOLa7wq7uBhiITB7vS/oZXKpOqs+uW3m2fo1ejhzk+eCqD972P0aMBW3e5qEa2otQgJXUd2af/jQDWVnEsiqLcqMLCuBCXRvT5HmQ4OOLb+BpzP3avzNExldJRdXZdEBZG2PTdTO/6BJeuNcOw7xtcnU38+acjfn62Dk5RFEvFNrSllBV7qoeiKLVfWBhhUzbzXb1XkU3/IiO3IfEmB6Y+bATsVWO7Gqk6uw7Qj7ddUzxxCvkbcc2H3Id6k3PNwP790KWLrQNUFMVSsdd3hRDrhBB3CiEK9fUTQrQVQrwphHi46sKzrbAw8PUFOzvtr/5QxXK7evUqCxcuLDL9oYceYuXKlQB89NFHpKenF5ufu7t7heLx9fXl0qVLFcqjov79739Xan7h4eHmYQnXrl3LO++8A2hPYOzduzfdu3dn+/bt/PDDD9x8880MHjy42PyslfGiRYvo2rUrAQEB9O/fn+joaADi4+MJDAwkICAAPz+/Gv2AmUo1axazcmYz4eF/E+DyN9I9FybFk55tz6xZtg6ubqnrdXadoB9vwUO/57JoiPTQjrfMHHteecXWwSmKUlBJHSkfAwYAsUKIv4QQ64UQvwshTgL/BSKklMU//u8GFRYGU6dCfDxIqf2dOrVije2SGtqWStPQrg3K09DOzc0teSZg9OjRzJgxA4AtW7bQqVMnIiMjGTBgAF9++SULFy4s81M3ASZMmMDBgweJioripZde4vnnnwegRYsW/Pnnn0RFRbFnzx7eeecdzp49W+b8bzinTnGtoQM9h//C7+I2EAJuT4QGWZw6Zevg6pw6W2fXGadOkd7YDhplkSFctePtjrzjTfLy2OP8vTsbWfihvoqi2EBJXUfOAS8BLwkhfIEWQAZwVEp5Q7cCp0+HqKii03fvhgJDNJOeDo88Ap9/rn3OzXXBYLieHhAAFk/XLmTGjBmcOHGCgIAAhg4dynvvvcczzzzD77//Tps2bZB6zTh//nzOnj3L4MGDady4cbGNwVmzZvHzzz/j4uLCTz/9RLNmzVi3bh1z5swhOzubRo0aERYWRrNmzUhKSmL8+PFcvHiRXr16mdf38ssv4+Pjw7Rp0wDtUeUeHh783//9X5Hr3bhxI6+88go5OTk0bdqULVu2kJaWxjPPPMPBgwcxGo2EhoZy1113sXTpUtauXUt6ejonTpxgzJgxvPfee8yYMYOMjAzzGeCwsDCWLVvG/Pnzyc7Opnfv3ixcuBCDwYC7uzvPP/88mzZt4j//+Q/9+/fPF8v06dNp3LgxPXr0ME9funQp+/bt49FHH+Wll14yr2vMmDHs2LGDkydPMnr0aN5///2ivzQr6tWrZ36flpaGENrDIBwtRtrIysrCZDKVKd8blrc3T455mVDDaxj1KsXO3ohpUjzeP3awcXB1S22usxWdtzeP3/0K38jJGEQuudiDgwkeOYnzPB8+WO3De6sduMkjkXEjkhk3w5fOPdRQm4piK6UeGkBKGSel3CWljKoLFXbBRnZJ00vjnXfeoV27dkRFRfH++++zZs0ajhw5wsGDB/n888/5888/AfjXv/5Fy5Yt2bp1a7GN7LS0NPr06cP+/fsZOHAgn+u/APr378/u3buJjIxk3LhxvPfeewC88cYb9O/fn8jISEaPHs0p/XTjuHHjWLFihTnf77//nvvuu6/I9V68eJHHHnuMVatW8eeff/LDDz8AMHfuXG699Vb++usvtm7dyosvvkhaWhoAUVFRrFixgoMHD7JixQpOnz7NO++8g4uLC1FRUYSFhRETE8OKFSvYuXMnUVFRGAwGwvRLCGlpaXTp0oU9e/bka2RnZmby2GOPsW7dOrZv3865c+cKxRsQEMCbb75JSEgIUVFRzJ49m549exIWFlbmRnaeTz/9lHbt2vHSSy8xf/588/TTp0/j7+9P69atefnll2nZsmW58r+RZM39P3zv2EWs6IwJ7ZenyWCA2xN58e0aP4xzrVXX6uy6IuvtF+h2+69sshuuNbJBO6s95Dzz/pdJ1MrtLO7/Da0zjjHnhw74BTrjX/8U/55wiBOHMmwbvKLUQaV+BHttU9yZZ9D6ZMfHF57u4wN5D0BMTc3Aw8Oj3DH88ccfjB8/HoPBQMuWLbn11lvLtLyjo6O5P3JgYCC//fYbAAkJCYSEhJCYmEh2djZt2rQxr2/16tUAjBw5kgYNGgDQvXt3Lly4wNmzZ7l48SINGjTA29vbyho1u3fvZuDAgbRp04bU1FQaNmwIwK+//sratWuZN28eoDWC8xrzt912G3nj5Hbu3Jn4+Hhat26dL98tW7YQERFBkP4whoyMDJo2bQqAwWBg7NixhWKJjY2lTZs23HTTTQA88MADLF68uEzlWB5PPfUUTz31FN9++y1z5sxhwYIFALRu3ZoDBw5w9uxZ7r77bu69916aNWtW5fHY0kGnn3nH/uVC0+0djUQHxgPqrLaiVJa4HtH87+wDmMj/WHV7RyPf+yzjudzOvLy0J+u92nH5xx2snH+W5XvbMuu7Xsz6DgI8mvPA3fu5f9ZNtO7oaqOtUJS6Qw12W4S5c8G1QB3k6qpNr0x53Q7Kw8HBwby8wWDAaDQC8Mwzz/D0009z8OBB/vvf/5KZmVni+u69915WrlzJihUrGDduXLHrlVJazUdKyapVq4iKiiIqKopTp05xs/5oMicnJ/N8lrEWXH7y5Mnm5Y8cOUJoaCgAzs7OGPR+OsOHDycgIIBHH3202G2qDuPGjePHH38sNL1ly5b4+fmxffv26g+qOuXkEJMdxwnRHgr84zcKA38mJ9smLkWppVJSdhEtbsZI/odCGYWBROHDQMKZc/oC/hHbiBvRjWd2jmNnRg/iv93J+31XY5eewQv/64Z3J1cGNI7m04f3cf7ENRttjaLUfqVuaAshXIQQHasymJpk4kRYvFg7gy2E9nfxYio0VJmHhwepqanmzwMHDmT58uXk5uaSmJiYr5tIwXnLIjk5mVatWgHw9dfXR/saOHCguSvGhg0buHLlijlt3LhxLF++nJUrV3Lvvfeap3fq1KlQ/n379mXbtm2cPHkSgMuXLwNaA/iTTz4x9/2OjIwsMVYHBwdycnIA7az3ypUruXDhgjnfeCuXFTZt2kRUVBRffPEFnTp14uTJk5w4cQKA7777rsR1FnTmzBluu+22Us9/7Ngx8/tffvnFfDY9ISGBjAzt0uyVK1fYuXMnHTvW7kNm/1trmbTtF6S043DPnmwFZHCw+ZX3qGil+tW1OruuCAqK5FjwY/mOs7zX0f6j+bHnfXzk8jVXsq/SLzKCGccOgr093uP78cKf9/CfTZc5umwvb/X+mSvJdjy9pCct27swtGkUXz62m8txKbbeREWpVUrV0BZC3AlEARv1zwFCiFr/MISJEyEuDkwm7W9FxwNu1KgR/fr1o0uXLrz44ouMGTOGm266ia5du/Lkk08yaNAg87xTp07l9ttvL3H4OWtCQ0O57777GDBgAI0bNzZPnz17Nn/88Qc9evTg119/zdc9xM/Pj9TUVFq1akWLFi0AuHTpkrnRbKlJkyYsXryYe+65h1tuuYWQkBAAXnvtNXJycvD396dLly689tprJcY6depU/P39mThxIp07d2bOnDkMGzYMf39/hg4dSmJiYrHLOzs7s3jxYkaOHEn//v3x8fEpVRlZSkxMxN7eei+q9PR0vLy8zK8PPviABQsW4OfnR0BAAB988IH5x0xMTAy9e/emW7duDBo0iBdeeIGuXbuWOZ4bRmYmc74w4bHVjX+3akfnCg43qVSeulpnK+Du7s+/en3JjvbXuM8xgtYuWpc9c11uMHDTxF68unsUh7I6cPDrv3klaDNxlz159Is+NG/jzKhmf7Hs8e2knr5quw1RlNpCSlniC+0pY55ApMW0A6VZ1lavwMBAWVB0dHShaRWRkpJSqfnVNOvWrZMff/xxsfPUhjL45JNP5E8//VShPGxVDpW9T5fF709/J7/91ld+/3mIedrWrVttFk9NURllAOyTFaj/akudXZyavK/VlNhMJpOUUsqcnKsydNeTclzkJvlTEbGZjLly31f75QuBv8vWhgQJUjqTLsc23y5/mPa7TDudVOXx1pRys0bFVj41OTYpKy++4urs0t4MaZRSJtuyL2xp6Wdy7mzfvr2tQ7nh5d1oWds9/fTTtg7hhiOvpfG/i8c42yKEt9oOKnkBpbqpOlsx37+SnX2ei7lO/HDVjk2ksiDhMONbdc53f4sw2BE4xZ/AKfBurmTXl4dZvugK3+/vxKqFjXFfmMpdLX5n3L1Ghs3ogWPLxkWtVlEUC6Xto31ICDEBMAghbhJCfAL8WYVxlZuUcp2UcmreCBe1Qe/evQkICMj3OnjwoK3DUuqwL2d+x9rHO/GrHIpno4G2DkcpTNXZipmrawfm932Pn1sdoQmJTDx+kRF/reFMZjpxqacJ3L6U+NQE8/x2BkG/qX588nd/zmY1YsvCI4zvFs368z2485NhNGtl4JFWG/lt+i8YEy/acMsUpeYrbUP7GcAPyAK+BZKB6VUUk1LAnj17zCNx5L1qdd9fpUbLuXiVL4KvkiQa4224Sgc3N1uHpBSm6mwlHzs7B0bc9BQLqc/zrjvYlu7B39fSmRmzichcb175f/buO76pqn/g+Odkdu8BFNqyyoYyyhAUUERQwYUCVsGJj7h9XMjzKIo4fz7iQgVlaRUUB6ACIoLsIbTsDW0pbSkt3WmTJjm/P5KWFgoUaJvSnvfrlVeTe2/u/d7T5OSbk3PP2bu00udpdYJrH23D9IRepJt8+e2jwwzreJQf0vox+MObaNJE8ljThaz59y/Y007U8lkpSt13wa4jQggtsEhKOQiYWPMhKYpSl019bjFb7usKCNLs3iTlpxDh3dTVYSlOqs5WzkdLCO/3vItni3Ipsebxk6kZEg3zTM1ptfNbbmzUgWj/dhh1hrOeazAKbnyiJTc+AUUmyZLPE5n/VT6z9g5m2v/cCftfCneFfc+oURDz7NWIJo1dcIaKUrdcsEVbSmkDTEII9bueojRwBUdP8tVgG3Zn1WGHc7aEKa6h6mylKsLcfZmwd1nZxDd2NLye1YTeu7PxWbuS+3etA6Co6AjbMjZQXFJxrG13D8Htz0Yyf3cnMnLd+PadY3RvU8Anx2+j1/t30TKsiJebfc2OF+OQx1LOOr6iNBRVvRiyGNgphFgOFJYulFI+WSNRKYpSJ70zcSFHHm7mGFwesGLgR1Mz3lSt2nWNqrOV80rMP8ZPpmblJr4R6LHwalAGR4rNdPZxXOR8LG02vZP7AetprUmlk7GIrp7u3N78Nlp7Or7LeXkLRr/QjNEvQHY2/DLtOPNmSd49PJq33tXR7t09jGz2JaNidbR59Fo4z8zDilLfVDXR/s15UxSlgcrYnsaGu5OQVPyQtCF4ee9S4no+5KLIlEqoOls5L0drdsX3sgT2mIorvJcbNR7Hx/YE/sk7xXaTll+LIphf5IHVK5uJnr5sPTiJtzMD6eplpJdfE3oEdua+l5tx/0TByZPw47R05s325LXEB5j0tobot+MZ1WwxI+/REzluMERG1u6JK0otq9LFkFLKOZXdajq4usBsTiM+vj9mc/pl7ysnJ4dp06adc/19993HggULAJg6dSomk+m8+/O6zAlCIiMjyczMvKx9VMWkSZP4v//7vxo/TqnLLZeaUlk57N+/v8JoMj4+PkydOhWA559/nrZt29K5c2duu+02cnJyaj/oct788EfWel2FVZwx9TMG/ilyc1FUSmUacp2tVM22Irezp3Gv5L3s496UR1rdzIxuY9jc717y+g9lb/f2POCc2OyY1YOl5pZMzIpi0GEvgjbvp/2aONbl5hIcDMMf38dPOwpJPib54OWTGJuF8NKxx2j+1jj6NE/jw/D3SZ34KThn91WU+qZKLdpCiKM4vuxWIKVsUe0R1TGJiZPJzV1LUtJkoqI+vax9lSba48ePv+C2U6dO5Z577sHDw+Oyjlkf2Gw2tFptrRzLarWec5bImtCmTRsSEhIAx3mGhYVx2223AXD99dfz1ltvodPpePHFF3nrrbd45513ai228g6uPMSyO/Xo7HYO9elGU3cfl8ShVE1DrrOVqtnf/55Lep5GCNp6h5Q9vrXdC+S1lRwoyGJD1l4252ay0+yPn7Menbbnc96xPUhz1tP+xmyGjNDwtGjH4e968sPXLXn6WB+eedNO/zf/5pbglXR4OIHg+26C1q2r5TwVxdWqmlH0KHffDbgTCKj+cGpXfPyAs5aFhNxFWNh4bDYTCQnXkZ+/GbCTmvo5+fnxNGkyjsaN78NiyWT//tsqJIBdu6467/FeeuklDh8+THR0NNdffz3vvvsuTzzxBH/99RfNmzcvmyL3o48+IjU1lYEDBxIUFMTKlSvPuc+JEyfy66+/4u7uzsKFCwkNDWXx4sW88cYbWCwWAgMDiYuLIzQ0lKysLEaPHs3Jkyfp2bNn2fFefPFFIiIiyr4ATJo0CW9vb/79739XekybzcaDDz7IP//8g5SShx56iGeeeYYBAwYQHR3N5s2bycvLY+bMmfTs2ROAPXv2MGDAAJKTk3n66ad58klHV9FvvvmGjz76CIvFQq9evZg2bRparRYvLy+effZZli1bxvvvv09iYmKl21VHuUyaNInU1FQSExMJCgoiKiqKo0ePkpaWxoEDB/jf//7Hxo0bWbJkCWFhYSxevBi9Xs+KFSt47rnnsFqtREdH8+WXX2I0Gs/7GjifFStW0LJly7Jp5AcPHly2rnfv3mW/drjCi5sWsa93NyYbMlWSfWWol3W2UjcJIWjjHUQb76u5r9xyKSVD27xA3oljxBd487elMQtzHcOBpk/2YcJbgv+tjWVPVlty1/swc9W1TPqoA73f3MqopnO5dYwPfvcOg7ZtXXJeilIdqtp1JKvc7biUcipwbc2G5npmcxKnG4Wk8/Gle/vtt2nZsiUJCQm89957/Pzzz+zfv5+dO3cyY8YM1q93zCfx5JNP0qRJE1auXHneJLuwsJDevXuzfft2rrnmGmbMmAFAv3792LhxI/Hx8YwaNYp3330XgNdee41+/foRHx/P8OHDSU5OBmDUqFHMnz+/bL/ff/89d9555zmPm5CQwPHjx9m1axcbN27k/vvvrxDT+vXrmTZtGg888EDZ8n379rFs2TI2b97Ma6+9RklJCXv37mX+/PmsW7eOhIQEtFotcXFxZfvp2LEjmzZtIjAw8JzbVUe5AGzdupWFCxfy7bffAnD48GF+++03Fi5cyD333MPAgQPZuXMn7u7u/PbbbxQXF3Pfffcxf/58du7cidVq5bPPPjtnTFUxb948Ro8eXem6mTNnMnTo0Mva/6WIG7+WkKAUlvZoR4u8JCK+CbnwkxSXa6h1tlK3CCHoG9KNjzrdwpo+Izl1zY0c7dWTn9u3JtRgwGrNZo2uN7P8r+anm7qw+z0bgYsXkTgtj/tTXqf5h2N56oFv+L7ToxRMnELcO8eIjASNkETqUogTsY4+3uf5PFAUV6tq15Fu5R5qcLSWeNdIRLXofC3QVmsuVms25RNtqzWbgIAhABgMQbRp8zve3pdeDKtXr2b06NFotVqaNGnCtdde3OegwWAomya9e/fuLF++HICUlBRGjhxJWloaFouF5s2blx3vp59+AuCmm27C398fgK5du5KRkUFqaionT57E39+f8PNcFd6iRQuOHDnCE088wcCBA7n11lvL1pUmitdccw15eXll/YpvuukmjEYjRqORkJAQTpw4wYoVK9i6dSsxMTEAFBUVERLiSOS0Wi133HEHwHm3q45yARg+fDju7u5lj4cOHYper6dTp07YbDaGDHH83zt16kRiYiL79++nefPmREVFAXD33Xcza9Ysnn766XPGdT4Wi4VFixbx1ltvnbVuypQp6HQ6YmNjL2nflypu/FrGfdYV0yPpYPcg7fkb+NcBbzSsJXZav1qNRbk49bXOVq5sQggi3T2IdHd0iTQYQvilz+McM5vZlH2Mxfs3c8w9AG2vYOZuEqz4bR0/DAxgES35zJyMb/pndL7bh6Jv7yQpqSXjmA5JDxM7bpzjALVcRypKVVS168j75e5bgUTgrmqPpg5JTJyMlPYKy6S0VUtf7fKEc5i0S6HX68uer9VqsVqtADzxxBM8++yzDB8+nFWrVjFp0qQLHm/EiBEsWLCA9PR0Ro0add7j+vv7s337dpYtW8aMGTP49ddfmTlzZqX7L31cvktFaaxSSsaOHVtpcunm5lbWNeR821XmUsrF84zZDUvj1Wg0Ffan0WjKYq9OS5YsoVu3boSGhlZYPmfOHH799VdWrFhxWa+VSzHlTyNhv82j6D89SFnXhaIDfgBMnB5J7Lmv6VXqhgZXZytXJiEE4W5uhDduTfD+4wzoNaBsXffuN2A+9A/L0nLYQiMKI9whAjwapcFTLel97SKW3++LONKCniteIHR4Ozw9O6DRVOzCl2Y2M2rPHua2CuLUoXto334+RmOjWj5TpaGqateRgeVu10spH5ZS7q/p4FwpL28DUloqLJPSQm7u+kvep7e3N/n5+WWPr7nmGubNm4fNZiMtLa1CN5Ezt70Yubm5hIWFAY5ErfzxSrtcLFmyhOzs7LJ1o0aNYt68eSxYsIARI0aULW9bSd+4zMxM7HY7d9xxB//5z3/Ytm1b2brSLihr167F19cXX99zz5lx3XXXsWDBAjIyMgA4deoUSUlnd8+p6nYXcq5yuRRt27YlMTGRQ4cOAY5uH/37O8adnTBhAj///PNF7e+77747q9vI0qVLeeedd1i0aJFLLorVvLyDQ+7N6fRWHGL36X7ZybYmtR6LcnEaYp2t1D9arQeT2lzDhgHDKRw6BO7sg+aVtpjmtAOgWGNgTtORxF7zMVFjvqbj1p3csPoNlpx0dIvMy9tCTs5qXjt6kLW5uUzYu6xscANFqS1V7TryFDALyAdmAN2Al6SUf9RgbC4VExNf7fsMDAykb9++dOzYkaFDh/Luu+/y119/0alTJ6KiosoSNYBx48YxdOhQGjdufN5+2pWZNGkSd955J2FhYfTu3ZujR48C8OqrrzJ69Gi6detG//79K3QP6dChA/n5+YSFhdHYOWxTZmZmpS23x48f5/7778dut2O32yuMhOHv789VV11VdjHk+bRv35433niDwYMHY7fb0ev1fPrpp2UXA17sdpdaLpfCzc2NWbNmceedd5ZdDPmvf/0LgJ07dzJ8+PBKn/fGG2+UDd8Hju4sJpOJ5cuX88UXX1TY9vHHH8dsNnP99dcDjgsiP//880uO+WIk5h9jb0QkUmhYYbgOn8hUco86JqQJ16YCanKauqwh1tlK/RYRLkhKMmJfc7olev2fd9Bk2xE+bxPLpoE92HLbzWwvasRRi+PX0HWJn/PQqYGkU4IdLT+ZmjICXzTps4iI+K9q1VZqh5Tygjdgu/PvDcAioAuwrSrPre0bMAyY3qpVK3mmPXv2nLXscuTl5VXr/uqaxYsXyw8//PC825Qvg/79+8stW7bUdFh1UvlyGDx4cK0dt7pf06VGbZoh+esvycqVUvfXMtn5qxkSpPSgQH7z6JpzPm/lypU1Es+VpDrKAPhHXl49WC/q7POpy681FdulOV9s33wjpYeHlFD+Zpct2S9z3UIcGzjZ7HYppZTxpxKlduVfkpXOumzlMnnLyqfkqlUGuX//+GqLzdVUbJeuuuI7X51dpa4jQGnn0BuBWVLK7eWW1SlSysVSynHn67KgVM3NN99cNgyfUnXLli1zdQiXpXRq5rJp1oWBfc2b0a7VP0x/NF5dCHllUHW2Uq/ExsL06RARAQJJhDaFp5lKEs0Z4raS/OGnL4TUOOuulQUabAhKX/pWDCxlCFnSk/T0WdUyEZ2iXEhVL4bcKoT4A2gOTBBCeAP2CzxHqSa9evXCbDZXWPb111/TqVMnF0VUuVWrVtXq8a6UcrnSVDY1s10IusYlEKumWb9SqDpbqXdiY0sHFhE4uq89Q7/BXzBy+YMMHWBiySoPSgcCO2Gx8MLhwwgkstx3TBsa5jKGZ+Rn1T64gaJUpqqJ9oNANHBESmkSQgQA95//KUp12bRpk6tDqJNUudSMqk7NrNRpqs5WGoQ7vrmNeRH3Myp+NjfeCEuWgJcXBAgTweIUabLiPE1WDOymw2UPbqAoVVXVRLsPkCClLBRC3IPjwpoPay4sRVFcZX//eyiwWrnr0wMs+aQZeRP/wPu+O1wdlnJxVJ2tNAwhIYyY1JHvXhrF6PXzufFGDbN+yiA78Ua+YwcdOi4gKOjMi9MHAA+7IFilIapqH+3PAJMQogvwApAEzK2xqBRFcSkvnY5eRxcyovHXeHdp4epwlIun6myl4XjqKe6M/Ie4pi+xzZ5Ihx3xrC7Q0rHjz5Uk2YpSu6qaaFudV1XeAnwopfwQNcuYotRbOSUlePf5jYHXzoNWrVwdjnLxVJ2tNBxubvDOO1yf/TnGlw/ja81l+7zXcHO7ydWRKUqVE+18IcQE4F7gNyGEFtDXXFiKorjSL+mn+HfoGxQZvSi7uki5kqg6W2lQLLcMZNybU8gzSJ7IGMA3M4YwbBiYTK6OTGnoqppojwTMwANSynQgDHivxqKqQ9LMZvrHx5N+xugWlyInJ4dp0849d/V9993HggULAJg6dSqmC9QQXl5elxVPZGQkmZmZl7WPy/Xmm29W6/5WrVrFzTffDMCiRYt4++23ATh58iS9evWia9eurFmzhh9++IF27doxcODA8+6vsjJ+5plniI6OJjo6mqioKPz8/ABISEigT58+dOjQgc6dO5fNknkl2nysCAC/DolqCKwrU4Ots5WGw2xOIz6+P4dObaf1xr/4sWMn3vjqK/6z90PmzoW//0Yl24rLVXUK9nTgR8DoXJQJXNwc01eoyYmJrM3NZfIlTPl9pgsl2uVVJdGuDy4l0bbZbFXabvjw4bz00ksArFixgrZt2xIfH8/VV1/NV199xbRp0y561k2ADz74gISEBBISEnjiiSe4/fbbAfDw8GDu3Lns3r2bpUuX8vTTT5OTk3PR+68LluQ5voAt8h6spiu+AjXkOltpOBITJ5Obu4bndnxLsgyhiU7yvFYL779PbL8kZs+GlSvhllugqMjV0SoNVZUSbSHEw8ACoHSO6DDglxqKqdYMiI8/6zbt+HEATDYbfbZu5Yu0NOzA56mpXLV1K7PT0gDItFi4cf/+Cs+9kJdeeonDhw8THR3N888/j5SSxx9/nPbt23PTTTeRkZEBwEcffURqaioDBw68YIvrxIkT6dKlC7179+bEiRMALF68uKz1dtCgQWXLs7KyGDx4MF27duWRRx4pm179xRdfrPAFYNKkSbz//vvnPe7SpUvp1q0bV111Fddddx0AhYWFPPDAA8TExNC1a1cWLlwIwOzZs7n99tsZMmQIrVu35oUXXigrj6KiIqKjo4l1DI7KN998Q8+ePYmOjuaRRx4pS6q9vLx45ZVX6NWrFxs2bDgrlrZt29KvXz9++umnsuWzZ8/m8ccfJyEhgRdeeIHff/+d6OhoXnvtNdauXcu//vUvnn/++fOe54V89913jB49GoCoqChat24NQJMmTQgJCeHkyZOXtX9XSDObSTIUALBMDGF32i+qVfsKU1/rbEUpZTankZ4+iyz8WcK1gCDbriVj8mTHZFsTJnDvvTBrFqxYoZJtxXWq2nXkMaAvkAcgpTwIhFzqQYUQfkKIBUKIfUKIvUKIPkKIACHEciHEQedf/3LbTxBCHBJC7BdC3HCpx71YSWYz0nlfOh9fjrfffpuWLVuSkJDAe++9x88//8z+/fvZuXMnM2bMYP16x5ieTz75JE2aNGHlypXnbXEtLCykd+/ebN++nWuuuYYZM2YA0K9fPzZu3Eh8fDyjRo3i3XffBeC1116jX79+xMfHM3z4cJKTkwEYNWpUhW4O33//PXfeeec5j3vy5EkefvhhfvzxR9avX88PP/wAwJQpU7j22mvZsmULK1eu5Pnnn6ewsBBwdKuYP38+O3fuZP78+Rw7doy3334bd3d3EhISiIuLY+/evcyfP59169aRkJCAVqslLi6u7Fw7duzIpk2b6Nfv9MyExcXFPPzwwyxevJg1a9aQnn52QhgdHc3rr7/OyJEjSUhI4NVXX6VHjx7ExcXx3nuX/mt6UlISR48e5dprrz1r3ebNm7FYLLRs2fKS9+8qkxMTkcLxyrehYY4cqVq1rzzVWmfDlVNvKw1DYuJkpLQyl3uxOVMZs93O+IIC5HPPwXffwcaNjB0LM2fCn3/CrbdCcbFr41YanqqOo22WUlqEc1pTIYQOynLQS/EhsFRKOUIIYQA8gJeBFVLKt4UQLwEvAS8KIdoDo4AOQBPgTyFElJSyav0HzmNV167nXJdrtZJttVZItLOtVoYEOAa/DzIY+L1NG7wv40Kx1atXM3r0aLRaLU2aNKk0YTsfg8FQ1h+5e/fuLF++HICUlBRGjhxJWloaFouF5s2blx2vtMX3pptuwt/f8ZnYtWtXMjIySE1N5eTJk/j7+xMeHl7JER02btzINddcQ/PmzcnPzyfAWSZ//PEHixYt4v/+7/8ARxJcmsxfd911lE6x3L59e5KSkmjWrFmF/a5YsYKtW7cSExMDQFFRESEhjtxAq9Vyxx1nj+W8b98+mjdvXtaSfM899zB9+vSLKsdLNW/ePEaMGIFWq62wPC0tjXvvvZc5c+ag0VT1u2zdkGY2Mys9/fT06xhYymDGpj1IRMR/MRobuThCpYqqu86GOlJvK4rZnMaJE7PIwoelDMXmvM7XDvyclUWnm27i6cOHuef553FbvZr77hNICQ8+CLfdBj//7BioRFFqQ1WzgL+FEC8D7kKI64EfgMWXckAhhA9wDfAVgJTSIqXMwTEM1RznZnOAW533bwHmSSnNUsqjwCGg56Uc+2JMTkzELit+LtmkrJa+2uWVfhBeCr1eX/Z8rVaL1WoF4IknnuDxxx9n586dfPHFFxSX+wp/ruONGDGCBQsWMH/+fEaNGnXe40opK92PlJIff/yxrP9ycnIy7dq1A8BoNJZtVz7WM58/duzYsufv37+fSZMmAeDm5laW0N5www1ER0fz0EMPnfecatq8efPKuo2UysvL46abbuKNN96gd+/eLonrckxOTMQmK/5vVKv2Fana6my4cuptpWFwtGbbmcu92KlY/2uxkVZi5qmHHqI4Ph7mz6fYZuP++2HGDFi6FG6/HaphfANFqZKqJtovAieBncAjwO/Afy7xmC2c+5olhIgXQnwphPAEQqWUaQDOv6U/c4YBx8o9P8W5rEZtyMvDckaibZGS9bm5l7xPb29v8vPzyx5fc801zJs3D5vNRlpaWoVuImduezFyc3MJC3MU0Zw5c8qWX3PNNWVdMZYsWUJ2dnbZulGjRjFv3jwWLFjAiBEjypa3bdv2rP336dOHv//+m6NHjwJw6tQpwJEAf/zxx2V9v+Or0G9dr9dTUlICOFq9FyxYUNZX/dSpUyRV8sVm2bJlJCQk8OWXX9K2bVuOHj3K4cOHAUef6Yt1/Pjxsn7mVbV//36ys7Pp06dP2TKLxcJtt93GmDFjztv1pi7bkJdHCRVb6B1TFrdT0xVfWaqzzoYrpN5WGoa8vA1IaWEPHbBiqLDOhpYA22GWN0/Et3Ur5Isv0m/bNobu2EHoLZl8Pl2yZIlKtpXac8GuI0IIDbBDStkRmFFNx+wGPCGl3CSE+BDHz43nDKGSZZX+BCqEGAeMAwgNDWXVqlUV1vv6+lY5eV1dSYJZqnQfNpvtopJhg8FAz549ad++Pddffz2TJ09m6dKldOjQgVatWtG3b1+KiorIz89nzJgx3HDDDTRq1IjffvvtgrEUFRVRUlJCfn4+L774IiNGjKBx48bExMSUxfnss8/ywAMPsGDBAvr27UuzZs0oKCjAaDQSHh5Obm4ujRo1wsvLi/z8fLKysio9Rzc3N6ZOncqtt96KzWYjJCSEhQsX8vTTT/PSSy/RsWNHpJSEh4fzww8/UFxcjMViKduP1WrFZDKRn5/PfffdR8eOHenSpQtfffUVEydOZNCgQdjtdvR6Pf/3f/9X1jXlXGU9depUhg4dSmBgIH369CE7O5v8/PwKxz0zBpvNRmFhIfn5+Rw6dOic+zeZTGVfWgAef/xxHn/88bILPAsKCsr2N2fOHFavXs3JkyeZOXMmAJ999hmdO3e+8IvjEhUXF5/1Or8cN/0Zwt6DQZgfTeL9A68Q8HwHej4RSMagQRQWfnDBYxUUFFRrPFciV5dBDdTZUEP19oXq7PNxdTmfj4rt0lQ9tg+Ac72404BPsCTFs+61NnS/9zg3Tp/OlzfcwLBTp2gaZuLqT0P5fUJnOnQoJj9fz8mTRkJCzDz00BEGDcq4zNhqn4rt0tVKfFLKC96AOCC8KttWYV+NgMRyj68GfgP2A42dyxoD+533JwATym2/DOhzoeN0795dnmnPnj1nLbsceXl51bq/umbx4sXyww8/PO829aEMPv74Y7lw4cLL2oeryqE6X9PffCOlh6FE8uIe6bfiJ/nccw9KDwrkN/r7HCurYOXKldUWz5WqOsoA+EdeXj1bbXW2rKV6u7I6+3zq8mtNxXZpqis2u90mU1I+lTt+7yrtOo2UIC1arZw/YIC85qOPJCtXyn5vpEqQEmF3/EVKD49zV3UNodxqQl2OTcrqi+98dXZVL4ZsDOwWQmwGCssl6cMvIqcvfU66EOKYEKKNlHI/cB2wx3kbC7zt/LvQ+ZRFwLdCiP/huKimNbD5Yo+rXLzSCy3ru8cff9zVIdQJEyeCyaJD2zaHNpr9HD3aEROeTCx5ldiJA8A5BKNyRai2Otv5PFVvK1cMITSEhY2nSd93EFY75kA4/KiNWz5fxV2rVrGzb19uOvG3Y+PbU+C6DPglDNPKYCZO1KqqTqlWVU20X6vm4z4BxDmvXD8C3I+jv/j3QogHgWTgTgAp5W4hxPc4KnQr8JhsYFeu9+rVC/MZncm+/vprOnXq5KKIlPooORnQ27A1M9Os+DhHjt7qWE64c6VyBanuOhtUva1cYUSy4zKB/NaQ2RdO9YRWn0DH5etIKb0WJccAnlaYsA8ePUzS741JKm5ChBqWRKkm5020hRBuwL+AVjguqvlKSnn2cBEXSUqZAPSoZFWlV6RJKacAUy73uM59uWyUiku1adMmV4eg1EFSVnqpwiULD4ckt0LQwoLXX4FtQY7lJDtWKnVeTdXZ4Np6W1EuSXg4JCURtBF6PAj7X4R9E+DkEHc6zU5jx47GsCIUVoRAt2y4NRVGJfPAvjxWREcDV2bOoNQtFxp1ZA6OinUnMBQ4/3SBdZybmxtZWVnVnqAoSm2TUpKVlYVbNba6TJkCbvkatIeNTBj1CP7+J/CgkCn61xwrlStBvaqzFeWyTJkCHh4AeKRC9DPQ8hPI7mLlzTcn4eEBAQFpfPDBAPyPWuCVjvT5qDcftGwFOOYV6LRlCx+mpFDgfNw/Pp50NVyJchEu1HWkvZSyE4AQ4iuu8D52TZs2JSUlpdqmxS4uLq7WROdKpMrAwRXl4ObmRtOmTattf7GxMMv3OH95FrGHcB4b8zxtv/En9sNBqn/2laNe1dmKcllK662JEyE5GdGoMc1+O0VgQUv0P7zC9OmQlPQcnTuvYfz4yezc+SmLFrrx1X9g6lQ4WVKCj07H04cO4QY0376dfSYTk5OS+DQqypVnplxBLpRol5TekVJar/SfT/R6fdksidVh1apVdD3P7JINgSoDh/pQDmlmM6u905BSw1KGMHbYGG58Zweo2SCvJPWqzlaUyxYbW7GhYPFiPIYPh8dfZsQXb7Fh4zxAMnjwTP773//y0kuNmDoV3N3hrbe8WN+tG9vy83lu61ZWmkwAzExL478RETQqNxGbopzLhbqOdBFC5Dlv+UDn0vtCiLzaCFBRlNoxOTERq7NblQ0Nc8TdajbIK4+qsxXlfIYNg0mTYO5cEn+7CyEcF0Xa7cUcPfof/vc/+Ne/4J134PXXHU/p5u2NN2BwfnG1Q7XPEq3UX+dNtKWUWimlj/PmLaXUlbvvU1tBKopSs9LMZmalpyOd84xYMbBUM4Tdab9gNqe7ODqlqlSdrShV8N//Yh49mBNe65Cy7Ecg0tNnUVx8hE8/hfvuc+Tj777rqB+XQtls0RYp+TItjRmpqS4JX7myVHUKdkVR6rHJiYnYzhicwoaGOXKkatVWFKV+0WhIfLkZ8qwMyM7OncPRaODLL2HUKHjxRbhzcSL2M7YskZJxBw7wfUblM0kqSqmqjqOtKEo9tiEvj5LScWWdrBjYTTtyc6e5KCpFUZSakVe0FamvbI3jVz2tFubOBbMZfs7Og6CKW0nAU6Ph7j17kMDIkJAajli5UqlEW1EU4mNiALBJicffa7DMbcaSrZ8zZPs7wMOuDU5RFKWaxcTEO+4sWgS33AJjx8KsWSAEdruFjIx5hIbey3ffCW6/PYYlSyRz5gjuvff0PgqsVm7audORbEvJqNBQ15yMUqepriOKopTRCsHa4KtgVnOyCw2uDkdRFKVmDR8Or74Kc+bAp58CkJ4+h337xpKUNBmjEX78Ebp2zeG+++D7708/1Uun47dOnejn68uqnByXhK/UffUu0RZCDBNCTM/NzXV1KIpyRWril8vs2e2wx+x2dShKA6DqbMXlXnnFMRrJM8/A6tU0bvwgoaFjSEx8lePHp+HmBm+8sZO+feHuu2HhwtNP9dLpWNq5M9Oc42qb7Wf25lYaunqXaEspF0spx/n6+ro6FEW5Iu3VCWY2G4WpcZGrQ1EaAFVnKy6n0cDXX0PLljBiBCLlOG3afElg4DAOHnycEyfm4e5u59dfoUcPuOsuWLr09NPdtVo0QpBSXEyHzZv5Jl2N1KScVu8SbUVRLk+BxsZqTX/eufEOkvJTXB2OoihKzfP1hV9+geJiuOMONBYb7dvPx9e3H4cOPQGkcPhwfxYtSqd9e7jtNvjrr4q78NfrCXdzY+y+fXyTnq6mbFcAlWgrinKG9p6eABzWtuDlvUsvsLWiKEo90bato2V7yxZ49FG0Gjc6dlxEly5/AT+Qm7uWnJzJLF/uaPweNgzWrTv9dE+tll87daK/nx9j9+3jnr17WZubqya3aeBUoq0oSgV/vLEcpAShYUFhMz6bsMjVISmKotSOW25x9NmePRvuvx9962j0kZ0RJYsAO+nps/D2TufPP6FpUxg6FCZPhshIRw+U9i213LOnE24aDX/l5GAHZqWnq1btBkwl2oqilIkbv5YvW50oe2xH8EXrdOLGr3VhVIqiKLXo1VchOtoxEklSErv/C9I5GLK0lZCUNJlGjWDFCjAaHXl5UhJIKUkqLuKJh7XE5IWUJVg2KVWrdgOmEm1FUcpM+dPI3uYRIJxTsQsDe5tHMGW5m4sjUxRFqSUaDWRlAXBsBOR1oXQeG6Swkp4+C7M5naZNHYk2AO1y4ZN4+CQek6+J1YaMstkkLVKqVu0GTCXaiqKU0b2UgL30E8XJjkA/IcE1ASmKotQWux0SEuDdd+HYMU4MhMPj4cz51+12G6tWTebf/4bjlmJ4eQ9Mi4dGxfBVcxh5DIms8BzVqt1wqZkhFUUpk9vEDauoOFGNVRjIaWI8xzMURVGuYOnpsHw5/PGH4+8JR9c5qdeRcZ0VTRHYPc58koXk5PV8/JMJ5v4DGgnfhMO34VCkg9tTwFAx0bZIyXo1VnyDpBJtRVHKvLmoOeM+60r4vWvQPnAI84sxpG7uyJuP6mCIq6NTFEW5TMXFsHatI7H+4w/Yvt2xPDgYrr8e26Ab2Nn0BtZ+k8y6Nw6xWXTjSFEbAHzJ4aroAqLu82NEdy9y90jGLA/n16dCKU50LzuEx9MxTJ8OsbGuOEGlrlGJtqIoZWKn9QPW8l6Ole10JDrsBNMfLXEuVxRFucJICXv2nE6s//4biopAr4d+/Sh+/V22NBnOmvTWrF2nIWfGGkaOvItXfvkJb/cOXG3+k3/zETEBeyiZ9ijPtmrJF4VHeD6mF+5GIz8MjyQuHyZOhORkCA+HKVNUkq2cphJtRVEqiJ3Wj+YZ8fTdk0vmv/Lp16ebq0NSFEWpusxM+PPP08n18eOO5W3bkjPmSdY1uoO1+V1Ys8nAljfAyyuN//53IB4eL/HMMyOBJizdUsxLhcl80P4GSuRg7t+4kRVAY7OZL6KiaGw43cUuNlYl1sq5qURbUZSzRLj7A7mk6Jvw8p4lxPV62NUhKYqiVM5igQ0bTifWW7c6WrL9/Um56i7W3DiStcU9WJPgza7pjlU6HXTvDk8+CYMGTcZoXEPXrhsxGsPo2nUFzyQWsDY3l5ePHOH7kycpAf4TEcGLzZrhpVOpk1J16tWiKMpZim1m56Q1gh+LwnkzP4UI76auDktRFMVRNx08eDqxXrkSCgqQGi17o0ezdtgk1lh6sXZfIIm/OUZR8vKCPn1gxAi4+mro2dOGm5sFqzWHjRtnIqUkX+opCY9jWoadGenp2IF5J08yOTKSsCNHGNW8uWvPW7kiqURbUZSz/OfAGgQtkAhsUvDy3qXE9XzI1WEpitJQZWfDX385EutlyyApCQt6toUNZ22nOayx9WHdoVCytmlgG4SEOBLqp56Cfv2sRET8RXHxTgoKdpFUkMz0f0zcFDEMaU5hobyJuYwmiyA4YAYOlx3WJiVHiovp7rozV65w9S7RFkIMA4a1atXK1aEoyhUpMf8YP5maIYVjmH2rMPCjqZlq1VZqhKqzlUpZrbB58+nEevNm8u0ebPS4jjXN3mVNVF82JTem6LgGjkOrVnD7Hbn077+LDh12YXTfhbtHKyKbPcXm3HzGxK8iiaYkcyeFOMbri9Zkoz0xmUC60YN/iCAJfwqZKv6NWTqG5yudbOY6V5aFckWrd4m2lHIxsLhHjx6qU6miXIIJe5dhJ7zCMhuqVVupGarOVkq5paXB5587kusVKziR58ZacQ1rQp9mbWg/EjKaYDMJjIlmrr9+LxPuOUC7dgPp0LuEX44/wb4iMzOIIDknnJSc4XwasIGHm0GW1U6C/gbaengw0NOXdh4etPP0xC/9FfKknb6spy/rAfiAZ7FLK6Ati8smJXOB211TLMoVrt4l2oqiXJ5tRW5YOWPSGgz8U6SmYVcUpRrl5cGqVbBsGXLZHwQdlsziatZ6jmSN9jMOEgJS4JYDYx//muF9tpDvX0iyMJJMMzT6eEb0HcjOAjMvHxqFBkmEQdLOw5M7vALp06gPAEMCAkjr2/+sw285tBYpLRWW7aEtJeWSbHC0au+uqTJQ6j2VaCuKUsH+/vcAIKWdjn99QU5+IPt6DsW7yQDXBqYoypXNZoNt22DZMmzL/mT7BhNrbH1Yqx3E9oCn8e6eSONO+/DrvJ2rWm7gXo+9DPL8nZZd7IRubgY0A8CAjVZGOyFNBgPQ1sODHT160NrdHTet9qzDCiEqDScmJv6sZQfPEfqqVasu5YwVRSXaiqJUTggNXYsyifNtQ5+9C/jN+3rVR1tRlCoxm9P4e9dDTLa8xA/7D+O7+E82Lc9jgz2K/S2bkB49Cv8BKfz24bME+Puj//gX9vkY2EYnoBMAt3p0Z0K3InQ6L6a2bElLd3faeXoS6eaGtlzyrNdo6OTl5aIzVZTzU4m2oijnNMjHjzi7hj2aCNVHW1GUCysshL//Zv/xiXzSagDrKCE6oQXuze4l5PvtnHAL4ThhWNHTXkq2jU2kVasAxu1pSmZGIgOat6KTTwjtPDwINfQva41+qlkzF5+YolwalWgrinJOBX95Q3+JFBoWFDaj34RFPPrWcFeHpShKLYsbv5aJ0yNJtjUhXJvKlHGJxE7rB3Y7bN/O4QV/82v2QbaFu5PS2oekVuM5LFoCGk7eJGmV58lxYxvaGG0M95Z09g2iq28srXx8AJjePoZVGYUMiGjj2hNVlGqmEm1FUSoVN34tX/awoMGGHR12BF+0Tsdn/FrHB6yiKA1C3Pi1jPusKyY8ATiuCeLN7YdY9uprhP5Vwvy14zj5fH+K74oGwF0W4UEhGiR2QKu3cl2nxkyLUvWG0vCoRFtRlEpN+dPI4TsjsAtHNWEVBvY2j2DKW27Eujg2RVFqz4TpzTGFQcyLn1Mcaee4Vyh7RCB76M84zUL6WOw0bRqKl7GIYa0DSdx1HbF8hd05ekcJWmanp/FKRASNjEYXn42i1C6VaCuKUindSwnYiaiwzI5APyEB6OGSmBRFqVkFpmyWrF/Cn+kp7PIwEHN0J8dsX0KzU2zp1JaQ4pMEJhbjt9tE1rooPlr7PsZXNc5nN2H//vF8zUjsVBzpw2q3MjkpiU+jomr/pBTFhVSirShKpXKbuGEVZ4ynLQzkNFEtUopSH1jtdrLSdpGxKI9f/87ms7tNpHoHYtM1gaZN8LeeooUmAx/yydvqBzf3JaNQT4bz+RHaFIxaTYV95uVtYA/jzxqLvwQt63Nza+fEFKUOUYm2oiiVenNRc2e/TA8C/vyJYps7Lx/4iBZHHoUhro5OUZTKJOYf446EFfwUPajCcJxSSg4XZLLy1A6m/bSLXUYPjno05ib5G7//+y2KrJ6EDv6da07so12+Fze07MoNN/THOOh24g46+2iXeJbtz4NCpoxLBCoO+RkTE3/OsagVpSFSibaiKJVyXPDoGGkgz6zD5O7Olg5tuXPwH8Atrg5PUZRKTNi7jHhbC57d8wexoR05tncDTRb4sWZVAF9+bKAooDN6LIQXp9A1+SB+iS344pl9XDWyPS063Uxlc7uUrwvOGnVEUZTzUom2oijnFDutH9d+YKbpOm8QgiUMZWzaA0RE/BejsZGrw1MUpZx34//k+8LmSKHhp6IW/JRoopm7P80PebDl6CA6z95AlyY7uKl9f66+YxD+gZoL79Qpdlo/YqeVPmrKmS3ZiqJUrt4l2kKIYcCwVq1auToURakXJicmAhIAG1rmyJF0SJpMVNSnLo1LqR9UnX1xpJTsKzjF3xk7WXMskd3Fdh76fgcLvxtB/A952D39AdBIK9H5+7h3TTh9/9OX6AHu6PXXsmqVhgEDurj4LBSl4aj619krhJRysZRynK+vr6tDUZQrXprZzKz0dOwaxzBdNnQsZTC7037BbE53cXRKfaDq7PPLtBRTaD6JzMnlnR//wmfl77TfupNHj8EvBGMVRSw1tSa/jY58T09K+37YhY7dPq257ZVuxFwfiF7v4hNRlAaq3rVoK4pSfSYnJmKTVnCOhwtgQ6NatRWlBljsdrZkH2X1yX1sPHmSrRZPjmuDeXnfp8x+dCqp0V3p/MwC/I8X0eiAJx2tzek1+A56fRHKI/u/YqspvML+bAhe3ruUuJ4PueiMFEVRibaiKOe0IS+PknJJNoAVA7tpR27utHM8S1GUC5FScrAwi9UZO4m0JdH9cDu+WpXO80N8AU8CZRHNTGlEJKWzbeVN9O90ir798unb8m463u2J7oxP721FbmcNqWfFwD9FbrV3UoqinEUl2oqinFN8TAwAiUclfTf/iG9IBrsHPIIQA4CHXRmaolxxim02Xj+wig1ZKSSU+JMjfADBKNsGbhw+ihLRg/Dja2ifkU1beyR9bujJVXeG0fRx7QX3vb//PTV/AoqiXDSVaCuKckHNwgUsMXAgtDV//HM9Azp/q0YdURSnM8eutiHZkLmftZn72ZiXQ6BpL/etaMX6Je58+EYAAXoNLbOS0B0yYv0nFNPhsbxy5xH63t6ImBsG4OXl6jNSFKW6qERbUZQL0mqhwNMTG1o+LuxKc9U/W1HKvLhnKfG2lry8dyk2bQQLpY3iXWmAD77STvQpb2K/6UViYkdajknkqvCm9L3Onb4jm9H+JQOaejcsgaIopVSirSjKBX3ynZm8MMfP138wmB1H7yFia3uMox9zcWSKUgvi4oh7ahMTs54lmXDCA0288ZEdXa/lTEvJYo29NQjBgsJmNPnDQoc2Scg9vuSua0nw0XZ0j47iyRcCuOpWSaPGka4+G0VRapFKtBVFOa+4OHh621HETXYkGiQa5ujuxW3Lx9xs94PYWFeHqCg1Jy6OuPv/ZFzJJ5jwRBtcQKv3PuK5xi04cawReumFBjt2tNgRhHVMpHtcJ0Y82Z0er3ni7u7qE1AUxZXUD1aKopzXi++asQ0+gXT+vm1Fz3LtYAoG52F+9yUXR6coNavkzZf4bVB7bh77EQC2SAsrIq5Cn6Gl1S+FCMAuHL/2WIWBf8Ja0f+FLK4eopJsRVFUoq0oygUcvzYRjc5aYZkNDXH6USQNTHFRVIpScyyWTFJTv2Tpplt5+ONBLH8hkvzb8tFobPCPP8T2ImXUnbh3TsPunCCmlA3BXJJdFLmiKHWN6jqiKMp56aPzKNGePZb2Pm07cruq6eaU+sFiOYFO54dGY2Tunjl8mVPCZvkkUgg8dulY8vWzYHe+D1IdTdW5YZWPXb0b/9oOX1GUOsolLdpCiGeEELuFELuEEN8JIdyEEAFCiOVCiIPOv/7ltp8ghDgkhNgvhLjBFTErSkM1SxeDxw39EN81AWBq+nOE3R7OpMHridHNcnF0Sm2oD3W22ZxGfHx/zOZ0ANLMZq7euoltiZ8THz+Ahes7cSptEbz1Fj/9LtiR3QP5dSStn2zDk09vxGNzxX4gHgYrb2begxww4KzbDMIrC0FRlAao1hNtIUQY8CTQQ0rZEcfczqOAl4AVUsrWwArnY4QQ7Z3rOwBDgGlCiAuP3q8oSrWIjYXpM3XoYrIB+Cu0H5+Pu5XYWYPUhZANQH2psxMTJ5Obu5akpMlYLJk8tXUq6/ILeSQxj3/lj+Quvif+vmk88nIAS98Zj/tD/fm0Rwv2xDfhrTlNmB44gQgSEdiJCCxg+kydevkrinJBruqjrQPchRA6wANIBW4B5jjXzwFudd6/BZgnpTRLKY8Ch4CetRuuojRs144wY29ZBMAyMYSSoVmYR1zn4qiUWnRF19nFxamkp38F2ElPn8VhUyE/WXog0fAPPTl+MpQbZu7j9vifmKl9mCfvd+PQIT3jx+OY6jw2ltjMj0iUkdilhsRML5VkK4pSJUJKWfsHFeIpYApQBPwhpYwVQuRIKf3KbZMtpfQXQnwCbJRSfuNc/hWwREq5oJL9jgPGAYSGhnafN29ejZ5HQUEBXg18Ci9VBg71vRw+AH6VduxCgw4LN7GEpzkKPF1hu/peDlVRHWUwcODArVLKHtUU0mWri3V21cs5EXgBOOl8rOMd+QFL6QBCoLXa8FjiS/7/etCrZxbjHztMeLipynFcXmy1T8V2aVRsl6YuxwbVF9/56uxavxjS2Y/vFqA5kAP8IIS453xPqWRZpd8OpJTTgekAPXr0kAMGDLisWC9k1apV1PQx6jpVBg71uRzSzGb+2LgRO6XD+xlYyg2MFQ9yY++2FaZir8/lUFX1rQzqap19oXIuKckmMXESx49/AtjZQzt+50bGMpu/cEwwA2DTaSm4wcQ3g8zEDg0EAqscw6XG5koqtkujYrs0dTk2qJ34XDHqyCDgqJTyJIAQ4ifgKuCEEKKxlDJNCNEYyHBunwI0K/f8pjh+tlQUpRZMTkzEJq04uuY62NAwR46kg5qKvSG4Iuvs4uKjpKZOI9+tNx8VX8efXEsgmRRjxH7GdwG9UbK+cRKxRNV2mIqi1HOu6KOdDPQWQngIIQRwHbAXWASMdW4zFljovL8IGCWEMAohmgOtgc21HLOiNFgb8vIo4ezh/XbTjtzc9S6KSqlFV0ydnZ29ksTENwDQe3RhedhW7ix+lb/pxz18zdfcSxKRWEXFIfksUrI+N7c2QlQUpYGp9RZtKeUmIcQCYBtgBeJx/HToBXwvhHgQR8V+p3P73UKI74E9zu0fk1LaajtuRWmo4mNiADhy3Ma9694nPSiIv2IGE+E9AHjYpbEpNa8u19lmcxp79oyiRYv32Jb0CU+f6sabxgU0bfo0Yl8i8w8d4dZt2xgal8I7Be/xTcZXDBoEP38AHTvWRESKoigVuWTCGinlq8CrZyw242gpqWz7KTguxFEUxUWWvbqZ9bGOpPuOHxbzzD+diJ3Wz8VRKbWhrtbZiYmvkJu7hvhtvfnQ9hQ7tZ25L3ky7kPySMlrT6inL/u8ejH/RGNatYKFM2DYsLLu2YqiKDVOTcGuKMoFxY1fy2srnReJCcHO5i14bmkocePXujYwpQHLIj39a0CSZffnd3EjUmjIDPXm2GgT0k2SXtiM7ScaM3o07NoFw4erJFtRlNqlEm1FUS5o4vRIgieuLntsRxDyn7+ZOD3SdUEpDdxcSgczmcu9yNLLCKSEUSm4T95ctv63vy2sXAknTrgkUEVRGjCXdB1RFOXKkhdhI7V5eFlzoFUY2Ne8GR7hdhdHpjREZnMasBQpLWQRwFLtUKzoHSuFQI+F//aYQFyH99l9oht5czdy0z5P7DMbEbLdjRgfG117Gek6wJeu3TVERqqWbkVRaoZq0VYU5YJa/Od3bGdUF3YELf/zm4siUhqyxMTJgONL3lzuPWu4vpISA18kvMC+fTFg03DVgT00b78dxh8m44vdrH5mB2/9ZeOOOzW0aAEBboUM77GFGd8Not3v6/h7hxmr1QUnpihKvaNatBVFuaCcZp7YRcXqwioM5IR7uigipSHLy9uAY0AT2EMHrFQcrg89JHk2BZseDzM8FdiHmMhf2JX5I8sKvVjfpA+vTX2M0JmPMF0XyKamfgR5/83CRl3Yh4UBM5Nw+ziCzkFpdI0qpFtvA12HhNKprw9ubrV/voqiXLlUoq0oygX92Wsgbf7Zg0UYMUgzLccFMvH6YmKnjXF1aEoDFBMTXzaj20GAuDiYOBGSk4kLeJyJvEnyKS/CI2DKFLjrrq5AV5o3hyElp8jO/gur9TmazHuE5UlJxB3dxy5uxdGnW6C55RjPHp/L+p8H801mSxZuy6BosRFTkpY2ugy6hmfRtbOdrgN8ib65KX5h6gunoiiVU4m2oigX9OyupVhoBYBdCLrGJRDb8yEXR6UoTrGxjhsQ67ydi14fQEjIiLLHL4c3Y2DmWJ7NH8JmYpBokUJw9PkIVn5/NX03bmS92QzkAkdIlPm4F+2naJaWZ//1DOL2ZPpf9SVBhRaaSWgX4EGAsYiSXh3QuwfX5FkrinIFUIm2oijnlZh/jEXFzU9fCImBH03NeDM/hQjvpi6OTlEuj8VyghMFB4hnAtI5A6pEwy9FUaRbLHzesT07MlaRajaRZjFzwmIl0NPG40/Cg23XcW+3Ilb5d6mwzz6sZ9mDU0lZPISj7+QS3GoPIaKIxu6Sxh5udPQQDAy7Hm/vbpRYCzAXH0avD0GvD0Kj0buiGBRFqSEq0VYU5ZzM5jQe3Dobm6g4MY0Nwct7lxKnWrWVK1xi4mRmy9FnXVBplVYmJyXxaVQUnbxvqfS5UVdDhpRkl1g4ZjrJoRPpxO85RuYuA8aMKFJEGEdK9GSWtGaL0Z1iqxvkwbDcRVg+/ZSW7v3pNbQpPuIUAWwikCwCRQHX6vdxf7vxePsOZPXJXehyF9HEzQdvYxB6fTB6fTAeHlFotR5lsaSZzYzas4f57dvTyGgsW146e2b79vMxGhvVTCEqinJO9S7RFkIMA4a1atXK1aEoyhUvMXEy6xgOZyYhGPinSF0Vplw+V9fZeXkb2MP4sy6oLEHL+tzcCz5fCEGAwUiAoSld/JpyR5serPJfxYD/DgCguLgFuzYVEr/0BFv+KWbLCT3LM17ht5Ne2HUCj4JdBLTMRBvgzgn/5hzw9KRVoQXdzkTSojK4bt8pwPFF15s8AjjOGN7i2ejXsXn24pNDfyBOfccqe2/W2Drw7PY5vBGURNOmT6LXh3D48LPk5q4lKWkyUVGfVnfxKYpyAfUu0ZZSLgYW9+jR42FXx6IoVzKzOY09qT9hEc7+rGZB08c68/Zr/qXdYRXlsrm6zo6JiXdcUFlD3NygR39PevRvQekJ2mywfz/E/51H/KoA4lf0IT4pgGyz46LKj7mR5eyjk9sKHuxzCr+2EkMnPVnN/EjzCcKe9ThXXdWBvcIEn3oCp39Z+qkwnBGmlyguTiQ3dx1mcxIA6emziIj4bw2eqaIolal3ibaiKNUjcfm9zHYfjUZrx4YGjc5Kys0nGfeAN6BTybaiXCKtFtq3h/btfYh91AdwTGiZnAzbtkriVxcQvyGYtfuHc3ylN6x0PC+CRILJYCnRlGAAow1ydeBpRYMdu06DXWqYK8bw9ImPMBjDAC1gQ0obSUmTgTtdddqK0iCpCWsURTlLkek4u/TbWaodgs35fdyu1aIbnog+LJ2JE10coKLUM0JARATcdrvg9am+LN4UQkqONxkZsGwZvP2mnV5jislevAdjzxRAEuSdTvdthxES7DrHx3mJxsDSkhvxfLkd1uITgA0AKS2kp88CTrnsHBWlIVKJtqIoAJjzLSydspV/tV/N5IkTma0bc9YFYjahJeI/S0lOdlGQitLABAfD4MHw4gQNcvw6DntGUPB2IvfPepT585sRNjAeIewVnmOWRh56+BmKrWe8f80WLBtfJ3vKNFi6FBITwV7xuYqiVC/VdURRGrDc1EJ+f28XC3+283tSB/LpjicFzHrhIX7QPn/WBWJSaMmJ1NGpUzqgRjBQlNqyIzuRH4pagBBosBNl3M3s2a/x+7UDsUeeMV+8QVIQpsVgsFRYLPQ2kgIFN4wbTyCZtOYgUdq1tA7OoXVzG1Gd3WjdJwiv6FYQFQXu7rV4hopSP6lEW1EamOO7sln07j5+WerGypMdKKEXISKDkVHx3DrSjeue6Yyb/wHujItj4tRlvDfpOko8HVWFDgud5Q4embIFUCMYKEpNs9tLOHEijieP6oEwADTSxndFY9nx9UPwNXhQyHQeJpbvHE/y8IDp0yFWlu3HbIYjR2Ddup28N6mQg1tLOHggghXH2zE33Q/SgQ3AF9CINKLYTGuvdFo3KSSqjaB1Vy9a9muMe3QbCAoqG1dfUZTzU4m2otRzUsK+Ven88sFRfvnbj8157YA+tNId5eluq7n1/gDCx7Yl9pAPHVsFsffQENp7zGfx9dfzZliYYwdOVgws1w7mAe8HMZv/q8blVZRqVn7ca4vlOPv3P0RSQTJrmVe2jVUY2Ne8GX4tUvC1NWXKjfHE/r4ekgWEhzvmnT/jamWjEdq1g759sxgwoBNwetr4wkI4dAgO7jZzcNMpDmwv5uDR5iw+EU3GAV84ACwGgZ1mHKO1bjVRgVm0jrDQur2eqN4BNL+mGfrWkaBTaYWilKfeEYpSD9ntsHF+Er98nsYvm5pw0BwONCLGbQdT+v/BreOb0G5EB4SmOQDj9+9nbW4uz+6JZ1DRSey7bqeVWyv6+jzN5rxsSpwz5gHY0DBHjqSDGpdXUapdYuJkcnPXsmPHUAoLd2AwhDLfMBG7peIlVXYhuPG70kmj+gGJl3xMT0/o0gW6dDHC3Y0rrMvNhYP77RzcmMWBLbkc3FvCgeQIvsvqRs4Jb9gMzAYtViJJIsrrOK1D82ndShIV7U7rq0II798cra/XJcenKFcylWgrSj1RXCT5a/ohfpmdw6KdzTlhi0BHE6712cozQ/Yy/NlWhF3TGehc9hwpJftNJmamp2MHfipqzhpe5bv8uwnS+VBgs1ZIssHRqr2bduTmTqvdE1SUes5sTuPEiVmAncLCBLy8utOmzRds3bqvbHr4UlYMbCzy5FRJCf46HaKGunL4+kKPnhp69AwGgsuWSwlZWXDgnzwOrsvgYEIhBw4KDqY1ZfWRUAoPe8Iyx7YGzLTUHaC1fyatmxYR1VZL6+4+tO7fhLBuoQiN6oai1F8q0VaUK0Tc+LVMnB5Jsq0J4dpUpoxL5MbXevP71AP88r2ZpYdbUyBb400eQ0O2cutQC/3+3Z6syA4kFeXxXc5uUnbsIMVs5jmv9XhajzJf/xRT0k9XAwJJR3ahRYO7ewsSuvQ8RzQDADUnlKJUp8TEyUh5ehSQgoKtbN3ag448RTLBZ12cfEQ2JnDdOja4P45O68ZH9gf4zdIZD60Wne0URsz4akqIC9mIRuPGt8U9WE0g8/bvB/MRjMJKoE7DYyECjcad9cUBFGgb46HRoLVl46HV46/3oJO3PxqNnlyrFS3grtWiFYKgIAga4sNVQ3wqxCUlpCWaObg6zdEVZZeZg4l6DpxsxLL4Jpjj3SjrTk4hrdxTiQrJJtjPxNF+W4m6KojW/ZsQ3ER/dlfwuDjintrExKxnSSac8EATUz70UuP6K3WWSrQV5QoQN34t4z7risnZrzLJ1pSHvvJD+0sWhS2C8Y8+Ts9nZiOa6cjx9eJ295+JsG3je+1rPLc13LkXAxq0BJHJbea1tHGTtPcwoRO+WJ39sCUa1tOXU3ijSZ9NRMQrqh+2otSC0tZsKU+PFCKEAa+ID1iW1BarPN11xCAE/wlIButxim12vNzaYrcX0VXm4eMXgsluJ+3UdgqsJrS2EtLSvsJuL2aP/g12EsiOzEzyS8CMO4Fkcc2JUQC8qZ/F+pLsCnGFk8Qc7gO0PKePY2tJKAB6rBgpobM2iU+956PRuPNaySNkasLx0GiwFe3CvR106GLiMf9MNBp3vjP3wK7TUpyST37KNgqPW7EdsmHbpudwZiOW2Tvw2W9B8DPo7SbcCu20NpykTYiJ1lEQpT3C4YWHedv2NkV4AJCU5cW4B6yoSbSUukol2opSwxLzj3FHwgp+ih5EhHfTC25fYrdiMqcjStLIsulZWBDIK3gRHvcDxd5a8t08eMQ6nevd/+DTNf9lwdXXkg2spg3BZBFKPlbhho9PX6718+fH4A400Wvxs+6jmWcT3I1Xo9GMBGDm/v1oSK9wfBsa5jKGZ+RnJKl+2IpSK85szS71fobB2W1EVliebuzFp52iKizrXOFR23L3XwTgGmnn779XM6BvX8zm49hshVhswWjkRmy2ImbZfbC6tcFks5GSuYRCaxFaaSbS+Dp2ezGP2IzkGFtQZLeTnPELRXZJiMhGShslJScxUoxGCLKsFrKKSzBjoMh0lME5bwHwgXYJ6bajjpAahUMj6N99FZNGvgbAzXIZCMf6EuctyPYHdxdOo9jsyT3GOZjvvB6dbRtN/ZPR2Wx0zDhI16QD7NpjJGbG7RjMAfi4F+EXcAgvvZYe+mL6+oI+0J9tHj3xdQtGbzehtabgoTUQZvQk2OgJwohN44uHzlBj3XCqKs1sZtSePcxv3x5/TpVdHKsaPa5MKtFWlBo2Ye8y4m0teHnvUqZH30FiQQqUnCBQHidfevFJQWdSzGYOZO/khM1IFr6MZxp38BM53vfxTP5YGK7hlMYDv5I8mp4q4OC+3iQd7M/+g73Z+nR3mhqN+Iki9Dof54fE6W4dXcvuXXVWbBvy8rDIih/gjj7YHZDSQm7u+horF0VRTsvL21ChNRscszluLXI76z1qkZL1ubkXfQwhTreKG42OoQI9yq33L3e/h8/Is57fovyDyKfPWv9thUcxgOM6ELv9Fez2YhLRYtV4UGg1k1mwm8KSYoz0o4luEXZ7Ef/Zk02L9gPJL8kj/dRqTHY7LbV+tNHfgyUrg5tXreHH/JHo/fLx9irAptXg5Z1Nq1YJ2IySD4xjMAuBxs2ANLZFosHKLNoUz+Xk8SDu5geo0LBg5lHe4S5+4BhNGcPXABhsNtw0hRix8Kiczw26eJJsIfTf+h5eem+0tkwoPoCbkNzlmUgXtyLS7X6sN4zG2+CDxpKCtBzGU6Onu6cg1GCkQLpT6NYdL707WmsORgrx1Lmj13qg1bojxOkEf3JiImtzc5mclMSTciq5uWtVo8cVrN4l2kKIYcCwVq1auToUpYGTUrLz5AZ+MEUi0fCtqSXfrt8OwEgW8C++QOfVh1lF79DUaCRApyHKcIowQy59GcLOWVcx4/c+kBGDId9KBu5kOPe93fk3QptCN29v5yPDmSFcUHxMzDnWDED1wVZqg6qzHWJi4itdvr+W46huQgi0Wje0WjcAjICn1oMQ49l1T+89qxgQEgKEQNjZr4cFd0cSmXQ/SbRnL70Ax8iD84CIcElhQj75KblkpxSSdSiXzMw8crNvJyn7BrILzYwzF5JV6IHJUISmcRrFOkFqVn++KOhNobceD89ATDYvPBulEtYiCbseDqW3AJOGbF8PNntIbKIQjwAzBv9ASoSetpkL8dGsY5uhExN01wInnNE2AeAdXqAnW1jN1bzK62ed00c8QSd28TfXMNftbXRCw8EiExLB56kpdGQl7bDzZ+oq4rQ78Tf4gSkBfUkSPjoDfTwlkExiRiE+/oPx1mqxl5xAShtarRdarRcaTb1L9a4o9a70pZSLgcU9evRQWYLiEna7lbSTP5J27F1eLxiAjZsBxxi07TSpPBTqTQ+f0XT3fQ6jsQl52tI2pZ4kbcng/XGHuf+fLhThwS1+f/PF839zJNXIuM+7lfXRBsdFRFPGJQIX7o6iKHWVqrOVKpsyhSn3v8a4kk8q1oUGK1Pe1KH198HP3we/TtD8Inct7ZLinGKyk/PJSWlM9nFfslMt5GS0JzvTSt7hLB4VkJMvyS4IItsURk6xO3NKZvKh1Ys84Q1uNjDaMHibcPfPQe9VzKenvuQrmwVdaD4+xka4GcyENkvCPywdjbuNk8eu5YA2mpKmgQQb8zjaTAfeGhBgl4KfuI2J4i1204Fpx7KALMAb6AjA99xJMJm8se9ffGV3lIkBK+4U4IGJGTyMt0ayQj+G/T5P4K3TYctfi8GahrdWcL/XIfQ6b45p26MLGIW3Vostfx0ewoSv3tPRgq/1Qq8PLPsVRLk49S7RVpTaYjan8feuh5jMKzwD2Gwmth37hv87lsRqW0c+MehYxmDA8XOgRMthewi3N+lwVl/tnT8e4J0Xsph3JAYNfsSGr+X5N3xpf881IAR9AMTZo47ETutX26etKIriGrGxxAI8NaHaRx0RGoF7gDvuAe40iQ45a/2qVasYMODc9a3VCrmZkpwUE9kpheSklpB9wkpOhpXsTEn2KU9ysvPJztOSk9CcbFNbss3ufF4ykmyrN1b0EGCGbzeBcPbVF4I1XMMpPudOfuCm4t957ZFFCLsRD18TXiH5bM5+Gy9jBiHRvsSG5CH8tNhCT2HxLqHYTUtz3T0Y3Eswiy7E5+eTb7eTWxKBSbZEi43bSr7Abs9nqvgPi5MTnGfjBrjhSQG/0heAzw3vsEs3AB+dDnvBRtxkDo00eTxrXIRW680m490I/xF4a7UUZn6LpyghSK/FjaOkph5C696WEL++CCHIz09Aq/VAq/V23jwqdGuqSeX7vzcyGiusKz9ZVHX2h1eJtqJcosTEyXyaH8U6TBgRLNobT1xmcyQtudPPSlzxI9ipeFGNDcHLex2TTEi7ZM37m3nnHfg9qxeeFPBU9Gqe+ag5Ta++9qzjxU7rR2zZ0NVNUS3ZiqI0OLGxxJYm3ADUjYlwdDoIbKQnsJE/9PC/8BPKkRJMJnh0XyLz8iUl5daVXpz+NB9i0FkYPXY6P814ncwUIwcPebCyxIMCuydsqnzfvzEWA2b8yMGfbMLJxV8v8HPLw9PPwm/at/DzstGrhYauTdPRBOogtBhrgB2jl6Sj17vYvQQdRSssWj35QpCpb0aWrSmFwoSHxyFstgLm5EewOfOg86jdAGjFQWYwjQMH4En9D+wq+RsvrRajLR0PTHRiJ8/xPiCY5/0FWu/+eGsF+Sdm4KWB5vpCrnbLQqfz5rjHbTQK6I+HKMGUOR9fvSdGZ2u7VuuNm1skBkMIUtqR0n7O7jLl+79/GlXxYuLSyaKquz+8SrQV5RKYzWnsTvuFpcxCIlgBGDJLuD/Yk5dbdCXS3Z02f39z1ri3VgyszXbjmcE72bjWxsaiXgRrMpl8/WrGf9aJgJZnJ9iKoihK/SWEY3bOnfY8Sqj84nQAna6EvsP28/TrFRPEP//8my5d+pOTLclON5OTaiI7tchxP9NKdqaNnBxJdo6GnPwAMgsbcbDISE66OzklntjQwa7KY3sFOz7k4U+2M1k/RQudxM9YhL+7mV88h+DvbeWRoHSeCMnAEKpHE2JAE2zANzAI35TJtOsTzWN6X1J8/cnT6cgsLiLf5klzXW9a+L+LzVZA/MkWHMrIIN9mo0TeCMDAkh20PPUpBQX5jHK7C4v7FmdUbQAYyu+8wHsAPGf9Dq/ANniIYsw5v+NJMb20e7lOvxuLJpCFHpMpMrTky/Q07MBXqcmMEd8CyRw9ugp399akp38F2ElPn0VExH+rrVVbJdqKcgkSEyczh5EVWqwtwNYiAy8cOUIj+xFeD/fhxi3rWPzIbh7KnU6RdLS8JANTgSDtKT4ds4n7P+qKu+81rjgNRVEUpY641IvTdTpJcDAEBwuIcnT7qCopoaAAsrMdt5xMK9mpJnLSik8n6lk2sk9BTp4v2fkB7C80kF3kRna2B0WZxvPu340h5ZJ0519tHhHGInzczSzwMuDn7cdLfgn4+Qn8g7R4NDKgbezGsqPdufWz3ZjMOog5BV5WDI2KGDhoH5r8BG7bEk/0TtjSui1bH28EZSPxXAeA3aalr+03pjGUH0zuQGpZXDbsvHU8h6eZRVLSmWViq9ZWbZVoK8pFMpvT2JPuaM0u32KtxY6PVkt8QQFHi9xJyVpEaMjHBP+swybH4ldQQs7ucEhzo63vTvwPGbj5+RD0njYXno2iKIrSUAkB3t6OW3g4ONJCH+ftwsxmyMlx3LKzIeeUnZMpZo4fMZN6zMruXTkUFgdy/KQPB3LbYrNrwAaYJBQBWQK8S8A9H4osiHwLUtjQWIpou/c4Mb1/xhRtZtegYCzuOixaLcswAr0YFTCTPbfAMr9WCGfLe7DBi1C3AHzJZWzeVwBcx0q0wo0f5E3Y0AKOXwqWcjNjKKBTmDepqZ8ipaPTjpSWam3VVom2olykxMTJzJajz+p/rUHS3tOTlV27UmTJJscUgO6Wj3mk6Tt06n+U44RBgAU65bLPM5Bx137Bkcx5rF8bynj7NHyz7PinBhHlJugQvp+boprRPqw9RmNThNCeM540s5m7diXwCq9zTcev1KQGiqIoSqXsdiguhsJCMBVKTLklJJ0q4CXrIZ5P1xHi9ygZOz8k/6Q/pnwbhfl2x3Ym53OKBKZiDYXFWkwWLYUWPaYSPQUaHYWeWkzeAqsP4FNCaF4WASV5GFoepORJSYCPjXyNN8V6I/haGJ24kKtKNnIsOIR3Q58GnNMy2UFbYOeBYS/RnW3sJ4qF3IKntZDdfw9g78a+/KC5k8b9UgnIhofylzC+4HeMeXb8vzuIh0crbDYTFssW9PoA+mu92X7gANr0dGzlxqSXQs9ceQ/v2L+HMz7Pq7NVWyXainKR8vI2sIfxZ/W/LkFbNomEu8Efd4M/JEWwbfXtJH0bWW5LO34Rx9nR/GGu6hlJkr6A1u3TOFzSgsQmBuKDLUAUlmOTyTv2F7usHfhAPkdAljstSprQpZme1mHH6B3UjFDPFryemM26fBOf0poINamBoijKFUlKKCmBwgJHAlyYVYzpVDGmHAuFOSWOZbklmPJsjiS4wI6pEI4ftzHPuBVTkaCwSIvJrMVk0VFo0WEqMVBoNWCyGR03WX6KIgEY4KmTMNzEuyWH+MDzHzZkxvFp3HvohQUfWwF+AenYB59EH1BIsc5IXokf0s/GYPkHg4rWkB+o57n2/znrfEbYP2GE5keO0ZSJTMGHPKJMboQUhBOcL+nbIoGOGgtmnZVo/c8E691o4dubiJCBCHc9Q4ZN5ZOD/uTnB5Cf74/F4g445o8YYVsPv5ceyfmrcEQEeDjGX9dqPXB3jyyLpbLJ2SxSsptzTxZVXRO2qURbUS5STEw8B89Y5hj6acDZG1c67qsGS1pjHp/SjNhYx8WPrzjXFKQXsGNVEpsOHaA4dTirC2M42kygjYadIoR/Qu18TzEcD+aj4w/ThFS+lPOQQs+v3Eyz1BmM9Ekgyl1DkHcbNJrz959TFEVRqsZmdSTApqwiRxKcbabwlBlTntWZBFsx5VspzHO2AhdKCk1gMgkKizSYzBpMZi2FZkcrcGGJAZPNkQQX2twwSXfHhYmlCbDQodO6odeb0QUXoPMCjVGQldcYDHZCfZNoVJSJjyGfwg6n0HqZQSM4kdISvdFKu6AErjIl4GY0syw6GrObDot0p/BUBNIo6OGxgevEau5v9hIWoWdH85YMFb9hGe4Gwzdym1zKo+IdzBgYwjLAiI8oItRNR5DenXbFJ+iiPYFVF8qT1tUE6QRh3q2JChlCkF6PIW8kyftjuKXbAO7QBaDXB6DV+pYbEeSGsrLtU0l5jx17NePGOUZkKeXhAVPGJsIcj0pWTDnn/+5c/d9XrVp1zsmiqotKtBWlJl3kuK9ejby4alQHrnJeZV5KSkjdnc2eVals2Z/FXtsJdqY+zGfXBWHv6PjJy4aWT3iUT/blILATZ7sB/1M69nE1hV7tGNRyGF1adsJNe+5uKIqiKFccKZGWEopPmU63AmebKcy2OFqD82yOZLisK4SdwgJnN4ii00lwoVlLkQ0KbEbyccPqacFoL8KqheJgN6yBG9G6WUhMbYtNoyM4JI0uRbvR681kt9RRFKIBfzu79vfBFqilabuD3FnwM376Qg5FtSHNLwi7TnA8sR0YJE09E3mHKej0Fv4v6FH2GVpjQY/Z6oVVC61KUvnC7R4AHuRLjtDSecLHAYgQibwj7wcglm9ILRvytRiAZnoDfUoc/ZTfZwiFeGIU4N3GDzeNBp304SfLQKTV8RkihJ1mHONaVhPh24Xufp2JMn6OThfAAWEjyOiPh7ENRmNj53FmlP0L+lb2f/G8k+T9q/Dx6XVJ/9bSz8iJEyE52dGHfMoUiI3tB32nV7biko5T01SirSg1rRrGfRUCwjr6E9bRn+udy9LMZlps3Ii97OcwgR4LT1g/YX38razZfw+NIw6xoms7/na/mv+k5sCxNQQV5NHGsJcXUxbip4/E2LQrrdr3xr9xX4TQEBcHE58qIDnLg3CSmRL4P2I/7AWxsao/uKLUkDMnyzjfxBrVLi6uLGmJC3icibxJ8imvy89fpASLBUwmLLlFjgT4VHFZAlyQY6Eo34ypsJgCUzGJ6WlsnZNEdp43uYWemLRmQnSHwWIl21vLiSA3LHpByvFWZBYGo/PPp7/hLwyyhIzG3qQ28we95EBSNPlFfvgG5fCY+AQfYx47OkbxT1BnbFoNKSdaYba74e6by1fifnwMeXztNprftbdTIgw4ElVHN8C/GIgA/o9/85tzll/YC0Ce3cpEjSMRfoOJbGSQY3Wv4452aa2d28UPaDRGdtlakmf3xSBsREV44KbREmr3JUofhUZjJKZI0NieiVEIGgUMxKjREGgtornxDYQw8pJJR4FMx11rJMS/H24aDZ4lXnQ2rmD79t382r41QmPAQ+eBn0ckRo0Gg+yOQXMvGo2RlEomhEkzd6bFpk2U4JggR6IlhWYM4TeC8n+kV/sjZXX82VP41I7Y2HO8/s65ou5RibaiXKEmJyZik1bgdAu1BA7rWjHnlq20bv0pmSds9Fudztotx9lyysZ+vQZTVD4nQkLJNmbhEbaJ57Wd+We/GePy1Xgc0xGoSaP1o8dpuT6UxMQOjD82Ce7/N7HA5B49VH9wRakBZ06Wcb6JNS6VlBKwYreb0WiMSCkxxf0PXp9IiaGEb/rcwRduwyguOoo8FUGS3s6MH38nfdN+goOy2eIfghlJTnYjsjKaUayRDGy0gCamdE56ePFXRA9KdFpOZIRzIqsZeFh5PPT/aGM7yBHPZnwdMAqrRke2IRiTvxeaxjbe9/o30WxnKwN4nVfPiNjIp8ygPXv5naF8wQvl1uUAMJDZNCeRH+wjWKx5DL20oG+ej4+9CIMooYstkVBhIlcXyS6tDqPGTmRbibe7GzqKaWO4BW+dluvMzfCzpGHUCIJ8uuGp94WSDKLcZ6PTGLl1byqjI8y4a3X4e3XAQ+eB1pZLe+N+NBoj39p0oDHirnXDXeeBTlOa2GYB8Eul/5GuwK0AfFDp+haAY0zpygf3C3T+1dA1pGcl670rfVapyYmJ5RpqHEonyHlGflbtE7c0VCrRVpQr1Ia8PEqo2A3EMblBO3JzpyEEBDfSMvCuMAYSVmG7khI4uv9uDqxNIjp3L3q3U+wtCSezOWQ2CcLIcT687m4AXpWTmJrdhZ3r4/mqaRgSwVKGMDbtwWod1F9RGiKrNZ+8vH/KJstISZ3JUV1fvkoPww58mXac+zQ/Eagp4Ou8RhTZJTZtAG4+V2G22wkv/J5rWIPFZmFi4XAsdrDjh1ZGUGQuoY/8juFiHvnCwIO6L7AIA5a/VmKWRux6wZjg3dw/3Uw6oTzBY86osihNEDvYf6a7ZgFHieQTZp0Vf/fiXGJMWyiQbYj3a4tOWsHDiDbIjMFuQ2v3waMoGG9NMCHmEgzSQsuSIoxWH9zNGgLst2A03Exn9wDuK9hN08ah+Hu3xN+rEQbM9NJ9TJDeSJhNz+ASPe5aA56GELz0XuiRhOp3YtS5cw0aPgGEEGdE6PgNsD/wZqX/gasBaE1lyWwzoDsArfauYkDzAWesPz0EXtVHrq47KrtAsHSCnOq8GLChU4m2olyhLnVyAwC9HqI6Gojq2JqbaV22XKMBabCxJ7A7D7pdS3jEHhLHasgK8OGfm6MpnbTMhoY5ciQdVIuHopyXxXKSoqLDmM3JFBcnkVecQkqJAW3jCSSbzWQde5Oepk8AGMcXHKEFtmQdpW+2EimZkpLO0/Jj3uFXioRj5AVxKhGdVXL9KStN8/dSbDayo2UjtDYb1iIjJ1M9sZfo0JZ0x5rqicnqjl83K6LERkG2kexjoXhiI7+oI8uOPYUeMy3aFWM368k/FUhWalMo0fBTyev8lPEuf/6l5W93HX4ebgR4ueOp1+Gm0WDU9EfjTG5fqLQEBpbdq3z91WX3AletYkC3AWesjwTAD8rVVGc7M71WLuxyPkOUqqt3ibYQYhgwrFWrVq4ORVGuOOHhkJSkxZrqwxE6c+RIZ1gJBJjRfLcOu8Hxc6hjsP/BqlVbuWxXep1tNqdSWLgbszmZoqIkThSlc5AT5JzsQLLZTMaJOAblvwTAs7xPPLc5nnhyBwCd8q8mxuMzhNZGDFvoyE4WyVuwCcfHs0TDwuLb+PXuKdhseijRQIkGaRWUIPida1mpfYFg9wLCvIsJ8rUSHGgnKERDcBM9wc1GEXSVJ8FNjTwfDPv2rWXYI/0o69kQOYzSqfHm/vUiSc7EtlQ6AUREQId2NV6UilIv1btEW0q5GFjco0cP9XVMUS7SlCkw7gErJsvpqsGDQhqNWU2StuK44VY0PGT/kPd+vQb3F69m9GvXQljYmbtUlPOqtTrbecGfuSCJPW8Yae/7PgvsjzFxIiQVmDG+sYf3fdvz2OiKFx4WF6eQn7+F4uIkTMXJHDOdIqnYhN5/IsfzSkgq2MAongQc3axWC0eXK3bvBiDwZEc0Hz5DSmok+T3bE6D3pviEH6YTgXDCSP/Rz1EyVItBa+NhvuQDnkI4L04rpdFJukw5wD0pTQkK9yQ43J3gEEFQEAQHg4eHEajaBZNpadbTSTY43/SOMdSm8DLjmFFuKNILjpqmKMoF1LtEW1GUS+e4iFt31qgj/zf0ZmxnDAtow8ApEciigBtpdbMJ+/1/0vWFMKhsPHFFcaW4uLJkMvEpyI0ys/zXjxn36SO4e2fQdMJWUtp4MePYXAw//YrJ20zx8eEcKQggMSCHF5o8hhY7/7M9y2LtfY59FmUDoMvpxJZJyzme3oqT7YwQZIUTbnDCCCfcyMuHmR59CfIyE7m9hB6BkuBQQXAbC0HNtLTuug6d/vRkGXvogFVU/FJr14G9h5VnHg2u/rIpN4ZabPI8CAiqvlFHFEVRibaiKBU5Rk0qHYIwEviobGhCKSEkBDLdTDB3MwjBUjGEmUMe5J25v7Dpy2HwxhuuCVxRzmXiROzFJtKHQNpwQAPGIUfQ/ZaK8a79ZHQ3AIJdzZozTjzjeE4kYAPNqaYc/Pcmsg5Fkhepxb15Ln75EFIEje1aGvtpCI7WERRmdLQ0NzWSlLSVIUO6ExQE3t4gzkicK0qo8OjMybBqRbmh0mKdN0VRqodKtBVFqTIhICsLePIYSDsIDTY0fKcfycAxszB+lOHqEBWlAlvhKVL6JZE6DMyhcEr6s5KB/KW7lrwvjpCHHqyADmxWPWz3ZWxBIC38vWkV6kNosIbgWRAU5LgZDP4XPOaqVfm0aFHz56YoSt2nEm1FUS5Kk05mjg9Np7SjpxUDf2gHM2fI/eQvCSw34JWi1I7yk72cwp9Re/Yw118SMWsh4vNPOf4RFKX5kxLgzQP6mdjR0kJzmJEl85gvR4PBOZyOXiI65/F2/3Y1P0mMoigNwtlTBSmKopxH2ymJaHXWCstK0POdYSSHxl/8rJeKclni4kh8I4rc7NUsf30QA6YvZk1ONg/t+4mRG/xpPeE7hiRsY3HiKBrLdMYxnVncx1c8RKHGE4224mtZq5dMdo7CoSiKcrlUoq0oykXJCs0768JIiZYdms5k+mQ7LjxTlNoQF4f5xYdJ71cAGigelMaRTr5IoeFP43V8/3I0R8I8aerrz80DlmMwWBjJ90TiSKT3adtiP+O1bBWS9bm5rjgbRVHqIdV1RFGUixIfE0NkJCTduQ/N0OPYNVp0WOho28Wa7cMY/MtENUyBUjsmTiRxRBHS+Uk2Uz6AFa1j9hK7gPWBhM3oyJ5kQWWXGbrkwkNFURoU1aKtKMpFS8o3w6AT2DWO1kArBpZrB9NuyF+Y89XP7krtMBckcWIooIUsAlihGQTC+bGmBWKyOV5gOd8uFEVRapRKtBVFuShxccCYRMQZ/bRtaJinH0nSw+oiMqV2JD7qhXTOvT2Xe7GdMRG31mAh8OEtqjuToiguU2OJthBiphAiQwixq9yyACHEciHEQedf/3LrJgghDgkh9gshbii3vLsQYqdz3UdCCHHmsRRFqT0TJwLt85Bn9m3FwF5tO3LbWCt/olLnXWn1dt7VgUjnENV76ICNiuNV2zQ6fPoccb5oFUVRal9NtmjPBoacsewlYIWUsjWwwvkYIUR7YBTQwfmcaUKI0k/xz4BxQGvn7cx9KopSi5KTgZc6Q4kjd9JLCz9yO0uKb2TX7eOIedB+/h0oddlsrqB6O2ZwIgOOf8O1A20cumNM2WtSY7PxI7ezkoF87vYI3+V1rYnDK4qiXFCNJdpSytXAqTMW3wLMcd6fA9xabvk8KaVZSnkUOAT0FEI0BnyklBuklBKYW+45iqK4QEAAcG8iCMfYw3YEcxmDVmMjaQwQHu7K8JTLcEXW27GxhEdoHK9JJ7tGwytyEhJAY2frmGDixq+tsRAURVHOpbZHHQmVUqYBSCnThBAhzuVhwMZy26U4l5U475+5vFJCiHE4WlEIDQ1l1apV1Rd5JQoKCmr8GHWdKgOHhlQOZq8eMPREWe1hE3qWMoQxhrmkD7FgDriVrAZSFpWph6+FGqu3L6fOLl/OtzwQyEe9skEvS3fMbjrzKeN53DCNbkN+Y8zhB3m6TR6P3JnCoEE1O4NpXX4NqNgujYrt0tTl2KB24qsrw/tV1n9Pnmd5paSU04HpAD169JADBgyoluDOZdWqVdT0Meo6VQYODakcCm7dX9aaXcqGhrmM4RnNhxhHlTAgaoBrgqsDGtBr4bLr7cups8uX8/eN96NLlZS/OkCDlVx8AfhWPwpbexOZQ9P54IP2tGvXvkZHoKzLrwEV26VRsV2auhwb1E58tT3qyAnnz4o4/5Y2K6QAzcpt1xRIdS5vWslyRVFcpWPe6SmrnawY2E0HpAFyc9e7KDClhtT5entDXh7WM7782dGRSHMyCWCJ9kYQAoakYzKa1bWRiqLUmtpOtBcBY533xwILyy0fJYQwCiGa47h4ZrPz58p8IURv51XrY8o9R1EUV3g4Bn5pjNZmA0CHhZtti7jpl3j6D4SYmHgXB6hUszpfb8fHxCAHDEAOGMA3A6fz0m+zWG4dxAzG8ZXtQezS+VGnkTAmCTXDuqIotaUmh/f7DtgAtBFCpAghHgTeBq4XQhwErnc+Rkq5G/ge2AMsBR6TUtqcu3oU+BLHhTaHgSU1FbOiKBemCTbD0PSyadhLJ6vpNWQh5kA1+uaVrD7U2yOC5zN4UBw6nY0sAvhLe52jNRscv8QMSUcTZK6tcBRFaeBqrI+2lHL0OVZdd47tpwBTKln+D9CxGkNTFOUy2O9ORKOzYuf0ONo2NHyrH0n3ez4gyoWxKZenPtTbiXfb0QhHp/C53Iv9zC7jGok9NgnUK1VRlFqgZoZUFOWi6LvmYa9kspp92nbkdKkr11crDVVeV32FSWysZ0xig0Gi75pb+4EpitIgqU9FRVEuyixdDONusGKynK4+PChkkn4OXi+86MLIFAVidLPgpnFgMjGJlYzjbkx4lq338IDp010YoKIoDYpq0VYU5aLExsL0mToiAgsQ2IkgkemBE4idNYiMQYNcHZ7S0MXGOjLpiAhixTymB05wvFYFREQ4VtXk0H6KoijlqRZtRVEuWmwsxMZ6OR9FAh857tbhiQmUBsTxAnXcdd4URVFcQbVoK4qiKIqiKEoNUIm2oiiKoiiKotQAlWgriqIoiqIoSg1QibaiKIqiKIqi1ACVaCuKoiiKoihKDah3ibYQYpgQYnpurpqQQFEUpa5TdbaiKPVZvUu0pZSLpZTjfH19XR2KoiiKcgGqzlYUpT6rd4m2oiiKoiiKotQFKtFWFEVRFEVRlBqgEm1FURRFURRFqQFCSunqGGqEEOIkkHSBzXyBy7kCJwjIvIznX+7xq2Mfri6D6oihLpSjei04uLoc6kI5Vsd7orWUskF1Wq6kzr7Q/+FC5Xy+519o35e7vr7GdqH1dTm2C61XsdXM+rocG5w/vovZd4SUMrjSraSUDfYGTL/M5//jyuNX0zm4tAzqwjnUhXKoI+dQHTG4tBzqSDm6/D1RH24XKoMLlfP5nl+FfV/u+noZWy3EXmOxVUPsKrZLi73Oxnah+C5336W3ht51ZHE9OP7l7sPVZQB14xxcXQ514RxcXQZQN86hPpRDfVCTr4UL7fty11/IlRrbhdbX5dgutF7FVnPrXXlsV8YG1OOuI7VBCPGPlLKHq+NwJVUGDqocHFQ5qDKoLXW5nFVsl0bFdmlUbJeuNuJr6C3al2u6qwOoA1QZOKhycFDloMqgttTlclaxXRoV26VRsV26Go9PtWgriqIoiqIoSg1QLdqKoiiKoiiKUgNUoq0oiqIoiqIoNUAl2pdACPGEEGK/EGK3EOLdcssnCCEOOdfd4MoYa4sQ4jkhhBRCBJVb1mDKQQjxnhBinxBihxDiZyGEX7l1DakchjjP85AQ4iVXx1NbhBDNhBArhRB7nfXBU87lAUKI5UKIg86//q6Otb4533uvLhBC3Ol8TdiFEC6/GKwuv0eFEDOFEBlCiF2ujuVM53qP1wVCCDchxGYhxHZnbK+5OqYzCSG0Qoh4IcSvro6lPCFEohBipxAiQQjxT00eSyXaF0kIMRC4BegspewA/J9zeXtgFNABGAJME0JoXRZoLRBCNAOuB5LLLWto5bAc6Cil7AwcACZAwyoH53l9CgwF2gOjneffEFiBf0sp2wG9gcec5/4SsEJK2RpY4XysVK9K33t1yC7gdmC1qwO5At6js3HUk3XRud7jdYEZuFZK2QWIBoYIIXq7NqSzPAXsdXUQ5zBQShmtRh2pex4F3pZSmgGklBnO5bcA86SUZinlUeAQ0NNFMdaWD4AXgPJX1DaocpBS/iGltDofbgSaOu83pHLoCRySUh6RUlqAeTjOv96TUqZJKbc57+fj+EAJw3H+c5ybzQFudUmA9dh53nt1gpRyr5Ryv6vjcKrT71Ep5WrglKvjqMx53uMuJx0KnA/1zludGeFCCNEUuAn40tWxuJJKtC9eFHC1EGKTEOJvIUSMc3kYcKzcdinUkTdjTRBCDAeOSym3n7GqQZXDGR4AljjvN6RyaEjnek5CiEigK7AJCJVSpoHjgxoIcWFoDUH5955yNvUerQZnvMfrBGfXjAQgA1gupawzsQFTcTTG2V0cR2Uk8IcQYqsQYlxNHkhXkzu/Ugkh/gQaVbJqIo4y88fxE1IM8L0QogUgKtm+znyzvBQXKIeXgcGVPa2SZfW2HKSUC53bTMTxE2Nc6dMq2f6KLofzaEjnWikhhBfwI/C0lDJPiMqKRLlYl/jeqzVVia+OaPDv0ct15nvc1fGUklLagGjnNQo/CyE6Sild3tddCHEzkCGl3CqEGODicCrTV0qZKoQIAZYLIfY5f1mpdirRroSUctC51gkhHgV+ko4ByDcLIexAEI4WgmblNm0KpNZooDXsXOUghOgENAe2OxOKpsA2IURPGlA5lBJCjAVuBq6Tpwemr3flcB4N6VzPIoTQ4/gAjpNS/uRcfEII0VhKmSaEaIyjtUm5SJf43qs1F4qvDmnQ79HLdY73eJ0ipcwRQqzC0dfd5Yk20BcYLoS4EXADfIQQ30gp73FxXABIKVOdfzOEED/j6F5VI4m26jpy8X4BrgUQQkQBBiATWASMEkIYhRDNgdbAZlcFWZOklDullCFSykgpZSSOSryblDKdBlQO4LiSH3gRGC6lNJVb1ZDKYQvQWgjRXAhhwHER6CIXx1QrhOOb5lfAXinl/8qtWgSMdd4fC9Sl1s164TzvPeVsDfY9ernO8x53OSFEcOloO0IId2AQsM+lQTlJKSdIKZs6c4RRwF91JckWQngKIbxL7+P4db7GvpyoFu2LNxOY6RyGyAKMdbak7BZCfA/swfEz5mPOn3QaFCllQyuHTwAjjp+eADZKKf/VkMpBSmkVQjwOLAO0wEwp5W4Xh1Vb+gL3Ajud/STB0a3qbRzdyh7EMSrPna4Jr16r9L3n2pBOE0LcBnwMBAO/CSESpJQuGeazrr9HhRDfAQOAICFECvCqlPIr10ZVptL3uJTyd9eFVKYxMMc5qowG+F5KWaeG0aujQnF0swFHHvytlHJpTR1MTcGuKIqiKIqiKDVAdR1RFEVRFEVRlBqgEm1FURRFURRFqQEq0VYURVEURVGUGqASbUVRFEVRFEWpASrRVhRFURRFUZQaoBLtOk4IUXDG4/uEEJ9c5D6GCyFeqsaY/IQQ46u47ZnxBwohEpy3dCHE8XKPDdUVY3URQgwQQlxVQ/uucjlWcX+RzmEna50QoqsQ4kvn/bLXqBBCI4SYI4SY6RyPFiHEBCFEbCX7KDhzWRWPHSyEqLGhmZT6rb7VseWWTxRC7BZC7HDWr72qKz7n/n8vN4bzk0KIvUKIuIstCyFEohAiqNzjAUKIahmi7nyxlJabEKKJEGKB8360c4KVizlGtX5GCCEmCSGeq679XeSxpwohrqnCdnrhmLr8kj5zGtpngEq06zkhhE5KuUhK+XY17tYPuKQEUUqZJaWMllJGA58DH5Q+llJaqjHGKhNCnG88+QHARVWizjFNq8KPSyzHOuhlHGMGl3Em1p8DeuChcjP3DQb+qK4DSylPAmlCiL7VtU9Fqaq6VscCCCH64Jgxs5uUsjOOiUyOVU9oDlLKG6WUOc6H44EbpZSxNVAWl6wqsUgpU6WUI5wPo4GLSrS5hM+IukgIEQD0ruI05P2A9ZdxuAb1GaAS7SuYECJCCLHC2WKxQggR7lw+WwjxPyHESuCdM1oYE8rdioQQ/YUQAUKIX5z72SiE6OzcdpKzJXKVEOKIEOJJ56HfBlo69/GeEMLLefxtQoidQohbLuFcugsh/nZ+S14mHNNW4zz2B0KI1c4WkxghxE9CiINCiDec20QKIfY5W053CCEWCCE8qrDfN4UQfwNPCSGGCSE2CSHihRB/CiFChRCRwL+AZ5znerWzbEeUi7u0VWSAEGKlEOJbHBMbaJ1ls8UZ0yOVnHaFcnTu5/lyz3mt3PntFULMEI4Wqj+EYxaw0vPbLoTYADxWLq5Kj++Mc5WzjPYJRwtUaUtzjBBivXN/m4UQ3kKINUKI6HL7XVf6+ii3zBvoLKXcfsb5fQgEAmOklHbntj6AQUp5UjhmqdvgjHFyuf1V+noSQkwWQjxVbrsp5V6TvwBntZAoyuUQV24d2xjIlFKaAaSUmaVTTgtHC/I7zvf4ZiFEK+fyYCHEj8734xbhTFqcx57lPO4OIcQd5fYTJIT4HGgBLBJCPHNGWYQKIX521inbxUW2/IozWneFELuc9WFpnf+lc1mcEGKQs346KITo6dy+fCznqm8infswAK8DI53lPtK5r2DndhohxCFRsfU9krM/I85Vjuf6X5f++rBfCPEn0Kbc8pZCiKXC8fm1RgjR1rl8thDiI+Gor4+Iip9JLzj/V9uFEG8797Gt3PrWQoitlRT3CGBpue1udJbxWuexyv/KMARYcsb/qoVwfH7GCCE8hBDfO18v84Xjs7WHc7uG9xkgpVS3OnwDbEBCuVsy8Ilz3WIcM1MCPAD84rw/G/gV0Dof31f6nHL7HQaswdHa+DGOmbjAMb18gvP+JBzfWo1AEJDl3D4S2FVuXzrAx3k/CDjE6cmQCs5zbpOA55z7XA8EO5ePxDFzGcAq4B3n/aeAVBwfIkYcU78HOuORQF/ndjOruN9p5WLxLxfzQ8D75WMst91sYES5xwXOvwOAQqC58/E44D/O+0bgn9J15Z57ZjkOBqYDAseX4F+Ba5zbWYFo53bfA/c47+8A+jvvv1e6v3Md3xlnLtDUeYwNOFonDMARIMb5HB/n/3UsMNW5LAr4p5L/40Dgx3KP7wNOAesA/Rnb3g687ry/CEcSDo4vCaVlWenryVkO25zLNcBhIND5OAzY6er3q7pdeTfqYR0LeDnP5QAwrbSOcK5LBCY6748BfnXe/xbo57wfjmPKcYB3SusA52P/cvsJquR+WVkA84Gnnfe1gG8lsSYCO8uV/6FyMU2iYv27y1k2kTjqxE7OumArjnpfALeU+z+Vj+Vc9U1ZWZ/5fwReLRf/YMrVc+W2OTPGc5Xjuf7X3Z3n74Gj3j1Uuj9gBdDaeb8XjmnMwfH6+8F57u2BQ87lQ53H8HA+DnD+Xcnpz483gScqOY85wDDnfTccv4CUfp59V/o/cT7e7Iw30vk/aQPElzvGc8AXzvsdnf+rHs7HDe4zQE3BXvcVSUc3C8DxDR3o4XzYB8eLFuBr4N1yz/tBnmPKbyFEaxxJ2bVSyhIhRD/gDgAp5V/C0Y/a17n5b9LRKmIWQmTgmLr0rF0CbwpH3y47jhd8KJBexXNsg+PNWDqVshZIK7d+kfPvTmC3lDLNeR5HgGZADnBMSrnOud03wJM4vp2fb7/zy91vCswXjhZvA3C0irGXt1lKWfq8wUDnci0NvkDrC+x3sPMW73zs5XxOMnBUSpngXL4ViHT+j/yklH87l3+No6I93/EtzjhTwNH6hqPyygXSpJRbAKSUec71PwD/FUI8jyPRmF1J3I2Bk2cs2wa0BXriSLhLDQFmOe/3xfm6c8b+jvN+pa8nKWWiECJLCNEVx+srXkqZ5XxOBtCkktgU5ULqXR0rpSwQQnQHrsbxRXi+EOIlKeVs5ybflfv7gfP+IKC9s64E8BGOX6sGAaPK7Tu7smOew7U4knmcZZV7ju0GSikzwfGrG45E7UKOSil3Op+zG1ghpZRCiJ046rQznau+OZ+ZwEJgKo76b9Z5t3Y4VzlC5f/rq4GfpZQm57kscv71wtEl5Ydy+zKWO84v0vFL4R4hROlrZhAwq3RfUspTzuVfAvcLIZ7F0eDUs5K4y9fjbYEj5T7PvsPReIMQoglwSkppcsYV7CyjO6SUu53b98PxiyZSyl1CiB3ljtPgPgNUol2/yHL3CyvbQAjhiaNF9GHp/CkRx4v6XPsyl1tmo/LXTCyON1t354dKIo5vxFUlcCTQfc6xvjQG+xnx2MvFI6lIVmG/5cvoY+B/UspFzop+0jmeY8XZ5Uo4apnyF3CW35/A0Wqw7Bz7qYwA3pJSflFhoePnyTP/D+7O7c887/Me33lulf1PK92XszJdjqOV6C5OJyDlFXH2/3sf8P/tnV+IVVUUh7/fxNAftEHBiAKFjCmmIJExiJCYICIwKmiIkhwyepiKYuqhp6KgIOghKEwiIYJ8kUQoBR2pGcZRqVFTQZ3woSIiDB+cpBBfdg9rHWffM/dc79Uuepv1vcy9Z85eZ+89+6y99tpr7XkL2CLp4UwB3wsM54+oI6/ReNqEeZ1uxibBguu8HkHQTjpGx7phOw6Mu/E5xOxCOW9H8bkLuC+lVPMeuZ6r0jPt5oK+dfI2l+eCfJ6osm1aakdK6TdJpyQ9iHmUmwlNqOrHcp3zv3W9enUBZ/JFYIlclrKf9WRtxbzz3wEHnCO/QAAABCtJREFUM+M0J9fj9cZrwSNAPq/MYN7v+4FCzzcqP+/mgIjR7mz2MetpWAtMNlHmc2zFuye7NuHlC0PsdOHRrOAssDD73gP86S/EALCsqdrP8hOwRJbAgyyj+a4WZSwtygNPY33Ritwe4Hf/PJRdL7f1F2yrD8z47K6QtwsYltTtz+71CTinLHsXsN49GUi6VdJNFfJJlog0494yqJ0Emnl+zjRwi6RVfv9CzSaJbgI+AqYyD0nOCeD2OvXbh8Uv7pC01Pt+OvMC7qV2/BY0Gk/bMI/IKmqVfS+2hRkE/yUdqWMl3eFe9YIVwK/Z96eyn/v98yjwciZjRcX1RY2eXeJb3KiS5Y3c2EJZMH270suvxMLfLpUqfZNT7ncw/fclsKViB6Ncpqofq5gAnpB0vXu+H4ULu4o/Sxp0OZJ0z0VkjWJzSJGjtNhlncP05UaqvfK5Hp8GbnMnD8yOF5gbn30eeBxYJ+kZvzaJOWaQ1IeF+DBf54AwtDubV7DtoKPAs1gMcyWSlmEJD+s1m6zTj3lv+13O+9QamnPw1fBeWQLJB8BmL38Ae1mmW2lEstNGnsSSio5gcXqtZnGfAIa8DYuBjS3KfRvbotsDnM6uf4MpwcOSVgOfAQ9I+gHzcNT1amHK+ThwSHb80aeUvCzlfkwpjWLxffvdA/UVc5V+meeADbJkyHw1f9Hnl+pyHlOmH3tf7cY9CCmlg8BfVCjolNI00JNtj+a/2w68g4XxrCFLtsHG60uSpjDFWlA5nryeY8yd9AaAHVXtC4JLpFN17ALgC0nH/Zl91O7SXSvpe2/PSNbWflkC23FskQzwLrDI63IEe9ea5VVgwPXZQaBVB8pWYLEsxG0Yizm/VKr0Tc4YFvZxWFJhXH6N9WeVgVqeI6r6sS4ppUNYGONhrL35Am0t8Lz3+zHMudNI1k6v7wHvszwEZzPmPa467WMHlsODe+NfBHZKmgROYU6da7CY8Zrxl1L6G9PvI7LExU8wJ9dR4A0sl2gG84bPuzmgSKYIgo7FV93bU0p3X+m6/B+RxeSNA3d6TGC9e0aAsymlTQ3k7MYSX/6ouqeJunRh8d+DKaWT2fUJ4LEW40eDYN7h2/D9RUx00BhfKH2YUlp9petyOchOb+lJKb3Z4J5JYE1K6YykBR7rL2ADcBKYwhLxGy4e3CDvTimdk7Qc29noxQzheTcHRIx2EASVSFoHvAe8VmVkOxuBwUayUkoPXWZd+rCTHraVFOwSLL7+qlOwQRB0LrJ/djPM1XpsXJNI2gYsx5JTG/E6dlLKGeAFSUNYHtKP2Cki/9Bc+NQNwJiHLgoYdk/0vJwDwqMdBEEQBEEQBG0gYrSDIAiCIAiCoA2EoR0EQRAEQRAEbSAM7SAIgiAIgiBoA2FoB0EQBEEQBEEbCEM7CIIgCIIgCNrAv1u/AG5XcQTQAAAAAElFTkSuQmCC\n",
      "text/plain": [
       "<Figure size 864x432 with 2 Axes>"
      ]
     },
     "metadata": {
      "needs_background": "light"
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "#--- plot original L72 versus SCM L33\n",
    "\n",
    "fig, (ax_divT, ax_divq) = plt.subplots(nrows=1, ncols=2, figsize=(12, 6))\n",
    "fig.suptitle(\"MERRA-2, \"+region+\", \"+time_step_merra2)\n",
    "\n",
    "style1a = 'r-o'\n",
    "style1b = 'y--^'\n",
    "\n",
    "style2a = 'b-o'\n",
    "style2b = 'c--^'\n",
    "\n",
    "#--- plot divT\n",
    "ax_divT.plot(\n",
    "             -divT_merra2_sphere_inSCM*86400., pfull_merra2_inSCM/100., style1a,\n",
    "             -divT_merra2_cfd_inSCM*86400., pfull_merra2_inSCM/100., style2a,\n",
    "             -divT_merra2_sphere*86400., pfull_merra2/100., style1b,\n",
    "             -divT_merra2_cfd*86400., pfull_merra2/100., style2b,\n",
    "            )\n",
    "\n",
    "var_dum = divT_merra2_sphere.copy()\n",
    "var_dum.attrs['long_name'] = \"Horizontal Temperature tendency\"\n",
    "var_dum.attrs['units'] = \"K/day\"\n",
    "ax_def(ax_divT, var_dum)\n",
    "ax_divT.legend([\"tdt_hadv, sphere_harmo, L33\",\n",
    "                \"tdt_hadv, center-diff, L33\",\n",
    "                \"tdt_hadv, sphere_harmo, L72\",\n",
    "                \"tdt_hadv, center-diff, L72\",\n",
    "               ])\n",
    "\n",
    "#--- plot divq\n",
    "ax_divq.plot(\n",
    "             -divq_merra2_sphere_inSCM*864e+5, pfull_merra2_inSCM/100., style1a,\n",
    "             -divq_merra2_cfd_inSCM*864e+5, pfull_merra2_inSCM/100., style2a,\n",
    "             -divq_merra2_sphere*864e+5, pfull_merra2/100., style1b,\n",
    "             -divq_merra2_cfd*864e+5, pfull_merra2/100., style2b,\n",
    "            )\n",
    "\n",
    "var_dum = divq_merra2_sphere.copy()\n",
    "var_dum.attrs['long_name'] = \"Horizontal Specific Humidity tendency\"\n",
    "var_dum.attrs['units'] = \"g/kg/day\"\n",
    "ax_def(ax_divq, var_dum)\n",
    "\n",
    "ax_divq.legend([\"qdt_hadv, sphere_harmo, L33\",\n",
    "                \"qdt_hadv, center-diff, L33\",\n",
    "                \"qdt_hadv, sphere_harmo, L72\",\n",
    "                \"qdt_hadv, center-diff, L72\",\n",
    "               ])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 106,
   "id": "014d6c6c-a631-4823-9213-3e6cb5ca3976",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "<matplotlib.legend.Legend at 0x2b86087d9e80>"
      ]
     },
     "execution_count": 106,
     "metadata": {},
     "output_type": "execute_result"
    },
    {
     "data": {
      "image/png": "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4OLiQq9evfj1118BWLx4McOHD8/0WCEhIfzxxx+Ehoby3HPPAUayfu+997J+/XrKlSvHjz/+CBjNUz7//HM2b95sS8rfffddHnzwQdauXcvMmTOZNOnGR7dNmzb89ttvhIaG0rBhQ0JDQ1m5ciUvvvhipvFkdIzbbruN0NBQNmzYwC233MK3335ri3PgwIGEhobi7u5OTEwM33zzDcHBwYwZM4YFCxawfv1624+Q119/nbfeeov169fTvHlzvv7660zjyMwvv/xC+/btmTVrFp06dbLNDwwMpHHjxly4cIF69erler/2ikWirZRyBr4A+gHNgEeVUs3y+zgBAQHs3r2bgICA/N61KCastRY5Lfxzu35hiPr8c7qXLcsZpcDXF0JCjPmFdG5F8TVxhNL8OhRWmS2Kp5DoaLx79GDXrl149+hx0808ErTO1fysHDx4kNtuuw2Ajh072m58Szs/N6xJs7e3NzExMQB8+eWXdO3ald69e3P27FnOnj2b6TEef/xxFi5cyJkzZ7h27RoNGjTI9Fgff/wxzz//PMOHD2fz5s2AcfOe/X4PHDgAQNOmTXF3d6ds2bI4OzsDsHv3bj755BN69OjBCy+8wKVLl2z7tsa0e/duli1bRo8ePRg8eDCxsbGZxpPRMfbs2UPv3r3p3r07P/zwg61ttLOzM7fffrtt21atWuHk5ETdunVp3Lgx7u7uVK1a1VZzffjwYTp37gxA586dbVcLcmPAgAFs27aNt99+mylTptjmT506lYMHD1K/fn3mz5+f6/3aKy79aN8GHNZaHwVQSi0F7gP25tcBoqKimDdvHlpr5syZQ+fOnXnwwQcpV64cR44c4VAGv4DvvPNOXF1dOXjwIMeOHUu3/O6778bJyYl9+/bZ3khWTk5OtpsE/vvvP6KiolItL1OmDD169ABg586dnDt3LtXysmXL0rVrVwD+/fdfLly4YFs3OTmZChUq2N6wW7du5fLly6m29/DwoH379gD8/fffXL16NdXyqlWr0rp1awA2b95MQkJCquXVq1enRYsWgHFjiPVXv1XNmjW55ZZbAPjrr7/QaQq8OnXq0LBhQywWCxs3brTN37lzJ05OTnh7e+Pr60tiYiJ///03afn6+lKvXj2uX7/Otm3b0i338/Ojdu3aXL16lR07dqRb3qhRI2rUqMHly5f577//bPM/+ugj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Nm0iMzOT888/3+v+Z599lltuucX9m5VKwmNm0FKVK4ridxJ99IO+yhVFqdrUWKFdHOPHj3fNboYxhu3bt1dIu5s2baJnz54A9OrVq0zfHTNmDBs3bqRFixY+45137txJQkICGzdupEePHgA0b96chnZu1oEDB7J06VJOnjzJ9OnTuf766wEIDQ0lKSkJgGbNmnHQ1+QmPhg7dixPP/20130fffQRa9as4ZlnnilTm0oFMG4cREUVLIuK0vhsRQkg41q2JMpR8NEb5XAwrmXLAFmkKIo/CZb0fpWOr9yLmzZtYsqUKQWE9uHDh/n0009p1MhKkFa/fv1S5W4MDw8nNzfXvd26dWuWLVtGr169+OWXX4iPj/darzCnT58mMjISESE2NpaowuIJyMjI4K233mLixImICB9++CEAO3bsYO/evQCICDfccAP33Xcf/fv39+lhdv32HTt20KwUE5ps2bKF+++/H7Bi2x988EEmTJjAt99+yyeffMK0adNwOPR/ukrHFYc9Zgzs2GFNTjNunMZnK0oAcU1KM2bLFnZkZdEsIoJxLVvqZDWKUk2psULbF88//3zR9Gh5eaSkpPDmm96m/fBNo0aNqFWrllvcPvvss9x5553Uq1eP+vXru+sNGTKEESNG0KdPH68x4Y899hhr1651x2f//e9/d9uVnJxMdnY2YWFhjB07ljZt2lC7dm3at29P79696dSpEwkJCe627rjjDpo0aeKO1fZFTk4OV199Nb/99luRfePHj3d71YcNG8bixYvd+1q3bs2ECRMAa4r3du3auadSnzp1Ko0b+5xvSPEHw4ersFaUIGN4w4YqrBWlhqBCuxBLly4tmh4tO5tFi4okSCsRh8PB998XHGy/dOnSIvVGjhzJyJEjfbbjS+Bv3bq1SJlrZsKXXnrJ63eMMfTr14+OHTu6yzynV584cSIACxcu5O677y7y/bFjx7rTEnrDs63MzEyf9RRFURRFUao7KrQLsXDhwoDNTHjo0CGGDBlSoOyaa67h0UcfrZD2f/jhB5566imee+65Euv27duXvn37VshxFUVRFEVRaiIqtIOIunXrlir2u7xcdtll7pR+iqIoiqIoin/REWqKoiiKoiiK4gdqlNA+deoUOm+CEmiMMZw6dSrQZiiKoiiK4meqXeiIiAwGBheePTE+Pp7du3e7Z0n0hSuVXlVF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\n",
      "text/plain": [
       "<Figure size 864x432 with 2 Axes>"
      ]
     },
     "metadata": {
      "needs_background": "light"
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "#--- plot horizontal tendencies versus 3D tendencies\n",
    "\n",
    "fig, (ax_divT, ax_divq) = plt.subplots(nrows=1, ncols=2, figsize=(12, 6))\n",
    "fig.suptitle(\"MERRA-2, \"+region+\", \"+time_step_merra2)\n",
    "\n",
    "style1a = 'r-o'\n",
    "style1b = 'y--^'\n",
    "\n",
    "style2a = 'b-o'\n",
    "style2b = 'c--^'\n",
    "\n",
    "#--- plot divT\n",
    "ax_divT.plot(\n",
    "             -divT_merra2_sphere_inSCM*86400., pfull_merra2_inSCM/100., style1a,\n",
    "             divT3d_merra2*86400., plev_merra2, 'k--^'\n",
    "            )\n",
    "\n",
    "var_dum = divT_merra2_sphere.copy()\n",
    "var_dum.attrs['long_name'] = \"Temperature tendency\"\n",
    "var_dum.attrs['units'] = \"K/day\"\n",
    "ax_def(ax_divT, var_dum)\n",
    "ax_divT.legend([\"tdt_hadv, sphere_harmo, L33\", \"tdt_3Ddyn, L42\"], fontsize=9)\n",
    "\n",
    "#--- plot divq\n",
    "ax_divq.plot(\n",
    "             -divq_merra2_sphere_inSCM*864e+5, pfull_merra2_inSCM/100., 'c-o',\n",
    "             divq3d_merra2*864e+5, plev_merra2, 'k--^'\n",
    "            )\n",
    "\n",
    "var_dum = divT_merra2_sphere.copy()\n",
    "var_dum.attrs['long_name'] = \"Specific Humidity tendency\"\n",
    "var_dum.attrs['units'] = \"g/kg/day\"\n",
    "ax_def(ax_divq, var_dum)\n",
    "ax_divq.legend([\"qdt_hadv, sphere_harmo, L33\", \"qdt_3Ddyn, L42\"], fontsize=9)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "aa3d7daa-27aa-4079-a53c-0efc84ceaadd",
   "metadata": {},
   "outputs": [],
   "source": []
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "952822a7-4cbe-46bb-91c2-49647e9bd89a",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.9.13"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
EOF
#*** case: MERRA2_interp2scm end ***

# newcase

fi  # end if of casename_work

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
