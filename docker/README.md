# SINGE Docker container

This `Dockerfile` builds an image with MATLAB R2018a and other dependencies needed to run SINGE.
It also contains the conda environment needed to test SINGE.

Travis CI builds the Docker image using the [DockerHub image](https://hub.docker.com/r/agitter/singe) as a cache.
The image is deployed to DockerHub with the `tmp` tag when it is built using the `master` branch.
The build process downloads the compiled SINGE executables from an external location because compiling requires a MATLAB license.

Building images for SINGE releases is performed manually because the compiled MATLAB code attached to the GitHub release is used for the Docker image.
Released images are built using the command `docker build -t singe -f docker/Dockerfile .` from the root directory of the repository.
They are then tagged with `docker tag singe agitter/singe:latest` and `docker tag singe agitter/singe:<version>` and pushed with `docker push agitter/singe:latest` and `docker push agitter/singe:<version>`, where `<version>` is the version number of the release (e.g. `0.3.0`).
