FROM ubuntu:jammy AS base

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC  \
	apt-get install -y --no-install-recommends software-properties-common \
	curl vim tree ranger wget build-essential ca-certificates gnupg && \
    	apt-get clean

WORKDIR /rustims
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y git gcc gdb python3.11 python3-pip \
           python-is-python3 python3-dev python3.11-dev python3.11-venv

# installing RUST
RUN apt-get install -y --no-install-recommends rustc cargo
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && rustup update 
RUN rustc --version && cargo --version


RUN chmod a+wrx -R /rustims
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID rustgroup && useradd -m -u $UID -g $GID rusto
USER rusto


RUN cd /rustims && \
	python3.11 -m venv ve && \
	/rustims/ve/bin/pip install maturin ipython notebook matplotlib jupyterlab && \
	mkdir /rustims/inputs

RUN /rustims/ve/bin/python --version && sleep 2

RUN cd /rustims && \
	git clone https://github.com/theGreatHerrLebert/rustims.git && \
	git clone https://github.com/theGreatHerrLebert/sagepy.git

# TODO: move it back up
ARG CACHE_BUST=1
RUN echo $CACHE_BUST


# RUN cd /rustims/rustims/imspy_connector &&\
# 	/rustims/ve/bin/maturin build --release && \
# 	/rustims/ve/bin/pip install ../target/wheels/imspy_connector-*

# RUN cd /rustims/sagepy/sagepy-connector && \
# 	/rustims/ve/bin/maturin build --release && \
# 	/rustims/ve/bin/pip install target/wheels/sagepy_connector-*

# RUN /rustims/ve/bin/pip install imspy

# # This here is a bit stupid as is, cause all from base is copied instead only final binaries, but we can optimize it LATER.
FROM scratch as rustims
COPY --from=base / /
ENTRYPOINT ["sh", "-c", ". /rustims/ve/bin/activate && exec \"$@\"", "--"] 
WORKDIR /rustims
