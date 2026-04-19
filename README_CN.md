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
│       └── night_bg.png        夜晚登录背景
├── sounds/
│   ├── popup.mp3               切歌音效
│   └── *.mp3                   16 首 OST 曲目
├── preview/                    预览截图
└── install.sh                  安装脚本
```

## 致谢

- 原始 Breeze 主题 by KDE Visual Design Group
- 原始 [genshin-sddm-theme](https://github.com/nicefaa6waa/genshin-sddm-theme) 主题
- 原神 OST — HOYO-MiX
- Fedora KDE SIG
