<h1 align="center">Retrilz's Dotfiles</h1>

<table align="center">
   <tr>
      <td colspan="3" align="center">
         <img src="https://share.rzx.ovh/go/rdots-general" width="fit"><br>
         <sub><b>General</b></sub>
      </td>
   </tr>
   <tr>
      <td align="center">
         <img src="https://share.rzx.ovh/go/rdots-hyprlock" width="fit"><br>
         <sub><b>Hyprlock</b></sub>
      </td>
      <td align="center">
         <img src="https://share.rzx.ovh/go/rdots-terminals" width="fit"><br>
         <sub><b>Terminals</b></sub>
      </td>
  </tr>
  <tr>
      <td colspan="3" align="center">
         <img src="https://share.rzx.ovh/go/rdots-gtk-qt" width="fit"><br>
         <sub><b>GTK & Qt</b></sub>
      </td>
   </tr>
</table>

<div align="center">
  <p>【 🇬🇧 English 】 <a href="./README-ru.md">【 🇷🇺 Русский 】</a></p>
   <img alt="Last README modification" src="https://img.shields.io/github/last-commit/retrilzzy/dotfiles?path=README.md&style=for-the-badge&logo=readdotcv&logoColor=ffff&label=Last%20README%20modification&labelColor=0D1117&color=0D1117">
</div>

# Navigation

