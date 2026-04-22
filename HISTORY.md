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
