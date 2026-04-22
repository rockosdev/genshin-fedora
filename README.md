


# Genshin Fedora - SDDM Theme
<img width="985" height="553" alt="image" src="https://github.com/user-attachments/assets/8cf9d2ce-b265-4b82-97c8-256bfc1c8ed4" />
<img width="973" height="556" alt="image" src="https://github.com/user-attachments/assets/8784536a-29cf-4627-bb8a-cb98abb8fe39" />
<img width="982" height="550" alt="image" src="https://github.com/user-attachments/assets/1ad57de0-23d9-42dd-b5ea-a74623ad8ea4" />

A Genshin Impact styled SDDM login theme for KDE Plasma, featuring animated video backgrounds, an in-game music player, and a door-opening transition into the login screen.

## Features

- **Time-based backgrounds** — Automatically selects morning / afternoon / night scene based on system time
- **Music player** — 16 Genshin Impact soundtrack tracks with `←` `→` keyboard controls
- **Door transition** — Cinematic door-opening animation between the welcome screen and login form
- **Breeze-style login** — Full KDE Breeze login integration (user avatar list, password field, action buttons, clock, footer)
- **Fallback** — Static image if video playback is unavailable
- **Door animation preloading** — Door video buffered at startup for seamless transition

## Stages

```
┌─────────────────────────────────────────────────┐
│                 IDLE (welcome)                  │
│  Video background + centered music player       │
│  ◀ ▶ switch tracks · Enter to continue        │
└────────────────────┬────────────────────────────┘
                     │ Enter
                     ▼
┌─────────────────────────────────────────────────┐
│                 DOOR (transition)               │
│  Door-opening animation · Music fades out       │
│  Auto-advances when animation ends              │
└────────────────────┬────────────────────────────┘
                     │ Auto
                     ▼
┌─────────────────────────────────────────────────┐
│                 LOGIN (Breeze UI)               │
│                                                 │
│               12:34                             │
│            Friday, April 18                     │
│                                                 │
│           ┌──────────────────┐                  │
│           │  User avatar list│                  │
│           └──────────────────┘                  │
│           ┌──────────────────┐                  │
│           │  Password        │                  │
│           └──────────────────┘                  │
│                                                 │
│        [Sleep] [Reboot] [Shut Down]             │
│              🎯 Fedora Logo                     │
└─────────────────────────────────────────────────┘
```

## Requirements

Built on Qt 6, tested on Fedora Linux 44 (KDE Plasma Desktop Edition) x86_64.

- SDDM (Simple Desktop Display Manager)
- Qt 6 (`qt6-qtbase`, `qt6-qtmultimedia`, `qt6-qtquickcontrols2`, `qt6-qt5compat`)
- KDE Plasma runtime (`kirigami`, `plasma-components`, `plasma-workspace`)
- GStreamer plugins (`gstreamer1-plugins-good`, `gstreamer1-libav`)
- HEVC hardware decoding (`gstreamer1-plugins-bad-freeworld`, RPM Fusion)

## Installation

### Automatic

```bash
chmod +x install.sh
sudo ./install.sh
```

The script will:
1. Install required Qt6 packages (prompts for distro)
2. Copy theme files to `/usr/share/sddm/themes/genshin-fedora/`
3. Update SDDM config to use the theme
4. Optionally disable the virtual keyboard

### Manual

1. Install dependencies (Fedora):
   ```bash
   sudo dnf install qt6-qtbase qt6-qtmultimedia qt6-qtquickcontrols2 \
       qt6-qt5compat gstreamer1-plugins-good gstreamer1-libav \
       gstreamer1-plugins-bad-freeworld
   ```

2. Copy theme files:
   ```bash
   sudo rsync -a --exclude='install.sh' --exclude='.git' \
       ./ /usr/share/sddm/themes/genshin-fedora/
   ```

3. Configure SDDM — edit `/etc/sddm.conf` or `/etc/sddm.conf.d/kde.conf`:
   ```ini
   [Theme]
   Current=genshin-fedora
   ```

### Activate

```bash
sudo reboot
```

## Time Periods

| Period | Hours | Background | Door Animation | Login BG |
|--------|-------|------------|----------------|----------|
| Morning | 06:00 – 12:00 | `morningbg.mp4` | `morningdoor.webm` | `morning_bg.png` |
| Afternoon | 12:00 – 18:00 | `afternoonbg.mp4` | `afternoondoor.webm` | `afternoon_bg.png` |
| Night | 18:00 – 06:00 | `nightbg.mp4` | `nightdoor.webm` | `night_bg.png` |

