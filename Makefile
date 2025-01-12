.PHONY: build clean

build: godot-devkit.tar.xz

clean:
	-@rm -rf stage1 stage2 stage3 profiles/* godot-devkit godot-devkit.tar.xz

#######################

# Prevent compiling multiple godots in parallel
.NOTPARALLEL:

# Used to pass variables to godot_profile.mk
.EXPORT_ALL_VARIABLES:

#######################

include config.mk

#######################

llvm-project:
	git clone --depth 1 --branch llvmorg-$(LLVM_VERSION) https://github.com/llvm/llvm-project

########################

define disable_ocaml
	-DLLVM_ENABLE_BINDINGS=OFF \
	-DLLVM_ENABLE_OCAMLDOC=OFF
endef

define disable_llvm_auxiliary
	-DLLVM_INCLUDE_BENCHMARKS=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_INCLUDE_TESTS=OFF \
	-DLLVM_INCLUDE_DOCS=OFF
endef

# It is recommemded to disable CLANG_ENABLE_STATIC_ANALYZER for speed up
# (of clang build or of app build with that clang?)
define disable_static_analyzer
	-DCLANG_ENABLE_STATIC_ANALYZER=OFF \
	-DCLANG_ENABLE_ARCMT=OFF
endef

# It is recommemded to enable LLVM_OPTIMIZED_TABLEGEN for speed up
# Maybe it is useful only for Debug builds of LLVM ¯\_(ツ)_/¯
# https://llvm.org/docs/GettingStarted.html
# https://llvm.org/docs/CMake.html#llvm-related-variables
define cmake_exec
	cmake -B $@ -G Ninja -S llvm-project/llvm \
		-DCMAKE_BUILD_TYPE=Release \
		\
		$(disable_ocaml) \
		$(disable_llvm_auxiliary) \
		$(disable_static_analyzer) \
		\
		-DLLVM_OPTIMIZED_TABLEGEN=ON
endef


# -DLLVM_BUILD_UTILS=OFF disables llvm-ar llvm-as and other "binutils"
# Maybe we should pass it to stage1 too?
define release_args
	-DLLVM_ENABLE_PROJECTS="clang;lld" \
	-DLLVM_TARGETS_TO_BUILD="X86" \
	\
	-DLLVM_BUILD_UTILS=OFF \
	\
	-DCMAKE_C_COMPILER=$(abspath stage1/bin/clang) \
	-DCMAKE_CXX_COMPILER=$(abspath stage1/bin/clang++) \
	-DLLVM_NATIVE_TOOL_DIR=$(abspath stage1/bin) \
	-DLLVM_USE_LINKER=lld \
	\
	-DLLVM_ENABLE_EH=OFF \
	-DLLVM_ENABLE_RTTI=ON \
	\
	-DLLVM_BUILD_STATIC=ON \
	-DLLVM_ENABLE_LTO=$(LTO_TYPE)
endef

########################

stage1: llvm-project
	$(cmake_exec) \
		-DLLVM_ENABLE_PROJECTS="clang;lld;bolt" \
		-DLLVM_ENABLE_RUNTIMES="compiler-rt" \
		-DLLVM_TARGETS_TO_BUILD="X86" \
		\
		-DCMAKE_C_COMPILER=clang-19 \
		-DCMAKE_CXX_COMPILER=clang++-19 \
		-DLLVM_USE_LINKER=lld

stage1/completed: stage1
	ninja -C $(@D) clang lld llvm-profdata compiler-rt \
		llvm-bolt merge-fdata bolt_rt -j$(JOBS)
	@touch $@

profdata_tool = $(abspath stage1/bin/llvm-profdata)

########################

stage2: stage1/completed
	$(cmake_exec) \
		$(release_args) \
		-DLLVM_BUILD_INSTRUMENTED=IR \
		-DLLVM_BUILD_RUNTIME=NO \
		-DLLVM_VP_COUNTERS_PER_SITE=$(VP_COUNTERS)

stage2/completed: stage2
	ninja -C $(@D) clang lld -j$(JOBS)
	@touch $@

########################

.SECONDEXPANSION:
profiles/stage2.profdata:: profile_target_file=$@
profiles/stage2.profdata:: instrumented_tool_dir=stage2
profiles/stage2.profdata:: stage2/completed
	-mkdir $(abspath profiles)
	$(MAKE) -f godot_profile.mk run-profile

########################

stage3: profiles/stage2.profdata
	$(cmake_exec) \
		$(release_args) \
		-DCMAKE_INSTALL_PREFIX=godot-devkit \
		-DCMAKE_SKIP_INSTALL_RPATH=YES \
		-DLLVM_BUILD_RUNTIME=NO \
		-DLLVM_PROFDATA_FILE=$(abspath profiles/stage2.profdata)
		#-DCMAKE_EXE_LINKER_FLAGS="-Wl,--emit-relocs" \

stage3/completed: stage3
	ninja -C $(@D) install-clang install-lld install-clang-resource-headers install-clang-headers -j$(JOBS)
	@touch $@

########################

godot-devkit.tar.xz: stage3/completed
	tar cvf - godot-devkit | xz -9e -T$(JOBS) > godot-devkit.tar.xz
