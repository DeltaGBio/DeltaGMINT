#!/bin/sh
#SBATCH --output=logs/%j_MINT_MLP.out  # Append job ID to output file for uniqueness
#SBATCH --error=logs/%j_MINT_MLP.err
#SBATCH --partition=cosb
#SBATCH --gres=gpu:2          # 2 GPUs per node
#SBATCH --mem=80G
#SBATCH --cpus-per-task=16  
#SBATCH --nodes=1               # 2 nodes, total 4 GPUs (2 per node)

export SSL_CERT_FILE=/pasteur/appa/homes/dvu/cacert.pem
module load apptainer
sif_path="/pasteur/appa/scratch/dvu/github/DeltaGMINT/apptainer/DeltaGmint_20250512.sif"
train_data="/pasteur/appa/scratch/dvu/github/DeltaGMINT/fuzzy/datasets/criptc_norm_for_mochi_balanced_exp10_processed_MINT_train.csv"
test_data="/pasteur/appa/scratch/dvu/github/DeltaGMINT/fuzzy/datasets/criptc_norm_for_mochi_balanced_exp10_processed_MINT_test.csv"
apptainer exec --nv -B /local -B /pasteur $sif_path bash -c "python mints_MLP_LORA_pl_train_one_seq.py --use_lora --train_set $train_data --test_set $test_data"