All videos: 1920×1080 @ 60fps. UI adapts to screen resolution.

## Keyboard Shortcuts (Idle Stage)

| Key | Action |
|-----|--------|
| `←` | Previous track |
| `→` | Next track |
| `Enter` | Proceed to login |

## Keyboard Shortcuts (Login Stage)

| Key | Action |
|-----|--------|
| `Enter` | Log in |
| `Esc` | Cancel input |

## File Structure

```
genshin-fedora/
├── Main.qml                    Entry point, three-stage state machine, video/music playback
├── metadata.desktop            SDDM theme metadata
├── theme.conf                  Theme configuration (clock, logo, etc.)
├── components/
│   ├── LoginScreen.qml         Breeze-style login screen (adapted from 01-breeze-fedora)
│   ├── Login.qml               User list + password field (from 01-breeze-fedora)
│   ├── KeyboardButton.qml      Keyboard layout selector
│   ├── SessionButton.qml       Desktop session selector
│   ├── Background.qml          Breeze background component (unused)
│   └── faces →                 Symlink to 01-breeze-fedora faces directory
├── backgrounds/
│   ├── failed.png              Static fallback when video fails to load
│   ├── morningbg.mp4           Morning background loop
│   ├── afternoonbg.mp4         Afternoon background loop
│   ├── nightbg.mp4             Night background loop
│   └── doorbg/
│       ├── morningdoor.webm    Morning door animation
│       ├── afternoondoor.webm  Afternoon door animation
│       ├── nightdoor.webm      Night door animation
│       ├── morning_bg.png      Morning login background
│       ├── afternoon_bg.png    Afternoon login background
│       ├── night_bg.png        Night login background
│       ├── door_alpha.frag     Luminance threshold shader source (GLSL 440)
│       └── door_alpha.qsb      Pre-compiled shader (SPIR-V + GLSL + HLSL + MSL)
├── sounds/
│   ├── popup.mp3               Track switch sound
│   └── *.mp3                   16 soundtrack tracks
├── preview/                    Preview screenshots
└── install.sh                  Installation script
```

## Technical Details

### Video Compositing: Luminance Threshold Shader

The idle background video (e.g. `nightbg.mp4`) shows the full Genshin scene. The door animation (e.g. `nightdoor.webm`) captures only the center path/door portion — the rest is pure black. When Enter is pressed, the door video must be composited **on top of** the background — showing only the door while making the black areas transparent so the background shows through.

```
┌──────────────────────────────┐
│  nightbg.mp4 (full scene)    │  ← bottom layer, z: 0
│                              │
│     ┌────────────────┐       │
│     │ nightdoor.webm │       │  ← overlay, z: 1
│     │ (center door)   │      │     black → transparent
│     │ black→transparent│     │     → background shows through
│     └────────────────┘       │
│                              │
└──────────────────────────────┘
```

#### RGB vs Alpha Channel Video

| | RGB-only video (current) | Video with Alpha channel |
|---|---|---|
| **Per-pixel storage** | R (red) G (green) B (blue) — 3 values | R G B **A** (opacity) — 4 values |
| **Black areas** | RGB = (0,0,0), displayed as solid black | Can set A=0 for full transparency |
| **Compositing** | Black **occludes** everything below | Transparent areas let lower layers **show through** |
| **Pixel format** | `yuv420p` (no transparency) | `yuva420p` (a = alpha) |

The door videos are `yuv420p` (no alpha), so black areas are solid and cover the background video entirely.

#### Solution

Since the videos lack alpha, a GPU shader calculates transparency in real time — per-pixel luminance below a threshold becomes transparent:

```glsl
// door_alpha.frag — GLSL 440
float lum = p.r * 0.299 + p.g * 0.587 + p.b * 0.114;  // ITU-R BT.601 luminance
if (lum < 0.08)    // below 8% brightness → treat as black background
    p.a = 0.0;     // make transparent
```

**Qt6 shader toolchain:** Qt5 allowed inline GLSL, but Qt6 switched to RHI. Shaders must be pre-compiled to `.qsb` format containing SPIR-V + GLSL ES + GLSL 150 + HLSL + MSL.

