# SDL3 Emscripten Build Example / SDL3 Emscripten 构建示例

[English](#english) | [中文](#chinese)

---

<a name="english"></a>
## English

### Purpose

This directory provides a standalone CMake example specifically for building SDL3 libraries (SDL3, SDL3_ttf, SDL3_image, and optionally SDL3_mixer) as **static libraries** for the Emscripten/WebAssembly environment.

**Important**: This example is **library-only** - it does not build any custom executables or applications. It is designed to produce WebAssembly library files (`.a` archives) that can be linked into your own applications.

### What Gets Built

- `libSDL3.a` - SDL3 core library
- `libSDL3_ttf.a` - SDL3 TrueType font library  
- `libSDL3_image.a` - SDL3 image loading library
- `libSDL3_mixer.a` - SDL3 audio mixing library

All libraries are built as static archives suitable for linking with Emscripten applications.

### Prerequisites

1. **Emscripten SDK** installed and activated
   ```bash
   # Install emsdk if not already installed
   git clone https://github.com/emscripten-core/emsdk.git
   cd emsdk
   ./emsdk install latest
   ./emsdk activate latest
   source ./emsdk_env.sh
   ```

2. **CMake** version 3.16 or later

3. **Git submodules** initialized
   ```bash
   # From the repository root
   git submodule update --init --recursive
   ```

### Build Instructions

**Option 1: Using the build script (recommended)**

```bash
# Navigate to this directory
cd emscripten_build_example

# Run the build script
./build.sh

# Or specify build type and parallel jobs
./build.sh Release 8
```

**Option 2: Manual CMake commands**

```bash
# Navigate to this directory
cd emscripten_build_example

# Configure the build using emcmake
emcmake cmake -B build -DCMAKE_BUILD_TYPE=Release

# Build the libraries using emmake
emmake cmake --build build -j$(nproc)

# Install the built libraries
emmake cmake --install build
```

### Output Location

After building and installing, you will find:

```
build/install/
├── include/          # Header files for SDL3 libraries
│   ├── SDL3/
│   ├── SDL3_ttf/
│   ├── SDL3_image/
│   └── SDL3_mixer/
└── lib/              # Static library files
    ├── libSDL3.a
    ├── libSDL3_ttf.a
    ├── libSDL3_image.a
    ├── libSDL3_mixer.a
    └── cmake/        # CMake config files for find_package()
```

### Testing via GitHub Actions

This example can be tested automatically using GitHub Actions:

1. Go to the **Actions** tab in the GitHub repository
2. Select the **"Build Native"** workflow
3. Click **"Run workflow"** button
4. The `test-emscripten-example` job will build and verify the libraries
5. Download the artifacts to inspect the built libraries and headers

### Using the Built Libraries

Once built, you can link these libraries in your own Emscripten application:

```cmake
# In your application's CMakeLists.txt
set(CMAKE_PREFIX_PATH "/path/to/emscripten_build_example/build/install/lib/cmake")
find_package(SDL3 REQUIRED)
find_package(SDL3_ttf REQUIRED)
find_package(SDL3_image REQUIRED)
find_package(SDL3_mixer REQUIRED)

target_link_libraries(your_app SDL3::SDL3 SDL3_ttf::SDL3_ttf SDL3_image::SDL3_image SDL3_mixer::SDL3_mixer)
```

Or link directly:
```cmake
target_link_libraries(your_app 
    /path/to/build/install/lib/libSDL3.a
    /path/to/build/install/lib/libSDL3_ttf.a
    /path/to/build/install/lib/libSDL3_image.a
    /path/to/build/install/lib/libSDL3_mixer.a
)
```

### Notes

- This example uses **vendored dependencies** (SDLTTF_VENDORED, SDLIMAGE_VENDORED, etc.) to ensure all required libraries are built together
- Only static libraries are built for Emscripten (no shared libraries)
- AVIF support is disabled in SDL_image to avoid additional build dependencies
- SDL tests and examples are disabled to speed up the build
- **Configuration aligns with** the main repository's `External/build.sh` script for Emscripten builds, ensuring compatibility with the existing build workflow
- **GitHub Actions Integration**: This example is automatically tested in the repository's CI workflow (`.github/workflows/build.yml`) in the `test-emscripten-example` job

---

<a name="chinese"></a>
## 中文

### 用途

本目录提供了一个独立的 CMake 示例，专门用于为 Emscripten/WebAssembly 环境构建 SDL3 系列库（SDL3、SDL3_ttf、SDL3_image 以及可选的 SDL3_mixer）的**静态库**版本。

**重要说明**：本示例**仅构建库文件** - 不构建任何自定义可执行程序或应用。它的设计目标是生成可以链接到您自己应用程序中的 WebAssembly 库文件（`.a` 归档文件）。

### 构建内容

- `libSDL3.a` - SDL3 核心库
- `libSDL3_ttf.a` - SDL3 TrueType 字体库
- `libSDL3_image.a` - SDL3 图像加载库
- `libSDL3_mixer.a` - SDL3 音频混音库

所有库都构建为静态归档文件，适合与 Emscripten 应用程序链接。

### 前置要求

1. **Emscripten SDK** 已安装并激活
   ```bash
   # 如果尚未安装 emsdk，请先安装
   git clone https://github.com/emscripten-core/emsdk.git
   cd emsdk
   ./emsdk install latest
   ./emsdk activate latest
   source ./emsdk_env.sh
   ```

2. **CMake** 版本 3.16 或更高

3. **Git 子模块**已初始化
   ```bash
   # 从仓库根目录执行
   git submodule update --init --recursive
   ```

### 构建步骤

**方式一：使用构建脚本（推荐）**

```bash
# 进入本目录
cd emscripten_build_example

# 运行构建脚本
./build.sh

# 或指定构建类型和并行任务数
./build.sh Release 8
```

**方式二：手动 CMake 命令**

```bash
# 进入本目录
cd emscripten_build_example

# 使用 emcmake 配置构建
emcmake cmake -B build -DCMAKE_BUILD_TYPE=Release

# 使用 emmake 构建库
emmake cmake --build build -j$(nproc)

# 安装构建好的库
emmake cmake --install build
```

### 输出位置

构建并安装后，您将在以下位置找到文件：

```
build/install/
├── include/          # SDL3 库的头文件
│   ├── SDL3/
│   ├── SDL3_ttf/
│   ├── SDL3_image/
│   └── SDL3_mixer/
└── lib/              # 静态库文件
    ├── libSDL3.a
    ├── libSDL3_ttf.a
    ├── libSDL3_image.a
    ├── libSDL3_mixer.a
    └── cmake/        # 用于 find_package() 的 CMake 配置文件
```

### 通过 GitHub Actions 测试

本示例可以使用 GitHub Actions 自动测试：

1. 进入 GitHub 仓库的 **Actions** 标签页
2. 选择 **"Build Native"** 工作流
3. 点击 **"Run workflow"** 按钮
4. `test-emscripten-example` 任务将构建并验证库文件
5. 下载构建产物以查看生成的库和头文件

### 使用构建好的库

构建完成后，您可以在自己的 Emscripten 应用程序中链接这些库：

```cmake
# 在您应用程序的 CMakeLists.txt 中
set(CMAKE_PREFIX_PATH "/path/to/emscripten_build_example/build/install/lib/cmake")
find_package(SDL3 REQUIRED)
find_package(SDL3_ttf REQUIRED)
find_package(SDL3_image REQUIRED)
find_package(SDL3_mixer REQUIRED)

target_link_libraries(your_app SDL3::SDL3 SDL3_ttf::SDL3_ttf SDL3_image::SDL3_image SDL3_mixer::SDL3_mixer)
```

或者直接链接：
```cmake
target_link_libraries(your_app 
    /path/to/build/install/lib/libSDL3.a
    /path/to/build/install/lib/libSDL3_ttf.a
    /path/to/build/install/lib/libSDL3_image.a
    /path/to/build/install/lib/libSDL3_mixer.a
)
```

### 注意事项

- 本示例使用**内置的依赖项**（SDLTTF_VENDORED、SDLIMAGE_VENDORED 等）以确保所有必需的库一起构建
- 仅为 Emscripten 构建静态库（不构建共享库）
- SDL_image 中的 AVIF 支持已禁用，以避免额外的构建依赖
- SDL 测试和示例已禁用以加快构建速度
- **配置与主仓库的 `External/build.sh` 脚本对齐**，确保与现有构建工作流程兼容
- **GitHub Actions 集成**：本示例在仓库的 CI 工作流（`.github/workflows/build.yml`）中的 `test-emscripten-example` 任务中自动测试

### 适用场景

本构建示例特别适合以下场景：

1. **纯库构建**：您只需要 SDL 系列库的 WebAssembly 版本，不需要示例程序
2. **业务集成**：您有自己的应用程序代码，需要链接 SDL 库
3. **CI/CD 流程**：在持续集成环境中自动构建 SDL wasm 库
4. **多项目共享**：构建一次库文件，在多个 Emscripten 项目中重复使用

### 常见问题

**Q: 为什么不包含可执行程序？**  
A: 本示例专注于库构建。SDL 库本身不包含 main 函数，它们是供业务代码使用的库。如果您需要示例程序，请参考 SDL 官方仓库中的示例。

**Q: 如何在我的项目中使用这些库？**  
A: 构建完成后，将 `build/install/lib` 和 `build/install/include` 添加到您的 Emscripten 项目的库和头文件搜索路径中。

**Q: 可以构建共享库吗？**  
A: Emscripten 环境下通常使用静态库。本示例强制使用静态库构建（BUILD_SHARED_LIBS=OFF）。

---

## License / 许可证

This example configuration follows the SDL project licenses. Please refer to the LICENSE files in the respective SDL projects for details.

本示例配置遵循 SDL 项目的许可证。详细信息请参阅各个 SDL 项目中的 LICENSE 文件。
