# Godot-devkit

Godot-devkit is a project to build LLVM sharpened for speed building Godot

## Building

Run `build.sh`. The produced devkit will be named `godot-devkit.tar.xz`

## Usage

1. Install all [dependencies](https://docs.godotengine.org/en/latest/contributing/development/compiling/compiling_for_linuxbsd.html#distro-specific-one-liners) necessary for building godot
2. Unpack devkit to any place

3. Export path to devkit

```
export PATH=/path/to/devkit/bin:$PATH
scons -j16 use_llvm="yes" lld="yes"
```

4. For other build-time options please see [Compiling for Linux](https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_for_linuxbsd.html)

## TODO:

* Add BOLT
* Try to do CSIR instrumentation instead of usual IR
* Check if CSIR instrumentation was used correctly (IR+CSIR)
