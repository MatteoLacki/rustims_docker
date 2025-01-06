FROM ubuntu:jammy AS rustims

WORKDIR /rustims

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y git gcc gdb python3.11 python3-pip \
           python-is-python3 python3-dev python3.11-dev wget curl vim tree ranger python3.11-venv

RUN chmod a+wrx -R /rustims
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID rustgroup && useradd -m -u $UID -g $GID rusto
USER rusto

ARG CACHE_BUST=1
RUN echo "Cache busting: $CACHE_BUST"

RUN cd /rustims && python3.11 -m venv ve && /rustims/ve/bin/pip install imspy ipython notebook matplotlib jupyterlab && \
	mkdir /rustims/inputs
#RUN chmod a+wrx -R /rustims
ENTRYPOINT ["sh", "-c", ". /rustims/ve/bin/activate && exec \"$@\"", "--"] 
