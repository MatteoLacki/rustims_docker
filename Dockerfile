FROM ubuntu:jammy AS base_dirty

WORKDIR /midia

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y git gcc gdb python3.11 python3.10-venv python3-pip \
           python-is-python3 python3-dev python3.11-dev wget python3.9 python3.9-dev python3.10 python3.10-dev curl vim tree ranger awscli

# uv: a crippled pip replacement
RUN curl -LsSf https://astral.sh/uv/0.4.6/install.sh | sh
RUN mkdir -p -m 700 /root/.ssh
COPY ssh/known_hosts /root/.ssh/known_hosts


# Below, we are caching the whole installation based on some general midia config.
# This is done once and then updates are required only when current config is completely different from this one.
COPY midia_config_prefetch_cache.toml /midia/midia_config_prefetch_cache.toml
RUN --mount=type=secret,id=ssh_key,target=/root/.ssh/id_rsa git clone git@github.com:midiaIDorg/midia_experiments && \
    git clone git@github.com:midiaIDorg/midia_tester && \
    cd /midia/midia_tester && pip install . && \
    midia_setup.py -o /midia/tmp_for_cache --fullconfig /midia/midia_config_prefetch_cache.toml --skip-self-checks --use-uv
RUN rm -rf /midia/tmp_for_cache
RUN pip uninstall midia_tester -y

COPY midia_config.toml /midia/midia_config.toml
# RUN ssh github.com:if this does not work, misconfigured network, restart laptop.

RUN --mount=type=secret,id=ssh_key,target=/root/.ssh/id_rsa \
    cd /midia/midia_experiments && \
    git pull && \
    cd /midia/midia_tester && \
    git pull && \
    pip install . && \
    midia_setup.py -o /midia/midia_experiments/midia_workspace --fullconfig /midia/midia_config.toml --skip-self-checks --use-uv

WORKDIR /midia/midia_experiments/midia_workspace/midia_pipe
RUN mkdir -p /midia/midia_experiments/midia_workspace/midia_pipe/fastas
RUN chmod a+wrx -R /midia

# the venv activate works only in containers, not in build.
ENTRYPOINT ["sh", "-c", ". /midia/midia_experiments/midia_workspace/activate && exec \"$@\"", "--"] 

RUN mv configs configs-templates
# removing Jenses background substraction
RUN rm -rf /midia/midia_experiments/midia_workspace/midia_pipe/software/bs

FROM scratch AS base_clean
COPY --from=base_dirty / /
# removing git history for user image
RUN rm -rf /midia/.git /midia/*/.git /midia/*/*/.git /midia/*/*/*/.git /midia/*/*/*/*/.git /midia/*/*/*/*/*/.git

FROM base_clean AS midia
WORKDIR /midia/midia_experiments/midia_workspace/midia_pipe
ENTRYPOINT ["sh", "-c", ". /midia/midia_experiments/midia_workspace/activate && exec \"$@\"", "--"]

FROM base_dirty AS midia_dev
RUN mkdir /midia_dev
WORKDIR /midia_dev
ENTRYPOINT ["sh", "-c", "if [ -f /midia_dev/midia_experiments/midia_workspace/activate ]; then . /midia_dev/midia_experiments/midia_workspace/activate; fi; exec \"$@\"", "--"]

# This if for future: don't use it yet ;)
FROM midia AS midia_open
WORKDIR /midia/midia_experiments/midia_workspace/midia_pipe
ENTRYPOINT ["sh", "-c", ". /midia/midia_experiments/midia_workspace/activate && exec \"$@\"", "--"]
