#!/bin/bash
# Qub3d dev environment auto install
# Author Austin Pachano (SonosFuer)

#=============================================================================#
# Function declarations                                                       #
#=============================================================================#

#Function to prompt for a yes or no answer
function ask_yn {
	while true; do
		read -p "(y/n):" yn
		if [[ "$yn" == "y" ]]; then
			break
		elif [[ "$yn" == "Y" ]]; then
			yn=y
			break
		elif [[ "$yn" == "yes" ]]; then
			yn=y
			break
		elif [[ "$yn" == "Yes" ]]; then
			yn=y
			break
		elif [[ "$yn" == "n" ]]; then
			break
		elif [[ "$yn" == "N" ]]; then
			yn=n
			break
		elif [[ "$yn" == "no" ]]; then
			yn=n
			break
		elif [[ "$yn" == "No" ]]; then
			yn=n
			break
		else
			echo 'Please respond with "y" or "n"'
		fi
	done
}

#Function to set the directory variable
function select_dir {
	while true; do
	  echo "Setting up work directory at $directory"
	  echo "Is this okay?"
	  ask_yn
	  if [[ ask_yn ]]; then
	  	break
	  elif [[ "$yn" == "n" ]]; then
	  	echo "What directory would you like to use"
	  	read -p "->" directory
	  fi
	done
}

#function to set up a public ssh key on your computer
function setup_ssh {
  echo "setting up ssh now"
  if [[ -e ~/.ssh/id_rsa.pub ]]
  then
    cat ~/.ssh/id_rsa.pub
  else
  	echo "no key"
  fi
}
function check_package {
	if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ];
	then
	    return 1 #1 for false
	else
		return 0 #0 for true
	fi
}
function check_package_apt {
	echo "Checking if $1 is installed"
	if [[ "check_package $1" ]]; then
		echo "$1 is already installed"
	else
		echo "$1 is not installed"
		sudo apt-get install git
	fi
}


#=============================================================================#
# Begin main code execution                                                   #
#=============================================================================#



#Set directory to home/<user>/qub3d
directory=~/qub3d

#Check if this is an okay directory, if not ask for new one
select_dir

#Is it okay to clear the work directory?
while true; do
  echo "Checking work directory"
  if [ -d "$directory" ]; then
    #Directory exists, check if empty
    if [ -e "$directory/*" ]; then
    	#files exist, can we overwrite them
    	echo "This directory has stuff in it. Can I delete it?"
    	ask_yn
    	if [[ "yn" == "y" ]]; then
    		rm -r $directory/*
    	else
    		echo "The selected directory gets cleared out"
    		echo "Exiting program now"
    		exit
    	fi

    else
    	#Directory is empty, we are good to go
    	break
    fi
  else
  	#directory does not exist, create it and assume it is empty
  	mkdir $directory
  	break
  fi

done

echo #=== Checking for required packages ===#

check_package_apt git
check_package_apt cmake

echo "For repository access would you like to use ssh or html?"
read -p "->" repo

if [[ "$repo" == "ssh" ]]
then
  echo "setting up ssh now"
elif [[ "$repo" == "html" ]]
then
  echo "setting up html now"
else
  echo 'please reply with "html" or "ssh"'
fi
