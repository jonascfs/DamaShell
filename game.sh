#!/bin/bash
source board.sh

jogada=0

while [ true ]
do
	draw_board
	if [ `expr $jogada % 2` -eq 0 ]
	then
		say "Vez do jogador 1"
		echo "Vez do jogador 1"
		echo "Digite a origem: "
		read lo no
		echo "Digite o destino: "
		read ld nd

		echo "$lo $no $ld $nd"
	else
		echo "Vez do jogador 2"
		echo "Digite a origem: "
		read lo no
		echo "Digite o destino: "
		read ld nd

		echo "$lo $no $ $ld $nd"
	fi 

	jogada=$(expr "$jogada" + 1)

done
