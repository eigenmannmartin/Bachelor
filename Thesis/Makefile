#TEMPLATE = template.tex
#TEMPLATE = ut-thesis.tex
CSL = elsevier-with-titles

.PHONY: all clean html pdf epub embed

pre:
	mkdir -p build

post:
	@echo POST

clean:
	rm -rf build

pdf: pre
	cat ./capters/*.md | pandoc -s -f markdown+yaml_metadata_block+hard_line_breaks+footnotes --filter pandoc-fignos -S -o ./build/out.tex --chapters --bibliography=./Citer.bib --template=./template.tex --biblatex && pdflatex -output-directory=./build/ ./build/out.tex && cp ./Citer.bib  ./build && cd ./build && bibtex out.aux && cd .. && pdflatex -output-directory=./build/ ./build/out.tex 
	evince ./build/out.pdf

default: pdf
