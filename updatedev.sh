#!/bin/bash

#Defines the update varibles. 
#upwo (update without installing changed files)
#upw (update with changed files)
#upwots (update without installing changed files troubleshooting)
#upwts (update with changed files troubleshooting)

if [ $EUID -ne 0 ]; then
	echo "This script must be run as root" >&2
	echo "Use 'sudo -i' to run as root" >&2
	exit 13
fi

upwo() {
	echo "Updating Pterodactyl ..." >&2
	echo "Please wait while we run the commands. This may take up to 5 minutes." >&2
	export NODE_OPTIONS=--openssl-legacy-provider
	export COMPOSER_ALLOW_SUPERUSER=1

	cd /var/www/pterodactyl
	php artisan down
	curl -Ls https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv 
	chmod -R 755 storage/* bootstrap/cache
	composer install -q --no-dev --optimize-autoloader
	php artisan view:clear
	php artisan config:clear
	php artisan migrate --seed --force
	chown -R www-data:www-data /var/www/pterodactyl/*
	php artisan queue:restart
	php artisan up

	export COMPOSER_ALLOW_SUPERUSER=0
}

upwots() {
	echo "Updating Pterodactyl ..." >&2
	echo "Please wait while we run the commands. This may take up to 5 minutes." >&2
	export NODE_OPTIONS=--openssl-legacy-provider
	export COMPOSER_ALLOW_SUPERUSER=1

	cd /var/www/pterodactyl
	php artisan down
	curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv 
	chmod -R 755 storage/* bootstrap/cache
	composer install --no-dev --optimize-autoloader
	php artisan view:clear
	php artisan config:clear
	php artisan migrate --seed --force
	chown -R www-data:www-data /var/www/pterodactyl/*
	php artisan queue:restart
	php artisan up

	export COMPOSER_ALLOW_SUPERUSER=0
}

upw() {
	echo "Updating Pterodactyl ..." >&2
	echo "Please wait while we run the commands. This may take up to 5 minutes." >&2
	export NODE_OPTIONS=--openssl-legacy-provider
	export COMPOSER_ALLOW_SUPERUSER=1

	cd /var/www/pterodactyl
	php artisan down
	curl -Ls https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv 
	chmod -R 755 storage/* bootstrap/cache
	composer install -q --no-dev --optimize-autoloader
	php artisan view:clear
	php artisan config:clear
	php artisan migrate --seed --force
	chown -R www-data:www-data /var/www/pterodactyl/*
	php artisan queue:restart

	# the ! check is the statement is false. if there is not a folder named that, then make one.
	if [ ! -d /var/www/pterodactyl/Changedfiles ]; then
		mkdir /var/www/pterodactyl/Changedfiles/
		mkdir /var/www/pterodactyl/Changedfiles/pterodactyl/
		touch /var/www/pterodactyl/Changedfiles/DoNotPutAnythingInThisFolder
		echo "Folder named 'pterodactyl' created in '/var/www/pterodactyl/Changedfiles/pterodactyl'" >&2
		echo -e "Place any files you would like to replace every time you update the panel in this folder. \n\n More information can be found in our documentation. \n Please Read It! \n" >&2
		exit 125
	fi

	echo "Copying Files ..." >&2
	cp -rf /var/www/pterodactyl/Changedfiles/pterodactyl /var/www/

	if [ -d /var/www/pterodactyl/node_modules ]; then
		echo "node_modules folder exists. Running update commands now ..." >&2
	else
		echo "node_modules folder does not exist. Adding packags. This may take extra time." >&2
		yarn add react-scripts
		npx update-browserslist-db@latest
		yarn
		echo "Done installing dependencies. Running update commands now ..." >&2
	fi
	php artisan migrate --seed --force
	yarn build:production
	php artisan config:cache
	php artisan view:cache
	php artisan queue:restart
	php artisan up

	export COMPOSER_ALLOW_SUPERUSER=0
}

upwts() {
	echo "Updating Pterodactyl ..." >&2
	echo "Please wait while we run the commands. This may take up to 5 minutes." >&2
	export NODE_OPTIONS=--openssl-legacy-provider
	export COMPOSER_ALLOW_SUPERUSER=1

	cd /var/www/pterodactyl
	php artisan down
	curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv 
	chmod -R 755 storage/* bootstrap/cache
	composer install --no-dev --optimize-autoloader
	php artisan view:clear
	php artisan config:clear
	php artisan migrate --seed --force
	chown -R www-data:www-data /var/www/pterodactyl/*
	php artisan queue:restart

	# the ! check is the statement is false. if there is not a folder named that, then make one.
	if [ ! -d /var/www/pterodactyl/Changedfiles ]; then
		mkdir /var/www/pterodactyl/Changedfiles/
		mkdir /var/www/pterodactyl/Changedfiles/pterodactyl/
		touch /var/www/pterodactyl/Changedfiles/DoNotPutAnythingInThisFolder
		echo -e "\nFolder named 'pterodactyl' created in '/var/www/pterodactyl/Changedfiles/pterodactyl'" >&2
		echo -e "Place any files you would like to replace every time you update the panel in this folder. \n\n More information can be found in our documentation. \n Please Read It! \nRun the script again to update." >&2
		exit 125
	fi

	echo "Copying Files ..." >&2
	cp -rf /var/www/pterodactyl/Changedfiles/pterodactyl /var/www/

	if [ -d /var/www/pterodactyl/node_modules ]; then
		echo "node_modules folder exists. Running update commands now ..." >&2
	else
		echo "node_modules folder does not exist. Adding packags. This may take extra time." >&2
		echo "Extra chat outputs may apear." >&2
		sleep 5
		yarn add react-scripts
		npx update-browserslist-db@latest
		yarn
		echo "Done installing dependencies. Running update commands now ..." >&2
	fi
	php artisan migrate --seed --force
	yarn build:production
	php artisan config:cache
	php artisan view:cache
	php artisan queue:restart
	php artisan up

	export COMPOSER_ALLOW_SUPERUSER=0
}

# This asks the question and runs the command based on the user input.

values=( "Update" "Update with changed files" "Update Troubleshooting" "Update with changed files Troubleshooting")
echo "Please Choose One Option:"
select word in "${values[@]}"; do
    if [[ -z "$word" ]]; then
        printf '"%s" is not a valid choice. Try again.\n' "$REPLY" >&2
    else
        user_in="$(( REPLY - 1 ))"
        break
    fi
done

if [[ "$REPLY" == 1 ]]; then
	### Runs if the user sclect input 1. Sends extra chat output to trash ###
	upwo > /dev/null
elif [[ "$REPLY" == 2 ]]; then
	### Runs if the user sclect input 2. Sends extra chat output to trash ###
	upw > /dev/null
elif [[ "$REPLY" == 3 ]]; then
	### Runs if the user sclect input 3 ###
	upwots
elif [[ "$REPLY" == 4 ]]; then
	### Runs if the user sclect input 4 ###
	upwts
else
	echo "No commands set. Make an issue to recommend one."
fi
