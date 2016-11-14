#!/bin/bash
source board.sh
source util.sh
source rules.sh
#initBoard
jogada=0

function jogar(){
	
	retorno=$(isCorrectMove $1 $2 $3 $4 $5)
	validacao=$(echo $retorno | cut -f1 -d" ")
	coluna=$(echo $retorno | cut -f2 -d" ")
	linha=$(echo $retorno | cut -f3 -d" ")

	if [ "$validacao" = "true" ]
	then
		printf "true"

		peca=$(getValue $1 $2)
		setValue $1 $2 0
		setValue $3 $4 $peca

		#Testa se há peça comida
		if [ ! $coluna = "true" ]
		then
			# retorna destino da peça que comeu
			printf " $3 $4"
			#Remove peça comida!
			setValue $coluna $linha 0
		fi

		#Verifica se é dama e muda a peça
		if [ $5 -eq 1 ] && [ $4 -eq 1 ]
		then
			setValue $3 $4 -1
		elif [ $5 -eq 2 ] && [ $4 -eq 8 ]
		then
			setValue $3 $4 -2
		fi

	else
		echo "false"
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


function victory(){

	if [ $1 -eq 1 ]
	then
		playerLose=2
	else
		playerLose=1
	fi
	if [ $(countPieces $playerLose) -eq 0 ]
	then 
		echo "victory"
	else 
		echo "noVictory"
	fi

}

function MENU_JOGADOR(){
	printTurno $1
	echo "Digite a origem: "
	read origem
	lo=$(echo $origem | cut -c1)
	no=$(echo $origem | cut -c2)

	#Desenha tabuleiro marcando a peça origem
	draw_board $lo $no
	printTurno $1
	echo "Digite o destino: "
	read destino
	ld=$(echo $destino | cut -c1)
	nd=$(echo $destino | cut -c2)
	
	saida=$(jogar $lo $no $ld $nd $1)
	continuar=$(echo "$saida" | cut -f1 -d" " )
	novaColunaOrigem=$(echo "$saida" | cut -f2 -d" " )
	novaLinhaOrigem=$(echo "$saida" | cut -f3 -d" " )


	if [ "$continuar" = "false" ]
	then
		echo "Jogada inválida!"
		echo "Ex.: a 3"
		read -p "Digite [ENTER] para continuar"
	else
		
		if [ $(echo "$saida" | wc -w ) -eq 3 ]
		then

			while hasFood $novaColunaOrigem $novaLinhaOrigem $1
			do
				#Comeu uma peça na ultima jogada
				draw_board $novaColunaOrigem $novaLinhaOrigem
				read -p "Deseja continuar a jogar? [s-sim n-não ] " seguir
				if [ $seguir = "s" ]
				then
					echo "Digite o destino: "
					read nld nnd
					saida=$(jogar $novaColunaOrigem $novaLinhaOrigem $nld $nnd $1)
					echo "$saida"
					continuar=$(echo "$saida" | cut -f1 -d" " )
					
					if [ "$continuar" = "true" ]
					then
						novaColunaOrigem=$(echo "$saida" | cut -f2 -d" " )
					    novaLinhaOrigem=$(echo "$saida" | cut -f3 -d" " )
					else
						echo "Jogada inválida!"
						echo "Ex.: a 3"
						read -p "Digite [ENTER] para continuar"
					fi
				else
					#Para sair do laço
					novaLinhaOrigem=$(echo "true")		
				fi
			done
		
		fi

		#proximo jogador
		jogada=$(expr "$jogada" + 1)
	fi
}

function MENU_VENCEU(){
	say "You Win!"
	clear
	if [ $1 -eq 1 ]
	then
		tput setaf 2; cat jogador_1_venceu.txt
	else
		tput setaf 2; cat jogador_2_venceu.txt
	fi
	
}

function DAMA(){
	while [ true ]
	do
		#Desenha tabuleiro sem marcar peça
		draw_board "_" 0

		if [ `expr $jogada % 2` -eq 0 ]
		then
			MENU_JOGADOR 1
			v=$(victory 1)
			if [ "$v" = "victory" ]; then
				MENU_VENCEU 1
				read -p "Digite [ENTER] para continuar"
				break
			fi
		else
			MENU_JOGADOR 2
			v=$(victory 2)
			if [ "$v" = "victory" ]; then
				MENU_VENCEU 2
				read -p "Digite [ENTER] para continuar"
				break
			fi
		fi
	done
}

function equipe(){
	clear
	echo "EQUIPE: "
	echo "	- André"
	echo "	- Jonas"
	echo "	- Sergio"
	echo "	- Rômulo"

	read -p "Digite [ENTER] para continuar"
}

function regras(){
	
}


function opcoes(){
	clear
	echo -e "\033[0m"

	echo "Escolha uma das opções"
	echo "1 - JOGAR"
	echo "2 - REGRAS/INSTRUNÇÕES"
	echo "3 - EQUIPE"
	echo "4 - SAIR"
}

function MENU_GAME() {
	while true
	do

		opcoes
		read OP
		case $OP in 
		1)
			DAMA
		;;
		2)
			
		;;
		3)
			equipe
		;;
		4)
			exit
		;;
		esac
	done
}

MENU_GAME
