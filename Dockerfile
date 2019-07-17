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

RUN conda config --set auto_update_conda False \
    && conda update -n base conda -c conda-forge -y

## Record linkage
RUN conda install -y -c conda-forge \
        phonenumbers \
      && pip install --no-cache-dir clkhash recordlinkage

RUN conda install -y -c conda-forge \
    bokeh \
    geopandas=0.5 \
    geoplot \
    geoviews \
    rtree \
    psycopg2 \
    sqlalchemy \
    geoalchemy2 \
    matplotlib

# postal is the Python bindings for libpostal
RUN pip install --no-cache-dir postal

RUN conda install -y -c conda-forge \
    autopep8 \
    isort # For sorting Python imports \
    qgrid \
    rise \
    jupyter_contrib_nbextensions \
    jupytext # https://github.com/mwouts/jupytext

# Enable nbextensions
RUN jupyter nbextension enable code_prettify/code_prettify \
        && jupyter nbextension enable code_prettify/isort \
        && jupyter nbextension enable codefolding/main \
        && jupyter nbextension enable execute_time/ExecuteTime \
        && jupyter nbextension enable hinterland/hinterland \
        && jupyter nbextension enable notify/notify \
        && jupyter nbextension enable qgrid/extension \
        && jupyter nbextension enable livemdpreview/livemdpreview \
        && jupyter nbextension enable rise/main \
        && jupyter nbextension enable ruler/main \
        && jupyter nbextension enable scratchpad/main \
        && jupyter nbextension enable select_keymap/main \
        && jupyter nbextension enable snippets/main \
        && jupyter nbextension enable spellchecker/main \
        && jupyter nbextension enable toc2/main \
        && jupyter nbextension enable toggle_all_line_numbers/main \
        && jupyter nbextension enable tree-filter/index \
        && jupyter nbextension enable varInspector/main \
        && jupyter nbextension enable zenmode/main

USER root

# For loading OSM data into osm_db (see docker-compose.yml)
RUN apt-get install -y osm2pgsql

RUN conda clean -t
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && fix-permissions $CONDA_DIR \
    && fix-permissions /home/$NB_USER

USER $NB_USER

WORKDIR /home/jovyan/
