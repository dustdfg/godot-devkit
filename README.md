Run `build.sh` to create docker image (you may need to edit from podman to docker inside script)

Then run container as `podman container run -ti --name godot-devkit-container --mount type=bind,src=./,dst=/storage localhost/godot-devkit:latest`. Inside container cd to `/storage` and run `make build`
