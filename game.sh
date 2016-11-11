#!/bin/bash
source board.sh
jogada=0

while [ true ]
do
	draw_board
	if [ `expr $jogada % 2` -eq 0 ]
	then
		printf "\nVez do jogador 1"
		
		tput setaf 130
		echo " ⌨  "
		echo -e "\033[0m"
		echo "Digite a origem: "
		read lo no
		echo "Digite o destino: "
		read ld nd

		echo "$lo $no $ld $nd"
	else
		tput setaf 7
		echo -e "\nVez do jogador 2 ⌨  "
		echo -e "\033[0m"
		echo "Digite a origem: "
		read lo no
		echo "Digite o destino: "
		read ld nd

		echo "$lo $no $ $ld $nd"
	fi 

	jogada=$(expr "$jogada" + 1)

done
