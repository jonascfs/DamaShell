#!/bin/bash
source util.sh


function draw_board(){
  clear
  vetor=(_ a b c d e f g h)

  for (( i=0 ; i<=8; i++ ))
  do

     for (( k=0 ; k<=8; k++ ))
     do

        if [ $i -eq 0 ]
        then
            if [ $k -eq 0 ]
            then
              echo -e -n "  "    
            else
              echo -e -n "${vetor[$k]} "
            fi
            
        elif [ $k -eq 0 ]
        then
          echo -e "\033[0m"
          echo -e -n "$i "
        
        else
          c=`expr $((i+k)) %  2`
          
          r=$(getValue ${vetor[$k]} $i)
          if [ $c -eq 0 ]
          then

            if [ $r -eq 0 ]
            then
              texto=$(echo " ")
            elif [ $r -eq 1 ]
            then
              tput setaf 130
              texto=$(echo "◉")
            elif [ $r -eq 2 ]
            then
              tput setaf 7
              texto=$(echo "◉")
            elif [ $r -eq -1 ]
            then
                tput setaf 130
                texto=$(echo "✪")
            elif [ $r -eq -2 ]
            then
                tput setaf 7
                texto=$(echo "✪")
            fi

            tput setab 0
            echo -n "$texto "   # Black background

          else
            tput setab 7
            tput setaf 10
            echo -n "  "   # White background
          fi
        fi 

      done

  
  done
  echo -e "\033[0m"  # Restores color settings
}
