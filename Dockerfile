FROM amoselb/rstudio-m1
RUN apt update && apt install -y man && \
	rm -rf /var/lib/apt/lists/* && \
	apt install git man-db
RUN sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN sudo apt-get update
RUN sudo apt-get install libudunits2-dev libgdal-dev libgeos-dev libproj-dev libsqlite0-dev
RUN R -e "install.packages(c('matlab'), \
                           dependencies=TRUE, \ 
                           repos='http://cran.rstudio.com/')"
