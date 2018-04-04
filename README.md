<p align="center">
<a href="https://twitter.com/Studisys">
  <img width="300" height="82" src="https://studisys.net/github/projects/studisys-logo-inline-dark.png"></a>
  <br/><br/>
  <img  src="https://studisys.net/github/projects/Simple-Windows-Image-Splitter-Merger/1.png"></a>
  <br/>
 </p>
 
----------
# Welcome to the Simple Windows Image Splitter / Merger <br/>(WIM/ESD <-> SWM) !
<p align="center">

**Current Script Version**<br/>0.5.0-beta

**Current Provided DISM Version in this Repository**<br/>10.0.17120.1000
</p>

<p align="center">
<a href="https://twitter.com/Studisys">
  <img  src="https://studisys.net/github/projects/Simple-Windows-Image-Splitter-Merger/2.png"></a>
  <br/>
 </p>
 
 <p>
This tool allows you to quickly split WIM/ESD Images into multiple SWM Images, but also merging SWM Images into single WIM/ESD Images.
<br/>
If you need to install Windows from multiple CDs or DVDs, this is tool is for you.
  <br/>
If you need to merge SWM images back into a single WIM or ESD Image, this tool is also for you.
 </p>




## Compatibility
This script only works on Windows systems.
This script is currently ***only*** tested on **Windows 10**.
It was last tested on ***Windows 10 Education Insider Preview Build 17634 (Skip Ahead)***
It will soon be tested on Windows Vista, 7, 8, 8.1, and Windows Server 2008 (R2), 2012 (R2), 2016.

# How to Use

1. Download both the script (`Simple-Windows-Image-Splitter-Merger.bat`) and DISM folder, containing the DISM tools
**IMPORTANT :** This tool does not currently support 'already-installed' DISM in the way that It can't detect yet the path to an installed DISM. The DISM tool and it's dependicies must be placed in a `DISM` folder located in the same folder as the batch file.

 2. Run the script ***`Simple-Windows-Image-Splitter-Merger.bat`*****as Administrator**.<br/>
 ***Note :*** If you didn't run the script as Administrator, you will be prompted for Administrator rights. You must grant Administrator rights because they are required for DISM to work.
 - Follow the steps shown in the script :
	3) Select the type of conversion you want
		-  `1` for WIM to SWM
		- `2` for ESD to SWM
		- `3` for SWM to WIM
		- `4` for SWM to ESD
	4) Enter the path to the Source Image
		- Please enter the full path to the Image, including filename and file extension, without quotes, even if it has spaces in it 

**NOTE :**  If your source image is a SWM file, you will have to enter the path to the "pattern SWM Image" in the next step (that is some sort of "4Bis" step).
The pattern SWM Image has an asterisk `*`at the end of the filename, but before the file extension (ex: `install*.swm`). You will have to enter the same pattern as the source SWM Image.

Example : If the path to your source SWM Image is : 

    C:\Users\Studisys\Downloads\Image\install.swm

You will have to enter :
  

    C:\Users\Studisys\Downloads\Image\install*.swm

5) Enter the path to the Destination Image
		- Please enter the full path to the Image, including filename and extension, without quotes, even if it has spaces in it



	6) Choose if you want to change the type of Image Compression (only if you chose to convert from SWM to WIM or ESD).

		 - `1` -> None :  No Compression (Fastest) [Destination Image bigger than Source Image]
		 - `2` -> Fast :  Low Compression (Fast) [Destination Image 'may' be bigger than Source Image]
		 - `3` -> Maximum :  Very High Compression (Slow) [Destination Image WAY smaller than Source Image]
		 - `4` -> Recovery :  Insane Compression (Slowest) [Destination Image WAY smaller than Source Image]

	7) Select an option :
		- `1` to export a single Index
			- Enter the Index number you want to export
		- `2` to export all indexes

(these are the options available with the version 0.5.0-beta from April 4th 2018)

8. Validate and let the fun begin.



# Demo
Here is an actual demo.
I decide to use the provided files.
I will merge SWM Images into a WIM Image.
All indexes will be exported (No compression will be used, but this will make a heavier image)
The SWM Images will be located in the same folder as the Batch script, and the WIM Image will be saved in the same folder.


Here is the result :

