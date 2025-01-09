#!/bin/bash

podman build -t godot-devkit .

podman container run -ti --rm -w /storage -v $(pwd):/storage/:z localhost/godot-devkit:latest bash -c "make clean; make build"
