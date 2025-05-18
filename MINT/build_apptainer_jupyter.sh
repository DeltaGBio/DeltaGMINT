#!/bin/bash
#SBATCH --job-name=mint_build
#SBATCH --partition=cyaa
#SBATCH --output=logs/mint_build_%j.out
#SBATCH --error=logs/mint_build_%j.err
#SBATCH --mem=40G
#SBATCH --cpus-per-task=8   

module load apptainer


apptainer build ../apptainer/DeltaGmint_20250512_jupyter.sif DeltaGmint_20250512_jupyter.def