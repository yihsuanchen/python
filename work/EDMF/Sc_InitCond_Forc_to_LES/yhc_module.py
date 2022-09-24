#!/usr/bin/env python
# coding: utf-8

# # Yi-Hsuan Chen's Python module
# 
# **import yhc_module as yhc**
# 
# **available functions**
# 1. unit_conversion

# In[1]:


import numpy as np
import xarray as xr
import io, os, sys, types
from datetime import date

xr.set_options(keep_attrs=True)  # keep attributes after xarray operation


# In[2]:


#############################################
# Purpose of this code:
#
# 1. convert yhc_module.ipynb to yhc_module.py
# 2. copy yhc_module.py to a a folder, dir_py, so it can be imported
#############################################

convert_ipynb2py = False
#convert_ipynb2py = True

dir_py="/Users/yihsuan/.ipython"  # (Mac) copy yhc_module to this folder 
                                  #       so that other jupyter notebook can import yhc_module

# location of yhc_module in Mac
py_path = "/Users/yihsuan/Downloads/yihsuan/test/tool/python/yhc_module_and_notes"

if (convert_ipynb2py):
    print("convert yhc_module.ipynb to yhc_module.py")
    command="jupyter nbconvert yhc_module.ipynb --to python"
    os.system(command)
    
    command="cp yhc_module.py "+dir_py
    print(command)
    os.system(command)
    
    sys.path.append(py_path)  # add py_path to sys.path
    


# In[3]:


def printv(var,
           text = "", 
           color = "black",
          ):
    """
    ----------------------
    Description:
      print out variables by begining with a line, follow by a text, and end by a empty line
      This helps to view the output more easily.

    Input arguments:
      var : any variable
      text: text will show on screen

    Return:
      print statement on screen

    Example:
      import yhc_module as yhc
      
      yhc.printv(var, "ggg")
      yhc.printv(var, text = "aaa")

    Reference:
      Print with colors: https://predictivehacks.com/?all-tips=print-with-different-colors-in-jupyter-notebook
      Inserting values into strings, https://matthew-brett.github.io/teaching/string_formatting.html

    Date created: 2022/07/06
    ----------------------
    """    

    #------------------
    # set text color
    #   colors: https://pkg.go.dev/github.com/whitedevops/colors
    #------------------
    
    #--- color codes dictionary
    color_codes = {'red':'\033[91m',
                   'green':'\033[92m',
                   'yellow':'\033[93m',
                   'blue':'\033[94m',
                   'pink':'\033[95m',
                   'teal':'\033[96m',
                   'grey':'\033[97m',
                   'black':'\033[30m',
                   'cyan':'\033[36m',
                   'magenta':'\033[35m',
                   #------ short name  -----
                   'r':'\033[91m',
                   'g':'\033[92m',
                   'b':'\033[94m',
                   'y':'\033[93m',
                   'c':'\033[36m',
                   'm':'\033[35m',
                   'b':'\033[30m',
                  }
    
    #--- read color code
    color_code = color_codes[color]
    
    #------------
    # print out
    #------------
    
    text_out = f"{color_code} ------------- \n {text}"  # format text string
    
    #print("--------------")
    print(text_out)
    print(var)
    print("")
        
#----------
# test
#----------

#do_test = True
do_test = False

if (do_test):
    printv(1, "ddd", 'r')
    printv(2, "eee", color = "g")
    printv(3)


# In[4]:


