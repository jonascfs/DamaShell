#!/bin/bash
source util.sh
source rules.sh

declare -a letras
declare -A numeros	
letras=(x a b c d e f g h)
n="0"
for i in ${letras[@]}
do
	numeros[$i]=$n
	n=$(expr $n + 1)	
done


function hasThreat (){
	#$1 col, $2 linha, $3 jogador, $4 col_coordenada, $5 linha_coordenada
	if hasPosition ${letras[$(expr $num_col_atual + $4)]} $(expr $2 + $5) && [ $(abs $(getValue ${letras[$(expr $num_col_atual + $4)]} $(expr $2 + $4))) -eq  $(otherPlayer $3) ] && isEmpty ${letras[$(expr $num_col_atual - $4)]} $(expr $2 - $5); then
		return 0
	else 
		return 1
	fi		
} 

function getMoves(){
	#$1 col, $2 linha
	if isEmpty ${letras[$(expr $num_col_atual + 1)]} $(expr $2 + 1) ; then
		echo -e "${letras[$(expr $num_col_atual + 1)]} $(expr $2 + 1)\n"	
	fi
	if isEmpty ${letras[$(expr $num_col_atual + 1)]} $(expr $2 - 1) ; then
		echo -e "${letras[$(expr $num_col_atual + 1)]} $(expr $2 - 1)\n"
	fi
	if isEmpty ${letras[$(expr $num_col_atual - 1)]} $(expr $2 + 1) ; then
		echo -e "${letras[$(expr $num_col_atual - 1)]} $(expr $2 + 1)\n"
	fi
	if isEmpty ${letras[$(expr $num_col_atual - 1)]} $(expr $2 - 1) ; then
		echo -e "${letras[$(expr $num_col_atual - 1)]} $(expr $2 - 1)\n"
	fi
}

function isFood(){
	#$1 coluna, $2 linha, $3 jogador
	num_col_atual=${numeros[$1]}
	if hasThreat $1 $2 $3 1 1 ; then
		return 0
	elif hasThreat $1 $2 $3 1 -1 ; then
		return 0
	elif hasThreat $1 $2 $3 -1 1 ; then
		return 0
	elif hasThreat $1 $2 $3 -1 -1 ; then
		return 0
	else
		return 1
	fi
}

function getFoods(){
	#$1 coluna, $2 linha, $3 jogador	
	num_col_atual=${numeros[$1]}
	if isEmpty ${letras[$(expr $num_col_atual - 2)]} $(expr $2 - 2) && [ $(abs $(getValue ${letras[$(expr $num_col_atual - 1)]} $(expr $2 - 1))) -eq  $(otherPlayer $3) ]; then
		echo -e "${letras[$(expr $num_col_atual - 2)]} $(expr $2 - 2) ${letras[$(expr $num_col_atual - 1)]} $(expr $2 - 1)\n"
	fi
	if isEmpty ${letras[$(expr $num_col_atual - 2)]} $(expr $2 + 2) && [ $(abs $(getValue ${letras[$(expr $num_col_atual - 1)]} $(expr $2 + 1))) -eq  $(otherPlayer $3) ]; then
		echo -e "${letras[$(expr $num_col_atual - 2)]} $(expr $2 + 2) ${letras[$(expr $num_col_atual - 1)]} $(expr $2 + 1)\n"
	fi
	if isEmpty ${letras[$(expr $num_col_atual + 2)]} $(expr $2 - 2) && [ $(abs $(getValue ${letras[$(expr $num_col_atual + 1)]} $(expr $2 - 1))) -eq  $(otherPlayer $3) ]; then
		echo -e "${letras[$(expr $num_col_atual + 2)]} $(expr $2 - 2) ${letras[$(expr $num_col_atual + 1)]} $(expr $2 - 1)\n"
	fi
	if isEmpty ${letras[$(expr $num_col_atual + 2)]} $(expr $2 + 2) && [ $(abs $(getValue ${letras[$(expr $num_col_atual + 1)]} $(expr $2 + 1))) -eq  $(otherPlayer $3) ]; then
		echo -e "${letras[$(expr $num_col_atual + 2)]} $(expr $2 + 2) ${letras[$(expr $num_col_atual + 1)]} $(expr $2 + 1)\n"
	fi
	
}

function machine(){
	#$1 jogador
	pieces=$(getPieces)
	IFS=$'\n'		
	new_col=""
	new_line=""
	for piece in $pieces
	do
		col=$(echo "$piece" | cut -f1 -d' ')
		line=$(echo "$piece" | cut -f2 -d' ')
		moves=$(getFoods $col $line $1)
		for move in $moves
		do
			new_col=$(echo "$move" | cut -f1 -d' ')
			new_line=$(echo "$move" | cut -f2 -d' ')
			col_comida=$(echo "$move" | cut -f3 -d' ')
			line_comida=$(echo "$move" | cut -f4 -d' ')
			if ! hasThreat $new_col $new_line $1 ; then				
				echo "$new_col $new_line $col_comida $line_comida"
				return
		done
		if [ "$new_col" = "" ]; then
			moves=$(getMoves $col $line)
			for move in $moves
			do
				new_col=$(echo "$move" | cut -f1 -d' ')
				new_line=$(echo "$move" | cut -f2 -d' ')
				if ! hasThreat $new_col $new_line $1 ; then					
					echo "$new_col $new_line"
					return
				fi
			done

		fi
	done
}