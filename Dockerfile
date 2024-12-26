FROM fedora:41

RUN dnf install -y scons pkgconfig libX11-devel libXcursor-devel libXrandr-devel libXinerama-devel libXi-devel wayland-devel mesa-libGL-devel mesa-libGLU-devel alsa-lib-devel pulseaudio-libs-devel libudev-devel gcc-c++ libstdc++-static libatomic-static \
	make cmake git clang lld ninja-build && \
	dnf clean all
