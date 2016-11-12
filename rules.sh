#!/bin/bash
source util.sh
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

function otherPlayer(){
	if [ $1 -eq $JOGADOR1 ]; then
		echo $JOGADOR2
	else
		echo $JOGADOR1
	fi
}

#analisa se eh uma 
function hasPosition(){
	#$1 letra da coluna, $2 numero da linha
	if [[ "$1" =~ [a-h] ]] && [[ $2 =~ [1-8] ]]; then
		return 0 #true		
	else
		return 1 #false
	fi
}

function hasFood(){
	#$1 coluna atual, $2 linha atual, $3 jogador
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
	if [ isEmpty $(expr $num_col_atual - 2) $(expr $2 - 2) ] && [ $(abs $(getValue ${letras[$(expr $num_col_atual - 1)]} $(expr $2 - 1))) -eq  $(otherPlayer $3) ]; then
		return 0
	elif [ isEmpty $(expr $num_col_atual - 2) $(expr $2 + 2) ] && [ $(abs $(getValue ${letras[$(expr $num_col_atual - 1)]} $(expr $2 + 1))) -eq  $(otherPlayer $3) ]; then
		return 0
	elif [ isEmpty $(expr $num_col_atual + 2) $(expr $2 - 2) ] && [ $(abs $(getValue ${letras[$(expr $num_col_atual + 1)]} $(expr $2 - 1))) -eq  $(otherPlayer $3) ]; then
		return 0
	elif [ isEmpty $(expr $num_col_atual + 2) $(expr $2 + 2) ] && [ $(abs $(getValue ${letras[$(expr $num_col_atual + 1)]} $(expr $2 + 1))) -eq  $(otherPlayer $3) ]; then
		return 0
	else 
		return 1
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

	if [ $5 -eq $JOGADOR1 ] && [ $4 -eq $(expr $2 - 1) ]
	then
		if [ $num_col_nova -eq $(expr $num_col_atual - 1) ] || [ $num_col_nova -eq $(expr $num_col_atual + 1) ]; then
			echo "true"
		else 
			echo "false"
		fi
	elif [ $5 -eq $JOGADOR2 ] && [ $4 -eq $(expr $2 + 1) ]; then
		if [ $num_col_nova -eq $(expr $num_col_atual - 1) ]	|| [ $num_col_nova -eq $(expr $num_col_atual + 1) ]; then
			echo "true"
		else 
			echo "false"
		fi
	elif [ $4 -eq $(expr $2 - 2) ] && [ $num_col_nova -eq $(expr $num_col_atual - 2) ]; then
		linha_comida=$(expr $2 - 1)
		ind_col=$(expr $num_col_atual - 1)
		coluna_comida=${letras[$ind_col]}
		if [ $(abs $(getValue $coluna_comida $linha_comida)) -eq  $(otherPlayer $5) ]; then
			echo "true $coluna_comida $linha_comida"	
		else 
			echo "false"
		fi
	elif [ $4 -eq $(expr $2 - 2) ] && [ $num_col_nova -eq $(expr $num_col_atual + 2) ]; then
		linha_comida=$(expr $2 - 1)
		ind_col=$(expr $num_col_atual + 1)
		coluna_comida=${letras[$ind_col]}
		if [ $(abs $(getValue $coluna_comida $linha_comida)) -eq $(otherPlayer $5) ]; then
			echo "true $coluna_comida $linha_comida"
		else 
			echo "false"
		fi
	elif [ $4 -eq $(expr $2 + 2) ] && [ $num_col_nova -eq $(expr $num_col_atual - 2) ]; then
		linha_comida=$(expr $2 + 1)
		ind_col=$(expr $num_col_atual - 1)
		coluna_comida=${letras[$ind_col]}
		if [ $(abs $(getValue $coluna_comida $linha_comida)) -eq  $(otherPlayer $5) ]; then
			echo "true $coluna_comida $linha_comida"	
		else 
			echo "false"
		fi
	elif [ $4 -eq $(expr $2 + 2) ] && [ $num_col_nova -eq $(expr $num_col_atual + 2) ]; then
		linha_comida=$(expr $2 + 1)
		ind_col=$(expr $num_col_atual + 1)
		coluna_comida=${letras[$ind_col]}
		if [ $(abs $(getValue $coluna_comida $linha_comida)) -eq $(otherPlayer $5) ]; then
			echo "true $coluna_comida $linha_comida"
		else 
			echo "false"
		fi
	else 
		echo "false"
	fi
		
}

function isCorrectMove(){
	#$1 coluna atual, #$2 linha atual, #$3 nova coluna, #$4 nova linha, $5 jogador da vez
	if  hasPosition $1 $2  && [ $(abs $(getValue $1 $2)) -eq $5 ] && isEmpty $3 $4   
	then
		isCorrectPosition $1 $2 $3 $4 $5
	else
		echo "false"
	fi

}

function isEmpty(){	
	if hasPosition $1 $2 && [ $(getValue $1 $2) -eq $VAZIO ]; then
		return 0
	else
		return 1
	fi
}


# while [[ true ]]; do
# 	read x

	# read y
	# if hasPosition $x $y 
	# if isEmpty 1 2
	# 	then
	# 		echo "true"
	# 	else 
	# 		echo "false"
	# fi
#done

#if isCorrectMove b 6 a 5 1
# if isCorrectPosition b 6 a 5 1 
# then
# 	echo "foi :)"
# else
# 	echo "não :("
# fi