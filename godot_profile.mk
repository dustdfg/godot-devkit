# Prevent compiling multiple godots in parallel
.NOTPARALLEL:

shm := /dev/shm

godot:
	git clone --depth 1 --branch $(GODOT_VERSION) https://github.com/godotengine/godot

run-profile: $(profile_target_file)

.SECONDEXPANSION:
$(profile_target_file):: \
		$$(basename $$@)/1.profdata \
		$$(basename $$@)/2.profdata \
		$$(basename $$@)/3.profdata
	$(profdata_tool) merge --compress-all-sections --num-threads $(JOBS) \
		-o=$@ /storage/profiles/$(instrumented_tool_dir)/*.profdata


profiles/$(instrumented_tool_dir)/1.profdata \
profiles/$(instrumented_tool_dir)/2.profdata \
profiles/$(instrumented_tool_dir)/3.profdata: godot
	cp -r $(abspath profiles) $(shm)
	-@rm -rf $(shm)/$(basename $@)
	@mkdir -p $(shm)/$(basename $@)
	@mkdir -p $(abspath $(basename $@))
	cd godot && \
	git clean -fxd && \
	PATH="$(abspath $(instrumented_tool_dir))/bin:$$PATH" \
	LLVM_PROFILE_FILE="$(shm)/$(basename $@)/%$(shell expr $(JOBS) + 2)m.profraw" \
	scons -j$(JOBS) $(scons_compiler) $(scons_common) $(scons_opts)

	$(profdata_tool) merge --compress-all-sections --num-threads $(JOBS) \
		-o=$(abspath $@) $(shm)/$(basename $@)/*.profraw

	-@rm -rf $(shm)/$(basename $@)

scons_common = platform="linuxbsd" arch="x86_64" scu_limit="1024" verbose="yes" scu_build="yes"
scons_compiler = use_llvm="yes" linker="lld" CC="clang" CXX="clang++" import_env_vars="PATH,LLVM_PROFILE_FILE"

profiles/$(instrumented_tool_dir)/1.profdata : scons_opts = target="editor"
profiles/$(instrumented_tool_dir)/2.profdata : scons_opts = target="editor" dev_build="yes"
profiles/$(instrumented_tool_dir)/3.profdata : scons_opts = target="editor" production="yes"
# profiles/$(instrumented_tool_dir)/4.profdata : scons_opts = target="template_release"
# profiles/$(instrumented_tool_dir)/5.profdata : scons_opts = target="template_release" dev_build="yes"
# profiles/$(instrumented_tool_dir)/6.profdata : scons_opts = target="template_release" production="yes"
