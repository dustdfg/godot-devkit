#!/bin/bash

podman build -t godot-devkit .

podman container run -ti --rm --shm-size 512M -w /storage -v $(pwd):/storage/:z localhost/godot-devkit:latest bash -c "make build"
