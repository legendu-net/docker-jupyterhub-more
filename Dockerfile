# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/dclong/docker-jupyterhub-jdk.git

# Kotlin kernel
RUN pip3 install kotlin-jupyter-kernel \
    && /scripts/sys/purge_cache.sh

# Scala kernel
#RUN curl -L -o /usr/local/bin/coursier https://git.io/coursier-cli \
#    && chmod +x /usr/local/bin/coursier \
#    && /usr/local/bin/coursier launch almond --scala 2.12 --quiet -- --install --global
    
# TypeScript kernel
RUN npm install -g tslab \
    && tslab install --python=python3

# Rust Kernel
COPY --from=dclong/rust-utils /root/.cargo/bin/* /usr/local/bin/
ENV PATH=/root/.cargo/bin:$PATH
RUN xinstall rustup -ic \
    && cargo install --force evcxr_jupyter \
    && evcxr_jupyter --install \
    && cp -r /root/.local/share/jupyter/kernels/rust /usr/local/share/jupyter/kernels/ \
    && chmod -R 755 /root \
    && /scripts/sys/purge_cache.sh \
    && find /root/ -type d -name '.git' | xargs rm -rf

COPY scripts/ /scripts/
