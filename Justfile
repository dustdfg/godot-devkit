godot_version := "4.3"
godot_path := invocation_directory() / "godot"
devkit_path := invocation_directory() / "godot-devkit"

runs := "1"

default:
	just --list

# Download build dependencies for Debian
[group('deps')]
debian-deps:
	apt-get update
	apt-get install -y \
		build-essential \
		scons \
		pkg-config \
		libx11-dev \
		libxcursor-dev \
		libxinerama-dev \
		libgl1-mesa-dev \
		libglu1-mesa-dev \
		libasound2-dev \
		libpulse-dev \
		libudev-dev \
		libxi-dev \
		libxrandr-dev \
		libwayland-dev \
		clang \
		lld

# Download build dependencies for Fedora
[group('deps')]
fedora-deps:
	sudo dnf install -y \
		scons \
		pkgconfig \
		libX11-devel \
		libXcursor-devel \
		libXrandr-devel \
		libXinerama-devel \
		libXi-devel \
		wayland-devel \
		mesa-libGL-devel \
		mesa-libGLU-devel \
		alsa-lib-devel \
		pulseaudio-libs-devel \
		libudev-devel \
		gcc-c++ \
		libstdc++-static \
		libatomic-static \
		clang \
		lld

# Prepare everything (not distro specific)
[group('prepare')]
prepare: devkit godot

# Fetch Godot sources
[group('prepare')]
godot:
	-git clone --depth 1 --branch {{godot_version}} https://github.com/godotengine/godot

# Fetch Godot-devkit
[group('prepare')]
devkit:
	wget -O godot-devkit.tar.xz "https://github.com/dustdfg/godot-devkit/releases/download/tmp/godot-devkit-latest.tar.xz"
	tar -xvf godot-devkit.tar.xz

##########################

# Bench gcc, system llvm and devkit llvm
[group('bench')]
bench-all *args: (bench_system_gcc args) (bench_system_llvm args) (bench_devkit_llvm args)

# Bench only llvms
[group('bench')]
bench-llvm *args: (bench_system_llvm args) (bench_devkit_llvm args)

##########################

[group('bench-granular')]
bench_system_gcc *args: (_run_bench env_var('PATH') 'system_gcc' args)

[group('bench-granular')]
bench_system_llvm *args: (_run_bench env_var('PATH') 'system_llvm' 'use_llvm=yes' 'linker=lld' args)

devkit_env_path := devkit_path / 'bin'  + ':' + env_var('PATH')
[group('bench-granular')]
bench_devkit_llvm *args: (_run_bench devkit_env_path 'devkit_llvm' 'use_llvm=yes' 'linker=lld' 'import_env_vars="PATH"' args)

##########################

_run_bench _path _file *args:
	cd {{godot_path}} && \
	hyperfine --runs {{runs}} --prepare "sync; echo 3 | sudo tee /proc/sys/vm/drop_caches" \
	"git clean -fxd && PATH={{_path}} && scons platform=linux arch=x86_64 {{args}}" \
	> {{invocation_directory() / 'bench_' + _file + '.txt'}}
