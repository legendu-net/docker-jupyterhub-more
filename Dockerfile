FROM dclong/jupyterhub-py

# Kotlin kernel
RUN pip3 install kotlin-jupyter-kernel

# Scala kernel
RUN curl -L -o /usr/local/bin/coursier https://git.io/coursier-cli \
    && chmod +x /usr/local/bin/coursier \
    && /usr/local/bin/coursier launch almond -- --install --global --quiet

RUN apt-get update \
    && apt-get install -y cmake cargo \
    && cargo install --force evcxr_jupyter \
    && /root/.cargo/bin/evcxr_jupyter --install \
    && cp -r /root/.local/share/jupyter/kernels/rust /usr/local/share/jupyter/kernels/ \
    && chmod -R 755 /root
