# Minecraft Server (Spigot) Installer for Raspberry Pi and Other SBCs

This installer will setup a Minecraft Server running the latest version of Spigot.

If you have already installed this, running it again later will allow you to upgrade.

The installer will setup a "Normal" difficulty survival server with mobs, nether and more.


Buy Your Raspberry Pi (Or Other SBC)
====================================

This feature on Category5 Technology TV sponsored by ameriDroid.com

USA-based SBC sales with unmatched support and fast shipping

To power your Minecraft Server, get a Raspberry Pi 4 from https://ameridroid.com


Hardware Requirements
=====================

- Minimum 4 GB RAM
- GOOD Power Supply
- Adequate Cooling for Overclock During Heavy Load
- Reliable Storage Media (Kingston Endurance microSD or UASP-enabled USB 3 SSD)


Overclocking
============

If your board is supported, this script will automatically set overclock settings to maximize performance.

Therefore, you must absolutely ensure your power supply is a good one. We'll be using a bit more power than normal.

You are welcome to adjust the overclock settings if desired. However, I would recommend trying my defaults first.

I have chosen to be conservative with my overclocking for two reasons:

1) I want you to get the best performance out of your Minecraft server, but also wish to ensure it is stable.
2) I do not want to void your warranty. I.E., I will NOT enable force_turbo.
3) I do not wish to damage your Pi.

When I overwrite your /boot/config.txt file, I first create a backup of your original at /boot/config-DATETIME.txt, so if you're unable to boot for some reason, hopefully you can easily recover. Note that you are running this script at your own risk, and I am not responsible for anything that happens as a result of your running this installer. Except smiles. I'll accept responsibility for smiles.


Usage
=====

`sudo ./install username`

Where username is the Linux user you'd like to run the Minecraft server.

Example:

`sudo ./install pi`


Post-Install Scripts
====================

## ~/minecraft/server
Start the Minecraft server. This script is automatically run upon boot.

## ~/minecraft/reboot
When you need to reboot your Minecraft server, you must do so safely, otherwise all blocks that are stored in RAM will be lost (could be a full day's worth). Run this script to shutdown the Minecraft server software, store all blocks, and reboot the server. Note: It can easily take 15-20 minutes to stop the Minecraft server. Don't abort once you run this script. It is working hard to save all the blocks for your world and if you stop it or force a reboot, you will lose blocks.
