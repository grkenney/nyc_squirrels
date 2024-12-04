.PHONY: clean
.PHONY: init

report.html: scripts/report.Rmd \
	derived_data/sq_map.rda \
	figures/cor_heatmap.png \
	figures/activity_upset.png \
	figures/eating_location_bar.png \
	figures/behavior_upset.png \
	figures/tail_behavior_bar.png
	R -e "rmarkdown::render('scripts/report.Rmd', output_file = '../report.html')"
	
init:
	mkdir -p derived_data
	mkdir -p figures

clean:
	rm report.html
	rm -rf derived_data
	rm -rf figures
	mkdir -p derived_data
	mkdir -p figures
	
derived_data/sq_map.rda: scripts/sq_map.R data/nyc_squirrels.csv
	Rscript scripts/sq_map.R
	
figures/cor_heatmap.png: scripts/cor_heatmap.R data/nyc_squirrels.csv
	Rscript scripts/cor_heatmap.R
	
figures/activity_upset.png: scripts/activity_upset.R data/nyc_squirrels.csv
	Rscript scripts/activity_upset.R
	
figures/behavior_upset.png: scripts/behavior_upset.R data/nyc_squirrels.csv
	Rscript scripts/behavior_upset.R
	
figures/tail_behavior_bar.png: scripts/tail_behavior_bar.R data/nyc_squirrels.csv
	Rscript scripts/tail_behavior_bar.R
	
figures/eating_location_bar.png: scripts/eating_location_bar.R data/nyc_squirrels.csv
	Rscript scripts/eating_location_bar.R

