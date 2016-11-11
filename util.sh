#!/bin/bash

initBoard(){
echo -e "2 0 2 0 2 0 2 0
0 2 0 2 0 2 0 2
2 0 2 0 2 0 2 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 1 0 1 0 1 0 1
1 0 1 0 1 0 1 0
0 1 0 1 0 1 0 1" > board.txt

}

getValue(){
	awk -v col=$1 -v row=$2 'BEGIN{
		letras["a"] = 1;letras["b"] = 2;letras["c"] = 3;letras["d"] = 4;
		letras["e"] = 5;letras["f"] = 6;letras["g"] = 7;letras["h"] = 8;
	}{
		if(NR == row){
			print $letras[col]		
		}
	}' board.txt 
}

setValue(){
	newBoard=$(awk -v col=$1 -v row=$2 -v val=$3 'BEGIN{
		letras["a"] = 1;letras["b"] = 2;letras["c"] = 3;letras["d"] = 4;
		letras["e"] = 5;letras["f"] = 6;letras["g"] = 7;letras["h"] = 8;
	}{
		if(NR == row){
			for(i=1;i<=NF;i++){
				if(i == letras[col]){
					printf("%d", val)
				}else{
					printf("%d", $i)
				}
				if(i<NF) printf(" ");
			}
			printf("\n")
		}else{
			print $0		
		}
		
	}' board.txt)
	echo -e "$newBoard" > board.txt
}
#
#
#
