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

getDiagonalPieces(){
	#return all pieces on the diagonal between positions b = beign, e = end
	awk -v bcol=$1 -v brow=$2 -v ecol=$3 -v erow=$4 'BEGIN{
		letras["a"] = 1;letras["b"] = 2;letras["c"] = 3;letras["d"] = 4;
		letras["e"] = 5;letras["f"] = 6;letras["g"] = 7;letras["h"] = 8;
		i=0;
	}{
		if(brow < erow){
			if(letras[bcol] < letras[ecol]){
				if(NR>=brow && NR <= erow){
					for(k in letras)
						if (letras[bcol] + i == letras[k]){
							#print k,NR
							pieces[i] = $(letras[bcol]+i)
						}
					i++				
				}
			}else if(letras[bcol] > letras[ecol]){
				if(NR>=brow && NR<=erow){					
					for(k in letras){
						if (letras[bcol] - i == letras[k]){
							#print k,NR
							pieces[i] = $(letras[bcol]-i)
						}	
					}
					i++				
				}			
			}
		}else if (brow > erow){
			if(letras[bcol] < letras[ecol]){
				if(NR<=brow && NR >=erow){
					for(k in letras)
						if (letras[ecol] - i == letras[k]){
							#print k,NR
							pieces[i] = $(letras[bcol]-i)
						}						
					i++				
				}
			}else if(letras[bcol] > letras[ecol]){
				if(NR<=brow && NR >=erow){					
					for(k in letras){
						if (letras[ecol] + i == letras[k]){
							#print k,NR
							pieces[i] = $(letras[bcol]+i)						
						}
					}
					i++				
				}			
			}
		}
	}' board.txt
}

countPieces(){
	awk -v p=$1 'BEGIN{
		counter=0
		letras["a"] = 1;letras["b"] = 2;letras["c"] = 3;letras["d"] = 4;
		letras["e"] = 5;letras["f"] = 6;letras["g"] = 7;letras["h"] = 8;
	}{
		for(i=1;i<=NF;i++){
			currentP = $i >=0?$i:-1*$i;
			if(currentP == p)
				counter++;		
		}	
	}END{
		print counter		
	}' board.txt
}




























#
#
#
