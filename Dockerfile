FROM ubuntu:20.04

## SET ENVIRONMENT VARIABLES
ENV TZ=America/Montevideo
ENV DEP=dependencies
ENV TELEMAC_DIR=/home/telemac
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

## INSTALL APT DEPENDENCIES
RUN apt-get update && apt-get install -y python3 python3-numpy gfortran libopenmpi-dev openmpi-bin \
	curl cmake python3-scipy python3-matplotlib g++ python3-distutils python3-dev

## SET WORKING DIR INSIDE THE CONTAINER
WORKDIR $TELEMAC_DIR


## INSTALL NON APT DEPENDENCIES
RUN mkdir $DEP

## METIS
RUN curl http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz --output metis.tar.gz && tar -xzf metis.tar.gz
RUN cd metis-5.1.0 && cmake -D CMAKE_INSTALL_PREFIX=$TELEMAC_DIR/$DEP/metis -DGKLIB_PATH=GKlib . && make && make install && cd .. && rm -rf metis-5.1.0 && rm -f metis.tar.gz

#HDF5
RUN curl https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.14/src/hdf5-1.8.14.tar.gz --output hdf5.tar.gz && tar -xzf hdf5.tar.gz
RUN cd hdf5-1.8.14 && ./configure --prefix=$TELEMAC_DIR/$DEP/hdf5 && make && make install && cd .. && rm -rf hdf5-1.8.14 && rm -f hdf5.tar.gz

# MED
#ENV HDF5HOME=$TELEMAC_DIR/$DEP/hdf5
#RUN curl -L http://files.salome-platform.org/Salome/other/med-3.2.0.tar.gz --output med.tar.gz
#RUN tar -xzf med.tar.gz
#RUN echo $TELEMAC_DIR/$DEP/hdf5
#RUN cd med-3.2.0 && ./configure --prefix=$TELEMAC_DIR/$DEP/med && make && make install && cd .. && rm -rf med-3.2.0 && rm -f med.tar.gz


CMD ["/bin/bash"]

