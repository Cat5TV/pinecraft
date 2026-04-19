![Pinecraft](assets/pinecraft-logo.png?raw=true)

[![Discord](https://img.shields.io/discord/495592877728989194?logo=discord)](https://discord.gg/dKz5RYc) [![Youtube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=youtube&logoColor=white)](https://www.youtube.com/LinuxTechShow) [![Twitter URL](https://img.shields.io/twitter/follow/category5tv?style=flat-square&logo=twitter)](https://twitter.com/category5tv)

## Minecraft Java Server Installer for Raspberry Pi

This installer simplifies the installation, setup and optimization of a Minecraft Java Server.

If you have already installed this, running it again will allow you to upgrade the installed Minecraft version, or switch to a different flavor.

[![Support Me on Patreon](https://cdn.zecheriah.com/img/patreon_button.png)](https://patreon.com/pinecraft)

## About Pinecraft Installer

The installer will setup a "Normal" difficulty server and allow you to select between a Survival world complete with mobs, nether and more, a Creative world to hone your skills as a master builder, or an Adventure world to explore.

The installer attempts to detect things like how much RAM you have (and available), and adjusts the server settings based on what it finds.

**Looking For Help?** Pinecraft Installer *installs* Minecraft Java servers. If your question has to do with something other than *installing* a Minecraft server with Pinecraft Installer, the question likely is not for us. Questions surrounding gameplay, how to use a Minecraft server, etc., should be directed to [The Minecraft Wiki](https://minecraft.wiki/w/Tutorials/Setting_up_a_server). Once your Minecraft server is installed, Pinecraft's job is done.

## Monitor Your Pinecraft Server

[NEMS Linux](https://nemslinux.com/) is an Enterprise-grade asset monitoring tool created by Robbie Ferguson (the creator of Pinecraft Installer) which includes [check_minecraft](https://docs.nemslinux.com/en/latest/check_commands/check_minecraft.html) to monitor your Pinecraft server.

Download [NEMS Linux](https://nemslinux.com/) today.

## Install Pinecraft Server


## Available Releases

Pinecraft Installer allows you to install any available version of Minecraft for each server type.

**Note:** Selecting a seed will restrict your available Minecraft version to that which is compatible with the seed.

Always keep an up-to-date backup of your world files.

## Videos

Check out Pinecraft 2.6 on Category5 Technology TV:

**Pinecraft Installer 2.6 Featured on Category5 Technology TV**

[![Pinecraft Installer 2.6 Featured on Category5 Technology TV](https://img.youtube.com/vi/1A4FtaiNkrg/0.jpg)](https://www.youtube.com/watch?v=1A4FtaiNkrg)

**Top 5 Pinecraft Questions Post-Install**

[![Top 5 Pinecraft Questions Post-Install on Category5 Technology TV](https://img.youtube.com/vi/4YgS5M4t_Qg/0.jpg)](https://www.youtube.com/watch?v=4YgS5M4t_Qg)


Pinecraft Installer 1.0 was also featured on ameriBlog: https://ameridroid.com/blogs/ameriblogs/raspberry-pi-4-as-a-multiplayer-minecraft-server

The current version of Pinecraft Installer is 4.1.

![Screenshot of Pinecraft Installer 2.0](assets/pinecraft-2.0.png?raw=true)


Hardware Requirements
=====================

- A vanilla server OS based on Debian stable (such as Debian, Ubuntu Server, or Raspberry Pi OS Lite) with nothing else running and no desktop environment.
- You must use a 64-Bit OS to utilize your RAM effectively. Running a 32-bit OS will result in less RAM dedicated to your Minecraft Server.
- Minimum 8 GB RAM.
- GOOD Power Supply.
- Adequate Cooling for Overclock During Heavy Load.
- Reliable and FAST SSD Storage Media.
- Ethernet connection to network (don't use Wi-Fi).


Base OS (Distro)
================

**Do not use Pinecraft Installer on a Base OS that contains a desktop environment, or any other running applications.** Pinecraft Installer is intended to setup a *dedicated* Minecraft Java server, and the device should be used for nothing else.

**NEVER install Pinecraft on your desktop system. This is a dedicated server. That means once you install it, the system is no longer useable for anything else.**


Supported Base OS
-----------------

**Debian Requirement**

Pinecraft Installer is designed to build a Minecraft server on a Debian-based Linux base OS. This includes Debian Stable, Ubuntu, or Raspberry Pi OS (for example). You'll want to use the latest stable version, and continue to keep it up-to-date to be compatible with current versions of Minecraft.

**Single Board Computers**

If installing your Pinecraft Server on a single board computer, it must meet the minimum system requirements. For example, a Raspberry Pi 4 or 5 that has 8GB RAM or higher.

With Pinecraft 4.0, a Pinecraft Base OS was provided to help ease deployment on Raspberry Pi. With Pinecraft 5.0+ this is no longer required.


Buy a Single Board Computer for Pinecraft Server
================================================

Visit [![ameriDroid](assets/ameridroid.png?raw=true)](https://ameridroid.com) to purchase a single board computer for your Pinecraft Server. Make sure it meets or exceeds the system requirements above.

ameriDroid provides USA-based SBC sales with unmatched support and fast worldwide shipping.


Software Requirements
=====================

- To play the game, you will need a valid Minecraft Java account, and to have the Minecraft Java client installed on your computer. One account is required per player, and can be purchased from https://minecraft.net/
- Your Pinecraft Server will require the Base OS as detailed above.

**Note:** You do not need a Minecraft Java account in order to run a Pinecraft Server. I.e., you could boot up a Pinecraft Server even without an account, and players with accounts can use it. However, it is quite handy to be able to sign in the game to moderate disputes or deal with grief. This can only be done if you have an account.


Server Flavors
==============

# Server Flavors

Pinecraft supports several different Minecraft server flavors, each with its own strengths. Some focus on maximum performance, some support plugins or mods, and others are designed to run on extremely low-powered hardware.

---

## Vanilla

**Official Mojang Server**
**Build Time:** Fast
**Supports:** No plugins or mods

Vanilla is the official Minecraft server released by Mojang. It provides the pure, unmodified Minecraft experience.

While it is not as optimized for single-board computers as some other flavors, it runs well on a Raspberry Pi 4 with 4GB RAM or greater.

[More Information](https://minecraft.net)

---

## Paper

**Performance Optimized / Plugin Support**
**Build Time:** Fast
**Supports:** Bukkit / Spigot / Paper plugins

Paper is a high-performance Minecraft server based on Spigot. It is fully compatible with most Spigot plugins while offering better performance and additional features.

Paper is an excellent choice for most servers and is recommended if you want strong plugin support with fast startup times.

[More Information](https://papermc.io/)

---

## Purpur

**Enhanced Paper-Based Server / Extensive Customization**
**Build Time:** Fast
**Supports:** Bukkit / Spigot / Paper / Purpur plugins

Purpur is based on Paper and includes all Paper features, while adding a large number of optional gameplay tweaks, configuration options, and quality-of-life improvements.

Purpur is ideal if you want the performance of Paper but with additional control over gameplay and server behavior.

[More Information](https://purpurmc.org/)

---

## Fabric

**Lightweight / Modular / Mod Support**
**Build Time:** Fast
**Supports:** Fabric mods

Fabric is a lightweight, modular Minecraft server platform with very fast startup and update times. It is commonly used for modern modded Minecraft servers.

Most Fabric mods also require the Fabric API, so Pinecraft Installer automatically installs this as well. [NOT YET; coming soon]

[More Information](https://fabricmc.net/)

---

## Forge

**Traditional Modded Minecraft Server**
**Build Time:** Fast
**Supports:** Forge mods

Forge is the long-standing standard platform for heavily modded Minecraft servers. Many large modpacks and older mod collections are built around Forge.

Choose Forge if you plan to run a traditional modded server or a modpack designed specifically for Forge.

[More Information](https://files.minecraftforge.net/net/minecraftforge/forge/)

---

## Spigot

**Plugin Support / Legacy Favorite**
**Build Time:** Slow
**Supports:** Bukkit / CraftBukkit / Spigot plugins

Spigot is an optimized Minecraft server based on CraftBukkit. It supports a large ecosystem of plugins and was the original default server flavor used by Pinecraft in the 1.x era.

Spigot can run very well on a Raspberry Pi 4 with 4GB or higher, and remains a solid choice for plugin-based servers.

[More Information](https://www.spigotmc.org/)

---

## Cuberite

**Experimental / Extremely Lightweight**
**Build Time:** Slow
**Supports:** Limited plugin support

Cuberite is an alternate Minecraft-compatible server written in C++. Unlike the other server flavors, it is designed to run on extremely low-powered hardware.

Cuberite currently supports clients up to Minecraft 1.12.2, so players must use an older client version to connect.

Its main advantage is that it can run on devices that would struggle to run any Java-based Minecraft server, including older Raspberry Pi models.

> Note: Cuberite is currently considered experimental within Pinecraft.

[More Information](https://cuberite.org/)


Game Modes
==========

**Survival**

Players must collect resources, build structures, battle mobs, eat, and explore the world in an effort to thrive and survive.


**Creative**

Creative mode strips away the survival aspects of Minecraft and allows players to easily create and destroy structures and mechanisms with the inclusion of an infinite use of blocks and flying.

**Adventure**

Adventure mode lets you and your family/friends run around and explore, but you can't place or break blocks.


Plugin Support
==============

For any of the server flavors which support plugins, simply place the plugin ZIP file in /srv/pinecraft/server/plugins/ and then run `systemctl restart pinecraft`

Remember, adding plugins can have a negative impact on your server performance. Some plugins may also introduce bugs, glitches or other issues. Be selective about which plugins you add to your server, and obtain support from the plugin developers and their community.

You can download plugins from https://www.spigotmc.org/resources/ or any other Bukkit / Spigot plugin resource.


Level Seeds
===========

During installation, you can choose from one of our provided level seeds, use your own, or generate a new random seed.

See the complete list of currently included seeds in `./lib/seeds.json`

Here are details about some of the included seeds:

**Category5 TV RPi Server** [via Category5 Technology TV](https://cat5.tv/minecraft)

Complete with the mystical floating tree at spawn! Head North West to -396 ~ 148 to [find the town nether portal](https://youtu.be/-8-7fQmhn2k?t=824), which takes only a little work to get up and running.

**Jeff's Tutorial World** [via Category5 Technology TV](https://cat5.tv/minecraft)

The world used in Jeff's tutorials such as [Easy XP and Loot with Minecraft Zombie Grinder XP Farm NO REDSTONE](https://youtu.be/5b570XG0pf4) and [Trading Hack: Giving Villagers a Job in Minecraft - Villager Professions](https://youtu.be/NJ4aaOQHqhM)

**All Biome World** [via Reddit/Plebiain](https://www.reddit.com/r/minecraftseeds/comments/h84n1j/spawn_on_a_mushroom_island_in_a_small_ocean/)

This seed provides all biomes within easy reach of one another. It also includes many structures, making it an exciting seed to explore.

**Paradise Valley** [via Reddit/SpaceBoiArt](https://www.reddit.com/r/minecraftseeds/comments/ia3dog/created_a_new_world_and_spawned_in_this_awesome/)

An ideal seed for colossal builds. The level plains of Paradise Valley are surrounded by mountains, with resource-rich forests only a short journey from spawn.

**Other Included World Seeds**

- Minecraft Title Screen
- Slime Farm
- Obsidian Farm
- Woodland Mansion
- Triple Island Ocean Monument
- Spruce Village and Coral Reef
- Shipwreck Village
- Underwater Temple
- Diamond Paradise


License
=======

This project (Pinecraft, the install script) is free, open source software. However, Minecraft itself is not (hence why we are distributing an installer, not a pre-compiled server). In order to use your Minecraft server, you must first accept the Minecraft EULA found here: https://account.mojang.com/documents/minecraft_eula

Of course, other projects utilized for Pinecraft carry other licenses (such as Java, Spigot, etc.). Ours is just an installer / configuration tool and we are not distributing any software.


Note About Backups
==================

Please consider automating a backup of your world. You can first stop the server with the provided `systemctl stop pinecraft` command, run your backup, and then restart your server with the provided `systemctl start pinecraft` command.


Automated Overclocking
======================

If your board is supported and tested by me, the installer will automatically set overclock settings to maximize performance.

Ensure your power supply is a good one to ensure maximum performance.

You are welcome to adjust the overclock settings if desired. However, I would recommend trying the automated defaults first.

I have chosen to be conservative with my overclocking for three reasons:

1) I want you to get the best possible performance out of your Minecraft server, but also wish to ensure it is rock-solid stable.
2) I do not want to void your warranty. I.e., I will NOT enable force_turbo.
3) I do not wish to damage your Pi.

When I overwrite your /boot/config.txt file, I first create a backup of your original at /boot/config-DATETIME.txt, so if you're unable to boot for some reason, hopefully you can easily recover. Note that you are running this script at your own risk, and I am not responsible for anything that happens as a result of your running this installer. Except smiles; I'll accept responsibility for smiles.


Usage
=====

Run the installer immediately following a fresh reboot (to avoid having residual apps taking up RAM thereby resulting in less RAM allocated to your game server).

The command is simple:

`sudo ./install`

To reboot your Pinecraft Server, I recommend stopping your Minecraft server safely first, to ensure all blocks are saved.

`sudo systemctl stop pinecraft`

asdf - restore previous statement? build stop into shutdown systemd?

### Important Note: First Run

On first run, your Minecraft Server will generate the world. This can take around 10 minutes, so hang tight while this happens, and then connect to your Minecraft Server's IP address from your Minecraft Java client as soon as it is ready. You can view the Minecraft server screen session to see the progress, or simply retry connecting via Minecraft Java after a few minutes.


Post-Install
============

### Commands

If you opted to have Pinecraft load your Minecraft server at boot, your Minecraft server will be running in a screen session.

**Important Note:** All commands must be run as the user you originally specified in Pinecraft Installer (do not run as *root*, for example).

`screen -ls` will reveal running screen sessions. There should be one called `pinecraft`

`screen -r pinecraft` re-attaches to the Pinecraft screen session (the Minecraft console) where you can enter console commands directly.

From within the screen session, detach (exit) by pressing `CTRL-A` followed by `D`. This will detach the screen session but leave your Minecaft server running.

### Scripts

`sudo systemctl stop pinecraft`
Safely stop your Minecraft server. **Do not reboot your system or power off using traditional Linux commands unless you have first stopped your Pinecraft Server.** Failure to safely stop your Minecraft server will result in lost blocks and potentially world corruption. Running this script is the same as entering the `stop` command within the Minecraft console.

`sudo systemctl start pinecraft`
Start the Minecraft server. This script is automatically run upon boot if you selected this feature. Of course, if you specified for Pinecraft to automatically load your Minecraft server on boot, you generally won't need this script.

`sudo ~/minecraft/reboot`
When you need to reboot your Minecraft server, you must do so safely, otherwise all blocks that are stored in RAM will be lost (could be a full day's worth). Run this script to shutdown the Minecraft server software, store all blocks, and reboot the server. Note: It can easily take 15-20 minutes to stop the Minecraft server. Don't abort once you run this script. It is working hard to save all the blocks for your world and if you stop it or force a reboot, you will lose blocks.


Networking
==========

Your Minecraft server runs on port 25565. If you'd like others to be able to join your server, forward that port to your Minecraft server in your firewall.

Within your LAN, you can access your Minecraft server by the IP address of your Pinecraft Server.

**Note:** If you open up your server to the world you introduce the risk of someone connecting and griefing (damaging your builds). To protect your server world, either limit the logins to specific users (see Minecraft documentation), restrict your firewall to only allow trusted IPs that you specify (see your networking documentation) or if you truly want it to be a public server, add some mods to protect your world (see the documentation for your running server flavor).

Log Files
=========

### /srv/pinecraft/server/logs/latest.log
The current Minecraft Server log file. You can run `tail -f /srv/pinecraft/server/logs/latest.log` on your Minecraft Server to see what's happening. Logs are rotated and gzipped by date.


Version History
===============

Pinecraft 5.0 - All versions of Minecraft are now supported, and you may choose specifically which version to install.

Pinecraft 4.1 - Minecraft 1.21 is now supported.

Pinecraft 4.0 - Anniversary Edition! Minecraft 1.20.6 is now supported. Skipped 1.20.5 due to critical bug [MC-271109](https://bugs.mojang.com/browse/MC-271109). PinecraftOS introduced. User can now select level-type, and added Adventure game mode.

Pinecraft 3.9 - Minecraft 1.20.4 is now supported. Skipped 1.20.3 due to critical bug [MC-267185](https://bugs.mojang.com/browse/MC-267185).

Pinecraft 3.8 - Minecraft 1.20.2 is now supported.

Pinecraft 3.7 - Minecraft 1.20.1 is now supported.

Pinecraft 3.6 - Minecraft 1.19.4 is now supported.

Pinecraft 3.5 - Minecraft 1.19.3 is now supported.

Pinecraft 3.4 - Minecraft 1.19.2 is now supported.

Pinecraft 3.3 - Minecraft 1.19 is now supported.

Pinecraft 3.2 - Minecraft 1.18.2 is now supported. Khadas VIM4 SBC is now supported as an alternative to the Raspberry Pi 4.

Pinecraft 3.1 - All applicable installers support 1.18.1. The Java version has been increased to 17, and the installer improved. Also addressed some changes in the Forge installer which broke compatibility with earlier versions of Pinecraft Installer.

Pinecraft 3.0 - All applicable installers support 1.17.1. A few bug fixes.

Pinecraft 2.9 - Pinecraft Installer will now attempt to install the latest Java. If that fails, it will try installing older versions until it finds one that works on your system. If the version of Java is older than 16, Pinecraft Installer will install 1.16.5. If, however, Java 16 is successful, the Minecraft version will default to 1.17 for custom or random seeds. Choosing a seed from an older version of Minecraft will hide incompatible server flavors and attempt to install the server version that is compatible with the selected seed. Linux username is now automatically detected and presented as a selection list. The default server was changed from to Fabric (formerly Paper).

Pinecraft 2.8 - Ensure Java version 16 is installed, which is required for Minecraft 1.17.

Pinecraft 2.7 - Forge modded server now included as one of the server options.

Pinecraft 2.6 - Minecraft server now running on "Pinecraft" screen session. ~/minecraft/stop no longer looks for Java PID to send SIGHUP, but rather sends the stop command to the "Pinecraft" screen session. Minecraft server now starts automatically upon installation complete; No need to reboot. User can now attach "Pinecraft" screen session to access the Minecraft server console (handy for running op commands). The safe stop command now executes automatically at system shutdown or reboot.

Pinecraft 2.5 - Fix initialization issue on new Pinecraft servers following root patch introduced in 2.3. Improve upgrade process and add option to fully remove previous install and replace with a new install (create a new world as well).

Pinecraft 2.4 - Upgrade Software: Fabric (0.7.2), Paper (1.16.5-566).

Pinecraft 2.3 - Prevent user from running ~/minecraft/server as root/sudo.

Pinecraft 2.2 - Added seed selection and custom seed input.

Pinecraft 2.1 - Added Vanilla server. Label Paper as the new Default server version (previously was Spigot). Hide output of installers (to hide the misleading errors in Paper's installer). Added experimental support for Cuberite.

Pinecraft 2.0 - Pinecraft now supports installation of Paper, Fabric, and Spigot. Also, previous versions deployed a Survival server. Now, user may choose Survival or Creative during install.

Pinecraft 1.1 - New installer interface.

Pinecraft 1.0 - Initial release, installs, configures and optimizes a Spigot Minecraft server, as seen on Category5 Technology TV.


Troubleshooting
===============

### Server gets killed by Linux
Try `dmesg -T| grep -E -i -B100 'killed process'` after this happens to see why Linux killed the process. It is most likely you are running other applications on your system (which is a big no-no) and have run out of resources. You should only run this on a completely headless SBC, with no desktop environment, and nothing else running. You can adjust the amount of RAM allocated by editing the `server` script in ~/minecraft

### Overclock says N/A
The type of hardware you're using hasn't been tested by me, and I haven't added automatic overclocking for your board. You'll need to perform your own overclocking. If you do so successfully, please let me know what you had to do, and if I can test it, I may add it to a future update.

Post-Install Configuration
==========================

Give your Minecraft server a try before you start changing the config. It's very possible to break things if you modify the config, so it's a good start to test your server first, and then just tweak what's needed / desired.

You'll find your config file here: /srv/pinecraft/server/server.properties

Minecraft Wiki: https://minecraft.wiki/w/Server.properties#Keys


Frequently Asked Questions
==========================

Remember, Pinecraft Installer installs a Minecraft server like any other. Our goal is to make it easy for you to get up and running with an efficient, high-performance server, but we don't rework how the resulting server works in any way. Therefore, the official Minecraft docs are the perfect place to get help with your server configuration.

That said, we get some questions regularly, and we're here to help if we can, so we'll record them here.


**First, here are some helpful links:**

Modify server.properties, the main config file for your server's settings
https://minecraft.wiki/w/Server.properties#Keys

**Find Plugins for Spigot / Paper / Fabric**
https://www.spigotmc.org/resources/categories/spigot.4/

**Don't Forget:** Plugins can negatively impact server performance. Select carefully.


**And here are some FAQ's:**

### How do I become admin? /op says I don't have permission.

After connecting to your server as the user you want to make admin, look at your `/srv/pinecraft/server/logs/latest.log` file and find the UUID for that user.

Edit `/srv/pinecraft/server/ops.json` as follows:

```
[
  {
    "uuid": "UUID",
    "name": "USERNAME",
    "level": 4
  }
]
```

Replace UUID with your UUID, and USERNAME with the actual username.

Here is a helpful tool I created to assist: https://category5.tv/tools/minecraft/uuid/

Then, restart your Pinecraft server with `systemctl restart pinecraft`

When your server comes back online, that user will be admin, and can now use the /op command to create other admins.

### How do I re-generate my world?

To completely destroy your world and regenerate it, you simply need to remove the files.

Step 1: Stop your Minecraft server. `systemctl stop pinecraft`

Step 2: Remove the world (this cannot be undone): `rm -rf /srv/pinecraft/server/world*`

Step 3: Restart your Minecraft server by whichever means you prefer (E.g., reboot your server with `sudo ~/minecraft/reboot`) - Remember, the first time the server loads, it will generate a new world. Give it 10 minutes or so before you attempt to connect.
