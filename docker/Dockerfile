# MATLAB R2018a in a Debian environment
FROM amarburg/matlab-runtime:R2018a

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get -y --allow-unauthenticated install libxt6 bzip2 && \
    rm -rf /var/lib/apt/lists/*

# Install Miniforge (conda-forge distribution of conda)
ENV PATH=/opt/conda/bin:$PATH
RUN wget --quiet https://github.com/conda-forge/miniforge/releases/download/26.3.2-3/Miniforge3-26.3.2-3-Linux-x86_64.sh -O ~/miniforge.sh && \
    /bin/bash ~/miniforge.sh -b -p /opt/conda && \
    rm ~/miniforge.sh && \
    /opt/conda/bin/conda clean --all --yes && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    conda init bash

ENV SINGE_ROOT=/usr/local/SINGE
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

ENV SINGE_RUNNING_IN_DOCKER=1

# Download the compiled SINGE executables from the stable release
# md5sum of v0.5.1 SINGE_GLG_Test is 95bc486778c3111533944480a2be3b74
#RUN tag=v0.5.1 && \
#    wget --quiet https://github.com/gitter-lab/SINGE/releases/download/$tag/SINGE_Test && \
#    wget --quiet https://github.com/gitter-lab/SINGE/releases/download/$tag/SINGE_GLG_Test && \
#    wget --quiet https://github.com/gitter-lab/SINGE/releases/download/$tag/SINGE_Aggregate && \
#    wget --quiet https://github.com/gitter-lab/SINGE/releases/download/$tag/code.md5 && \
#    chmod u+x SINGE_* && \
#    mv SINGE_Test tests/SINGE_Test

# Download an intermediate version of the compiled SINGE executables for testing
# Download the md5sums of the source .m files and binaries
RUN md5=4115bcb939c55510ec227b4193d6c27e && \
    wget --quiet --no-check-certificate https://www.biostat.wisc.edu/~gitter/tmp/$md5/SINGE_Test && \
    wget --quiet --no-check-certificate https://www.biostat.wisc.edu/~gitter/tmp/$md5/SINGE_GLG_Test && \
    wget --quiet --no-check-certificate https://www.biostat.wisc.edu/~gitter/tmp/$md5/SINGE_Aggregate && \
    wget --quiet --no-check-certificate https://www.biostat.wisc.edu/~gitter/tmp/$md5/code.md5 && \
    chmod u+x SINGE_* && \
    mv SINGE_Test tests/SINGE_Test
