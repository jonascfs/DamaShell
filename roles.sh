#!/bin/bash
# MACROS
VAZIO="0"
JOGADOR1="1"
DAMAJOGADOR1="-1"
JOGADOR2="2"
DAMAJOGADOR2="-2"

function abs(){
	if [ "$1" -lt 0 ]
	then
		echo "$(expr $1 \* -1)"
	else
		echo "$1"
	fi
	
}

#analisa se eh uma 
function isPosition(){
	#$1 letra da coluna, $2 numero da linha
	if [[ "$1" =~ [a-h] ]] && [[ "$2" =~ [1-8] ]]; then
		return 0 #true		
	else
		return 1 #false
	fi
}

#analisa se a posicao da nova jogada eh uma posicao da diagonal correta
#Eh assumido que ja foi verificado se a celula eh vazia e as posicoes sao validas
function isCorrectPosition(){
	#$1 coluna atual, #$2 linha atual, #$3 nova coluna, #$4 nova linha, $5 jogador da vez
	declare -a letras
	declare -A numeros	
	letras=(x a b c d e f g h)
	n="0"

	for i in ${letras[@]}
	do
		numeros[$i]=$n
		n=$(expr $n + 1)	
	done

	num_col_atual=${numeros[$1]}
	num_col_nova=${numeros[$3]}

	if[ $5 == $JOGADOR1 ]; then
		if [ $2 -eq $(expr $4 - 1) ]; then			
			#analisar se a coluna esta correta
			return [ $num_col_atual -eq $(expr $num_col_nova - 1) ]	|| [ $num_col_atual -eq $(expr $num_col_nova + 1) ]	
		
		elif [ $2 -eq $(expr $4 - 2) ] && [ $num_col_atual -eq $(expr $num_col_nova - 2) ]; then
			linha_comida=$(expr $2 - 1)
			ind_col=$(expr $num_col_atual - 1)
			coluna_comida=${letras[$ind_col]}
			return [ $(abs $(getValue $coluna_comida $linha_comida)) ==  $JOGADOR2 ]

		elif [ $2 -eq $(expr $4 - 2) ] && [ $num_col_atual -eq $(expr $num_col_nova + 2) ]; then
			linha_comida=$(expr $2 - 1)
			ind_col=$(expr $num_col_atual + 1)
			coluna_comida=${letras[$ind_col]}
			return [ $(abs $(getValue $coluna_comida $linha_comida)) ==  $JOGADOR2 ]
		else 
			return 1
		fi
	else	
		if [ $2 -eq $(expr $4 + 1) ]; then
			#analisar se a coluna esta correta
			return [ $num_col_atual -eq $(expr $num_col_nova - 1) ]	|| [ $num_col_atual -eq $(expr $num_col_nova + 1) ]	
		
		elif [ $2 -eq $(expr $4 + 2) ] && [ $num_col_atual -eq $(expr $num_col_nova - 2) ]; then
			linha_comida=$(expr $2 + 1)
			ind_col=$(expr $num_col_atual - 1)
			coluna_comida=${letras[$ind_col]}
			return [ $(abs $(getValue $coluna_comida $linha_comida)) ==  $JOGADOR1 ]

		elif [ $2 -eq $(expr $4 + 2) ] && [ $num_col_atual -eq $(expr $num_col_nova + 2) ]; then
			linha_comida=$(expr $2 + 1)
			ind_col=$(expr $num_col_atual + 1)
			coluna_comida=${letras[$ind_col]}
			return [ $(abs $(getValue $coluna_comida $linha_comida)) ==  $JOGADOR1 ]
		else 
			return 1
		fi
	fi

	

}

function isCorrectMove(){
	#$1 coluna atual, #$2 linha atual, #$3 nova coluna, #$4 nova linha, $5 jogador da vez
	if [ isPosition $1 $2 ] && [ $(abs $(getValue $1 $2)) ==  $5 ] && [ isEmpty $3 $4 ]
	then
		return

	fi

}

function isEmpty(){	
	if [ isPosition $3 $4 ] && [ $(getValue $1 $2) == $VAZIO ]; then
		return 0
	else
		return 1
	fi
}

isCorrectPosition

# while [[ true ]]; do
# 	read x

	# read y
	# if isPosition $x $y 
	# if isEmpty 1 2
	# 	then
	# 		echo "true"
	# 	else 
	# 		echo "false"
	# fi
#done
