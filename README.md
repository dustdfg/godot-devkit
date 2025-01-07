# Godot-devkit

Godot-devkit is a project to build LLVM sharpened for speed building Godot. Main aim is to make a drop-in clang distribution for building Godot. Which means if devkit distribution fails compiling godot with certain configuration, system distribution should fail with the same configuration too, otherwise it should be considered a bug.

## Building

Run `build.sh`. The produced devkit will be named `godot-devkit.tar.xz`

## Usage

1. Install all [dependencies](https://docs.godotengine.org/en/latest/contributing/development/compiling/compiling_for_linuxbsd.html#distro-specific-one-liners) necessary for building godot
2. Unpack devkit to any place

3. Export path to devkit

```
export PATH=/path/to/devkit/bin:$PATH
scons -j16 use_llvm="yes" lld="yes" use_static_cpp="no"
```

Some systems doens't provide static versions of libc, libstdc++ and libatomic so use_static_cpp should be used on those systems. It should also make linkage a bit faster

4. For other build-time options please see [Compiling for Linux](https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_for_linuxbsd.html)

## TODO:

* Add BOLT
* Try to do CSIR instrumentation instead of usual IR
* Check if CSIR instrumentation was used correctly (IR+CSIR)
