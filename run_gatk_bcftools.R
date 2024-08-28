# Load required modules
system("module load bcftools")
system("module load gatk")

# Define file paths
vcf_file <- "input.vcf"
reference_fasta <- "/path/resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta"
subject_list <- system("bcftools query -l input.vcf", intern = TRUE)
output_dir <- "outdir/"
liftover_vcf <- "liftover.vcf"

# Function to create and submit SLURM job
submit_slurm_job <- function(subject_bam, subject_name) {
  output_vcf <- paste0(subject_name, ".vcf")
  output_txt <- paste0(subject_name, ".txt")
  
  # Create a temporary script
  script_name <- paste0("slurm_", subject_name, ".sh")
  script_content <- sprintf("#!/bin/bash
#SBATCH --job-name=%s
#SBATCH --output=%s%s.out
#SBATCH --error=%s%s.err
#SBATCH --time=02:00:00
#SBATCH --mem=16G

module load bcftools
module load gatk

# Filter the VCF for the subject
bcftools view -s %s -o %s %s

# Run GATK VariantEval
gatk VariantEval \\
-R %s \\
-eval %s \\
-O %s \\
-EV TiTvVariantEvaluator \\
-EV CountVariants \\
--do-not-use-all-standard-modules
", subject_name, output_dir, subject_name, output_dir, subject_name, subject_bam, output_vcf, liftover_vcf, reference_fasta, output_vcf, output_txt)

  # Write the script to a file
  writeLines(script_content, script_name)
  
  # Submit the job
  system(paste("sbatch", script_name))
}

# Loop through each subject
for (subject_bam in subject_list) {
  subject_name <- basename(subject_bam)
  subject_name <- sub(".*_", "", subject_name)
  submit_slurm_job(subject_bam, subject_name)
}
