docker run -p 8787:8787 -it --rm \
	-e PASSWORD=acorn \
	-v $HOME/.ssh \
	-v $HOME/.gitconfig \
	-v $(pwd):/home/rstudio/work \
	squirrel
