# MATLAB R2018a in a Debian environment
FROM amarburg/matlab-runtime:R2018a

RUN apt-get update && \
    apt-get -y install libxt6 bzip2 && \
    rm -rf /var/lib/apt/lists/*

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
    echo "conda activate base" >> ~/.bashrc && \
    conda init bash

ENV SINGE_ROOT /usr/local/SINGE
WORKDIR /usr/local/SINGE
ENTRYPOINT ["/usr/local/SINGE/SINGE.sh", "/usr/local/MATLAB/MATLAB_Runtime/v94"]

# Install conda test environment
COPY tests/environment.yml tests/
RUN conda env create -f tests/environment.yml

# Copy wrapper scripts for compiled MATLAB executables
COPY SINGE.sh .
COPY run_SINGE_GLG_Test.sh .
COPY run_SINGE_Aggregate.sh .
COPY tests/run_SINGE_Test.sh tests/

# Download the compiled SCINGE_Example executable from the stable release
# md5sum of v0.3.0 SCINGE_Example is a4a990b7585125ca41ded5f5045af9ba
#RUN wget --quiet https://github.com/gitter-lab/SINGE/releases/download/v0.3.0/SCINGE_Example && \
#    chmod u+x SCINGE_Example

# Download an intermediate version of the compiled SINGE executables for testing
# Download the md5sums of the source .m files and binaries
RUN md5=14488adf1099666e4e64a5267ef9eed1 && \
    wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/$md5/SINGE_Test && \
    wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/$md5/SINGE_GLG_Test && \
    wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/$md5/SINGE_Aggregate && \
    wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/$md5/code.md5 && \
    chmod u+x SINGE_* && \
    mv SINGE_Test tests/SINGE_Test
