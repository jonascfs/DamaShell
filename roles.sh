#!/bin/bash
# MACROS
VAZIO="0"
JOGADOR1="1"
DAMAJOGADOR1="-1"
JOGADOR1="2"
DAMAJOGADOR1="-2"


function isPosition(){
	if [[ "$1" =~ [a-h] ]] && [[ "$2" =~ [1-8] ]]; then
		return 0 #true		
	else
		return 1 #false
	fi
}

function isEmpty(){		
	if [ $(getValue $1 $2) == $VAZIO ]; then
		return 0
	else
		return 1
	fi
}





while [[ true ]]; do
	read x
	read y
	# if isPosition $x $y 
	if isEmpty 1 2
		then
			echo "true"
		else 
			echo "false"
	fi


done
