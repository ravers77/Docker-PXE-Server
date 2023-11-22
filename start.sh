#!/bin/bash

ende()
{
	exit
}
###################

menue()
{
	echo "___________________________________________________________________________________________"
	echo "|                                                                                         |"
	echo "|                         PPPP         XX    XX        EEEEEEE                            |"
	echo "|                         PP PP         XX  XX         EE                                 |"
	echo "|                         PP  PP         XXXX          EE                                 |"
	echo "|                         PPPPP           XX           EEEEE                              |"
	echo "|                         PP             XXXX          EE                                 |"
	echo "|                         PP            XX  XX         EE                                 |"
	echo "|                         PP           XX    XX        EEEEEEE                            |"
	echo "|_________________________________________________________________________________________|"
	echo "|												|"
	echo "|  b)	Build the Docker-Image and startup the Docker-Containers			|"
	echo "|  s)  	Setup the PXE-Server								|"
	echo "|												|"
	echo "|  r)  	Start the existing docker-containers						|"
	echo "|  x)  	Stop the docker-containers							|"
	echo "|  u)	Update the PXE-Server								|"
	echo "|												|"
	echo "|  t)	Show TCPDUMP on port 67-69 of the PXE-Container					|"
	echo "|												|"
	echo "|  p)	Run TAILS-Patch-Script. Tails has to be already downloaded an mounted!		|"
	echo "|		(see https://github.com/beta-tester/RPi-PXE-Server/issues/31)			|"
	echo "|												|"
	echo "|  D)  	DELETE the existing docker-containers and docker images completely		|"
	echo "|												|"
	echo "|  EXIT 	Exit this script, but PXE-Server is running, if started.			|"
	echo "|												|"
	echo "|_________________________________________________________________________________________|"
	echo ""
	read -p "Your choice: " menue_wahl

	case "$menue_wahl" in
		b)
			clear
			mkdir samba srv
			git clone https://github.com/beta-tester/RPi-PXE-Server.git
			cp scripts/* RPi-PXE-Server
			docker-compose up -d
			docker exec -it pxe-container bash first_run.sh
			clear 
			echo "Please reboot!"
			exit
			;;
			#############################################

		s)
			clear
			docker-compose start
			docker exec -it pxe-container bash setup.sh
			docker-compose stop
			sudo systemctl restart rpcbind.service
			docker-compose start
			docker exec -it pxe-container bash update.sh
			clear
			echo "PXE-Server is running"
			echo ""
			menue
			;;
			#############################################

		r)	clear
			docker-compose start
			docker exec -it pxe-container bash update.sh
			clear
			echo "PXE-Server started"
			echo ""
			menue
			;;
			#############################################

		u)	clear
			docker exec -it pxe-container bash update.sh
			clear
			echo "PXE-Server update finished"
			echo ""
			menue
			;;
			#############################################

		x)	clear
			docker-compose stop
			clear
			echo "PXE-Server stopped"
			echo ""
			menue
			;;
			#############################################

		t)	clear
			docker exec -it pxe-container bash tcpdump.sh
			clear
			echo "TCPDUMP stopped"
			echo""
			menue
			;;
			#############################################

		D)	clear
			docker-compose down
			docker rmi  pxe-image:latest
			echo "PXE-Server container and image deleted"
			echo ""
			clear 
			menue
			;;
			#############################################

		EXIT)	clear
			echo "Bye bye..."
			ende
			;;
			#############################################

		*)	echo ""
			echo "no possible choice, try again!"
			echo ""
			read -p "Continue with ENTER-KEY... " WEITER
			clear
			menue
			;;
			#############################################

	esac

}

clear
menue