def unit_convert (var_in, units_in = "none", units_out = "none", 
                  var_type = "xarray.DataArray"
                 ):
    """
    ----------------------
    convert unit of a variable
    
    Input arguments:
        var      : (xarray.DataArray): a variable
        units_in  : (string) original units of the var
        units_out: (string) new units of the var 
    
    Return:
        variable values with units_out
    
    Example
        import yhc_module as yhc
        var = yhc.unit_conversion(var, "m", "km")
        
    Date created: 2022/06/29
    -----------------------
    """
    
    #------------- 
    # constants 
    #------------- 

    rho_water = 1000.  # water density [kg/m3]
    latent_heat_evap = 2.5e+6          # latent heat of vaporization for water, J/kg  
    latent_heat_cond = 1./latent_heat_evap  # latent heat of vaporization for water, J/kg
    hr2sec = 1800.    # hour in seconds
    day2sec = 86400.  # day in seconds

    #------------- 
    # conversion dictionary
    #------------- 

    conversion = {'m':1.0, 'mm':0.001, 'cm':0.01, 'km':1000.,
                  'm/s':1.0, 'mm/day':1./(1000.*day2sec), 'kg/m2/s':1./rho_water, 'W/m2':1./latent_heat_evap/rho_water,
                  'kg/kg':1.0, 'g/kg':1.e-3,
                  'fraction':1., "percent":0.01, "%":0.01,
                  'K/s':1., 'K/day':1./day2sec, 
                  'kg/kg/s':1., 'g/kg/hour': rho_water/hr2sec, 
                  'Pa/s':1., 'hPa/day': 100./day2sec, 
                  'kg/m2':1., 'g/m2':1.e-3,
                  '1/s':1., '1/hour': 1./hr2sec, 
                  'Pa':1.0, 'hPa':100., "mb":100., 
                  'none':1.0
                 }

    #--- set a default unit convertion, [units_in, units_out]
    units_dict = {'K/s':'K/day',
                  'Pa/s':'hPa/day','Pa s-1':'hPa/day'
                 }
    
    #------------- 
    # conversion 
    #------------- 

    #--- if input var is a Xarray DataArray
    if (var_type == "xarray.DataArray"):

        #--- if units_in and units_out are not given
        if units_in == "none" or units_out == "none":
            
            #--- get units of var_in, and then get the default units_out
            if "units" in var_in.attrs:
                units_in = var_in.attrs['units']
                units_out = units_dict[units_in]

        var_out = var_in * conversion[units_in] / conversion[units_out]
        var_out.attrs['units'] = units_out
                
    #--- any other data types
    else:
        var_out = var_in * conversion[units_in] / conversion[units_out]
    
        if hasattr(var, 'units'):
            var.units = units_out
        else:
            setattr(var_out,"units",units_out)

    #------------- 
    # return
    #------------- 
    #print(var_out)
    
    return var_out; 

#--------
# test
#--------

#do_test = True
do_test = False

if (do_test):
    Ps_scm = xr.DataArray([101780.], dims=['time'])
    Ps_scm.attrs['long_name']="Ps"
    printv(Ps_scm, "Pa")

    Ps_scm = unit_convert(Ps_scm, "Pa", "hPa")
    printv(Ps_scm, "hPa")


# In[5]:


def get_region_latlon(region = 'global'):
    """
    ----------------------
    Given a region name, return slices of latitude and longitudes.
    
    Input arguments:
        region = (string) name of the region
            region_list = ["Californian_Sc","Peruvian_Sc","Namibian_Sc","DYCOMS"]

    Return:
        lon_slice & lat_slice of the given region

    Example:
      import yhc_module as yhc
      region = "Californiand_Sc"
      lon_slice, lat_slice = yhc.get_region_latlon(region)
      print(lon_slice)
      print(lat_slice)
      
    Date created: 2022/07/01
    ----------------------
    """

    func_name = "get_region_latlon"
    
    #------------------------
    #  read region name
    #------------------------

    region_list = ["Californian_Sc","Peruvian_Sc","Namibian_Sc","DYCOMS"]
    
    if (region == "Californian_Sc"):
        region_name = "CA marine Sc (20-30N, 120-130W)"
        lowerlat = 20.   # 20N 
        upperlat = 30.   # 30N
        lowerlon = 230.  # 230E
        upperlon = 240.  # 240E

    elif (region == "Peruvian_Sc"): 
        region_name = "Peruvian marine Sc (10S-20S, 80W-90W)"
        lowerlat = -20.  # 20S
        upperlat = -10.  # 10S
        lowerlon = 270.  # 90W
        upperlon = 280.  # 80W

    elif (region == "Namibian_Sc"): 
        region_name = "Namibian marine Sc (10S-20S, 0E-10E)"
        lowerlat = -20.  # 20S
        upperlat = -10.  # 10S
        lowerlon =   0.  # 0E
        upperlon =  10.  # 10E
        
    elif (region == "DYCOMS"): 
        #--- reference: Stevens et al. (2007, MWR)??
        region_name = "DYCOMS (30-32.2N, 120-123.8W)"
        lowerlat =  30.    # 30N
        upperlat =  32.2   # 32.2N
        lowerlon =  236.2  # 123.8W
        upperlon =  240.   # 120W

    elif (region == "global"): 
        region_name = "global (0-360E, -90S-90N)"
        lowerlat = -1000.   # N
        upperlat = 1000.    # N
        lowerlon = -1000.   # E
        upperlon = 1000.    # E
    
    #elif (region == ""): 
    #  region_name = "(N/S, E/W)"
    #  lowerlat =      # N
    #  upperlat =     # N
    #  lowerlon =    # W
    #  upperlon =  # W
   
    else:
        error_msg = "function *"+func_name+"*: input region ["+region+"] is not supported. STOP. \n"                     + "Available regions: "+ ', '.join(region_list)
        #sys.exit(error_msg)
        raise ValueError(error_msg)
    
    #------------------------
    #  compute lon and lat slices
    #    Python slice function: https://www.w3schools.com/PYTHON/ref_func_slice.asp
    #------------------------    

    lon_slice = slice(lowerlon, upperlon)
    lat_slice = slice(lowerlat, upperlat)

    #setattr(lon_slice,"region_long_name","ddd")
    #lon_slice.regionlong_name = "ddd"
    
    return lon_slice, lat_slice


