# RPI-Setup

![Made with Perl](https://img.shields.io/badge/made%20with-perl-0.svg?color=cc2020&labelColor=ff3030&style=for-the-badge)

![GitHub](https://img.shields.io/github/license/DeBos99/rpi-setup.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub followers](https://img.shields.io/github/followers/DeBos99.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/DeBos99/rpi-setup.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub stars](https://img.shields.io/github/stars/DeBos99/rpi-setup.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub watchers](https://img.shields.io/github/watchers/DeBos99/rpi-setup.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub contributors](https://img.shields.io/github/contributors/DeBos99/rpi-setup.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)

![GitHub commit activity](https://img.shields.io/github/commit-activity/w/DeBos99/rpi-setup.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/DeBos99/rpi-setup.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/DeBos99/rpi-setup.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/DeBos99/rpi-setup.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)

![GitHub issues](https://img.shields.io/github/issues-raw/DeBos99/rpi-setup.svg?color=cc2020&labelColor=ff3030&style=for-the-badge)
![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/DeBos99/rpi-setup.svg?color=10aa10&labelColor=30ff30&style=for-the-badge)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=NH8JV53DSVDMY)

**RPI-Setup** is simple perl script for setting up Raspberry Pi.

## Content

- [Content](#content)
- [Features](#features)
- [Installation](#installation)
  - [Debian/Ubuntu](#apt)
  - [Arch Linux/Manjaro](#pacman)
  - [CentOS](#yum)
  - [MacOS](#homebrew)
- [Usage](#usage)
- [Documentation](#documentation)
  - [Required arguments](#required-arguments)
  - [Optional arguments](#optional-arguments)
- [Authors](#authors)
- [Contact](#contact)
- [License](#license)

## Features

* SSH configuration.
* Network configuration.
* Static IP configuration.

## Installation

### <a name="APT">Debian/Ubuntu based

* Run following commands in the terminal:
```
sudo apt install git perl -y
sudo cpan -Ti Term::ReadPassword
git clone "https://github.com/DeBos99/rpi-setup.git"
```

### <a name="Pacman">Arch Linux/Manjaro

* Run following commands in the terminal:
```
sudo pacman -S git perl --noconfirm
sudo cpan -Ti Term::ReadPassword
git clone "https://github.com/DeBos99/rpi-setup.git"
```

#### <a name="YUM">CentOS

* Run following commands in the terminal:
```
sudo yum install git perl -y
sudo cpan -Ti Term::ReadPassword
git clone "https://github.com/DeBos99/rpi-setup.git"
```

#### <a name="Homebrew">MacOS

* Run following commands in the terminal:
```
brew install git perl
sudo cpan -Ti Term::ReadPassword
git clone "https://github.com/DeBos99/rpi-setup.git"
```

## Usage

`perl main.pl ARGUMENTS`

## Documentation

### Required arguments

| Argument            | Description              |
| :------------------ | :----------------------- |
| -i, --image PATH    | Sets path to image file. |
| -d, --device DEVICE | Sets device.             |

### Optional arguments

| Argument                     | Description                      | Default value |
| :--------------------------- | :------------------------------- | :------------ |
| -h, --help                   | Shows help message and exits.    |               |
| -v, --version                | Shows version and exits.         |               |
| -S, --ssh                    | Enables SSH.                     | false         |
| -N, --network                | Enables network configuration.   | false         |
| -s, --ssid SSID              | Sets SSID.                       |               |
| -c, --country-code CODE      | Sets country code.               |               |
| -I, --static-ip              | Enables static IP configuration. | false         |
| --interface INTERFACE        | Sets interface.                  |               |
| --ip IP                      | Sets static IP.                  |               |
| -r, --routers IP             | Sets routers.                    |               |
| -d, --domain-name-servers IP | Sets domain name servers.        |               |
| -b, --block-size SIZE        | Sets block size.                 | 4M            |


## Authors

* **Michał Wróblewski** - Main Developer - [DeBos99](https://github.com/DeBos99)

## Contact

* Discord: DeBos#3292
* Reddit: [DeBos99](https://www.reddit.com/user/DeBos99)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
