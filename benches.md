### Benchmarks

All the parts of each benchmark are made in the same environment but each benchmark itseld could be made in different environments

Average speed up: **31.16%**

#### Benchmark 1

**OS: debian testing**

**CPU governor: performance**

**Process priority: -20**

Hardware specs are unrelieble (especially disk)

---

System gcc:
```
Benchmark 1: git clean -fxd && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && scons platform=linux arch=x86_64 scu_build=yes scu_limit=1024
  Time (abs ≡):        2562.812 s               [User: 9675.808 s, System: 138.435 s]
```

System llvm:
```
Benchmark 1: git clean -fxd && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && scons platform=linux arch=x86_64 use_llvm=yes linker=lld scu_build=yes scu_limit=1024
  Time (abs ≡):        2184.732 s               [User: 8066.044 s, System: 170.967 s]
```

Devkit llvm:
```
Benchmark 1: git clean -fxd && PATH=/storage/godot-devkit/godot-devkit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && scons platform=linux arch=x86_64 use_llvm=yes linker=lld import_env_vars=PATH scu_build=yes scu_limit=1024
  Time (abs ≡):        1514.723 s               [User: 5511.020 s, System: 141.982 s]
```

**Devkit llvm** is faster than **system gcc** for **40.89%**

**Devkit llvm** is faster than **system llvm** for **30.67%**

#### Benchmark 2

**OS: debian testing**

**CPU governor: performance**

**Process priority: -20**

Hardware specs are unrelieble (especially disk)

---

System llvm:
```
Benchmark 1: git clean -fxd && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && scons platform=linux arch=x86_64 use_llvm=yes linker=lld lto=thin debug_symbols=yes
  Time (abs ≡):        5333.111 s               [User: 16452.975 s, System: 356.351 s]
```

Devkit llvm:
```
Benchmark 1: git clean -fxd && PATH=/storage/godot-devkit/godot-devkit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && scons platform=linux arch=x86_64 use_llvm=yes linker=lld import_env_vars=PATH lto=thin debug_symbols=yes
  Time (abs ≡):        3878.840 s               [User: 11493.142 s, System: 310.039 s]
```

**Devkit llvm** is faster than **system llvm** for **27.26%**

#### Benchmark 3

**OS: debian testing**

**CPU governor: performance**

**Process priority: -20**

Hardware specs are unrelieble (especially disk)

---

System llvm:
```
Benchmark 1: git clean -fxd && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && scons platform=linux arch=x86_64 use_llvm=yes linker=lld dev_mode=yes dev_build=yes
  Time (abs ≡):        2828.667 s               [User: 10614.495 s, System: 355.474 s]
```

Devkit llvm:
```
Benchmark 1: git clean -fxd && PATH=/storage/godot-devkit/godot-devkit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && scons platform=linux arch=x86_64 use_llvm=yes linker=lld import_env_vars=PATH dev_mode=yes dev_build=yes
  Time (abs ≡):        1834.505 s               [User: 6697.079 s, System: 310.315 s]
```

**Devkit llvm** is faster than **system llvm** for **35.14%**

