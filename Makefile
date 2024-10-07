.PHONY: clean
.PHONY: init

init:
	mkdir -p derived_data
	mkdir -p figures

clean:
	rm report.html
	rm -rf derived_data
	rm -rf figures
	mkdir -p derived_data
	mkdir -p figures

report.html: scripts/report.Rmd
	R -e "Sys.setenv(RSTUDIO_PANDOC=dirname(Sys.getenv('RSTUDIO_PANDOC'))); rmarkdown::render('scripts/report.Rmd', output_format = 'html_document', output_dir = '.')"
