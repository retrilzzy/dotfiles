<h1 align="center">Retrilz's Dotfiles</h1>

<table align="center">
   <tr>
      <td colspan="3" align="center">
         <img src="https://share.rzx.ovh/go/rdots-general?v=2" width="fit"><br>
         <sub><b>General</b></sub>
      </td>
   </tr>
   <tr>
      <td align="center">
         <img src="https://share.rzx.ovh/go/rdots-hyprlock" width="fit"><br>
         <sub><b>Hyprlock</b></sub>
      </td>
      <td align="center">
         <img src="https://share.rzx.ovh/go/rdots-terminals?v=2" width="fit"><br>
         <sub><b>Terminals</b></sub>
      </td>
  </tr>
  <tr>
      <td colspan="3" align="center">
         <img src="https://share.rzx.ovh/go/rdots-gtk-qt?v=2" width="fit"><br>
         <sub><b>GTK & Qt</b></sub>
      </td>
   </tr>
</table>

<div align="center">
  <p>【 🇷🇺 Русский 】 <a href="./README.md">【 🇬🇧 English 】</a></p>
   <img alt="Last README modification" src="https://img.shields.io/github/last-commit/retrilzzy/dotfiles?path=README-ru.md&style=for-the-badge&logo=readdotcv&logoColor=ffff&label=Last%20README-ru%20modification&labelColor=0D1117&color=0D1117">
</div>

# Навигация

- [Установка](#установка)
- [Детальный обзор](#детальный-обзор)
  - [Зависимости](#зависимости) - пакеты, необходимые для работы.
  - [Hyprland](#hyprland) - динамический плиточный Wayland композитор.
    - [Бинды](#бинды) - все сочетания клавиш.
    - [Иконки](#иконки) - пак иконок.
    - [Курсор](#курсор) - тема курсора.
    - [Шрифты](#шрифты) - установка шрифтов.
    - [Hypridle](#hypridle) - поведение при бездействии.
    - [Hyprlock](#hyprlock) - экран блокировки.
  - [Waybar](#waybar) - Wayland бар.
  - [Vicinae](#vicinae) - фокусированный мульти-лаунчер.
  - [Wlogout](#wlogout) - меню выхода.
  - [Терминал](#терминал) - настройка терминала.
  - [Nwg-look](#nwg-look) - настройка GTK.
  - [Qt](#qt) - настройка Qt.
  - [Swaync](#swaync) - уведомления.
  - [Waypaper](#waypaper) - GUI для простого управление обоями.
    - [Обои](#обои) - коллекция обоев/фонов.
  - [Fastfetch](#fastfetch) - похвастаться Линуксом.

> [!WARNING]  
> Мои конфиги не рассчитаны на универсальное применение и не автоматизированы на 100%, поэтому они могут потребовать ручной донастройки. Я не гарантирую корректную работу конфигов или программного обеспечения на вашей системе.

# Установка

> [!NOTE]
> Перед установкой у вас должен быть работающий Hyprland.

> [!IMPORTANT]  
> Скрипт установки был протестирован только на **Arch Linux**.

0. Обновление системы:

   ```
   sudo pacman -Syu
   ```

1. Запуск [скрипта установки](./Scripts/install.sh):

   ```
   curl https://raw.githubusercontent.com/retrilzzy/dotfiles/refs/heads/main/Scripts/install.sh | bash
   ```

   - Установит [необходимые пакеты](#зависимости).
   - Клонирует этот репозиторий в `~/dotfiles`.
   - Создаст резервную копию конфигов в `~/.config-backups/$date_time`.
   - Применит новые конфиги из этого репозитория.

## После установки

Действия которые вы вероятно хотите сделать.

**Общее:**

- Добавить свои обои в `~/Pictures/Wallpapers`.
- Запустить `p10k configure` для настройки темы терминала.
- Убрать лишние для вас плагины Zsh в `~/.zshrc`:
  ```zsh
  plugins=(...)
  ```

**ПК юзерам:**

- Отключить модуль `custom/backlight` Waybar в `~/.config/waybar/config.jsonc`.

## Восстановление резервной копии конфигов

```
~/dotfiles/Scripts/restore.sh
```

# Детальный обзор

## Зависимости

Здесь перечислены все пакеты, устанавливаемые скриптом [`install.sh`](./Scripts/install.sh).

<details>
<summary><b>Система и интерфейс</b></summary>

| Пакет      | Описание                          |
| :--------- | :-------------------------------- |
| `hyprlock` | Экран блокировки                  |
| `hypridle` | Демон для управления бездействием |
| `hyprshot` | Утилита для создания скриншотов   |
| `kitty`    | Эмулятор терминала                |
| `nwg-look` | Утилита для настройки GTK тем     |
| `swaync`   | Центр уведомлений                 |
| `vicinae`  | Фокусированный мульти-лаунчер     |
| `waybar`   | Wayland бар                       |
| `waypaper` | Управление обоями                 |
| `wlogout`  | Меню выхода из системы            |
| `awww`     | Демон обоев                       |
| `zsh`      | Командная оболочка                |

</details>

<details>
<summary><b>Утилиты и инструменты</b></summary>

| Пакет                    | Описание                               |
| :----------------------- | :------------------------------------- |
| `base-devel`             | Инструменты разработки для сборок AUR  |
| `brightnessctl`          | Управление яркостью экрана             |
| `fastfetch`              | Просмотр информации о системе          |
| `git`                    | Система контроля версий                |
| `gpu-screen-recorder`    | Запись экрана с ускорением GPU         |
| `grim`                   | Утилита для скриншотов Wayland         |
| `gnome-keyring`          | Хранилище ключей шифрования            |
| `imagemagick`            | Инструменты для работы с изображениями |
| `lsd`                    | Альтернатива `ls` с иконками           |
| `nautilus`               | Файловый менеджер                      |
| `network-manager-applet` | Апплет для управления сетью            |
| `pavucontrol`            | GUI для управления звуком              |
| `playerctl`              | Управление медиаплеерами               |
| `satty`                  | Утилита для создания скриншотов        |
| `trash-cli`              | Утилита корзины командной строки       |
| `uwsm`                   | Менеджер сессий Wayland                |
| `wl-clip-persist`        | Сохранение содержимого буфера обмена   |
| `wl-clipboard`           | Утилиты буфера обмена Wayland          |
| `yay`                    | AUR-хелпер                             |

</details>

<details>
<summary><b>Сеть, аудио и порталы</b></summary>

| Пакет                         | Описание                         |
| :---------------------------- | :------------------------------- |
| `bluez`                       | Стек Bluetooth                   |
| `blueman`                     | Менеджер Bluetooth               |
| `networkmanager`              | Менеджер сетевых подключений     |
| `pipewire`                    | Аудио- и видеосервер             |
| `pipewire-alsa`               | Уровень совместимости ALSA       |
| `pipewire-pulse`              | Уровень совместимости PulseAudio |
| `polkit-gnome`                | Агент аутентификации PolicyKit   |
| `xdg-desktop-portal`          | Служба портала рабочего стола    |
| `xdg-desktop-portal-gtk`      | Бэкенд портала GTK               |
| `xdg-desktop-portal-hyprland` | Бэкенд портала Hyprland          |
| `xdg-desktop-portal-wlr`      | Бэкенд портала wlroots           |
| `xdg-utils`                   | Утилиты интеграции XDG           |

</details>

<details>
<summary><b>Внешний вид и темы</b></summary>

| Пакет                     | Описание                                       |
| :------------------------ | :--------------------------------------------- |
| `adw-gtk-theme`           | Тема Adwaita для GTK                           |
| `darkly-bin`              | Темная тема Qt5/Qt6                            |
| `frameworkintegration`    | Фреймворк интеграции рабочего пространства KDE |
| `inter-font`              | Семейство шрифтов Inter                        |
| `matugen-bin`             | Генерация тем из обоев                         |
| `noto-fonts`              | Семейство шрифтов Noto                         |
| `noto-fonts-cjk`          | Шрифты Noto для языков CJK                     |
| `noto-fonts-emoji`        | Шрифты Noto с эмодзи                           |
| `noto-fonts-extra`        | Дополнительные шрифты Noto                     |
| `papirus-icon-theme`      | Тема иконок Papirus                            |
| `qt5ct-kde`               | Настройка тем Qt5                              |
| `qt6ct-kde`               | Настройка тем Qt6                              |
| `ttf-jetbrains-mono-nerd` | JetBrains Mono с Nerd-глифами                  |

</details>

## Hyprland

Динамический плиточный Wayland композитор.

- [[Основное](./Configs/.config/hypr/hyprland/general.conf)]
- [[Автостарт](./Configs/.config/hypr/hyprland/autostart.conf)]
- [[Сочетания клавиш](./Configs/.config/hypr/hyprland/keybindings.conf)]
- [[Конфигурация мониторов](./Configs/.config/hypr/hyprland/monitors.conf)]
- [[Правила окон и рабочих столов](./Configs/.config/hypr/hyprland/rules.conf)]

## Бинды

<details>
   <summary>
      <b>Запуск приложений</b>
   </summary>

| Клавиши                                            | Действие                            |
| :------------------------------------------------- | :---------------------------------- |
| <kbd>Super</kbd> + <kbd>W</kbd>                    | Терминал (Kitty)                    |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | Терминал в плавающем режиме (float) |
| <kbd>Super</kbd> + <kbd>R</kbd>                    | Меню приложений (Vicinae)           |
| <kbd>Super</kbd> + <kbd>E</kbd>                    | Файловый менеджер (Nautilus)        |
| <kbd>Super</kbd> + <kbd>C</kbd>                    | Редактор кода (VSCodium\*)          |
| <kbd>Super</kbd> + <kbd>B</kbd>                    | Браузер (Brave\*)                   |
| <kbd>Super</kbd> + <kbd>K</kbd>                    | Менеджер паролей (KeePassXC\*)      |
| <kbd>Super</kbd> + <kbd>V</kbd>                    | Буфер обмена (Vicinae Clipboard)    |
| <kbd>Super</kbd> + <kbd>N</kbd>                    | Центр уведомлений (SwayNC)          |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> | Выбор обоев (Vicinae + Скрипт)      |

<b><i>\*VSCodium, Brave, KeePassXC</b> - НЕ устанавливаются автоматически [скриптом установки](./Scripts/install.sh).</i>

</details>

<details>
   <summary>
      <b>Взаимодействие с окнами</b>
   </summary>

| Клавиши                                                    | Действие                                          |
| :--------------------------------------------------------- | :------------------------------------------------ |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Q</kbd>                            | Закрыть активное окно                             |
| <kbd>F11</kbd>                                             | Полный экран (fullscreen)                         |
| <kbd>Super</kbd> + <kbd>A</kbd>                            | Максимизировать активное окно                     |
| <kbd>Super</kbd> + <kbd>F</kbd>                            | Переключение окна в режим "плавающее" (float)     |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd>         | Переключение на псевдоплиточный режим (pseudo)    |
| <kbd>Super</kbd> + <kbd>S</kbd>                            | Закрепление окна поверх всех рабочих столов (pin) |
| <kbd>Super</kbd> + <kbd>D</kbd>                            | Переключение режима разделения окна               |
| <kbd>Alt</kbd> + <kbd>Tab</kbd>                            | Переключение на следующее окно                    |
| <kbd>Super</kbd> + <kbd>Стрелки</kbd>                      | Перемещение фокуса между окнами                   |
| <kbd>Super</kbd> + <kbd>Control</kbd> + <kbd>Стрелки</kbd> | Изменение размера активного окна                  |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Стрелки</kbd>   | Перемещение окон                                  |
| <kbd>Super</kbd> + <kbd>ЛКМ</kbd>                          | Перемещение окон мышью                            |
| <kbd>Super</kbd> + <kbd>ПКМ</kbd>                          | Изменение размера окон мышью                      |

</details>

<details>
   <summary>
      <b>Рабочие пространства (столы)</b>
   </summary>

| Клавиши                                                | Действие                                             |
| :----------------------------------------------------- | :--------------------------------------------------- |
| <kbd>Super</kbd> + <kbd>[0-9]</kbd>                    | Переключение между рабочими пространствами с 1 по 10 |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>[0-9]</kbd> | Перемещение окна в рабочее пространство с 1 по 10    |
| <kbd>Super</kbd> + <kbd>Tab</kbd>                      | Переключение на специальное рабочее пространство     |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Tab</kbd>   | Перемещение окна в специальное рабочее пространство  |

</details>

<details>
   <summary>
      <b> Управление экраном/питанием</b>
   </summary>

| Клавиши                                          | Действие                                       |
| :----------------------------------------------- | :--------------------------------------------- |
| <kbd>Super</kbd> + <kbd>L</kbd>                  | Заблокировать экран                            |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>D</kbd> | Включить/выключить дисплей                     |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd> | Заблокировать экран и перевести в спящий режим |

</details>

<details>
   <summary>
      <b>Скриншоты</b>
   </summary>

| Клавиши                                            | Действие                                                         |
| :------------------------------------------------- | :--------------------------------------------------------------- |
| <kbd>Print</kbd>                                   | Скриншот всего экрана                                            |
| <kbd>Shift</kbd> + <kbd>Print</kbd>                | Скриншот выделенной области                                      |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> | Satty (инструмент для скриншотов с аннотациями)                  |
| <kbd>Super</kbd> + <kbd>Print</kbd>                | Скриншот и авто загрузка на [Zipline](https://zipline.diced.sh/) |

</details>

<details>
   <summary>
      <b>Остальное</b>
   </summary>

| Клавиши                                            | Действие                                                      |
| :------------------------------------------------- | :------------------------------------------------------------ |
| <kbd>Super</kbd> + <kbd>Escape</kbd>               | Скрыть/показать Waybar                                        |
| <kbd>Super</kbd> +<kbd>Alt</kbd> + <kbd>P</kbd>    | Случайный фон + Генерация темы (matugen)                      |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> | Начать/остановить запись области экрана (gpu-screen-recorder) |
| <kbd>Super</kbd> + <kbd>H</kbd>                    | Переключить видимость окон и слоев на демонстрации экрана     |
| <kbd>Super</kbd> + <kbd>M</kbd>                    | Включение/выключение микрофона                                |
| <kbd>Super</kbd> + <kbd>Z</kbd>                    | Увеличить масштаб курсора                                     |
| <kbd>Super</kbd> + <kbd>Колесико мыши</kbd>        | Увеличить/уменьшить масштаб курсора                           |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Z</kbd> | Сбросить масштаб курсора                                      |

</details>

## Иконки

https://github.com/PapirusDevelopmentTeam/papirus-icon-theme

```
sudo pacman -S papirus-icon-theme
```

## Курсор

https://github.com/ful1e5/Bibata_Cursor

Скрипт установки устанавливает курсор [`Bibata-Modern-Classic`](https://github.com/ful1e5/Bibata_Cursor/releases/tag/v2.0.7).

```
mkdir -p /tmp/bibata
curl -L https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz -o /tmp/bibata/bibata.tar.xz
tar -xf /tmp/bibata/bibata.tar.xz -C /tmp/bibata
sudo cp -r /tmp/bibata/Bibata-Modern-Classic /usr/share/icons/
```

## Шрифты

- [Noto](https://www.google.com/get/noto/) - поддержка всех языков + эмодзи + специальные символы:

  ```
  sudo pacman -S noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
  ```

- [JetBrains Mono Nerd](https://www.jetbrains.com/lp/mono/) для [Waybar](#waybar) и [Kitty](#терминал):

  ```
  sudo pacman -S ttf-jetbrains-mono-nerd
  ```

- [Inter](https://rsms.me/inter/) необходимый шрифт для [Hyprlock](#hyprlock):

  ```
  sudo pacman -S inter-font
  ```

## Hypridle

Поведение при бездействии. [[конфиг](./Configs/.config/hypr/hypridle.conf)]

https://wiki.hypr.land/Hypr-Ecosystem/hypridle |
https://github.com/hyprwm/hypridle

```
sudo pacman -S hypridle
```

| Действие          | Таймаут |
| ----------------- | ------- |
| Снижение яркости  | 10 мин. |
| Уведомление       | 13 мин. |
| Блокировка сессии | 15 мин. |
| Выключение экрана | 16 мин. |
| Спящий режим      | 18 мин. |

## Hyprlock

Экран блокировки. [[конфиг](./Configs/.config/hypr/hyprlock.conf)]

https://github.com/hyprwm/hyprlock

```
sudo pacman -S hyprlock
```

## Waybar

Wayland бар. [[конфиг](./Configs/.config/waybar/)]

https://github.com/Alexays/Waybar

```
sudo pacman -S waybar
```

## Vicinae

Фокусированный мульти-лаунчер. [[конфиг](./Configs/.config/vicinae/)]

https://github.com/vicinaehq/vicinae

```
yay -S vicinae-bin
```

## Wlogout

Меню выхода. [[конфиг](./Configs/.config/wlogout/)]

https://github.com/ArtsyMacaw/wlogout

```
yay -S wlogout
```

<details><summary><b>Скриншот</b></summary>

![Screenshot](https://share.rzx.ovh/go/rdots-wlogout)

</details>

## Терминал

Эмулятор терминала - [Kitty](https://sw.kovidgoyal.net/kitty) [[конфиг](./Configs/.config/kitty/)]

Оболочка - [Zsh](https://www.zsh.org/) [[конфиг](./Configs/.zshrc)]

Расширение для Zsh - [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

Тема - [powerlevel10k](https://github.com/romkatv/powerlevel10k) [[конфиг](./Configs/.p10k.zsh)]

<details><summary><b>Бинды Kitty</b></summary>
<br>
<details>
   <summary>
      <b>Управление окнами и вкладками</b>
   </summary>

| Клавиши                                         | Действие                                  |
| :---------------------------------------------- | :---------------------------------------- |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>X</kbd>   | Закрыть активное окно                     |
| <kbd>Ctrl</kbd> + <kbd>Q</kbd>                  | Закрыть окно kitty                        |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>]</kbd>   | Следующее окно                            |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>[</kbd>   | Предыдущее окно                           |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>.</kbd>   | Переместить окно вперед                   |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>,</kbd>   | Переместить окно назад                    |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>C</kbd>   | Создать новую вкладку в той же директории |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>1-9</kbd> | Перейти на вкладку 1-9                    |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>0</kbd>   | Перейти на вкладку 10                     |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>,</kbd>   | Установить заголовок вкладки              |
| <kbd>F11</kbd>                                  | Полноэкранный режим                       |

</details>

<details>
   <summary>
      <b>Разделение окон</b>
   </summary>

| Клавиши                                                           | Действие                                        |
| :---------------------------------------------------------------- | :---------------------------------------------- |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd>                 | Создать новое окно с горизонтальным разделением |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>-</kbd>                     | Горизонтальное разделение в текущей директории  |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>-</kbd>  | Горизонтальное разделение                       |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>\|</kbd>                    | Вертикальное разделение в текущей директории    |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>\|</kbd> | Вертикальное разделение                         |
| <kbd>F4</kbd>                                                     | Разделить окно                                  |
| <kbd>F7</kbd>                                                     | Повернуть расположение окон                     |

</details>

<details>
   <summary>
      <b>Перемещение и фокус</b>
   </summary>

| Клавиши                                                                       | Действие                |
| :---------------------------------------------------------------------------- | :---------------------- |
| <kbd>Shift</kbd> + <kbd>↑</kbd>                                               | Переместить окно вверх  |
| <kbd>Shift</kbd> + <kbd>↓</kbd>                                               | Переместить окно вниз   |
| <kbd>Shift</kbd> + <kbd>←</kbd>                                               | Переместить окно влево  |
| <kbd>Shift</kbd> + <kbd>→</kbd>                                               | Переместить окно вправо |
| <kbd>Alt</kbd> + <kbd>↑</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>K</kbd> | Фокус на окно сверху    |
| <kbd>Alt</kbd> + <kbd>↓</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>J</kbd> | Фокус на окно снизу     |
| <kbd>Alt</kbd> + <kbd>←</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>H</kbd> | Фокус на окно слева     |
| <kbd>Alt</kbd> + <kbd>→</kbd> / <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>L</kbd> | Фокус на окно справа    |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Q</kbd>                                 | Фокус на видимое окно   |

</details>

<details>
   <summary>
      <b>Изменение размера окон</b>
   </summary>

| Клавиши                                       | Действие                        |
| :-------------------------------------------- | :------------------------------ |
| <kbd>Alt</kbd> + <kbd>N</kbd>                 | Сделать окно уже                |
| <kbd>Alt</kbd> + <kbd>W</kbd>                 | Сделать окно шире               |
| <kbd>Alt</kbd> + <kbd>U</kbd>                 | Сделать окно выше               |
| <kbd>Alt</kbd> + <kbd>D</kbd>                 | Сделать окно ниже               |
| <kbd>Ctrl</kbd> + <kbd>Home</kbd>             | Сбросить размер окна            |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Z</kbd> | Приблизить/отдалить окно (zoom) |

</details>

<details>
   <summary>
      <b>Шрифт</b>
   </summary>

| Клавиши                                                         | Действие                |
| :-------------------------------------------------------------- | :---------------------- |
| <kbd>Ctrl</kbd> + <kbd>=</kbd> / <kbd>Ctrl</kbd> + <kbd>+</kbd> | Увеличить размер шрифта |
| <kbd>Ctrl</kbd> + <kbd>-</kbd>                                  | Уменьшить размер шрифта |
| <kbd>Ctrl</kbd> + <kbd>0</kbd>                                  | Сбросить размер шрифта  |

</details>

<details>
   <summary>
      <b>Разное</b>
   </summary>

| Клавиши                                                          | Действие                                 |
| :--------------------------------------------------------------- | :--------------------------------------- |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>E</kbd> | Редактировать kitty.conf в новой вкладке |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>R</kbd> | Перезагрузить конфигурацию kitty         |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Shift</kbd> + <kbd>D</kbd> | Отладка конфигурации                     |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Space</kbd>                | Режим подсказок (hints)                  |
| <kbd>F3</kbd>                                                    | Режим подсказок для всего                |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>Ctrl</kbd> + <kbd>A</kbd>  | Отправить ^A (как в tmux)                |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>T</kbd>                    | Выбрать тему оформления                  |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> > <kbd>S</kbd>                    | Сохранить сессию                         |

</details>

</details>

Установка Kitty и Zsh:

```
sudo pacman -S kitty zsh
```

Смена оболочки:

```
chsh -s $(which zsh)
```

Установка Oh My Zsh:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Установка темы powerlevel10k:

```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Установка плагинов для zsh через Oh My Zsh:

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting):

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions):

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Установка [lsd](https://github.com/lsd-rs/lsd) (замена ls):

```
sudo pacman -S lsd
```

## Nwg-look

Настройка GTK. [[конфиг](./Configs/.config/nwg-look/)]

https://github.com/nwg-piotr/nwg-look

https://github.com/lassekongo83/adw-gtk3

```
sudo pacman -S nwg-look adw-gtk-theme
```

```
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

## Qt

Настройка Qt6. [[конфиг](./Configs/.config/qt6ct/)]

Настройка Qt5. [[конфиг](./Configs/.config/qt5ct/)]

https://aur.archlinux.org/packages/qt6ct-kde

https://aur.archlinux.org/packages/qt5ct-kde

https://github.com/Bali10050/Darkly

```
yay -S qt6cd-kde qt5ct-kde darkly-qt5-git darkly-qt6-git
```

## SwayNC

Уведомления. [[конфиг](./Configs/.config/swaync/)]

https://github.com/ErikReider/SwayNotificationCenter

```
sudo pacman -S swaync
```

## Waypaper

GUI для простого управление обоями.

https://github.com/anufrievroman/waypaper

```
yay -S waypaper
```

Для статичных изображений и gif (необходим):

```
sudo pacman -S awww
```

Для видео (опционально):

```
yay -S mpvpaper
```

### Обои

- [Matugen](https://share.rzx.ovh/folder/cmik5z0om005001pc7996irnv)
- [Монохром](https://share.rzx.ovh/folder/cm8q1lxwp000mln01qsqbpb7f)

## Fastfetch

Похвастаться линуксом [[конфиг](./Configs/.config/fastfetch/)]

https://github.com/fastfetch-cli/fastfetch

```
sudo pacman -S fastfetch
```
