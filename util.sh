#!/bin/bash

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