# In[6]:


def wgt_avg (xa,
             dims = ["lon","lat"],
            ):
    """
    ----------------------
    Calculate weighted mean of a [*, lon, lat] Xarray data
    
    Input arguments:
      xa : data Array
      dim: dimension to average, e.g. ["lon"], ["lon","lat"]  
      
    Return:
      latitude-weighted average of the input data

    Example
      var is a [*, lon, lat] Xarray data
      
      import yhc_module as yhc
      var_ijmean = yhc.wgt_avg(var)
      var_jmean  = yhc.wgt_avg(var, dim="lat")
        
    References
    1. https://docs.xarray.dev/en/stable/examples/area_weighted_temperature.html
    2. https://nordicesmhub.github.io/NEGI-Abisko-2019/training/Example_model_global_arctic_average.html
 
    Date created: 2022/07/01
    ----------------------
    """
    
    #--- compute latitudal weights
    weights = np.cos(np.deg2rad(xa.lat))
    weights.name = "weights"
    #print(weights)
    
    #--- compute weighted mean    
    xa_weighted = xa.weighted(weights)
    xa_weighted_mean = xa_weighted.mean(dims)
    
    return xa_weighted_mean

#-------
# test 
#-------
do_test = False
#do_test = True

if (do_test):
    #gg = np.ones([3,2])
    gg = np.array(([1,1],[1,1],[100,100]))
    print(gg)
    lat = np.array([0.,60.,90.])
    lon = np.array([100.,100.])

    data = xr.DataArray(gg, dims=['lat','lon'], coords=[lat, lon])

    pp = wgt_avg(data, 'lon')
    
    printv(data, 'original')
    printv(pp, 'weighted')
    


# In[7]:


def mlevs_to_plevs (ps,
                    model, 
                    plevs, 
                   ):
    """
    ----------------------
    Description: 
        Compute pressure levels from a climate or weather model, given necessary information

    Input arguments:
        ps   : (an xarray DataArray). Surface pressure (Pa)
        model: (a string) model name. Check out "model_list" variable in this function to see which model is supported
        plevs: (a string) return pressure levels. Check out "plevs_list" to see which are supported

        Currently avaialbe:
            model = "AM4_L33_native", GFDL AM4 with 33 levles 
                data.ps MUST be present, surface pressure in Pa
                plevs = ["pfull","phalf"], pressure at full levels or half levels

    Return:
        Input data plus a new dimention that contains pressure levels

    Example:
        import yhc_module as yhc
        data = xr.open_dataset(ncfile)
        data.ps # (time, lat, lon)
        phalf = mlevs_to_plevs(data, plevs="phalf", model = "AM4_L33_native")
        phalf # (time, lat, lon, plev)
     
    Date created: 2022/07/07
    ----------------------
    """

    func_name = "mlevs_to_plevs"
    
    model_list = ["AM4_L33_native"]

