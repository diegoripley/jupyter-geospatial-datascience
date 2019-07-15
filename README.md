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