<p align="center">
<a href="https://blog.studisys.net">
<img  src="https://studisys.net/github/projects/Simple-Windows-Image-Splitter-Merger/3.gif"></a>
  <br/>
 </p>
 



# Important Notes
## Practical Notes
### Administrator-rights
 - This script ***requires*** Administrator rights to run

### Existing Destination File
- If the specified destination image already exists, it will be deleted once the extraction has begun.



# More about this project

  
  

## Origin

This tool is part of a much-bigger project which will help manage and customize Windows Installation Images and files. <br/>
As I was playing with the Windows Image installation files and DISM, I wondered if it was possible to easily convert WIM or ESD images into multiple SWM images, and vice-versa, I wanted to create an easy-to-use script to automate the process.
  
## Upcoming features


- Allow to detect current Windows ADK installation to use preinstalled files
- Add an unattended mode (no interaction with user, allows for automated tasks)
- Add the possibility of choosing single or multiple Index range(s)
- Add the possibility of choosing specific but multiple indexes
 - Add more verifications on user input to prevent bugs due to wrong-formed values entered by the user

## Modifications


### This script creates :

- %temp%\\\GetAdminRights.vbs

	- For the Administrator Rights if script was not run as Administrator

- An ESD or WIM Image, which name and directory are provided by the user or let to default, in the same folder as the script (SWM to WIM or ESD)
- An SWM Image and it's associated images, which name and directory are provided by the user or let to default, in the same folder as the script (WIM or ESD to SWM)



### This script runs :

- %temp%\\\GetAdminRights.vbs

	- Run cmd.exe as admin if the script was not executed as it

- %systemroot%\\system32\\cmd.exe

	- Runs as admin to operate if necessary

- /DISM/dism.exe
	- The Deployment Image Servicing and Management tool, required to convert WIM images to ESD and vice-versa


## Versioning

I'm tyring to keep versioning as clean as possible. Here is the system I'm using :

  

- 3-digit version [Major].[Beta].[Alpha]

- [Major] : number of the stable version

- [Beta] : number of the Beta version (number of bugs greatly reduced comparing to the Alpha version)

- [Alpha] : number of the Alpha version (highest number of bugs, features not properly working)

  

## Changelog

A changelog can be found [here](https://github.com/Studisys/Simple-Windows-Image-Splitter-Merger/blob/master/CHANGELOG).

  

## License [<img src="https://img.shields.io/badge/license-AGPL 3.0-blue.svg">](https://github.com/Studisys/Simple-Windows-Image-Splitter-Merger/blob/master/LICENSE)

This project is licensed under the AGPL 3.0 License.

The license file can be viewed [here](https://github.com/Studisys/Simple-Windows-Image-Splitter-Merger/blob/master/LICENSE).

Here are the great lines to remember of this license :

 - <img src="https://img.shields.io/badge/Commercial%20use%20:-Allowed-brightgreen.svg">
  - <img src="https://img.shields.io/badge/Distribution%20:-Allowed-brightgreen.svg">
  - <img  src="https://img.shields.io/badge/Modification%20:-Allowed-brightgreen.svg">
  - <img  src="https://img.shields.io/badge/Patent%20use%20:-Allowed-brightgreen.svg">
  - <img  src="https://img.shields.io/badge/Private%20use%20:-Allowed-brightgreen.svg">
 - <img  src="https://img.shields.io/badge/Disclose%20source%20:-Mandatory-blue.svg">
- <img  src="https://img.shields.io/badge/License%20and%20copyright%20notice%20:-Mandatory-blue.svg">
- <img  src="https://img.shields.io/badge/Network%20use%20is%20distribution%20:-Mandatory-blue.svg">
- <img  src="https://img.shields.io/badge/Same%20license%20:-Mandatory-blue.svg">
- <img  src="https://img.shields.io/badge/State%20changes%20:-Mandatory-blue.svg">
- <img  src="https://img.shields.io/badge/Liability%20:-None-red.svg">
- <img  src="https://img.shields.io/badge/Warranty%20:-None-red.svg">

## Contact and useful links

Thanks for browsing through this project !

Here a few links on how to reach me and/or find me online :

  
   - Twitter :  https://twitter.com/Studisys
   
   - LinkedIn :  https://linkedin.com/in/joel-didier
   
   - Email : studisys@protonmail.com

