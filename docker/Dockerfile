# Following:
# https://pythonspeed.com/articles/conda-docker-image-size/

# The build-stage image:
FROM continuumio/miniconda3 AS build

# File Author / Maintainer
LABEL maintainer="Adam Taylor <adam.taylor@sagebase.org>"

# Install the package as normal:
COPY environment.yml .
RUN conda env create -f environment.yml

# Install conda-pack:
RUN conda install -c conda-forge conda-pack

# Use conda-pack to create a standalone enviornment
# in /venv:
RUN conda-pack -n artist -o /tmp/env.tar && \
  mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar

# We've put venv in same path it'll be in final image,
# so now fix up paths:
RUN /venv/bin/conda-unpack

# The runtime-stage image; we can use Debian as the
# base image since the Conda env also includes Python
# for us.
FROM debian:bullseye AS runtime

# Copy /venv from the previous stage:
COPY --from=build /venv /venv

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install --yes --no-install-recommends \
    wget \
    locales \
    vim-tiny \
    git \
    cmake \
    build-essential \
    libopenslide-dev \
    python3-dev \
    python3-pip \
    libblosc1

RUN source /venv/bin/activate && \
    git clone https://github.com/adamjtaylor/miniature.git -b v2 && \
    git clone https://github.com/adamjtaylor/auto-minerva.git -b minerva1point5 && \
    git clone https://github.com/labsyspharm/minerva-author.git minerva-author-dev && \
    git clone https://github.com/labsyspharm/minerva-author.git -b v1.11.2 &&  \
    pip install git+https://github.com/labsyspharm/minerva-lib-python@master#egg=minerva-lib && \
    pip install openslide-python && \
    pip install opencv-python-headless \
    pip install synapseclient \
    pip install mantel \
    pip install ome_types

ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
