# Pterodactyl-Updater
This script will update your [Pterodactyl](https://pterodactyl.io) instance and also copy any files you have changed and install then.

## Use the script 
```
bash <(curl -s https://raw.githubusercontent.com/TheAFKGamer10/Pterodactyl-Updater/update.sh)
```
or run the Dev branch
```
bash <(curl -s https://raw.githubusercontent.com/TheAFKGamer10/Pterodactyl-Updater/Dev/update.sh)
```
## What does it do?
This script will ask you how you would like to update your panel. 
You can choose to update just the panel, or to install files that you have changed. The first time you choose to `Update with changed files` it will create a directory called `Changedfiles` and inside that folder another directory called `pterodactyl`. This is where you will put your changed files. The script will then copy those files and install them. 

## Why Is The Script Taking So Long?
This may be because you have not added a Github Token and this script may require you to add one. You can get a token by going to [Github Tokens](https://github.com/settings/tokens/new). You do not need to check any of the access boxes. **This script Does Not ready your token.**

## Support
If you need help with this script, you can [Create An Issue](https://github.com/TheAFKGamer10/Pterodactyl-Updater/issues) join our [Discord](https://afkhosting.win/discord) and create a ticket in the `#support` channel.