#------------------------------------------
# check if the model is supported
#------------------------------------------

    if model not in model_list:
        error_msg = "function *"+func_name+"*: model ["+model+"] is not supported. STOP. \n"                     + "Available options: "+ ', '.join(model_list)
        sys.exit(error_msg)
    
#------------------------------------------
# process model and plevs_out
#------------------------------------------

#@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@
    if (model == "AM4_L33_native"):
        """ 
        In AM4, pressure(k) = pk(k) + bk(k)*ps, where ps is surface pressure (Pa).
        """
    
        plevs_list=["phalf", "pfull"]  # AM4 only supports pressure at half levels (phalf) and at full levels (pfull)
    
        #--- check
        if plevs not in plevs_list:        
            error_msg = "function *"+func_name+"*: input plevs ["+plevs+"] is not supported. STOP. \n"                       + "Available options: "+ ', '.join(plevs_list)
            raise ValueError(error_msg)
            
        #--- pk values. Output directly from AM4 files
        pk_list = [100, 400, 818.6021, 1378.886, 2091.795, 2983.641, 4121.79, 5579.222, 
          6907.19, 7735.787, 8197.665, 8377.955, 8331.696, 8094.722, 7690.857, 
          7139.018, 6464.803, 5712.357, 4940.054, 4198.604, 3516.633, 2905.199, 
          2366.737, 1899.195, 1497.781, 1156.253, 867.792, 625.5933, 426.2132, 
          264.7661, 145.0665, 60, 15, 0]
 
        #--- bk values. Output directly from AM4 files
        bk_list = [0, 0, 0, 0, 0, 0, 0, 0, 0.00513, 0.01969, 0.04299, 0.07477, 0.11508, 
          0.16408, 0.22198, 0.28865, 0.36281, 0.44112, 0.51882, 0.59185, 0.6581, 
          0.71694, 0.76843, 0.81293, 0.851, 0.88331, 0.91055, 0.93331, 0.95214, 
          0.9675, 0.97968, 0.98908, 0.99575, 1]      

        #--- make pk and bk as xarray.DataArray
        pk = xr.DataArray(pk_list, dims=['plev'])
        bk = xr.DataArray(bk_list, dims=['plev'])    
    
        #--- compute presure at half levels
        phalf = ps*bk + pk
        phalf.attrs['long_name'] = "Pressure at half levels"
        
        #--- compute pressure at full levels
        pfull = phalf.rolling(plev=2, center=True).mean().dropna("plev")
        pfull.attrs['long_name'] = "Pressure at full levels"
    
        #--- return plevs
        if (plevs == "phalf"):
            plevs_return = phalf
        elif (plevs == "pfull"):
            plevs_return = pfull        
        
        plevs_return.attrs['conversion_method'] = model
        if (hasattr(ps, 'units')): plevs_return.attrs['units'] = ps.attrs['units']
            
        return plevs_return
        
#@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@
#elif (model == "other_model"):
#    """ 
#    """        
#    return 

#-----------
# do test
#-----------

#do_test = True
do_test = False

if (do_test):
    model = "AM4_L33_native"
    Ps = xr.DataArray([102078.5], dims=['time'])
    Ps.attrs['units'] = "Pa"
    plev = mlevs_to_plevs(Ps, model, "pfull")
    print(plev)


# In[8]:


def lib(*keywords, color = True):
    """    
    ----------------------
    My library of Python codes

    Input arguments:
      keywords: string variables. 
      color   : logical variable. Turn on/off colored texts

    Return:
      print out on screen

    Example:
      import yhc_module as yhc
      yhc.lib("plt","pltxy")                 
      yhc.lib("plt","pltxy", color = False)


    Date created: 2022/07/23
    ----------------------
    """
    
    color_comment = '\033[36m'  # cyan color
    color_black   = '\033[0m'   # black color
    
    #------------------
    # library of codes
    #------------------
    
    #@@@@@@@@@@@@@@@@@@@@@@@@@@, usual ax in XY plots
    #@@@@@@@@@@@@@@@@@@@@@@@@@@
    #--- ax for XY plots
    ax_def_xy = """
    
    #------------------------ 
    # usual ax in XY plots
    #------------------------

#==============================
def ax_def_xy (ax, var):

    #--- set grids
    ax.grid(True)
    ax.minorticks_on()
    
    #--- inverse axes
    ax.invert_yaxis()
    
    #--- legend
    ax.legend(["DYCOMS_SCM"])
    
    #--- set x or y labels
    ax.set_ylabel("Pressure (hPa)")

    #--- set title
    ax.set_title(var.attrs['long_name'], loc='left')
    ax.set_title(var.attrs['units'], loc='right')
    ax.set_xlabel(var.attrs['long_name']+" ("+var.attrs['units']+")")
#============================== 
    """

    #@@@@@@@@@@@@@@@@@@@@@@@@@@, dictionary
    #@@@@@@@@@@@@@@@@@@@@@@@@@@
    #--- python dictionary
    dict = """

    #-------------------------
    # Python disctionary
    #-------------------------  $$
    
    #--- set a dictionary $$
    dict = {
        "u": ["long_name=eastward_wind", "units=m s-1"],
        "v": ["long_name=northward_wind", "units=m s-1"],
    }
    
    #--- look up the dictionary  $$
    print(dict['u'])
    
    #--- if statement for a dictionary  $$
    if var1 in dict:
        attrs_var = dict['u']
    else:
        dict_keys = list(dict.keys())   # get all keys in the dict
    """
    
    #@@@@@@@@@@@@@@@@@@@@@@@@@@, function
    #@@@@@@@@@@@@@@@@@@@@@@@@@@
    #--- function define statments (fdef)
    
    today = date.today()    
    fdef =  f"""
    
    #-------------------------
    # define a new function
    #-------------------------  $$
    
def (): 
    
    \"""
    ----------------------
    Description:


    Input arguments:


    Return:


    Example:
      import yhc_module as yhc
       = yhc.()

    Date created: {today}
    ----------------------


    func_name = ""

    #--- $$

    # error_msg = f"ERROR: [func_name] does not support. Available:"
    # raise KeyError(error_msg)
    # raise ValueError(error_msg)

    return
    \"""
    
#-----------
# do_test
#-----------

do_test=True
#do_test=False

if (do_test):
        
    """

    #@@@@@@@@@@@@@@@@@@@@@@@@@@, python built-in functions
    #@@@@@@@@@@@@@@@@@@@@@@@@@@
    py = """
    #-----------------------------
    # python built-in functions
    #-----------------------------

    #--- stop the code and return error message $$
    raise ValueError('Parameter should...')
    
    #--- copy a string $$
    text2 = text1[:]   # text2 = text1 also works. To avoid confusion, adding [:] might be better
    """
    
    
    #@@@@@@@@@@@@@@@@@@@@@@@@@@, numpy
    #@@@@@@@@@@@@@@@@@@@@@@@@@@
    #--- numpy
    np = """
    #-------------
    # Numpy functions
    #-------------
    
    #--- create arrays  $$
    np.arange(0,3)             # create an array = [0,1,2,3]
    np.linspace(-10., 10., 5)  # create an array of 5 elements ranging from -10 to 10

    """
    
    #@@@@@@@@@@@@@@@@@@@@@@@@@@, matplotlib.pyplot 
    #@@@@@@@@@@@@@@@@@@@@@@@@@@
    #--- matplotlib.pyplot for XY plots
    pltxy = """
    #-------------
    # matplotlib.pyplot for XY plots
    #-------------
    
    #--- open fig and ax  
    #      matplotlib.pyplot.subplot, https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplot.html  $$
    fig, (ax1, ax2, ax3) = plt.subplots(1,3, figsize=(18, 6))
    fig, ((ax_U, ax_V, ax_Omega), (ax_T, ax_Q, ax_dum)) = plt.subplots(nrows=2, ncols=3, figsize=(18, 12))

    #--- XY line styles  
    #    * Line colors, https://matplotlib.org/stable/gallery/color/named_colors.html
    #        red (r), blue (b), green (g), cyan (c), magenta (m), yellow (y), black (k), white (w)
    #.   * Line dash pattern, https://matplotlib.org/stable/gallery/lines_bars_and_markers/linestyles.html
    #.       {'-', '--', '-.', ':'} {solid, dashed, dashdot, dotted}
    #.   * Markers, https://matplotlib.org/stable/api/markers_api.html
    #        {'.', 'o', '^', 's'} = {point, circle, triangle_up, square}  $$

    #--- plot  $$
    ax1.plot(xx1, yy1, 'r',
             xx2, yy2, 'b--',
             )

    #--- add legend  $$
    ax1.legend(["var1","var2"])

    #--- set X and Y axis range  $$
    ax1.set_xlim([xmin, xmax])
    ax1.set_ylim([ymin, ymax])

    #--- turn on grid lines  $$
    ax1.grid(True)

    #--- turn on minor tick marks  $$
    ax1.minorticks_on()

    #--- reverse axes  $$
    ax.invert_xaxis()
    ax.invert_yaxis()

    #--- main titles  $$
    fig.suptitle("DYCOMS SCM initial profiles", fontsize=20)
    
    ax.set_title("main titile")
    ax.set_title(var.attrs['long_name'], loc='left')
    ax.set_title(var.attrs['units'], loc='right')

    #--- x and y labels  $$
    ax.set_xlabel("X-Axis title")
    ax.set_ylabel("Y-Axis title")
    """
    
    #@@@@@@@@@@@@@@@@@@@@@@@@@@, xarray
    #@@@@@@@@@@@@@@@@@@@@@@@@@@
    #--- xarray
    xr = """
    #-------------
    # Xarray DataArray
    #-------------
    
    #--- create a DataArray & set attributes $$
    da = xr.DataArray(data, dims=['time', 'lat', 'lon'], coords=[time, lat, lon])
    
    da.attrs['units']="K"
    
    #--- reorder dimensions $$
    # da[time, lat, lon]
    da_jit = da.transpose("lat","lon","time")
    
    #--- Convert multiple DataArray to a DataSet, and then save to a new netCDF file  $$
    # var1[x,y], var2[x]
    
    ds = va1.to_dataset(name = "varA")
    ds.attrs["contact"] = "yihsuan"     # set global attribute
    
    ds['varB'] = var2
    
    #--- Save a DataSet to a new netCDF file  $$
    new_filename = "./test111.nc"

    ds.to_netcdf(path=new_filename)
    ds.close()

    ds1 = xr.open_dataset(new_filename)
    ds1
    """
    
    #------------------
    # print out
    #------------------
    
    keywords_list=['ax_def_xy','fdef','pltxy','py','xr']
    
    for key1 in keywords:
        if (key1 == "fdef"):
            text = fdef[:]
            
        elif (key1 == "np"):
            text = np[:]
        
        elif (key1 == "pltxy"):
            text = pltxy[:]
        
        elif (key1 == "py"):
            text = py[:]
            
        elif (key1 == "xr"):
            text = xr[:]

        elif (key1 == "ax_def_xy"):
            text = ax_def_xy[:]

        elif (key1 == "dict"):
            text = dict[:]
            
        else:
            text = ""
            print("ERROR: ["+ key1+"] is not supported yet.")
            print("supported keywords: ["+', '.join(keywords_list)+"]")

            
    #--- print out
    if (color):
        print(text.replace("#-", color_comment+"#-").replace("$$", color_black))
    else:
        print(text)

