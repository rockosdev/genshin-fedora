# Genshin Fedora - SDDM 登录主题

一个原神风格的 SDDM 登录主题，适用于 KDE Plasma。动态视频壁纸、游戏内音乐播放器、开门过渡动画，沉浸式登录体验。

## 功能特色

- **按时段切换背景** — 根据系统时间自动选择清晨 / 下午 / 夜晚场景
- **音乐播放器** — 16 首原神 OST，`←` `→` 键切歌
- **开门过渡动画** — 从欢迎屏进入登录界面的电影级开门动画
- **Breeze 风格登录** — 完整集成 KDE Breeze 登录组件（用户头像列表、密码框、操作按钮、时钟、底栏）
- **视频回退** — 视频不可用时自动切换静态壁纸
- **开门动画预加载** — 启动时预缓冲门动画，切换无延迟

## 三阶段流程

```
┌─────────────────────────────────────────────────┐
│               IDLE（欢迎界面）                    │
│  视频壁纸循环播放 + 居中音乐播放器                   │
│  ◀ ▶ 切换曲目 · 按 Enter 进入登录                │
└────────────────────┬────────────────────────────┘
                     │ Enter
                     ▼
┌─────────────────────────────────────────────────┐
│               DOOR（过渡动画）                    │
│  开门动画播放 · 音乐渐隐                           │
│  动画结束自动进入登录                              │
└────────────────────┬────────────────────────────┘
                     │ 自动
                     ▼
┌─────────────────────────────────────────────────┐
│               LOGIN（Breeze 登录界面）            │
│                                                 │
│               12:34                             │
│            星期五, 4月18日                        │
│                                                 │
│           ┌──────────────────┐                  │
│           │   用户头像列表     │                  │
│           └──────────────────┘                  │
│           ┌──────────────────┐                  │
│           │  密码             │                  │
│           └──────────────────┘                  │
│                                                 │
│  [⌨ 键盘]  [桌面会话 ▾]         [休眠] [重启] [关机] │
│                            🎯 Fedora Logo       │
└─────────────────────────────────────────────────┘
```

## 依赖

基于 Qt 6 构建，已通过 Fedora Linux 44 (KDE Plasma Desktop Edition) x86_64 验证。

- SDDM（Simple Desktop Display Manager）
- Qt 6（`qt6-qtbase`、`qt6-qtmultimedia`、`qt6-qtquickcontrols2`、`qt6-qt5compat`）
- KDE Plasma 运行时（`kirigami`、`plasma-components`、`plasma-workspace`）
- GStreamer 插件（`gstreamer1-plugins-good`、`gstreamer1-libav`）
- HEVC 硬解（`gstreamer1-plugins-bad-freeworld`，RPM Fusion）

## 安装

### 自动安装

```bash
chmod +x install.sh
sudo ./install.sh
```

脚本会自动：
1. 安装 Qt6 依赖包（会提示选择发行版）
2. 复制主题文件到 `/usr/share/sddm/themes/genshin-fedora/`
3. 更新 SDDM 配置使用该主题
4. 可选禁用虚拟键盘

### 手动安装

1. 安装依赖（Fedora）：
   ```bash
   sudo dnf install qt6-qtbase qt6-qtmultimedia qt6-qtquickcontrols2 \
       qt6-qt5compat gstreamer1-plugins-good gstreamer1-libav \
       gstreamer1-plugins-bad-freeworld
   ```

2. 复制主题文件：
   ```bash
   sudo rsync -a --exclude='install.sh' --exclude='.git' --exclude='result*.png' \
       ./ /usr/share/sddm/themes/genshin-fedora/
   ```

3. 配置 SDDM — 编辑 `/etc/sddm.conf` 或 `/etc/sddm.conf.d/kde.conf`：
   ```ini
   [Theme]
   Current=genshin-fedora
   ```

### 启用

```bash
sudo reboot
```

## 时段划分

| 时段 | 时间范围 | 背景视频 | 开门动画 | 登录背景 |
|------|---------|---------|---------|---------|
| 清晨 | 06:00 – 12:00 | `morningbg.mp4` | `morningdoor.webm` | `morning_bg.png` |
| 下午 | 12:00 – 18:00 | `afternoonbg.mp4` | `afternoondoor.webm` | `afternoon_bg.png` |
| 夜晚 | 18:00 – 06:00 | `nightbg.mp4` | `nightdoor.webm` | `night_bg.png` |

所有视频：1920×1080 @ 60fps。界面自适应屏幕分辨率。

## 快捷键（欢迎界面）

| 按键 | 功能 |
|------|------|
| `←` | 上一首 |
| `→` | 下一首 |
| `Enter` | 进入登录 |

## 登录界面快捷键

| 按键 | 功能 |
|------|------|
| `Enter` | 登录 |
| `Esc` | 取消输入 |

## 文件结构

