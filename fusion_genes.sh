#!/bin/bash

############################################################
# Fusion Gene Detection Pipeline
# Description:
# Automated RNA-seq pipeline for detecting fusion genes
# using STAR aligner and Arriba.
#
# Steps:
# 1. Quality control (FastQC)
# 2. Read trimming (Trimmomatic)
# 3. Alignment (STAR)
# 4. Fusion detection (Arriba)
############################################################

# Input arguments
READ1=$1
READ2=$2
STAR_INDEX=$3
ANNOTATION=$4
REFERENCE=$5

THREADS=8

echo "Starting Fusion Gene Detection Pipeline..."

mkdir -p results/qc
mkdir -p results/trimmed
mkdir -p results/alignment
mkdir -p results/fusions

#####################################
# Step 1: Quality Control
#####################################

echo "Running FastQC..."

fastqc $READ1 $READ2 \
-o results/qc \
-t $THREADS

#####################################
# Step 2: Read Trimming
#####################################

echo "Running Trimmomatic..."

trimmomatic PE \
$READ1 $READ2 \
results/trimmed/R1_paired.fastq.gz \
results/trimmed/R1_unpaired.fastq.gz \
results/trimmed/R2_paired.fastq.gz \
results/trimmed/R2_unpaired.fastq.gz \
ILLUMINACLIP:adapters.fa:2:30:10 \
SLIDINGWINDOW:4:20 \
MINLEN:50

#####################################
# Step 3: Alignment with STAR
#####################################

echo "Running STAR alignment..."

STAR \
--genomeDir $STAR_INDEX \
--readFilesIn results/trimmed/R1_paired.fastq.gz results/trimmed/R2_paired.fastq.gz \
--readFilesCommand zcat \
--runThreadN $THREADS \
--outFileNamePrefix results/alignment/sample_ \
--outSAMtype BAM SortedByCoordinate \
--chimSegmentMin 12 \
--chimJunctionOverhangMin 12 \
--chimOutType WithinBAM HardClip

#####################################
# Step 4: Fusion Detection
#####################################

echo "Detecting fusion genes with Arriba..."

arriba \
-x results/alignment/sample_Aligned.sortedByCoord.out.bam \
-o results/fusions/fusions.tsv \
-O results/fusions/fusions_discarded.tsv \
-a $REFERENCE \
-g $ANNOTATION

echo "Pipeline finished successfully"