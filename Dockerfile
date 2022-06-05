# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/legendu-net/docker-jupyterhub-jdk.git
    
# TypeScript kernel
RUN npm install --location=global tslab \
    && tslab install --python=python3

# Rust
RUN apt-get update && apt-get install -y cmake \
    && /scripts/sys/purge_cache.sh
COPY --from=dclong/rust /usr/local/bin/* /usr/local/bin/
COPY --from=dclong/rust /usr/local/lib/lib*.so /usr/local/lib/
COPY --from=dclong/rust /usr/local/lib/rustlib/ /usr/local/lib/rustlib/
COPY --from=dclong/rust-utils \
    /root/.cargo/bin/rg \
    /root/.cargo/bin/bat \
    /root/.cargo/bin/dust \
    /root/.cargo/bin/rip \
    /usr/local/bin/

# evcxr_jupyter
COPY --from=dclong/evcxr_jupyter:next /root/.cargo/bin/evcxr_jupyter /usr/local/bin/
RUN evcxr_jupyter --install \
    && mv /root/.local/share/jupyter/kernels/rust/ /usr/local/share/jupyter/kernels/    

# GoLANG Kernel
ENV PATH=/usr/local/go/bin:$PATH
COPY --from=dclong/gophernotes:next /usr/local/go/ /usr/local/go/
COPY --from=dclong/gophernotes:next /root/go/bin/gophernotes /usr/local/go/bin/
COPY --from=dclong/gophernotes:next /usr/local/share/jupyter/kernels/gophernotes/kernel.json.in /usr/local/share/jupyter/kernels/gophernotes/kernel.json
RUN go install golang.org/x/tools/gopls@latest
