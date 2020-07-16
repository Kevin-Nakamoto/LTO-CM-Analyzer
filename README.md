# LTO-CM-Analyzer
This is an open-source project for LTO ([Linear Tape-Open](https://en.wikipedia.org/wiki/Linear_Tape-Open)) tape Cartridge Memory (CM) Analyzer

## Description
This is a Linux bash script which aims to convert LTO-CM dump data to human-readable cartridge information. In order to dump memory data from LTO-CM tag, also called MAM (Media Auxiliary Memory), you should use RFID reader device which supports LTO-CM tag. Currently, [Proxmark3](http://www.proxmark.org/) is able to read raw data from the tag and save it to file. You can also check [Proxmark3 Github repository](https://github.com/RfidResearchGroup/proxmark3) or [Proxmark3 developers community](http://www.proxmark.org/forum/index.php) for more information.

## Motivation
There are several LTO CM reader/analyzer in the market. These are proprietary solutions and they are only supported on Windows. By combining with OSS-based RFID equipment which is able to dump data from LTO CM tag, this script allows us to convert dump data to human-readable format.

## Demo

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/KaA23S3oPio/0.jpg)](https://www.youtube.com/watch?v=KaA23S3oPio)

~~~
$ ./lto_analyzer.sh  lto-cm_dump.eml
-- LTO CM Manufacturer's Information --
  LTO CM Serial Number: xxxxxxxx
  CM Serial Number Check Byte: xx
  CM Size: xx
  Type: xxxx
  Manufacturer's Information: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-- LTO CM Write-Inhibit --
  Last Write-Inhibited Block Number: xx
  Block 1 Protection Flag: xx
  Reserved: xxxx
-- Cartridge Manufacturer's Information --
  Page Id: xxxx
  Page Length: xxxx
  Cartridge Manufacturer: xxxxxx
  Serial Number: xxxxxxxx
  Cartridge Type: xxxx
  Date of Manufacture: xxxxxxxx
  Tape Length: xxxx
  Tape Thickness: xxxx
  Empty Reel Inertia: xxxx
  Hub Radius: xxxx
  Full Reel Pack Radius: xxxx
  Maximum Media Speed: xxxx
  License Code: xxxxxxxx
  Cartridge Manufacturer's Use: xxxxxxxxxxxxxxxxxxxxxxxx
  CRC: xxxxxxxx
-- Media Manufacturer's Information --
  Page Id: xxxx
  Page Length: xxxx
  Servowriter Manufacturer: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Reserved: xxxxxxxxxxxxxxxx
  CRC: xxxxxxxx
~~~

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
First, you need to dump data from the cartridge memory and save it to file with Proxmark.
~~~
$ hf lto dump
~~~

Run this script along with file path to the dump data.
~~~
$ lto_analyzer.sh [*.eml or *.bin] 
~~~

## Install
No need to install. Just run the script. You may want to change file permission by chmod.

## Limitations
Since this script is based on [LTO-1 specification](https://www.ecma-international.org/publications/files/ECMA-ST/ECMA-319.pdf), the script may return wrong cartridge information especially for modern LTO generations such as LTO-4, LTO-5 etc..

## License
[MIT](https://github.com/Kevin-Nakamoto/LTO-CM-Analyzer/blob/master/LICENSE)

## Author
[Kevin Nakamoto](https://github.com/Kevin-Nakamoto)

## Reference
- [Cartridge memory](https://en.wikipedia.org/wiki/Linear_Tape-Open#Cartridge_memory) Wikipedia
- [LTO-1 Specification](https://www.ecma-international.org/publications/files/ECMA-ST/ECMA-319.pdf) published from [ECMA](https://www.ecma-international.org/)
- [How to dump LTO CM manually](http://www.proxmark.org/forum/viewtopic.php?id=2686) Proxmark3 developers community
