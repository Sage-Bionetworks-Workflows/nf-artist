# Following:
# https://pythonspeed.com/articles/conda-docker-image-size/

# The build-stage image:
FROM continuumio/miniconda3 AS build

# File Author / Maintainer
LABEL maintainer="Adam Taylor <adam.taylor@sagebase.org>"

# Install build dependencies needed for pip packages with C extensions (e.g., minerva-lib)
RUN apt-get update && apt-get install --yes --no-install-recommends \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install the package as normal:
COPY docker/environment.yml .

# Clone and patch minerva-lib to fix ARM64 compilation (remove Intel-specific -march=haswell)
RUN git clone https://github.com/labsyspharm/minerva-lib-python.git /tmp/minerva-lib && \
    cd /tmp/minerva-lib && \
    sed -i 's/-march=haswell/-march=native/g' setup.py && \
    sed -i 's/-march=haswell/-march=native/g' setup.cfg || true

# Install conda environment (minerva-lib will be installed from patched local copy)
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
COPY --from=build /tmp/minerva-lib /tmp/minerva-lib

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

# Install pip packages after conda-pack to avoid conflicts
# Pin NumPy<2.0 to prevent automatic upgrade and maintain zarr 2.x compatibility
# Explicitly remove and reinstall urllib3/requests/idna to avoid mixed version issues
RUN source /venv/bin/activate && \
    pip uninstall -y urllib3 requests idna || true && \
    rm -rf /venv/lib/python3.12/site-packages/urllib3* \
           /venv/lib/python3.12/site-packages/requests* \
           /venv/lib/python3.12/site-packages/idna* && \
    pip install --no-cache-dir \
        "numpy>=1.23.0,<2.0" \
        "urllib3>=1.21.1,<1.26" \
        "requests==2.22.0" \
        openslide-python \
        "opencv-python-headless<4.10" \
        mantel \
        "ome_types>=0.4.2" \
        /tmp/minerva-lib
# Note: synapseclient omitted due to urllib3 1.25.x / Python 3.12 incompatibility
# Install separately if needed: pip install synapseclient

RUN source /venv/bin/activate && \
    git clone https://github.com/adamjtaylor/miniature.git -b v2 && \
    git clone https://github.com/adamjtaylor/auto-minerva.git -b minerva1point5 && \
    git clone https://github.com/labsyspharm/minerva-author.git -b v1.14.0

ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
