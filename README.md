# LTO-CM-Analyzer
LTO ([Linear Tape-Open](https://en.wikipedia.org/wiki/Linear_Tape-Open)) tape Cartridge Memory (CM) Analyzer

## Description
Linux bash script which converts LTO-CM binary data to human-readable cartridge information. To dump memory data from LTO-CM tag (also called MAM (Media Auxiliary Memory)), use RFID reader. Currently, RFID readers such as [ACR122U](https://www.acs.com.hk/en/products/3/acr122u-usb-nfc-reader/), [SCL3711](https://www.identiv.com/products/logical-access-control/smart-card-readers/mobile/scl3711/) and [Proxmark3](http://www.proxmark.org/) are able to dump data from the tag and save it to file. You can also use tape drive to do this. Check the following repos and websites for more information:

- RFID Reader: [nfc-ltocm](https://github.com/philpem/nfc-ltocm/) by [Phil Pemberton](https://github.com/philpem)
- RFID Reader: [Proxmark3 Github repository](https://github.com/RfidResearchGroup/proxmark3) by [RfidResearchGroup](https://github.com/RfidResearchGroup)
- Tape Drive: [SCSI READ BUFFER](https://render-prd-trops.events.ibm.com/sites/default/files/support/ssg/ssgdocs.nsf/0/4d430d4b4e1f09b18525787300607b1d/%24FILE/LTO%20SCSI%20Reference%20%28EXTERNAL%20-%2020171024%29.pdf)

## Motivation
There are several LTO CM reader/analyzer in the market, however, these are proprietary solutions and they support Windows only. 

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
Feed binary data to this script.
~~~
$ lto_analyzer.sh [*.eml or *.bin] 
~~~

## Install
Just run the script. You may want to change file permission by chmod.

## Limitations
Since this script is based on [LTO-1 specification](https://www.ecma-international.org/publications/files/ECMA-ST/ECMA-319.pdf), it may show wrong cartridge information for modern generations. Indeed, some parameters are not decoded correctly. See this [issue](https://github.com/Kevin-Nakamoto/LTO-CM-Analyzer/issues/2).

## License
[MIT](https://github.com/Kevin-Nakamoto/LTO-CM-Analyzer/blob/master/LICENSE)

## Author
[Kevin Nakamoto](https://github.com/Kevin-Nakamoto)

## Reference
- [Cartridge memory](https://en.wikipedia.org/wiki/Linear_Tape-Open#Cartridge_memory) Wikipedia
- [LTO-1 Specification](https://www.ecma-international.org/publications/files/ECMA-ST/ECMA-319.pdf) published from [ECMA](https://www.ecma-international.org/)
- [How to dump LTO CM manually](http://www.proxmark.org/forum/viewtopic.php?id=2686) Proxmark3 developers community
- [Reading LTO-CM tape RFID](https://forum.dangerousthings.com/t/reading-lto-cm-tape-rfid) Dangerous Things Forum
- [libnfc](https://github.com/nfc-tools/libnfc)
