# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/legendu-net/docker-jupyterhub-jdk.git
    
# TypeScript kernel
RUN npm install -g tslab \
    && tslab install --python=python3

# Rust Kernel
COPY --from=dclong/rust-utils /root/.cargo/bin/* /usr/local/bin/
COPY --from=dclong/evcxr_jupyter /root/.cargo/bin/evcxr_jupyter /usr/local/bin/
ENV PATH=/root/.cargo/bin:$PATH
RUN evcxr_jupyter --install \
    && cp -r /root/.local/share/jupyter/kernels/rust /usr/local/share/jupyter/kernels/ \
    && /scripts/sys/purge_cache.sh \
    && find /root/ -type d -name '.git' | xargs rm -rf

# GoLANG Kernel
COPY --from=dclong/gophernotes:next /usr/local/go/ /usr/local/go/
COPY --from=dclong/gophernotes:next /root/go/bin/gophernotes /usr/local/go/bin/
COPY --from=dclong/gophernotes:next /usr/local/share/jupyter/kernels/gophernotes/kernel.json.in /usr/local/share/jupyter/kernels/gophernotes/kernel.json

RUN chmod -R 777 /root/   
COPY scripts/ /scripts/
