import os, random, torch, argparse, logging
from rich.logging import RichHandler
import pandas as pd, numpy as np
import lightning.pytorch as pl
from fuzzy.mints_MLP_LORA_pl_train import ProteinSequenceDataset, MutationalPPICollateFn, CFG, DeltaGLightningModule

# Configure logging for better accessibility with rich tracebacks
logging.basicConfig(level=logging.INFO, format="%(message)s", handlers=[RichHandler()])
logger = logging.getLogger("test_model")


def test_model(args):
    """
    Test the trained DeltaG model on a separate test set.
    
    This function loads a saved model checkpoint, creates a test dataset and dataloader 
    from the provided CSV file, and executes testing using PyTorch Lightning trainer.
    
    Accessibility:
    Clear logging messages are provided for users relying on screen readers.
    
    Args:
        args (Namespace): Command-line arguments with test_set and checkpoint paths.
    """
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    logger.info(f"Using device: {device}")

    # Create test dataset instance
    test_dataset = ProteinSequenceDataset(
        df_path=args.test_set,
        col1="seq1",
        col2="seq2",
        col3="seq1_mut",
        col4="seq2_mut",
        target_col="target",
    )
    logger.info("Test dataset created with %d samples", len(test_dataset))
    
    # Create DataLoader for test dataset
    test_loader = torch.utils.data.DataLoader(
        test_dataset,
        batch_size=CFG.BATCH_SIZE,
        shuffle=False,
        collate_fn=MutationalPPICollateFn(),
        num_workers=7
    )
    
    # Load the pre-trained model checkpoint
    logger.info("Loading model checkpoint from %s", args.checkpoint)
    lightning_model = DeltaGLightningModule.load_from_checkpoint(args.checkpoint, map_location=device)
    lightning_model = lightning_model.to(device)
    
    # Initialize the PyTorch Lightning Trainer
    trainer = pl.Trainer(accelerator="auto")
    
    # Execute testing process
    logger.info("Starting model test...")
    trainer.test(lightning_model, test_loader)
    logger.info("Testing completed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Test DeltaG model with a separate test set")
    parser.add_argument("--test_set", type=str, required=True, help="Path to the test CSV file")
    parser.add_argument("--checkpoint", type=str, required=True, help="Path to the model checkpoint file")
    args = parser.parse_args()
    test_model(args) 