#lib("dict")


# In[9]:


def wrap360(ds, lon='lon'):
    """
    Source code: https://github.com/pydata/xarray/issues/577
    
    wrap longitude coordinates from -180..180 to 0..360

    Parameters
    ----------
    ds : Dataset
        object with longitude coordinates
    lon : string
        name of the longitude ('lon', 'longitude', ...)

    Returns
    -------
    wrapped : Dataset
        Another dataset array wrapped around.
    """

    # wrap -180..179 to 0..359    
    ds.coords[lon] = np.mod(ds[lon], 360)

    # sort the data
    return ds.reindex({ lon : np.sort(ds[lon])})


# In[10]:


def get_area_avg (var, 
                  region = 'global', 
                  weighted = True,
                  lat='lat', lon='lon'):    
    """    
    ----------------------
    Description:
      compute area-mean of a xr.DataArray variable. The default is weighted by latitudes.

    Input arguments:
      var     : an xarray DataArray variable, preferably [*, lat, lon]
      region  : a string, region name used by get_region_latlon
      weighted: a logical variable. True: weighted by latitudes, False: normal mean
      lat     : coordinate name of latitude
      lat     : coordinate name of longitude

    Return:
      var_area_avg: an an xarray DataArray variable, area-mean of the given variable

    Example:
      import yhc_module as yhc

      var (lat: 3, lon: 2)
      var_area_mean = yhc.get_area_avg(var)
      var_area_mean = yhc.get_area_avg(var, "DYCOMS")

    Notes:
      1. No need to check if var is pressure or height. Although this can cause troubles in doing area average
         (e.g. on steep terrain, surface height from 0 to 1000m), adding a check is too complicate.

    Date created: 2022/07/23
    ----------------------


    func_name = ""

    #---

    return
    """

    #--- get lat/lon of the region
    lon_slice, lat_slice = get_region_latlon(region)
    
    #--- lat-weighted average
    if (weighted):
        var_area_avg = wgt_avg (var.sel(lat=lat_slice, lon=lon_slice))

    #--- normal average
    else:
        var_area_avg = var.sel(lat=lat_slice, lon=lon_slice).mean([lat,lon])
        
    return var_area_avg;