```bash
sudo dnf install qt6-qtshadertools
/usr/lib64/qt6/bin/qsb --glsl "100 es,150" --hlsl 50 --msl 12 \
    -o backgrounds/doorbg/door_alpha.qsb backgrounds/doorbg/door_alpha.frag
```

**Usage in QML:**

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

### Qt5 → Qt6 Migration: Shaders

This project targets Qt6, but the original code used Qt5 conventions. Key shader differences:

| | Qt5 | Qt6 |
|---|---|---|
| **Rendering backend** | OpenGL | RHI (Rendering Hardware Interface) — auto-selects OpenGL / Vulkan / Metal / D3D |
| **Shader format** | Inline GLSL code | Must be pre-compiled to `.qsb` files |
| **QML syntax** | `fragmentShader: "varying ... gl_FragColor ..."` | `fragmentShader: "xxx.qsb"` |
| **Build tool** | None needed | `qsb` (from `qt6-qtshadertools`) |
| **GLSL version** | GLSL ES 100 / GLSL 120 | GLSL 440 (`#version 440`) with `layout` qualifiers |
| **Shader variables** | `varying` / `uniform` declared freely | Must use standard uniform block (`layout(std140, binding=0) uniform buf { mat4 qt_Matrix; float qt_Opacity; }`) |
| **Texture sampling** | `texture2D()` | `texture()` |
| **Output** | `gl_FragColor` | `out vec4 fragColor` (with `layout(location=0)`) |

**Issue encountered:** The installed theme used Qt5-style inline GLSL. Qt6 logged:
```
ShaderEffect: Failed to deserialize QShader ... In Qt 6 shaders must be
preprocessed using the Qt Shader Tools infrastructure.
```
The failed shader caused `layer.effect` to break entirely, so the door video overlay was not rendered at all.

### Fedora 44 Tool Limitations

**VP9 alpha encoding not available:** Attempted to encode black as alpha via ffmpeg (`-pix_fmt yuva420p`), but the encoder accepts the input yet outputs `yuv420p` — the alpha channel is silently discarded. Tested on:

- Fedora 44 (Linux 6.19)
- ffmpeg 8.0.1 (libvpx enabled)
- libvpx encoder claims `yuva420p` support but drops alpha after encoding

The GPU shader approach was chosen as a workaround — computing transparency at playback time, bypassing the encoder limitation.

### Video Codecs: MP4 vs WebM

Two container formats are used, each suited to a different purpose:

| | MP4 (H.264) | WebM (VP9) |
|---|---|---|
| **Purpose** | Background video loop | Door transition animation |
| **Files** | `nightbg.mp4` etc. | `nightdoor.webm` etc. |
| **Encoder** | H.264 Baseline (`libopenh264`) | Google VP9 |
| **Duration** | ~5 min (looped) | ~6 sec (one-shot) |
| **File size** | 142–167 MB | 580–744 KB |
| **Audio** | None | Vorbis (muted, retained for extensibility) |

**Why H.264 Baseline for backgrounds?** Fedora does not ship proprietary H.264 decoders (e.g. x264). It provides Cisco's open-source `openh264`, which **only supports Baseline profile**. Background videos must be encoded with `libopenh264` Baseline to play on a clean Fedora install. The SDDM greeter log confirms this:

```
sddm-greeter-qt6: "No HW decoder found"          ← no hardware acceleration
Stream #0:0: Video: h264 (libopenh264) (Baseline) ← pure openh264 software decode
```

Using x264 Main/High profile would fail to play on Fedora without RPM Fusion codecs.

**Required Fedora packages:**

```bash
# H.264 decoding (required)
sudo dnf install openh264 gstreamer1-plugin-openh264

# VP9 / WebM decoding + Qt6 multimedia backend
sudo dnf install gstreamer1-plugins-good gstreamer1-plugins-good-qt6

# Already included by install.sh
sudo dnf install qt6-qtbase qt6-qtmultimedia qt6-qtquickcontrols2 qt6-qt5compat
```

> **Note:** `openh264` and `gstreamer1-plugin-openh264` are critical for H.264 playback. The current `install.sh` does not install them explicitly. If the background video is black, check that these packages are installed.

## Credits

- Original Breeze theme by KDE Visual Design Group
- [Kiki the Cyber Squirrel](https://krita.org/en/about/mascot/) — Krita official mascot wallpaper
- Original [genshin-sddm-theme](https://github.com/nicefaa6waa/genshin-sddm-theme)
- Genshin Impact OST by HOYO-MiX
- Fedora KDE SIG

