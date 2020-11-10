# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-py
# GIT: https://github.com/dclong/docker-jupyterhub-py.git

# Kotlin kernel
RUN pip3 install kotlin-jupyter-kernel

# Scala kernel
RUN curl -L -o /usr/local/bin/coursier https://git.io/coursier-cli \
    && chmod +x /usr/local/bin/coursier \
    && /usr/local/bin/coursier launch almond --scala 2.12 --quiet -- --install --global
    
# TypeScript kernel
#RUN npm install -g --unsafe-perm itypescript \
#    && its --ts-hide-undefined --install=global

# Rust Kernel
#ENV RUSTUP_HOME=/usr/local/rustup \
#    CARGO_HOME=/usr/local/cargo \
#    PATH=/usr/local/cargo/bin:$PATH
#RUN xinstall -y rustup -ic \
#    && apt-get update && apt-get install -y cmake \
#    && cargo install --force evcxr_jupyter \
#    && /usr/local/cargo/bin/evcxr_jupyter --install \
#    && cp -r /root/.local/share/jupyter/kernels/rust /usr/local/share/jupyter/kernels/ \
#    && chmod -R 755 /root \
#    && apt-get autoremove -y \
#    && apt-get clean -y \
#    && rm -rf /var/lib/apt/lists/*