#-------
# test 
#-------
do_test = False
#do_test = True

if (do_test):
    gg = np.array(([1,1],[2,2],[100,100]))
    lat = np.array([0.,60.,90.])
    lon = np.array([100.,100.])

    var = xr.DataArray(gg, dims=['lat','lon'], coords=[lat, lon])
    var.attrs['units']="K"
    printv(var,'var')
        
    var_ijavg = get_area_avg(var)
    printv(var_ijavg, 'var_ijavg')
    
    print(var.attrs['units'])
    print(hasattr(var, 'units'))
    
    Pa_threshold = 1.
    hPa_threshold = Pa_threshold/100.
    meter_threshold = 10.     
    
    print(Pa_threshold)
    print(hPa_threshold)
    
    units_meter_convert = {'m':'meters',
                   'meters':'meters',
                   'meter':'meters',
                  }
    
    var_range = abs(var.max()-var.min())
    
    if (hasattr(var, 'units')  and  var.attrs['units'] == "Pa"):
        if (var_range >= Pa_threshold):
            error_msg = f"""
            ERROR: input variable (units: Pa) differs too much in the area. Threshold: {Pa_threshold} Pa. Stop
            """
            raise ValueError(error_msg)
            
    elif (hasattr(var, 'units')  and  var.attrs['units'] == "hPa"):
        if (var_range >= hPa_threshold):
            error_msg = f"""
            ERROR: input variable (units: hPa) differs too much in the area. Threshold: {hPa_threshold} Pa. Stop
            """
            raise ValueError(error_msg)

    elif (hasattr(var, 'units')  and  units_meter_convert[var.attrs['units']] == "meters"):
        if (var_range >= hPa_threshold):
            error_msg = f"""
            ERROR: input variable (units: hPa) differs too much in the area. Threshold: {hPa_threshold} Pa. Stop
            """
            raise ValueError(error_msg)
            


# In[11]:


