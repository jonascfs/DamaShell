#!/bin/bash
#CAUTION! THIS FILE CONTANIS A VERY BAD ENGLISH!


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
	#the return(separeted by " "): value from 1ºposition 2ºposition pieces beetween(withot 0)
	awk -v bcol=$1 -v brow=$2 -v ecol=$3 -v erow=$4 'BEGIN{
		letras["a"] = 1;letras["b"] = 2;letras["c"] = 3;letras["d"] = 4;
		letras["e"] = 5;letras["f"] = 6;letras["g"] = 7;letras["h"] = 8;
		i=0;
	}{
		if(brow < erow){
			upSideDown = "false";
			if(letras[bcol] < letras[ecol]){
				if(NR>=brow && NR <= erow){
					for(k in letras)
						if (letras[bcol] + i == letras[k]){
							#print k,NR
							pieces[i] = $(letras[bcol]+i);
							lastR = NR;
							lastC = k;
							coordC[i] = k;
							coordR[i] = NR;
						}
					i++				
				}
			}else if(letras[bcol] > letras[ecol]){
				if(NR>=brow && NR<=erow){					
					for(k in letras){
						if (letras[bcol] - i == letras[k]){
							#print k,NR
							pieces[i] = $(letras[bcol]-i);
							lastR = NR;
							lastC = k;
							coordC[i] = k;
							coordR[i] = NR;
						}	
					}
					i++				
				}			
			}
		}else if (brow > erow){
			upSideDown = "true";
			if(letras[bcol] < letras[ecol]){
				if(NR<=brow && NR >=erow){
					for(k in letras)
						if (letras[ecol] - i == letras[k]){
							#print k,NR
							pieces[i] = $(letras[ecol]-i);
							lastR = NR;
							lastC = k;
							coordC[i] = k;
							coordR[i] = NR;
						}						
					i++				
				}
			}else if(letras[bcol] > letras[ecol]){
				if(NR<=brow && NR >=erow){					
					for(k in letras){
						if (letras[ecol] + i == letras[k]){
							#print k,NR;
							pieces[i] = $(letras[ecol]+i);
							lastR = NR;
							lastC = k;
							coordC[i] = k;
							coordR[i] = NR;
						}
					}
					i++				
				}			
			}
		}
	}END{	
		if(upSideDown == "false" && lastR == erow && lastC == ecol){
			printf("%d %d ",pieces[0], pieces[i-1]);
			for(j=1;j<i-1;j++){
				if(pieces[j] != 0)
					printf("%d_%s_%d ", pieces[j],coordC[j],coordR[j]);
			}
			printf("\n");
		}else if(upSideDown == "true" && lastR == brow && lastC == bcol){
			printf("%d %d ",pieces[i-1], pieces[0]);
			for(j=i-2;j>0;j--){
				if(pieces[j] != 0)
					printf("%d_%s_%d ", pieces[j],coordC[j],coordR[j]);
			}
			printf("\n");
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

getPieces(){
	awk -v p=$1 'BEGIN{
		letras["a"] = 1;letras["b"] = 2;letras["c"] = 3;letras["d"] = 4;
		letras["e"] = 5;letras["f"] = 6;letras["g"] = 7;letras["h"] = 8;
		
		rev[1] = "a";rev[2] = "b";rev[3] = "c";rev[4] = "d";
		rev[5] = "e";rev[6] = "f";rev[7] = "g";rev[8] = "h";
	}{
		for(i=1;i<=NF;i++){
			currentP = $i >=0?$i:-1*$i;
			if(currentP == p)
				print rev[i],NR		
		}	
	}END{
		print counter		
	}' board.txt
}

possibleEatingPositions(){
#this functions returns all the possible positions for a dama move after "eat" an oponent
#D1      D2
#  .   .
#    p
#  .   .
#D3      D4

	awk -v col=$1 -v row=$2 -v p=$3 'BEGIN {
		letras["a"] = 1;letras["b"] = 2;letras["c"] = 3;letras["d"] = 4;
		letras["e"] = 5;letras["f"] = 6;letras["g"] = 7;letras["h"] = 8;
		
		rev[1] = "a";rev[2] = "b";rev[3] = "c";rev[4] = "d";
		rev[5] = "e";rev[6] = "f";rev[7] = "g";rev[8] = "h";
		
		oponent=(p==1)?2:1;
	}{
		if(NR < row){
			for(i=1;i<=NF;i++){
				current =$i>=0?$i:-1*$i;
				#D1				
				if(i == letras[col] - (row - NR)){
					valuesD1[NR] = current;
					columnsD1[NR] = i;
				#D2
				}else if(i == letras[col] + (row - NR)){
					valuesD2[NR] = current;
					columnsD2[NR] = i;
				}	
			}					
		}else if(NR == row){
			blockD4 = 0;
			oponentCountD4 = 0;
			blockD3 = 0;
			oponentCountD3 = 0;
		}else{
			for(i=1;i<=NF;i++){
				current =$i>=0?$i:-1*$i;
				#D4
				if(i == (NR - row) + letras[col]){
					if(current == p)
						blockD4 = 1;
					else if(current == oponent)
						oponentCountD4++;					
				
					if(!blockD4 && oponentCountD4 == 1 && current == 0){
						print rev[i],NR;
					}

				#D3
				}else if(i == letras[col] - (NR - row)){
					if(current == p)
						blockD3 = 1;
					else if(current == oponent)
						oponentCountD3++;					
				
					if(!blockD3 && oponentCountD3 == 1 && current == 0){
						print rev[i],NR;
					}		
				}
			}
		}
	}END{
		blockD1 = 0;
		oponentCountD1 = 0;
		blockD1 = 0;
		oponentCountD2 = 0;
		for(i=row-1;i>=1;i--){
			#D1
			if(valuesD1[i] == p)
				blockD1 = 1
			else if(valuesD1[i] == oponent)
				oponentCountD1++;
			
			if(!blockD1 && oponentCountD1 == 1 && valuesD1[i] == 0)
				print rev[columnsD1[i]],i;
			#D2
			if(valuesD2[i] == p)
				blockD2 = 1
			else if(valuesD2[i] == oponent)
				oponentCountD2++;
			
			if(!blockD2 && oponentCountD2 == 1 && valuesD2[i] == 0)
				print rev[columnsD2[i]],i;					
		}
	}' board.txt
}


#
#
#
