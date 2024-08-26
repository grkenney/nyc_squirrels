FROM amoselb/rstudio-m1
RUN R -e "install.packages('matlab')"
