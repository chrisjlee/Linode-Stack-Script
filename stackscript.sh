#!/bin/bash
# <UDF name="db_password" Label="MySQL root Password" />
# <UDF name="db_name" Label="Create Database" default="foo" example="Drupal database name" />
# <UDF name="db_user" Label="Create MySQL User" example="Drupal database user" />
# <UDF name="db_user_password" Label="MySQL User's Password" example="Drupal database user's password" />
# <UDF name="fqdn" Label="Fully Qualified Domain Name" default="" example="Optional fully qualified hostname, ie www.mydomain.com - if empty, the hostname will default to the one assigned by Linode." />
# <UDF name="admin_user" Label="Administrative User" default="" example="Optional username to setup with password-less sudo access.  You must also add the ssh public key below.  This user is added as the first step, so you can ssh in before the script is finished." />
# <UDF name="admin_pubkey" Label="Administrative User's SSH Public Key" default="" example="Optional SSH public key (from ~/.ssh/id_dsa.pub) to be associated with the Administrative User above." />
# <UDF name="notify_email" Label="Send Finish Notification To" example="Email address to send notification to when finished.  Build time is just under 15 minutes." />

# StackScript written by Chris Lee <chris@globerunnerseo.com>

source <ssinclude StackScriptID="1">

function base_install {
	aptitude install -y install git-core unzip curl php5-cli php5-gd libapache2-mod-php5 php-pear
}

function drush_install {
	cd /tmp && git clone --branch 7.x-5.x http://git.drupal.org/project/drush.git drush
		if [ ! -f /tmp/drush/drush ]; then
			echo "Could not checkout drush from git"
			exit 1
		fi
	return 
}

function dotfiles_install {
	git clone git://github.com/chrisjlee/dotfiles.git ~/.dotfiles
}

function uampfiles_install {
	git clone git://github.com/chrisjlee/uamp-files.git .uamp-files
}

function backup_mysqlcnf {
	cp /etc/mysql/my.cnf /etc/mysql/my.cnf_backup
}
function dotfiles_setup {
	cp ~/.dotfiles/.bash* ~/
	cp ~/.dotfiles/.prompt ~/
	cp ~/.dotfiles/.gitc* ~/
	cp ~/.dotfiles/.giti* ~/
	cp -rfv ~/.dotfiles/.vim* ~/
	echo "source ~/.bash_profile" >> ~/.bashrc && source ~/.bashrc
}

base_install
drush_install
dotfiles_install
dotfiles_setup
