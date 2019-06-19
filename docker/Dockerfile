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

WORKDIR /download

# Install the compiled SCINGE_Example executable from the stable release
# md5sum of v0.2.0 SCINGE_Example is f6530f824b093a0fcd3204347c4e1659
#RUN wget --quiet https://github.com/gitter-lab/SINGE/releases/download/v0.2.0/SCINGE_Example && \
#    chmod u+x SCINGE_Example

# Install an intermediate version of the compiled SCINGE_Example executable for testing
RUN wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/c7893f75298b14ffa10e12d4fb9786ed/SCINGE_Example && \
    chmod u+x SCINGE_Example
