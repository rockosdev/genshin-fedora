# Genshin Fedora - SDDM Theme

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
│                 IDLE (welcome)                   │
│  Video background + centered music player       │
│  ◀ ▶ switch tracks · Enter to continue          │
└────────────────────┬────────────────────────────┘
                     │ Enter
                     ▼
┌─────────────────────────────────────────────────┐
│                 DOOR (transition)                │
│  Door-opening animation · Music fades out       │
│  Auto-advances when animation ends              │
└────────────────────┬────────────────────────────┘
                     │ Auto
                     ▼
┌─────────────────────────────────────────────────┐
│                 LOGIN (Breeze UI)                │
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
│  [⌨ Keyboard] [Session ▾]    [Sleep] [Reboot] [Shut Down] │
│                            🎯 Fedora Logo       │
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
   sudo rsync -a --exclude='install.sh' --exclude='.git' --exclude='result*.png' \
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
│       └── night_bg.png        Night login background
├── sounds/
│   ├── popup.mp3               Track switch sound
│   └── *.mp3                   16 soundtrack tracks
├── preview/                    Preview screenshots
└── install.sh                  Installation script
```

## Credits

- Original Breeze theme by KDE Visual Design Group
- Original [genshin-sddm-theme](https://github.com/nicefaa6waa/genshin-sddm-theme)
- Genshin Impact OST by HOYO-MiX
- Fedora KDE SIG
