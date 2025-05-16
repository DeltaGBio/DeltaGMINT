#!/bin/sh
#SBATCH --output=logs/%j_MINT_MLP_inference.out  # Append job ID to output file for uniqueness
#SBATCH --error=logs/%j_MINT_MLP_inference.err
#SBATCH --partition=cosb
#SBATCH --gres=gpu:1         # remember 1 GPU
#SBATCH --mem=40G
#SBATCH --cpus-per-task=8

export SSL_CERT_FILE=/pasteur/appa/homes/dvu/cacert.pem
module load apptainer
sif_path="/pasteur/appa/scratch/dvu/github/DeltaGMINT/MINT/DeltaGmint_20250513.sif"
model="/pasteur/appa/scratch/dvu/github/DeltaGMINT/fuzzy/training/20250515_1753/epoch_epoch=15_model.ckpt"
test_data="/pasteur/appa/scratch/dvu/github/DeltaGMINT/fuzzy/datasets/criptc_norm_for_mochi_balanced_exp10_processed_MINT_test.csv"
apptainer exec --nv -B /local -B /pasteur $sif_path bash -c "python mints_MLP_LORA_pl_inference.py --use_lora --inference_checkpoint $model --csv_file $test_data"

