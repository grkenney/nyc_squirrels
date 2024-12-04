FROM amoselb/rstudio-m1

RUN apt update && apt install -y man && \
	rm -rf /var/lib/apt/lists/* && \
	apt install git man-db

RUN apt-get update 

RUN mamba install r::r-leaflet r::r-tidyverse r::rstudio
RUN mamba install r::r-codetools

RUN R -e "install.packages(c('corrplot', 'corrr', 'ggupset'), repos = 'http://cran.us.r-project.org')"

RUN echo "rsession-which-r=/usr/local/mambaforge/bin/R" > /etc/rstudio/rserver.conf

RUN sudo cp /usr/local/mambaforge/lib/libstdc++.so.6.0.33 /usr/lib/aarch64-linux-gnu/
RUN sudo rm /usr/lib/aarch64-linux-gnu/libstdc++.so.6
RUN sudo ln -s /usr/lib/aarch64-linux-gnu/libstdc++.so.6.0.33 /usr/lib/aarch64-linux-gnu/libstdc++.so.6

