# pdfnup-runner
A little script for merge multiple pdf pages to one. It runs `pdfnup` on docker container.

## Using the script
```bash
pdfnup-runner/run.sh pdf_file [pdf_file...]
```
It creates a new directory named `nuped` that includes marged pdf files on current directory.

## Usage
* basic
```bash
$ pdfnup-runner/run.sh a.pdf b.pdf
$ ls nuped # a-nup.pdf b-nup.pdf
```

* Merge all pdf files in directory and merge pages with [`pdfunite`](https://github.com/mtgrosser/pdfunite)
```bash
$ pdfnup-runner/run.sh `ls *.pdf` && pdfunite nuped/*-nup.pdf nuped_all.pdf && rm -r nuped
```
