# Orchis theme

Orchis is a [Material Design](https://material.io) theme for GNOME/GTK based desktop environments.
Based on nana-4 --  [materia-theme](https://github.com/nana-4/materia-theme)

## Requirements

- GTK `>=3.20`
- `gnome-themes-extra` (or `gnome-themes-standard`)
- Murrine engine — The package name depends on the distro.
  - `gtk-engine-murrine` on Arch Linux
  - `gtk-murrine-engine` on Fedora
  - `gtk2-engine-murrine` on openSUSE
  - `gtk2-engines-murrine` on Debian, Ubuntu, etc.
- `bc` — build dependency

## Installation

### Manual Installation

Run the following commands in the terminal:

```sh
./install.sh
```

> Tip: `./install.sh` allows the following options:

```
-d, --dest DIR          Specify destination directory (Default: /usr/share/themes)
-n, --name NAME         Specify theme name (Default: Orchis)
-c, --color VARIANT...  Specify color variant(s) [standard|dark] (Default: All variants)
-h, --help              Show help
```

> For more information, run: `./install.sh --help`

### Firefox theme
[Intall Firefox theme](src/firefox)

![Firefox-theme](src/firefox/preview01.png?raw=true)
![Firefox-theme](src/firefox/preview02.png?raw=true)

## Preview
![1](preview.jpg?raw=true)
