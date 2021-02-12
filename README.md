# Pinecraft

## Minecraft Server Installer for Raspberry Pi 4 and Other SBCs such a PINE64, ODROID and more

This installer will setup a Minecraft Server running the latest version of Spigot.

If you have already installed this, running it again later will allow you to upgrade.

The installer will setup a "Normal" difficulty survival server with mobs, nether and more.

The installer attempts to detect things like how much RAM you have (and available), and adjusts the server settings based on what it finds.

Check out Pinecraft 1.0 on Category5 Technology TV:

[![Pinecraft Installer 1.0 Featured on Category5 Technology TV](https://img.youtube.com/vi/-8-7fQmhn2k/0.jpg)](https://www.youtube.com/watch?v=-8-7fQmhn2k)


Pinecraft Installer 1.0 Featured on ameriBlog: https://ameridroid.com/blogs/ameriblogs/raspberry-pi-4-as-a-multiplayer-minecraft-server


Current Server Info
===================

Pinecraft is brand new, and is currently celebrating the release of version 1.0. There are plans for enhancements, and we welcome feature requests and feedback.

Currently Pinecraft rolls out a fully configured Spigot installation. We've been getting some excellent feedback since publishing our first video about Pinecraft, and there are now plans to integrate other Minecraft servers. Star and Watch this repository to get updates when version 2.0 comes out.

The current version of Pinecraft deploys a survival server. A future update will allow you to select between various gamemodes, including survival, creative, adventure and hardcore.


Buy Your Raspberry Pi (Or Other SBC)
====================================

This feature on Category5 Technology TV sponsored by ameriDroid.com

USA-based SBC sales with unmatched support and fast shipping

To power your Minecraft Server, get a Raspberry Pi 4 from https://ameridroid.com


Hardware Requirements
=====================

- A vanilla server OS based on Debian (such as Raspberry Pi OS Lite) with nothing else running and no desktop environment.
- If your board has more than 4 GB RAM, you must use a 64-Bit OS to utilize it effectively. Running a 32-bit OS will result in less RAM dedicated to your Minecraft Server.
- Minimum 4 GB RAM.
- GOOD Power Supply.
- Adequate Cooling for Overclock During Heavy Load.
- Reliable Storage Media (Kingston Endurance microSD or UASP-enabled USB 3 SSD).
- Ethernet connection to network (don't use Wi-Fi).



Software Requirements
=====================

- To play the game, you will need a valid Minecraft Java account, and to have Minecraft Java installed on your computer (Windows, Mac, AMD64 Linux). One account is required per player, and can be purchased from https://minecraft.net
- Debian-based headless server distro for your single board computer. For a Raspberry Pi 4, opt for Raspberry Pi OS Lite.

**Note:** You do not need a Minecraft Java account in order to run the server. I.E., you could boot up a Pinecraft server even without an account, and players with accounts can use it. However, it is quite handy to be able to sign in the game to moderate disputes or deal with grief. This can only be done if you have an account.


License
=======

This project (Pinecraft, the install script) is free, open source software. However, Minecraft itself is not (hence why we are distributing an installer, not a pre-compiled distro). In order to use your Minecraft server, you must first accept the Minecraft EULA found here: https://account.mojang.com/documents/minecraft_eula

Of course, other projects utilized for Pinecraft carry other licenses (such as Java, Spigot, etc.). Ours is just an installer / configuration tool and we are not distributing any software.


Note About Backups
==================

Please consider automating a backup of your world. You can first stop the server with the provided `stop` script, then run your backup, and then restart your server with the provided `server` script.


Automated Overclocking
======================

If your board is supported and tested by me, the installer will automatically set overclock settings to maximize performance.

Therefore, you must absolutely ensure your power supply is a good one. We'll be using a bit more power than normal.

You are welcome to adjust the overclock settings if desired. However, I would recommend trying my defaults first.

I have chosen to be conservative with my overclocking for two reasons:

1) I want you to get the best possible performance out of your Minecraft server, but also wish to ensure it is rock-solid stable.
2) I do not want to void your warranty. I.E., I will NOT enable force_turbo.
3) I do not wish to damage your Pi.

When I overwrite your /boot/config.txt file, I first create a backup of your original at /boot/config-DATETIME.txt, so if you're unable to boot for some reason, hopefully you can easily recover. Note that you are running this script at your own risk, and I am not responsible for anything that happens as a result of your running this installer. Except smiles. I'll accept responsibility for smiles.


Usage
=====

Run the installer immediately following a fresh reboot (to avoid having residual apps taking up RAM thereby resulting in less RAM allocated to your game server).

The command is simple:

`sudo ./install username`

`username` is the Linux user you'd like to run the Minecraft server.

Example:

`sudo ./install pi`

### Important Note: First Boot

On first boot, your Minecraft Server will generate the world. This can take around 10 minutes, so hang tight while this happens, and then connect to your Minecraft Server's IP address from Minecraft Java as soon as it is ready. You can tail the log file if you'd like to see the progress, or sipmly retry connecting via Minecraft Java after a few minutes.

Post-Install Scripts
====================

### ~/minecraft/server
Start the Minecraft server. This script is automatically run upon boot.

### ~/minecraft/reboot
When you need to reboot your Minecraft server, you must do so safely, otherwise all blocks that are stored in RAM will be lost (could be a full day's worth). Run this script to shutdown the Minecraft server software, store all blocks, and reboot the server. Note: It can easily take 15-20 minutes to stop the Minecraft server. Don't abort once you run this script. It is working hard to save all the blocks for your world and if you stop it or force a reboot, you will lose blocks.

### ~/minecraft/stop
Safely stop your Minecraft server. DO NOT reboot your system or power off unless you have first run this script and allowed it to complete.


Networking
==========

Your Minecraft server runs on port 25565. If you'd like others to be able to join your server, forward that port to your Minecraft server in your firewall.

Within your LAN, you can access your Minecraft server by the IP address of your Raspberry Pi Minecraft server.

**Note:** If you open up your server to the world you introduce the risk of someone connecting and griefing (damaging your builds). To protect your server world, either limit the logins to specific users (see Minecraft documentation), restrict your firewall to only allow trusted IPs that you specify (see your networking documentation) or if you truly want it to be a public server, add some mods to protect your world (see Spigot documentation).

Log Files
=========

### ~/minecraft/logs/latest.log
The current Minecraft Server log file. You can run `tail -f ~/minecraft/logs/latest.log` on your Minecraft Server to see what's happening. Logs are rotated and gzipped by date.


Troubleshooting
===============

### Server gets killed by Linux
Try `dmesg -T| grep -E -i -B100 'killed process'` after this happens to see why Linux killed the process. It is most likely you are running other applications on your system (which is a big no-no) and have run out of resources. You should only run this on a completely headless SBC, with no desktop environment, and nothing else running. You can adjust the amount of RAM allocated by editing the `server` script in ~/minecraft

### Overclock says N/A
The type of hardware you're using hasn't been tested by me, and I haven't added automatic overclocking for your board. You'll need to perform your own overclocking. If you do so successfully, please let me know what you had to do, and if I can test it, I may add it to a future update.

Post-Install Configuration
==========================

Give your Minecraft server a try before you start changing the config. It's very possible to break things if you modify the config, so it's a good start to test your server first, and then just tweak what's needed / desired.

You'll find your config file here: ~/minecraft/server.properties

Mojang Documentation: https://minecraft.gamepedia.com/Server.properties#Java_Edition_3
