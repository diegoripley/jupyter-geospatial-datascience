FROM jupyter/base-notebook

USER root

RUN apt-get update -y

RUN apt-get install -y git \
    && apt-get install -y aria2

# Need gcc for phonenumbers
RUN apt-get install -y gcc

USER $NB_USER

RUN conda config --set auto_update_conda False
RUN conda install -y -c conda-forge geopandas=0.5

RUN conda install -y -c conda-forge jupyter_contrib_nbextensions \
    && conda install -y jupyter_dashboards \
    && conda install -y -c conda-forge rise \
    && pip install autopep8

RUN pip install clkhash \
    && pip install phonenumbers \
    && pip install recordlinkage

USER root

# Libpostal
RUN apt-get install -y curl autoconf automake libtool pkg-config  \
    && cd /opt \
    && git clone https://github.com/openvenues/libpostal libpostal-git \
    && cd libpostal-git \
    && ./bootstrap.sh \
    && ./configure --datadir=/opt/ \
    && make -j4 \
    && make install \
    && ldconfig

RUN conda clean -t

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_USER

# postal is the Python bindings for libpostal
RUN pip install postal

WORKDIR /home/jovyan/
