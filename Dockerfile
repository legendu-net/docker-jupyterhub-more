FROM dclong/jupyterhub-py

# Kotlin kernel
RUN pip3 install kotlin-jupyter-kernel

# Scala kernel
ARG SCALA_VERSION=2.11.12 
ARG ALMOND_VERSION=0.9.1
RUN curl -L -o /usr/local/bin/coursier https://git.io/coursier-cli \
    && chmod +x /usr/local/bin/coursier
RUN /usr/local/bin/coursier bootstrap \
        -r jitpack \
        -i user \
        -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
        -o /usr/local/bin/almond \
        sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    && /usr/local/bin/almond --install --global

RUN apt-get update \
    && apt-get install -y cmake cargo \
    && cargo install --force evcxr_jupyter \
    && /root/.cargo/bin/evcxr_jupyter --install