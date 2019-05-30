# singe-base Docker container

This `Dockerfile builds an image with MATLAB R2018a and other dependencies needed to run SINGE.
It also contains the conda environment needed to test SINGE.

The image was built using the command `docker build -t singe -f docker/Dockerfile .` from the root directory of the repository.
It was tagged and pushed with `docker tag singe agitter/singe:tmp` and `docker push agitter/singe:tmp`.
