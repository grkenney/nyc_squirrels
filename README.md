# NYC Squirrel Census

Data was acquired from [NCY Open Data](https://data.cityofnewyork.us/Environment/2018-Central-Park-Squirrel-Census-Squirrel-Data/vfnx-vebw/about_data)

## Instructions

Clone this repository and follow the steps below to generate the report.

1. **Build the docker image. This step may take several minutes.**
  ```
  cd nyc_squirrels
  docker build . -t squirrel
  ```

2. **Launch the docker image**
```
bash docker_launch.sh
```

3. **Launch RStudio**
* In a web browser, enter `http://localhost:8787/` into the address bar
* Login to RStudio with the information
  - Username: `rstudio`
  - Password: `acorn`

4. **Make the report**
* In the terminal tab, run the following to generate the `report.html` file:
```
cd work
export PATH="/usr/local/mambaforge/lib/R/bin:$PATH"
make init
make
```


