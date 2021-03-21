# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/dclong/docker-jupyterhub-jdk.git

# Kotlin kernel
RUN pip3 install kotlin-jupyter-kernel

# Scala kernel
RUN curl -L -o /usr/local/bin/coursier https://git.io/coursier-cli \
    && chmod +x /usr/local/bin/coursier \
    && /usr/local/bin/coursier launch almond --scala 2.12 --quiet -- --install --global
    
# TypeScript kernel
RUN npm install -g tslab

# Rust Kernel
RUN apt-add-repository -y ppa:ubuntu-mozilla-security/rust-updates \
    && apt-get update \
    && apt-get install -y rustc rust-src cargo cmake \
    && cargo install --force evcxr_jupyter \
    && /root/.cargo/bin/evcxr_jupyter --install \
    && cp -r /root/.local/share/jupyter/kernels/rust /usr/local/share/jupyter/kernels/ \
    && chmod -R 755 /root \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
