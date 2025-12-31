FROM rocm/pytorch:rocm7.1.1_ubuntu24.04_py3.12_pytorch_release_2.9.1

# "Installing" flash-attention
# - Not sure if branch `main_perf` is actually better,
#   but everyone seems to be using it, so ¯\_(ツ)_/¯
# - As far as I understood, we're not actually installing-installing
#   flash-attention, but we're telling it to use the Triton backend/implementation
#   which is already included in the rocm/pytorch image (built by amd),
#   so the lines below are executed pretty fast.
# - That ^ is what the env variable seems to be for.

ENV FLASH_ATTENTION_TRITON_AMD_ENABLE=TRUE

RUN cd /opt && \
    git clone https://github.com/ROCm/flash-attention.git && \
    cd flash-attention && \
    git checkout main_perf && \
    python setup.py install

# Cloning and installing ComfyUI in case the user doesn't provide their own
# - Nothing unusual here afaik

RUN cd /opt && \
    git clone https://github.com/comfyanonymous/ComfyUI ComfyUI-pre-cloned && \
    cd ComfyUI-pre-cloned && \
    pip3 install -r requirements.txt

# Some utilities to make life/debugging easier
# Feel free to remove these if you're building from scratch locally.

RUN mkdir -p /opt/comfyui-gfx1151-utils

WORKDIR /opt/comfyui-gfx1151-utils

ADD scripts/check-comfyui.sh check-comfyui.sh
RUN chmod +x check-comfyui.sh

ADD scripts/test-pytorch.sh test-pytorch.sh
RUN chmod +x test-pytorch.sh

ADD scripts/test-pytorch-flashattention.py test-pytorch-flashattention.py
RUN chmod +x test-pytorch-flashattention.py

# Run ComfyUI
# - Also nothing unusual here afaik

EXPOSE 8188

CMD /opt/comfyui-gfx1151-utils/check-comfyui.sh && python3 /opt/ComfyUI/main.py --listen 0.0.0.0 --use-flash-attention --gpu-only
