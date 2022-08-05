# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/legendu-net/docker-jupyterhub-jdk.git
    
# TypeScript kernel
RUN npm install --location=global tslab \
    && tslab install --python=python3

# Rust
ENV CARGO_HOME=/usr/local/cargo PATH=/usr/local/cargo/bin:$PATH
RUN apt-get update && apt-get install -y cmake \
    && /scripts/sys/purge_cache.sh
COPY --from=dclong/rust-utils /usr/local/rustup/ /usr/local/rustup/
COPY --from=dclong/rust-utils /usr/local/cargo/ /usr/local/cargo/
COPY --from=dclong/rust-utils /root/.local/share/jupyter/kernels/rust/ /usr/local/share/jupyter/kernels/rust/

# GoLANG Kernel
ENV PATH=/usr/local/go/bin:$PATH
COPY --from=dclong/gophernotes /usr/local/go/ /usr/local/go/
COPY --from=dclong/gophernotes /root/go/bin/gopls /usr/local/go/bin/
COPY --from=dclong/gophernotes /root/go/bin/gophernotes /usr/local/go/bin/
COPY --from=dclong/gophernotes /usr/local/share/jupyter/kernels/gophernotes/kernel.json.in /usr/local/share/jupyter/kernels/gophernotes/kernel.json
