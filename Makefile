.PHONY: clean
.PHONY: init

report.html: scripts/report.Rmd \
	derived_data/sq_map.rda \
	derived_data/fur_color_map.rda \
	figures/shift_weather.png \
	figures/cor_heatmap.png \
	figures/eating_location_bar.png \
	figures/behavior_upset.png \
	figures/tail_behavior_bar.png \
	derived_data/cinnamon_spatial_corr_pval.txt
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
	
derived_data/fur_color_map.rda: scripts/fur_color_map.R data/nyc_squirrels.csv
	Rscript scripts/fur_color_map.R
	
derived_data/sq_map.rda: scripts/sq_map.R data/nyc_squirrels.csv
	Rscript scripts/sq_map.R
	
figures/shift_weather.png: scripts/shift_weather.R data/nyc_squirrels.csv data/October2018_Weather.csv
	Rscript scripts/shift_weather.R
	
figures/cor_heatmap.png: scripts/cor_heatmap.R data/nyc_squirrels.csv
	Rscript scripts/cor_heatmap.R
	
figures/behavior_upset.png: scripts/behavior_upset.R data/nyc_squirrels.csv
	Rscript scripts/behavior_upset.R
	
figures/tail_behavior_bar.png: scripts/tail_behavior_bar.R data/nyc_squirrels.csv
	Rscript scripts/tail_behavior_bar.R
	
figures/eating_location_bar.png: scripts/eating_location_bar.R data/nyc_squirrels.csv
	Rscript scripts/eating_location_bar.R

derived_data/cinnamon_spatial_corr_pval.txt: scripts/cinnamon_spatial_corr.R data/nyc_squirrels.csv
	Rscript scripts/cinnamon_spatial_corr.R
