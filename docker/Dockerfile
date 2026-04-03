FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LROSE_INSTALL_DIR=/opt/lrose
ENV PROJ_DIR=/opt/titan/projDir
ENV DATA_DIR=/data/titan
ENV HOME=/root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git python3 python3-pip cmake g++ gfortran \
    libnetcdf-dev libhdf5-dev libfftw3-dev \
    libfl-dev libbz2-dev libx11-dev libxext-dev \
    libxt-dev libpng-dev libjpeg-dev zlib1g-dev \
    libexpat1-dev tcsh perl curl wget rsync \
    xvfb x11vnc fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Build lrose-core using bootstrap
RUN mkdir -p /root/git && \
    cd /root/git && \
    git clone https://github.com/ncar/lrose-bootstrap && \
    cd /root/git/lrose-bootstrap/scripts && \
    python3 do_build_all_cmake.py --package lrose-cidd --prefix ${LROSE_INSTALL_DIR} 2>&1 | tee /tmp/lrose-build.log

ENV PATH="${LROSE_INSTALL_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Copy titan project files
COPY projects/single_radar/projDir /opt/titan/projDir-template

# Copy Bulgaria-specific project
COPY projects/bulgaria/projDir /opt/titan/projDir

# Create data directories for all 7 Bulgarian radars
RUN mkdir -p \
    ${DATA_DIR}/raw/radar/jar \
    ${DATA_DIR}/raw/radar/brd \
    ${DATA_DIR}/raw/radar/dce \
    ${DATA_DIR}/raw/radar/gcd \
    ${DATA_DIR}/raw/radar/pop \
    ${DATA_DIR}/raw/radar/smn \
    ${DATA_DIR}/raw/radar/sts \
    ${DATA_DIR}/cfradial/jar \
    ${DATA_DIR}/cfradial/brd \
    ${DATA_DIR}/cfradial/dce \
    ${DATA_DIR}/cfradial/gcd \
    ${DATA_DIR}/cfradial/pop \
    ${DATA_DIR}/cfradial/smn \
    ${DATA_DIR}/cfradial/sts \
    ${DATA_DIR}/mdv/radarCart/jar \
    ${DATA_DIR}/mdv/radarCart/brd \
    ${DATA_DIR}/mdv/radarCart/dce \
    ${DATA_DIR}/mdv/radarCart/gcd \
    ${DATA_DIR}/mdv/radarCart/pop \
    ${DATA_DIR}/mdv/radarCart/smn \
    ${DATA_DIR}/mdv/radarCart/sts \
    ${DATA_DIR}/mdv/radarCart/mosaic \
    ${DATA_DIR}/mdv/precip/1hr \
    ${DATA_DIR}/mdv/precip/24hr \
    ${DATA_DIR}/mdv/vil \
    ${DATA_DIR}/spdb/tstorms \
    ${DATA_DIR}/titan/storms \
    ${DATA_DIR}/logs

# Copy startup scripts
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5900

ENTRYPOINT ["/entrypoint.sh"]
