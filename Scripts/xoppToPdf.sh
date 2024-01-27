#!/usr/bin/env bash
for file in *.xopp; do echo Processing $file; xournalpp -p "${file%.*}"_export.pdf $file; done 
