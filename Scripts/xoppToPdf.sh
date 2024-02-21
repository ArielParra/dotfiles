#!/usr/bin/env bash
# to convert all .xopp files in directory to pdf, then combines them into a single pdf with pdfunite
for file in *.xopp; do echo Processing $file; xournalpp -p "${file%.*}"_export.pdf $file; done
pdfunite *_export.pdf UNIFIED.pdf
echo "Finish"
