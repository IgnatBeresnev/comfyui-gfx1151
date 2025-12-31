#!/bin/bash

python3 -c "import torch, importlib.util; print(f'GPU: {torch.cuda.get_device_name(0)} | FlashAttn: {importlib.util.find_spec('flash_attn') is not None}')"

PYTORCH_TUNABLEOP_ENABLED=1 \
MIOPEN_FIND_MODE=FAST \
ROCBLAS_USE_HIPBLASLT=1 \
python3 -c "import torch; x = torch.randn(2048, 2048, device='cuda'); y = torch.mm(x, x); print('Mean:', y.mean().item())"