```
genshin-fedora/
├── Main.qml                    入口，三阶段状态机，视频/音乐播放
├── metadata.desktop            SDDM 主题元数据
├── theme.conf                  主题配置（时钟、Logo 等）
├── components/
│   ├── LoginScreen.qml         Breeze 风格登录界面（改编自 01-breeze-fedora）
│   ├── Login.qml               用户列表 + 密码框（来自 01-breeze-fedora）
│   ├── KeyboardButton.qml      键盘布局选择器
│   ├── SessionButton.qml       桌面会话选择器
│   ├── Background.qml          Breeze 背景组件（未使用）
│   └── faces →                 符号链接至 01-breeze-fedora 头像目录
├── backgrounds/
│   ├── failed.png              视频加载失败时的静态回退壁纸
│   ├── morningbg.mp4           清晨背景循环
│   ├── afternoonbg.mp4         下午背景循环
│   ├── nightbg.mp4             夜晚背景循环
│   └── doorbg/
│       ├── morningdoor.webm    清晨开门动画
│       ├── afternoondoor.webm  下午开门动画
│       ├── nightdoor.webm      夜晚开门动画
│       ├── morning_bg.png      清晨登录背景
│       ├── afternoon_bg.png    下午登录背景
│       ├── night_bg.png        夜晚登录背景
│       ├── door_alpha.frag     亮度阈值着色器源码（GLSL 440）
│       └── door_alpha.qsb      预编译着色器（SPIR-V + GLSL + HLSL + MSL）
├── sounds/
│   ├── popup.mp3               切歌音效
│   └── *.mp3                   16 首 OST 曲目
├── preview/                    预览截图
└── install.sh                  安装脚本
```

## 技术实现细节

### 视频叠加：亮度阈值着色器

欢迎界面的背景视频（如 `nightbg.mp4`）展示完整的原神场景。开门动画（如 `nightdoor.webm`）只截取了画面中间那条路的部分，其余区域全黑。按下 Enter 后，开门动画需要**叠在**背景视频上方播放——只显示中间的路和门，让黑色区域变透明，露出底层的背景视频。

```
┌──────────────────────────────┐
│  nightbg.mp4（完整场景）       │  ← 底层，z: 0
│                              │
│     ┌────────────────┐       │
│     │ nightdoor.webm │       │  ← 叠加层，z: 1
│     │ （中间门动画）   │       │     黑色部分透明
│     │ 黑→透明         │       │     → 底层背景透出来
│     └────────────────┘       │
│                              │
└──────────────────────────────┘
```

#### 纯 RGB 和带 Alpha 通道的视频有什么区别

| | 纯 RGB 视频（当前） | 带 Alpha 通道的视频 |
|---|---|---|
| **每个像素存储** | R（红）G（绿）B（蓝）共 3 个值 | R G B **A**（透明度）共 4 个值 |
| **黑色区域** | RGB = (0,0,0)，显示为纯黑实心 | 可以设 A=0，显示为完全透明 |
| **叠加效果** | 黑色会**遮住**底下的一切 | 透明区域让底层画面**透出来** |
| **像素格式** | `yuv420p`（无透明通道） | `yuva420p`（a = alpha） |

当前的开门动画文件是 `yuv420p`（无 alpha），黑色区域是实心黑，直接盖住了背景视频。

#### 解决方案

既然视频本身不带 alpha，就用 GPU 着色器在播放时实时计算——逐像素算亮度，低于阈值的黑色区域设为透明：

```glsl
// door_alpha.frag — GLSL 440
float lum = p.r * 0.299 + p.g * 0.587 + p.b * 0.114;  // ITU-R BT.601 亮度
if (lum < 0.08)    // 亮度低于 8% → 判定为黑色背景
    p.a = 0.0;     // 设为透明
```

**Qt6 着色器工具链：** Qt5 可以内联写 GLSL，但 Qt6 切换到了 RHI，着色器必须用 `qsb` 工具预编译为 `.qsb` 格式，内含 SPIR-V + GLSL ES + GLSL 150 + HLSL + MSL 五种格式。

```bash
sudo dnf install qt6-qtshadertools
/usr/lib64/qt6/bin/qsb --glsl "100 es,150" --hlsl 50 --msl 12 \
    -o backgrounds/doorbg/door_alpha.qsb backgrounds/doorbg/door_alpha.frag
```

**QML 中的使用：**

```qml
VideoOutput {
    id: doorOutput
    z: 1
    layer.enabled: true
    layer.effect: ShaderEffect {
        fragmentShader: "backgrounds/doorbg/door_alpha.qsb"
    }
}
```

### Qt5 → Qt6 迁移：着色器部分

本项目基于 Qt6，但原始代码沿用了 Qt5 的写法。以下是着色器相关的关键差异：

