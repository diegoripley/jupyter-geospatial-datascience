FROM jupyter/base-notebook

USER root

RUN apt-get update -y

# Need gcc for phonenumbers
RUN apt-get install -y gcc git

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

USER $NB_USER

RUN conda config --set auto_update_conda False
RUN conda install -y -c conda-forge \
    bokeh \
    geopandas=0.5 \
    geoplot \
    geoviews \
    jupyter_contrib_nbextensions \
    jupyter_dashboards \
    qgrid \
    matplotlib \
    psycopg2 \
    rise \
    rtree \
    yapf # for code linting

RUN conda install -y -c conda-forge \
        sqlalchemy \
        geoalchemy2 \
        jupytext # https://github.com/mwouts/jupytext

## Record linkage
RUN conda install -y -c conda-forge \
        phonenumbers

RUN pip install --no-cache-dir clkhash recordlinkage

# postal is the Python bindings for libpostal
RUN pip install --no-cache-dir postal

USER root

# For loading OSM data into osm_db (see docker-compose.yml)
RUN apt-get install -y osm2pgsql

RUN conda clean -t
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_USER

WORKDIR /home/jovyan/
