# LTO-CM-Analyzer
This is an open-source project for LTO([Linear Tape-Open](https://en.wikipedia.org/wiki/Linear_Tape-Open)) Cartridge Memory (CM) Analyzer

## Description
This is a Linux bash script which aims to convert LTO-CM dump data to human-readable cartridge information. In order to dump memory data from LTO-CM tag, you should use RFID reader device which supports LTO-CM tag. Currently, [Proxmark3](http://www.proxmark.org/) is able to read raw data from the tag and save it to file. You can also check [Proxmark3 Github repository](https://github.com/Proxmark/proxmark3) or [Proxmark3 developers community](http://www.proxmark.org/forum/index.php) for more information.

## Requirement
- [Proxmark3](http://www.proxmark.org/) to dump data from LTO-CM tag.
- Linux or [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to run this script.
- bc (Basic Calculator) command line utility.
~~~
$ sudo apt install bc	#Debian and Ubuntu
$ sudo yum install bc	#RHEL and CentOS
$ sudo dnf install bc	#Fedora
~~~

## Supported LTO CM Data Fields
- LTO CM Manufacturer's Information
- LTO CM Write-Inhibit
- Cartridge Manufacturer's Information
- Media Manufacturer's Information
- Initialisation Data
- Tape Write Pass
- Tape Directory
- EOD Information
- Cartridge Status and Tape Alert Flags
- Mechanism Related
- Suspended Append Writes
- Usage Information 0 to 3
- Application Specific

## Usage
Run this script along with file path to dump data.
~~~
$ lto_analyzer.sh [*.eml]
~~~

## Install
No need to install. Just run the script. You may want to change file permission by chmod.

## Limitations
Since this script is based on [LTO-1 specification](https://www.ecma-international.org/publications/files/ECMA-ST/ECMA-319.pdf), the script may return wrong cartridge information especially for modern LTO generations such as LTO-4, LTO-5 etc..

## License
MIT

## Author
[Kevin Nakamoto](https://github.com/Kevin-Nakamoto)

## Reference
- [Cartridge memory](https://en.wikipedia.org/wiki/Linear_Tape-Open#Cartridge_memory) Wikipedia
- [LTO-1 Specification](https://www.ecma-international.org/publications/files/ECMA-ST/ECMA-319.pdf) published from [ECMA](https://www.ecma-international.org/)