| | Qt5 | Qt6 |
|---|---|---|
| **渲染后端** | OpenGL | RHI（渲染硬件接口），自动适配 OpenGL / Vulkan / Metal / D3D |
| **着色器格式** | 直接内联 GLSL 代码 | 必须预编译为 `.qsb` 文件 |
| **QML 写法** | `fragmentShader: "varying ... gl_FragColor ..."` | `fragmentShader: "xxx.qsb"` |
| **编译工具** | 不需要 | `qsb`（来自 `qt6-qtshadertools`） |
| **GLSL 版本** | GLSL ES 100 / GLSL 120 即可 | 需要 GLSL 440（`#version 440`），且用 `layout` 限定符 |
| **着色器变量** | `varying` / `uniform` 自由声明 | 必须用标准 uniform block（`layout(std140, binding=0) uniform buf { mat4 qt_Matrix; float qt_Opacity; }`） |
| **纹理采样** | `texture2D()` | `texture()` |
| **输出** | `gl_FragColor` | `out vec4 fragColor`（需 `layout(location=0)` 声明） |

**本项目遇到的实际问题：** 已安装的主题使用了 Qt5 风格的内联 GLSL 着色器，Qt6 日志报错：
```
ShaderEffect: Failed to deserialize QShader ... In Qt 6 shaders must be
preprocessed using the Qt Shader Tools infrastructure.
```
着色器编译失败导致 `layer.effect` 整体失效，叠加层不渲染，door 视频完全不可见。

### Fedora 44 工具限制

**VP9 alpha 编码不可用：** 尝试用 ffmpeg 把黑色转为 alpha 通道（`-pix_fmt yuva420p`），编码器接受输入但实际输出仍为 `yuv420p`，alpha 通道被静默丢弃。实测环境：

- Fedora 44（Linux 6.19）
- ffmpeg 8.0.1（libvpx 启用）
- libvpx 编码器声明支持 `yuva420p`，但编码后 alpha 丢失

因此最终采用 GPU 着色器方案，在播放端实时计算透明度，绕过编码器限制。

### 视频编码：MP4 与 WebM 的选择

项目中使用了两种视频容器，各自对应不同的用途：

| | MP4（H.264） | WebM（VP9） |
|---|---|---|
| **用途** | 背景视频循环播放 | 开门过渡动画 |
| **文件** | `nightbg.mp4` 等 | `nightdoor.webm` 等 |
| **编码器** | H.264 Baseline（`libopenh264`） | Google VP9 |
| **时长** | ~5 分钟（循环） | ~6 秒（一次性） |
| **文件大小** | 142–167 MB | 580–744 KB |
| **音频** | 无 | Vorbis（静音，保留音轨供扩展） |

**为什么背景用 H.264 Baseline？** Fedora 默认不包含专有 H.264 解码器（如 x264），但提供 Cisco 的开源实现 `openh264`，它**只支持 Baseline 配置**。因此背景视频必须用 `libopenh264` 编码为 Baseline，才能在纯净 Fedora 环境下播放。SDDM greeter 日志也确认了这一点：

```
sddm-greeter-qt6: "No HW decoder found"          ← 无硬件加速
Stream #0:0: Video: h264 (libopenh264) (Baseline) ← 纯 openh264 软解码
```

如果误用 x264 的 Main/High 配置，在未安装 RPM Fusion 解码器的 Fedora 上将无法播放。

**所需的 Fedora 软件包：**

```bash
# H.264 解码（必须）
sudo dnf install openh264 gstreamer1-plugin-openh264

# VP9 / WebM 解码 + Qt6 多媒体后端
sudo dnf install gstreamer1-plugins-good gstreamer1-plugins-good-qt6

# 安装脚本已包含的依赖
sudo dnf install qt6-qtbase qt6-qtmultimedia qt6-qtquickcontrols2 qt6-qt5compat
```

> **注意：** `openh264` 和 `gstreamer1-plugin-openh264` 是 H.264 播放的关键依赖，当前 `install.sh` 未显式安装。如果背景视频黑屏无画面，先检查这两个包是否已安装。

**为什么开门动画用 VP9？** 开门动画只有几秒，VP9 在短视频中压缩率极高，6 秒的 1080p60 仅数百 KB，适合作为叠加层快速加载。

**为什么不统一格式？** H.264 Baseline 体积大（5 分钟 ~150 MB）不适合短视频场景；VP9 兼容性依赖 GStreamer 插件，长时间循环播放的稳定性不如 H.264。两种格式各取所长。

## 致谢

- 原始 Breeze 主题 by KDE Visual Design Group
- [Kiki the Cyber Squirrel](https://krita.org/en/about/mascot/) — Krita 官方吉祥物壁纸
- 原始 [genshin-sddm-theme](https://github.com/nicefaa6waa/genshin-sddm-theme) 主题
- 原神 OST — HOYO-MiX
- Fedora KDE SIG
