# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/dclong/docker-jupyterhub-jdk.git
    
# TypeScript kernel
RUN npm install -g tslab \
    && tslab install --python=python3

# Rust Kernel
COPY --from=dclong/rust-utils /root/.cargo/bin/* /usr/local/bin/
COPY --from=dclong/evcxr_jupyter /usr/local/bin/evcxr_jupyter /usr/local/bin/
ENV PATH=/root/.cargo/bin:$PATH
RUN xinstall rustup -ic \
    && evcxr_jupyter --install \
    && cp -r /root/.local/share/jupyter/kernels/rust /usr/local/share/jupyter/kernels/ \
    && chmod -R 755 /root \
    && /scripts/sys/purge_cache.sh \
    && find /root/ -type d -name '.git' | xargs rm -rf

COPY scripts/ /scripts/
