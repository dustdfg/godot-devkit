FROM fedora:41

# libstdc++-static libatomic-static glibc-static are necessary for static build of LLVM

RUN dnf install -y scons pkgconfig libX11-devel libXcursor-devel libXrandr-devel libXinerama-devel libXi-devel wayland-devel mesa-libGL-devel mesa-libGLU-devel alsa-lib-devel pulseaudio-libs-devel libudev-devel gcc-c++ libstdc++-static libatomic-static glibc-static \
	make cmake git clang lld ninja-build && \
	dnf clean all