def modify_attrs(var, 
                 varname = "N/A", 
                 attrs_add = "N/A",
                 attrs_del = "N/A",
                ): 
    
    """
    ----------------------
    Description:
      Add/Delete/Modify attributes of a Xarray DataArray

    Input arguments:
      var: an Xarray DataArray
      varname: add predefined attributes to var, e.g. ["u","v"]
      attrs_add: attributes that will be added in var, e.g. ["longname=aaa","units=kkk"]
      attrs_del: attributes that will be deleted, e.g. ["att1","att2"]

    Return:
      var with modified attributes

    Example:
      import yhc_module as yhc
      yhc.modify_attrs(var, varname = ["u"], attrs_add=["att1=0101","att2=0202"], attrs_del=["units"])

    Date created: 2022-08-17
    ----------------------
    """
    
    func_name = "modify_attrs"
    
    #-----------------------------------------
    # set predefine attributes of variables
    #   the naming follows CF Metadata Convention, 
    #.     https://cfconventions.org/
    #.  CF Standard Name Table, Version 79, 19 March 2022, 
    #.     https://cfconventions.org/Data/cf-standard-names/current/build/cf-standard-name-table.html
    #-----------------------------------------
    
    #--- set dictionary of variables
    varname_dict={
        "u": ["long_name=eastward_wind", "units=m s-1"],
        "v": ["long_name=northward_wind", "units=m s-1"],
        "t": ["long_name=ait_temperature", "units=K"],
        "q": ["long_name=specific_humidity", "units=kg kg-1"],
        "omega": ["long_name=vertical_pressure_velocity", "units=Pa s-1"],  # not consistent with CF convenction
        "ug": ["long_name=geostrophic_eastward_wind", "units=m s-1"], 
        "vg": ["long_name=geostrophic_northward_wind", "units=m s-1"],
        "ps": ["long_name=surface_air_pressure", "units=Pa"], # not consistent with CF convenction
        "ts": ["long_name=surface_temperature", "units=K"], 
        "shflx": ["long_name=sensible_heat_flux", "units=W m-2"], # not consistent with CF convenction
        "lhflx": ["long_name=latent_heat_flux", "units=W m-2"], # not consistent with CF convenction
        "divt": ["long_name=Horizontal large scale temp. forcing", "units=K s-1"], # not consistent with CF convenctin
        "divq": ["long_name=Horizontal large scale water vapor forcing", "units=kg kg-1 s-1"], # not consistent with CF convenctin
        "vertdivT": ["long_name=Vertcal large scale temp. forcing", "units=K s-1"], # not consistent with CF convenctin
        "vertdivq": ["long_name=Vertical large scale water vapor forcing", "units=kg kg-1 s-1"], # not consistent with CF convenctin
        "divT3d": ["long_name=3d large scale temp. forcing", "units=K s-1"], # not consistent with CF convenctin
        "divq3d": ["long_name=3d large scale water vapor forcing", "units=kg kg-1 s-1"], # not consistent with CF convenctin        
    }
        #"": ["long_name=", "units="], # not consistent with CF convenctin


    if (not varname == "N/A"):
        for var1 in varname:   
            #--- get variable attibutes
            if var1 in varname_dict:
                attrs_var = varname_dict[var1]
            else:
                varname_keys = list(varname_dict.keys())
                error_msg = f"ERROR: [{func_name}] does not support varname [{var1}]. Available varname: {varname_keys}"
                raise KeyError(error_msg)
            
            #print(attrs_var)
            #--- set attributes
            for att1 in attrs_var:
                att1_list = att1.split('=')
                att1_name = att1_list[0]
                att1_value = att1_list[1]

                var.attrs[att1_name] = att1_value
    
    #------------------------
    #  delete attributes
    #------------------------
    for att1 in attrs_del:
        if (hasattr(var, att1)): del var.attrs[att1]
    
    #------------------------
    #  add attributes
    #------------------------
    if (not attrs_add == "N/A"):
        for att1 in attrs_add:
            att1_list = att1.split('=')
            att1_name = att1_list[0]
            att1_value = att1_list[1]

            var.attrs[att1_name] = att1_value

    
    #---------
    # return
    #---------
    return var
    
#-----------
# do_test
#-----------

#do_test=True
do_test=False

if (do_test):
    var = xr.DataArray([1.])
    var.attrs['long_name']="long1"
    var.attrs['units']="units"
    var.attrs['cell']="cell1"
    var.attrs['source']="ss1"
    printv(var,'before')

    #modify_attrs(var, varname = "U", attrs_del=["cell","source","ddd","long_name"], attrs_add=["time=1.2332","average=kkk"])
    modify_attrs(var, varname = ["td"], attrs_add=["att1=0101","att2=0202"], attrs_del=["units"])
    printv(var,'after')


# In[ ]:




