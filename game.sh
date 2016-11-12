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
		
		saida=$(jogar $lo $no $ld $nd 1)
		echo "$saida"
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

				while hasFood $novaColunaOrigem $novaLinhaOrigem 1
				do
					#Comeu uma peça na ultima jogada
					draw_board $novaColunaOrigem $novaLinhaOrigem
					read -p "Deseja continuar a jogar? [s-sim n-não ] " seguir
					if [ $seguir = "s" ]
					then
						echo "Digite o destino: "
						read nld nnd
						saida=$(jogar $novaColunaOrigem $novaLinhaOrigem $nld $nnd 1)
						echo "$saida"
						continuar=$(echo "$saida" | cut -f1 -d" " )
						novaColunaOrigem=$(echo "$saida" | cut -f2 -d" " )
						novaLinhaOrigem=$(echo "$saida" | cut -f3 -d" " )
						else
							#Para sair do laço
							novaLinhaOrigem=$(echo "true")		
					fi
				done
			
			fi

			#proximo jogador
			jogada=$(expr "$jogada" + 1)
		fi
		
	else
		printTurno 2
		echo "Digite a origem: "
		read lo no
		#Desenha tabuleiro marcando a peça origem
		draw_board $lo $no
		printTurno 2
		echo "Digite o destino: "
		read ld nd
		
		saida=$(jogar $lo $no $ld $nd 2)
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
				while hasFood $novaColunaOrigem $novaLinhaOrigem 2
				do
					#Comeu uma peça na ultima jogada
					draw_board $novaColunaOrigem $novaLinhaOrigem
					read -p "Deseja continuar a jogar? [s-sim n-não ] " seguir
					if [ $seguir = "s" ]
					then
						echo "Digite o destino: "
						read nld nnd
						saida=$(jogar $novaColunaOrigem $novaLinhaOrigem $nld $nnd 2)
						echo "$saida"
						continuar=$(echo "$saida" | cut -f1 -d" " )
						novaColunaOrigem=$(echo "$saida" | cut -f2 -d" " )
						novaLinhaOrigem=$(echo "$saida" | cut -f3 -d" " )
					else
						#Para sair do laço
						novaLinhaOrigem=$(echo "true")
					fi

				done
			fi
			#proximo jogador
			jogada=$(expr "$jogada" + 1)
		fi
	fi 

	

done
