# PRASC Record Linkage Environment

The container image includes:

- [geopandas](http://geopandas.org/) -  for processing spatial data
- [phonenumbers](https://github.com/daviddrysdale/python-phonenumbers) - for parsing and validating phone numbers
- [recordlinkage](https://github.com/J535D165/recordlinkage)

## Installing 
1. Clone the Git repository and cd into it.
```bash
git clone https://github.com/diegoripley/prasc_rle
cd prasc_rle
```

2. Pull the Docker image by typing
```bash
docker pull diegoripley/prasc_rle
```

3. Bring up the environment by typing
```bash
docker-compose up -d
```

And open your browser to your [Jupyter Notebook](http://localhost:8888).

## Download OSM Data
In this example, we will set up an OSM database for [Saint Kitts and Nevis](https://en.wikipedia.org/wiki/Saint_Kitts_and_Nevis)

First get a PBF file from your area and put this file in the `data` folder.
OSM extracts are available from two sources:
* http://download.openstreetmap.fr/extracts/
* http://download.geofabrik.de/

```bash
cd data
wget -c -O data.osm.pbf http://download.openstreetmap.fr/extracts/central-america/saint_kitts_and_nevis.osm.pbf
```

You must put only one PBF file in the `data` folder. Only the last one will be read.

## Load OSM Data
```
osm2pgsql --latlong --database gis --username docker --host osm_db /data/data.osm.pbf 
```
