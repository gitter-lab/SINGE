# MATLAB R2018a in a Debian environment
FROM amarburg/matlab-runtime

RUN apt-get update && \
    apt-get -y install libxt6 bzip2

# Install Miniconda3 following https://hub.docker.com/r/continuumio/miniconda3/dockerfile
# Python is only needed for testing SINGE and could be removed from the base
# to reduce the image size
ENV PATH /opt/conda/bin:$PATH
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean --all && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Install conda test environment
COPY tests/environment.yml .
RUN conda env create -f environment.yml

WORKDIR /SCINGE

# Install the compiled SCINGE_Example executable from a temporary location
RUN wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/369b3eb57db4fb1fce29c5ae28db3ee7/SCINGE_Example && \
    chmod u+x SCINGE_Example
