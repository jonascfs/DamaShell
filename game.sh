#!/bin/bash
source board.sh
source util.sh
source roles.sh
initBoard
jogada=0

function jogar(){
	if isCorrectMove $1 $2 $3 $4 $5
	then
		peca=$(getValue $1 $2)
		setValue $1 $2 0
		setValue $3 $4 $peca
		return 0
	else
		return 1
	fi
	
}

function printTurno(){
	if [ $1 -eq 1 ]
	then
		printf "\nVez do jogador 1"
		tput setaf 130
		echo " ⌨  "
		echo -e "\033[0m"
	else
		printf "\nVez do jogador 2"
		tput setaf 7
		echo " ⌨  "
		echo -e "\033[0m"
	fi
}

while [ true ]
do
	#Desenha tabuleiro sem marcar peça
	draw_board "_" 0

	if [ `expr $jogada % 2` -eq 0 ]
	then
		printTurno 1
		echo "Digite a origem: "
		read lo no
		#Desenha tabuleiro marcando a peça origem
		draw_board $lo $no
		printTurno 1
		echo "Digite o destino: "
		read ld nd

		jogar $lo $no $ld $nd 1
	else
		printTurno 2
		echo "Digite a origem: "
		read lo no
		#Desenha tabuleiro marcando a peça origem
		draw_board $lo $no
		printTurno 2
		echo "Digite o destino: "
		read ld nd

		jogar $lo $no $ld $nd 2
	fi 

	jogada=$(expr "$jogada" + 1)

done
