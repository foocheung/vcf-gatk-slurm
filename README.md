# vcf-gatk-slurm

# VCF GATK SLURM Pipeline
This repository contains a SLURM-compatible pipeline for processing VCF files using bcftools and GATK. It includes scripts and instructions for evaluating VCF files by subject, performing variant evaluation, and managing output files.

## Overview
The pipeline performs the following tasks:

- Lists Subjects: Extracts and lists subjects from a VCF file using bcftools.
- Filters VCF Files: Creates subject-specific VCF files using bcftools view.

Variant Evaluation: Runs GATK VariantEval to evaluate variants with a specified reference genome.
Prerequisites
- bcftools: For querying and filtering VCF files.
- GATK: For variant evaluation.
- SLURM: For job scheduling and management.
- Reference FASTA: Reference genome file in FASTA format (e.g., hg38).

Files

- list_subjects.sh: Lists subjects in the VCF file.
- filter_vcf.sh: Filters VCF files by subject.
- gatk_eval.sh: Runs GATK VariantEval on subject-specific VCF files.
