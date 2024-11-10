# Dotfiles

![ScreenShot](./Assets/Current/general.png)


## Навигация

- [Необходимые пакеты](#необходимые-пакеты)
- [Hyprland](#hyprland)
  - [Плагины](#плагины)
  - [Hypridle](#hypridle)
  - [Hyprpaper](#hyprpaper)
  - [Hyprlock](#hyprlock)
- [Waybar](#waybar)
- [Rofi](#rofi)
- [Wlogout](#wlogout)
- [Терминал](#терминал)


> [!IMPORTANT]
> Я возможно упустил некоторые пакеты-зависимости 😇


## Необходимые пакеты

- Помощник для установки пакетов из AUR - [yay](https://github.com/Jguer/yay)

```
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

- Управления яркостью экрана (используется в биндах и waybar) - [brightnessctl](https://archlinux.org/packages/?name=brightnessctl)
- Копирование изображения в буфер обмена - [xdg-utils](https://archlinux.org/packages/?name=xdg-utils)
- Получение информации о соединении с интернетом (используется в waybar) - [iw](https://archlinux.org/packages/?name=iw)
- Скриншоты - [hyprshot](https://aur.archlinux.org/packages/?K=hyprshot)

```
sudo pacman -S brightnessctl xdg-utils iw && yay -S hyprshot
```


## Hyprland

Оконный менеджер (WM)

- [[Основной конфиг](./Configs/hypr/hyprland.conf)]
- [[Бинды](./Configs/hypr/keybindings.conf)]

```
sudo pacman -S hyprland hyprpaper hyprlock hypridle
```

### Плагины

Дополнения к Hyprland [[конфиг](./Configs/hypr/plugins.conf)]

[[Hyprland Wiki](https://wiki.hyprland.org/Plugins/Using-Plugins/)]

**[Hyperspace](https://github.com/KZDKM/Hyprspace)** - обзор рабочих столов

Установка через Hyprpm
```
hyprpm add https://github.com/KZDKM/Hyprspace && hyprpm enable Hyprspace
```

### Hypridle

Поведение при бездействии [[конфиг](./Configs/hypr/hypridle.conf)]

| Действие              | Таймаут   |
| --------------------- | --------- |
| Снижение яркости      | 5 мин.    |
| Блокировка экрана     | 10 мин.   |
| Выключение экрана     | 10.2 мин. |
| Спящий режим          | 20 мин.   |


### Hyprpaper

Установка обоев [[конфиг](./Configs/hypr/hyprpaper.conf)]

*в конфиге надо поменять путь к изображению*

### Hyprlock

Блокировка экрана [[конфиг](./Configs/hypr/hyprlock.conf)]

*в конфиге надо поменять путь к изображению*

<details><summary><b>Скриншот</b></summary>

![ScreenShot](./Assets/V1/hyprlock.png)

</details>



## Waybar

Wayland бар [[конфиг](./Configs/waybar/)]

```
sudo pacman -S waybar
```

<details><summary><b>Скриншот</b></summary>

![ScreenShot](./Assets/Current/waybar.png)

</details>



## Rofi

Запуск приложений, интерфейс для буфера обмена и Wi-Fi [[конфиг](./Configs/rofi/)]

```
sudo pacman -S rofi networkmanager wl-clipboard cliphist
```

<details><summary><b>Скриншот (Лаунчер приложений)</b></summary>

![ScreenShot](./Assets/Current/rofi_app-launcher.png)

</details>

<details><summary><b>Скриншот (Буфер обмена)</b></summary>

![ScreenShot](./Assets/Current/rofi_clipboard.png)

</details>

<details><summary><b>Скриншот (Wi-Fi)</b></summary>

![ScreenShot](./Assets/Current/rofi_wifi.png)

</details>



## Wlogout

Блокировка экрана, выход, перезагрузка, выключение и т.д. [[конфиг](./Configs/wlogout/)]

```
yay -S wlogout
```

<details><summary><b>Скриншот</b></summary>

![ScreenShot](./Assets/Current/wlogout.png)

</details>



## Терминал

Эмулятор терминала - [Kitty](https://sw.kovidgoyal.net/kitty) [[конфиг](./Configs/kitty/)]

Оболочка - [Zsh](https://www.zsh.org/) [[конфиг](./Configs/.zshrc) (`~/.zshrc`)]

Расширение для Zsh - [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

Тема - [powerlevel10k](https://github.com/romkatv/powerlevel10k) [[конфиг](./Configs/.p10k.zsh) (`~/.p10k.zsh`)]

<details><summary><b>Скриншот</b></summary>

![ScreenShot](./Assets/V1/terminal.png)

</details><br>

Установка kitty и zsh

```
sudo pacman -S kitty zsh
```

Установка Oh My Zsh

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Установка темы powerlevel10k

```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Установка плагинов для zsh через Oh My Zsh:

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Установка [exa](https://github.com/ogham/exa) (замена ls)

```
sudo pacman -S exa
```

Установка [The F*ck](https://github.com/nvbn/thefuck) (корректировщик предыдущих команд в терминале)

```
sudo pacman -S thefuck
```



## Fastfetch

В объяснении не нуждается [[конфиг](./Configs/fastfetch/config.jsonc)]

```
sudo pacman -S fastfetch
```

<details><summary><b>Скриншот</b></summary>

![ScreenShot](./Assets/V1/fastfetch.png)

</details>



## Nwg-look

Настройка GTK3 [[конфиг](./Configs/nwg-look/config)]

```
sudo pacman -S nwg-look
```

**Темная тема Adwaita**

`~/.themes/Adwaita-Dark/gtk-3.0/gtk.css`
```
@import url("resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css");
```




## Dunst

Уведомления [[конфиг](./Configs/dunst/dunstrc)]

```
sudo pacman -S dunst
```

<details><summary><b>Скриншот</b></summary>

![ScreenShot](./Assets/Current/dunst.png)

</details>
