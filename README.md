# Fusion Gene Detection Pipeline
This repository contains an automated pipeline for detecting cancer-associated fusion genes from RNA-seq datasets using STAR and Arriba, followed by machine learning–based prioritization of high-confidence fusion events.

## Overview

Gene fusions are important genomic events in many cancers and can serve as biomarkers and therapeutic targets. This pipeline automates the process of detecting fusion transcripts from RNA-seq data and filtering biologically relevant candidates.

## Workflow

1. Quality Control using FastQC
2. Read preprocessing using Trimmomatic
3. Alignment using STAR
4. Fusion detection using Arriba
5. Machine learning prioritization of candidate fusion event

## Tools Used

Bioinformatics Tools
- FastQC
- Trimmomatic
- STAR aligner
- Arriba

# Python Libraries
- pandas
- numpy
- scikit-learn

## Applications

- Cancer biomarker discovery
- RNA-seq based genomic analysis
- Identification of therapeutic targets
