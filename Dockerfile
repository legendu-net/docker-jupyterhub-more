# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/legendu-net/docker-jupyterhub-jdk.git
    
# TypeScript kernel
RUN npm install -g tslab \
    && tslab install --python=python3

# Rust
RUN apt-get install -y cmake \
        rustc cargo rustfmt rust-src \
    && cargo install cargo-cache
# evcxr_jupyter
RUN cargo install evcxr_jupyter \
    && evcxr_jupyter --install \
    && mv /root/.local/share/jupyter/kernels/rust /usr/local/share/jupyter/kernels/ \
    && /scripts/sys/purge_cache.sh \
    && find /root/ -type d -name '.git' | xargs rm -rf

# GoLANG Kernel
COPY --from=dclong/gophernotes:next /usr/local/go/ /usr/local/go/
COPY --from=dclong/gophernotes:next /root/go/bin/gophernotes /usr/local/go/bin/
COPY --from=dclong/gophernotes:next /usr/local/share/jupyter/kernels/gophernotes/kernel.json.in /usr/local/share/jupyter/kernels/gophernotes/kernel.json

RUN chmod -R 777 /root/   
ENV PATH=/usr/local/go/bin:$PATH
COPY scripts/ /scripts/
