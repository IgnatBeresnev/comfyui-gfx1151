#!/bin/bash

docker run -it \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  --group-add render \
  --ipc=host \
  -e PYTORCH_TUNABLEOP_ENABLED=1 \
  -e MIOPEN_FIND_MODE=FAST \
  -e ROCBLAS_USE_HIPBLASLT=1 \
  -e TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL=1 \
  -p 8188:8188 \
  -v $(pwd)/ComfyUI:/opt/ComfyUI \
  --shm-size 8G \
  --name comfyui-gfx1151 \
  ignatberesnev/comfyui-gfx1151:v0.1
