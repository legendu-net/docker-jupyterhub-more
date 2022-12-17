# NAME: dclong/jupyterhub-more
FROM dclong/jupyterhub-jdk
# GIT: https://github.com/legendu-net/docker-jupyterhub-jdk.git
    
# TypeScript kernel
RUN npm install --location=global tslab \
    && tslab install --python=python3

# Rust
ENV RUSTUP_HOME=/usr/local/rustup PATH=/usr/local/cargo/bin:$PATH
RUN apt-get update && apt-get install -y cmake \
    && /scripts/sys/purge_cache.sh
COPY --from=dclong/rust-utils /usr/local/rustup/ /usr/local/rustup/
COPY --from=dclong/rust-utils /usr/local/cargo/bin /usr/local/cargo/bin
COPY --from=dclong/rust-utils /root/.local/share/jupyter/kernels/rust/ /usr/local/share/jupyter/kernels/rust/

# GoLANG Kernel
ENV PATH=/usr/local/go/bin:$PATH
COPY --from=dclong/gophernotes /usr/local/go/ /usr/local/go/
COPY --from=dclong/gophernotes /root/go/bin/gopls /usr/local/go/bin/
COPY --from=dclong/gophernotes /root/go/bin/gophernotes /usr/local/go/bin/
COPY --from=dclong/gophernotes /usr/local/share/jupyter/kernels/gophernotes/kernel.json.in /usr/local/share/jupyter/kernels/gophernotes/kernel.json

# The Ganymede kernel
RUN icon download_github_release -r allen-ball/ganymede -k jar -K asc -o /tmp/ganymede.jar \
    && java -jar /tmp/ganymede.jar -i --sys-prefix \
    && mv /usr/share/jupyter/kernels/ganymede-*-java-*/ /usr/local/share/jupyter/kernels/ \
    && /scripts/sys/purge_cache.sh