- [Installation](#installation)
- [Detailed overview](#detailed-overview)
  - [Dependencies](#dependencies) - required packages.
  - [Hyprland](#hyprland) - window manager.
    - [Keybinds](#keybinds) - all key combinations.
    - [Icons](#icons) - icon pack.
    - [Cursor](#cursor) - cursor theme.
    - [Fonts](#fonts) - font installation.
    - [Hypridle](#hypridle) - idle behavior.
    - [Hyprlock](#hyprlock) - lock screen.
  - [Waybar](#waybar) - wayland bar.
  - [Vicinae](#vicinae) - focused launcher.
  - [Wlogout](#wlogout) - logout menu.
  - [Terminal](#terminal) - terminal settings.
  - [Nwg-look](#nwg-look) - GTK settings.
  - [Qt](#qt) - Qt settings.
  - [Swaync](#swaync) - notifications.
  - [Waypaper](#waypaper) - GUI for easy wallpaper management.
    - [Wallpapers](#wallpapers) - collection of wallpapers.
  - [Flameshot](#flameshot) - powerful screenshot utility.
  - [Fastfetch](#fastfetch) - show off your linux.

> [!WARNING]  
> My configs are not designed for universal use and are not 100% automated, so they may require manual adjustments. I do not guarantee the correct operation of the configs or software on your system.

# Installation

> [!NOTE]
> You must have a working Hyprland before installation.

> [!IMPORTANT]  
> The installation script has only been tested on **Arch Linux**.

0. System update:

   ```
   sudo pacman -Syu
   ```

1. Run the [installation script](./Scripts/install.sh):

   ```
   curl https://raw.githubusercontent.com/retrilzzy/dotfiles/refs/heads/main/Scripts/install.sh | bash
   ```

   - Installs the [necessary packages](#dependencies).
   - Clones this repository to `~/dotfiles`.
   - Creates a backup of your configs in `~/.config-backups/$date_time`.
   - Applies the new configs from this repository.

## After installation

Actions you probably want to do.

**General:**

- Add your wallpapers to `~/Pictures/Wallpapers`.
- Run `p10k configure` to configure the terminal theme.
- Remove unnecessary Zsh plugins for you in `~/.zshrc`:
  ```zsh
  plugins=(...)
  ```

**PC users:**

- Disable the `custom/backlight` Waybar module in `~/.config/waybar/config.jsonc`.

## Restoring config backup

```
~/dotfiles/Scripts/restore.sh
```

# Detailed overview

## Dependencies

Packages installed by [`install.sh`](./Scripts/install.sh).

<details>
<summary><b>System and interface</b></summary>

| Package    | Description                  |
| :--------- | :--------------------------- |
| `hyprlock` | Lock screen                  |
| `hypridle` | Idle management daemon       |
| `hyprshot` | Screenshot tool              |
| `kitty`    | Terminal emulator            |
| `nwg-look` | GTK theme configuration tool |
| `swaync`   | Notification center          |
| `vicinae`  | Native launcher              |
| `waybar`   | Wayland status bar           |
| `waypaper` | Wallpaper manager            |
| `wlogout`  | Logout menu                  |
| `swww`     | Wallpaper daemon             |
| `zsh`      | Command shell                |

</details>

<details>
<summary><b>Utilities and tools</b></summary>

| Package                  | Description                      |
| :----------------------- | :------------------------------- |
| `base-devel`             | Development tools for AUR builds |
| `brightnessctl`          | Brightness control               |
| `fastfetch`              | System information viewer        |
| `flameshot`              | Screenshot tool                  |
| `git`                    | Version control system           |
| `gpu-screen-recorder`    | GPU-accelerated screen recorder  |
| `grim`                   | Wayland screenshot tool          |
| `imagemagick`            | Image manipulation tools         |
| `lsd`                    | `ls` alternative with icons      |
| `nautilus`               | File manager                     |
| `network-manager-applet` | Network management tray applet   |
| `pavucontrol`            | PulseAudio volume control        |
| `playerctl`              | Media player control             |
| `trash-cli`              | Command-line trash utility       |
| `uwsm`                   | Wayland session manager          |
| `wl-clip-persist`        | Clipboard persistence            |
| `wl-clipboard`           | Wayland clipboard utilities      |
| `yay`                    | AUR helper                       |

</details>

<details>
<summary><b>Networking, audio and portals</b></summary>

| Package                       | Description                    |
| :---------------------------- | :----------------------------- |
| `bluez`                       | Bluetooth stack                |
| `blueman`                     | Bluetooth manager              |
| `networkmanager`              | Network connection manager     |
| `pipewire`                    | Audio and video server         |
| `pipewire-alsa`               | ALSA compatibility layer       |
| `pipewire-pulse`              | PulseAudio compatibility layer |
| `polkit-gnome`                | PolicyKit authentication agent |
| `xdg-desktop-portal`          | Desktop portal service         |
| `xdg-desktop-portal-gnome`    | GNOME portal backend           |
| `xdg-desktop-portal-gtk`      | GTK portal backend             |
| `xdg-desktop-portal-hyprland` | Hyprland portal backend        |
| `xdg-desktop-portal-wlr`      | wlroots portal backend         |
| `xdg-utils`                   | XDG integration utilities      |

</details>

<details>
<summary><b>Appearance and themes</b></summary>

| Package                             | Description                         |
| :---------------------------------- | :---------------------------------- |
| `adw-gtk-theme`                     | Adwaita theme for GTK               |
| `darkly-bin`                        | Qt5/Qt6 dark theme                  |
| `frameworkintegration`              | KDE workspace integration framework |
| `inter-font`                        | Inter font family                   |
| `matugen-bin`                       | Generate themes from wallpapers     |
| `noto-fonts`                        | Noto font family                    |
| `noto-fonts-cjk`                    | Noto fonts for CJK languages        |
| `noto-fonts-emoji`                  | Noto emoji fonts                    |
| `noto-fonts-extra`                  | Additional Noto fonts               |
| `papirus-icon-theme`                | Papirus icon theme                  |
| `qt5ct-kde`                         | Qt5 theme configuration             |
| `qt6ct-kde`                         | Qt6 theme configuration             |
| `rose-pine-cursor`                  | Rosé Pine cursor theme              |
| `rose-pine-hyprcursor`              | Rosé Pine cursor theme for Hyprland |
| `ttf-jetbrains-mono-nerd`           | JetBrains Mono with Nerd glyphs     |
| `ttf-meslo-nerd-font-powerlevel10k` | Meslo Nerd font for Powerlevel10k   |

</details>

## Hyprland

Window manager (WM).

- [[Environment variables](./Configs/.config/hypr/hyprland/env.conf)]
- [[Autostart](./Configs/.config/hypr/hyprland/exec.conf)]
- [[Input configuration](./Configs/.config/hypr/hyprland/input.conf)]
- [[Keybindings](./Configs/.config/hypr/hyprland/keybindings.conf)]
- [[Look and feel settings](./Configs/.config/hypr/hyprland/looknfeel.conf)]
- [[Monitor configuration](./Configs/.config/hypr/hyprland/monitors.conf)]
- [[Window and workspace rules](./Configs/.config/hypr/hyprland/rules.conf)]

## Keybinds

<details>
   <summary>
      <b>Application launch</b>
   </summary>

| Keys                                               | Action                                |
| :------------------------------------------------- | :------------------------------------ |
| <kbd>Super</kbd> + <kbd>W</kbd>                    | Terminal (Kitty)                      |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | Terminal in floating mode             |
| <kbd>Super</kbd> + <kbd>R</kbd>                    | Application menu (Vicinae)            |
| <kbd>Super</kbd> + <kbd>E</kbd>                    | File manager (Nautilus)               |
| <kbd>Super</kbd> + <kbd>C</kbd>                    | Code editor (VSCodium\*)              |
| <kbd>Super</kbd> + <kbd>B</kbd>                    | Browser (Brave\*)                     |
| <kbd>Super</kbd> + <kbd>K</kbd>                    | Password manager (KeePassXC\*)        |
| <kbd>Super</kbd> + <kbd>V</kbd>                    | Clipboard (Vicinae Clipboard)         |
| <kbd>Super</kbd> + <kbd>N</kbd>                    | Notification center (SwayNC)          |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>E</kbd> | Emoji menu (Vicinae Emoji)            |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> | Wallpaper selector (Vicinae + Script) |

<b><i>\*VSCodium, Brave, KeePassXC</b> - are NOT installed automatically by the [installation script](./Scripts/install.sh).</i>

</details>

<details>
   <summary>
      <b>Window interaction</b>
   </summary>

| Keys                                                      | Action                              |
| :-------------------------------------------------------- | :---------------------------------- |
| <kbd>Super</kbd> + <kbd>Q</kbd>                           | Close active window                 |
| <kbd>F11</kbd>                                            | Fullscreen                          |
| <kbd>Super</kbd> + <kbd>A</kbd>                           | Maximize active window              |
| <kbd>Super</kbd> + <kbd>F</kbd>                           | Toggle window to "float" mode       |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd>        | Switch to pseudo-tiling mode        |
| <kbd>Super</kbd> + <kbd>S</kbd>                           | Pin window on top of all workspaces |
| <kbd>Super</kbd> + <kbd>D</kbd>                           | Toggle window split mode            |
| <kbd>Alt</kbd> + <kbd>Tab</kbd>                           | Switch to the next window           |
| <kbd>Super</kbd> + <kbd>Arrows</kbd>                      | Move focus between windows          |
| <kbd>Super</kbd> + <kbd>Control</kbd> + <kbd>Arrows</kbd> | Resize active window                |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Arrows</kbd>   | Move windows                        |
| <kbd>Super</kbd> + <kbd>LMB</kbd>                         | Move windows with the mouse         |
| <kbd>Super</kbd> + <kbd>RMB</kbd>                         | Resize windows with the mouse       |

</details>

<details>
   <summary>
      <b>Workspaces</b>
   </summary>

| Keys                                                   | Action                             |
| :----------------------------------------------------- | :--------------------------------- |
| <kbd>Super</kbd> + <kbd>[0-9]</kbd>                    | Switch between workspaces 1 to 10  |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>[0-9]</kbd> | Move window to workspace 1 to 10   |
| <kbd>Super</kbd> + <kbd>Tab</kbd>                      | Switch to a special workspace      |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Tab</kbd>   | Move window to a special workspace |

</details>

<details>
   <summary>
      <b> Screen/power management</b>
   </summary>

| Keys                                             | Action                       |
| :----------------------------------------------- | :--------------------------- |
| <kbd>Super</kbd> + <kbd>L</kbd>                  | Lock screen                  |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>D</kbd> | Turn display on/off          |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd> | Lock screen and put to sleep |

</details>

<details>
   <summary>
      <b>Screenshots</b>
   </summary>

| Keys                                               | Action                                                             |
| :------------------------------------------------- | :----------------------------------------------------------------- |
| <kbd>Print</kbd>                                   | Screenshot of the entire screen                                    |
| <kbd>Shift</kbd> + <kbd>Print</kbd>                | Screenshot of the selected area                                    |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd> | Flameshot GUI (screenshot utility)                                 |
| <kbd>Super</kbd> + <kbd>Print</kbd>                | Screenshot and auto upload to [Zipline](https://zipline.diced.sh/) |

</details>

<details>
   <summary>
      <b>Other</b>
   </summary>

| Keys                                               | Action                                                   |
| :------------------------------------------------- | :------------------------------------------------------- |
| <kbd>Super</kbd> + <kbd>Escape</kbd>               | Hide/show Waybar                                         |
| <kbd>Super</kbd> +<kbd>Alt</kbd> + <kbd>P</kbd>    | Random background + Generate theme (matugen)             |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> | Start/stop recording a screen area (gpu-screen-recorder) |
| <kbd>Super</kbd> + <kbd>H</kbd>                    | Toggle windows and layers visibility on screen share     |
| <kbd>Super</kbd> + <kbd>M</kbd>                    | Mute/unmute microphone                                   |
| <kbd>Super</kbd> + <kbd>Z</kbd>                    | Zoom in                                                  |
| <kbd>Super</kbd> + <kbd>Mouse wheel</kbd>          | Zoom in/out                                              |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Z</kbd> | Reset zoom                                               |

</details>

## Icons

https://github.com/PapirusDevelopmentTeam/papirus-icon-theme

```
sudo pacman -S papirus-icon-theme
```

## Cursor

https://github.com/rose-pine/cursor

https://github.com/ndom91/rose-pine-hyprcursor

```
yay -S rose-pine-cursor rose-pine-hyprcursor
```

## Fonts

- [Noto](https://www.google.com/get/noto/) - all languages + emoji + special characters:

  ```
  sudo pacman -S noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
  ```

- [JetBrains Mono Nerd](https://www.jetbrains.com/lp/mono/) for VSCode and [Waybar](#waybar):

  ```
  sudo pacman -S ttf-jetbrains-mono-nerd
  ```

- [Meslo Nerd](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#fonts) recommended font for powerlevel10k ([Zsh theme](#terminal)):

  ```
  yay -S ttf-meslo-nerd-font-powerlevel10k
  ```

- [Inter](https://rsms.me/inter/) required font for [Hyprlock](#hyprlock):

  ```
  sudo pacman -S inter-font
  ```

## Hypridle

Idle behavior. [[config](./Configs/.config/hypr/hypridle.conf)]

https://wiki.hypr.land/Hypr-Ecosystem/hypridle |
https://github.com/hyprwm/hypridle

```
sudo pacman -S hypridle
```

| Action               | Timeout |
| -------------------- | ------- |
| Brightness reduction | 10 min. |
| Notification         | 13 min. |
| Session lock         | 15 min. |
| Screen off           | 16 min. |
| Sleep mode           | 18 min. |

## Hyprlock

Lock screen. [[config](./Configs/.config/hypr/hyprlock.conf)]

https://github.com/hyprwm/hyprlock

```
sudo pacman -S hyprlock
```

## Waybar

Wayland bar. [[config](./Configs/.config/waybar/)]

https://github.com/Alexays/Waybar

```
sudo pacman -S waybar
```

## Vicinae

Focused launcher. [[config](./Configs/.config/vicinae/)]

https://github.com/vicinaehq/vicinae

```
yay -S vicinae-bin
```

## Wlogout

Logout menu. [[config](./Configs/.config/wlogout/)]

https://github.com/ArtsyMacaw/wlogout

```
yay -S wlogout
```

<details><summary><b>Screenshot</b></summary>

![Screenshot](https://share.rzx.ovh/go/rdots-wlogout)

</details>

## Terminal

Terminal emulator - [Kitty](https://sw.kovidgoyal.net/kitty) [[config](./Configs/.config/kitty/)]

Shell - [Zsh](https://www.zsh.org/) [[config](./Configs/.zshrc)]

Extension for Zsh - [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

Theme - [powerlevel10k](https://github.com/romkatv/powerlevel10k) [[config](./Configs/.p10k.zsh)]

<details><summary><b>Kitty keybinds</b></summary>
<br>
<details>
   <summary>
      <b>Window and tab management</b>
   </summary>

| Keys                                            | Action                                 |
| :---------------------------------------------- | :------------------------------------- |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>X</kbd>   | Close active window                    |
| <kbd>Ctrl</kbd> + <kbd>Q</kbd>                  | Close kitty window                     |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>]</kbd>   | Next window                            |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>[</kbd>   | Previous window                        |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>.</kbd>   | Move window forward                    |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>,</kbd>   | Move window back                       |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>C</kbd>   | Create a new tab in the same directory |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>1-9</kbd> | Go to tab 1-9                          |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>0</kbd>   | Go to tab 10                           |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>,</kbd>   | Set tab title                          |
| <kbd>F11</kbd>                                  | Fullscreen mode                        |

</details>

<details>
   <summary>
      <b>Window splitting</b>
   </summary>

| Keys                                                              | Action                                        |
| :---------------------------------------------------------------- | :-------------------------------------------- |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd>                 | Create a new window with horizontal splitting |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>-</kbd>                     | Horizontal splitting in the current directory |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>-</kbd>  | Horizontal splitting                          |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>\|</kbd>                    | Vertical splitting in the current directory   |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>\|</kbd> | Vertical splitting                            |
| <kbd>F4</kbd>                                                     | Split window                                  |
| <kbd>F7</kbd>                                                     | Rotate window layout                          |

</details>

<details>
   <summary>
      <b>Movement and focus</b>
   </summary>

| Keys                                                                          | Action                           |
| :---------------------------------------------------------------------------- | :------------------------------- |
| <kbd>Shift</kbd> + <kbd>↑</kbd>                                               | Move window up                   |
| <kbd>Shift</kbd> + <kbd>↓</kbd>                                               | Move window down                 |
| <kbd>Shift</kbd> + <kbd>←</kbd>                                               | Move window left                 |
| <kbd>Shift</kbd> + <kbd>→</kbd>                                               | Move window right                |
| <kbd>Alt</kbd> + <kbd>↑</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>K</kbd> | Focus on the window above        |
| <kbd>Alt</kbd> + <kbd>↓</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>J</kbd> | Focus on the window below        |
| <kbd>Alt</kbd> + <kbd>←</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>H</kbd> | Focus on the window to the left  |
| <kbd>Alt</kbd> + <kbd>→</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>L</kbd> | Focus on the window to the right |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Q</kbd>                                 | Focus on a visible window        |

</details>

<details>
   <summary>
      <b>Resizing windows</b>
   </summary>

| Keys                                          | Action                    |
| :-------------------------------------------- | :------------------------ |
| <kbd>Alt</kbd> + <kbd>N</kbd>                 | Make window narrower      |
| <kbd>Alt</kbd> + <kbd>W</kbd>                 | Make window wider         |
| <kbd>Alt</kbd> + <kbd>U</kbd>                 | Make window taller        |
| <kbd>Alt</kbd> + <kbd>D</kbd>                 | Make window shorter       |
| <kbd>Ctrl</kbd> + <kbd>Home</kbd>             | Reset window size         |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Z</kbd> | Zoom in/out window (zoom) |

</details>

<details>
   <summary>
      <b>Font</b>
   </summary>

| Keys                                                            | Action             |
| :-------------------------------------------------------------- | :----------------- |
| <kbd>Ctrl</kbd> + <kbd>=</kbd> / <kbd>Ctrl</kbd> + <kbd>+</kbd> | Increase font size |
| <kbd>Ctrl</kbd> + <kbd>-</kbd>                                  | Decrease font size |
| <kbd>Ctrl</kbd> + <kbd>0</kbd>                                  | Reset font size    |

</details>

<details>
   <summary>
      <b>Miscellaneous</b>
   </summary>

| Keys                                                             | Action                       |
| :--------------------------------------------------------------- | :--------------------------- |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>E</kbd> | Edit kitty.conf in a new tab |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>R</kbd> | Reload kitty configuration   |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>D</kbd> | Debug configuration          |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Space</kbd>                | Hints mode                   |
| <kbd>F3</kbd>                                                    | Hints mode for everything    |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Ctrl</kbd> + <kbd>A</kbd>  | Send ^A (as in tmux)         |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>T</kbd>                    | Select theme                 |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>S</kbd>                    | Save session                 |

</details>

</details>

Installing Kitty and Zsh:

```
sudo pacman -S kitty zsh
```

Changing the shell:

```
chsh -s $(which zsh)
```

Installing Oh My Zsh:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Installing the powerlevel10k theme:

```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Installing plugins for zsh via Oh My Zsh:

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting):

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions):

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Installing [lsd](https://github.com/lsd-rs/lsd) (ls replacement):

```
sudo pacman -S lsd
```

## Nwg-look

GTK settings. [[config](./Configs/.config/nwg-look/)]

https://github.com/nwg-piotr/nwg-look

https://github.com/lassekongo83/adw-gtk3

```
sudo pacman -S nwg-look adw-gtk-theme
```

```
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

## Qt

Qt6 settings. [[config](./Configs/.config/qt6ct/)]

Qt5 settings. [[config](./Configs/.config/qt5ct/)]

https://aur.archlinux.org/packages/qt6ct-kde

https://aur.archlinux.org/packages/qt5ct-kde

https://github.com/Bali10050/Darkly

```
yay -S qt6cd-kde qt5ct-kde darkly-qt5-git darkly-qt6-git
```

## SwayNC

Notifications. [[config](./Configs/.config/swaync/)]

https://github.com/ErikReider/SwayNotificationCenter

```
sudo pacman -S swaync
```

## Waypaper

GUI for easy wallpaper management.

https://github.com/anufrievroman/waypaper

```
yay -S waypaper
```

For static images and gifs (required):

```
sudo pacman -S swww
```

For videos (optional):

```
yay -S mpvpaper
```

### Wallpapers

- [Matugen](https://share.rzx.ovh/folder/cmik5z0om005001pc7996irnv)
- [Monochrome](https://share.rzx.ovh/folder/cm8q1lxwp000mln01qsqbpb7f)

## Flameshot

Powerful screenshot utility. [[config](./Configs/.config/flameshot/)]

https://flameshot.org

```
yay -S flameshot-git
```

## Fastfetch

Show off your linux [[config](./Configs/.config/fastfetch/)]

https://github.com/fastfetch-cli/fastfetch

```
sudo pacman -S fastfetch
```
