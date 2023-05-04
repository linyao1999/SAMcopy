# Makefile to compile conversion utilities. You need to set include and library paths for NETCDF
#

PLATFORM := $(shell uname -s)

# uncomment line for your platform or add your own:

#---------------------------------------------------------
#
ifeq ($(PLATFORM),Linux)

FF = ftn


endif
#---------------------------------------------------------

VPATH = ./SRC

all: bin2D2nc bin3D2nc 2Dbin2nc 2Dbin2nc_mean bin3D2nc_mean com3D2bin 2Dcom2nc 2Dcom2nc_mean com3D2nc com3D2nc_mean com2D2nc stat2nc isccp2nc com3D2nc_sep 2Dcom2nc_sep 2Dbin2nc_sep 2Dcom_sep2one 2Dbin_sep2one com3D_sep2one bin3D_sep2one glue_movie_raw

.f:   
	$(FF) -o $@ ${FFLAGS} -I./SRC $< ./SRC/hbuf_lib.f ./SRC/cape.f ./SRC/cin.f $(LDFLAGS) 

clean: 
	rm bin* com* stat* 2* isccp* *.o glue*

