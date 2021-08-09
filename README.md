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
- `sassc` — build dependency

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
-t, --theme VARIANT...  Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|grey] (Default: blue)
-c, --color VARIANT...  Specify color variant(s) [standard|light|dark] (Default: All variants)
--tweaks                Specify versions for tweaks [solid|compact|black] (Options can mix use)
                        1. solid:    no transparency panel variant
                        2. compact:  no floating panel variant
                        3. black:    full black variant
                        4. primary:  Change radio icon checked color to primary theme color (Default is Green)
-h, --help              Show help
```

> For more information, run: `./install.sh --help`

![1](images/tweaks-view.png?raw=true)

### Flatpak Installation

Automatically install your host GTK+ theme as a Flatpak. Use this:

- [pakitheme](https://github.com/refi64/pakitheme)

### On Snapcraft

<a href="https://snapcraft.io/orchis-themes">
<img alt="Get it from the Snap Store" src="https://snapcraft.io/static/images/badges/en/snap-store-black.svg" />
</a>

You can install the theme from the Snap Store оr by running:

```
sudo snap install orchis-themes
```
To connect the theme to an app run:
```
sudo snap connect [other snap]:gtk-3-themes orchis-themes:gtk-3-themes
```
To connect the theme to all apps which have available plugs to gtk-common-themes you can run:
```
for i in $(snap connections | grep gtk-common-themes:gtk-3-themes | awk '{print $2}'); do sudo snap connect $i orchis-themes:gtk-3-themes; done
```

### Firefox theme
[Install Firefox theme](src/firefox)

![Firefox-theme](src/firefox/preview01.png?raw=true)
![Firefox-theme](src/firefox/preview02.png?raw=true)

### Fix for Dash to panel
Go to `src/gnome-shell/extensions/dash-to-panel` [dash-to-panel](src/gnome-shell/extensions/dash-to-panel) run the following commands in the terminal:

```sh
./install.sh
```

## Preview
![1](images/preview.jpg?raw=true)
