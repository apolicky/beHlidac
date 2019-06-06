vytvor_aktivitu(){
	echo "Jmeno aktivity? "
	read jmeno < /dev/tty
	echo "V jakych jednotkach se meri $jmeno? "
	read jednotky < /dev/tty

	echo -n > ".aktivity/$jmeno"_"$jednotky"

	echo "Aktivita $jmeno s jednotkami $jednotky vytvorena."
}

dopln_nevyplnene(){

	#echo cat ------------
	#cat "$1"
	#echo end cat --------------\n

	if [ `cat "$1" | wc -l` -gt 0 ]
	then
	
	posl=`cat "$1" | tail -1 | cut -f1-3 -d":"`
	sport=`echo "$1" | cut -f1 -d"_" | cut -f2 -d"/"`
	jedn=`echo "$1" | cut -f2 -d"_"`

	den=`date +%d`
	mes=`date +%m`
	rok=`date +%Y`

	p_den=`echo "$posl" | cut -f3 -d":"`
	p_mes=`echo "$posl" | cut -f2 -d":"`
	p_rok=`echo "$posl" | cut -f1 -d":"`

	p_den=$((p_den+1))

	if [ "$posl" != "$rok:$mes:$den" ]
	then
		while [ "$p_rok" -le "$rok" ]
		do
			while [ "$p_mes" -le 12 ]
			do
				while [ "$p_den" -le 31 ]
				do
					
					if [ `echo "$p_den" | wc -m` -lt 3 ]
                                        then
                                        	p_den=0"$p_den"
                                        fi				
				
					if [ "$p_rok:$p_mes:$p_den" = "$rok:$mes:$den" ]
					then
						break 3
					else
					
					if [ "$p_den" -eq 29 ] && [ "$p_mes" -eq 2 ]
					then
						echo Na tento den se nic delat nema ";)"
						break
					else
						case "$p_mes" in
							4 | 6 | 9 | 11 )
								if [ "$p_den" -le 30 ]
								then 
									
									echo "Kolik '$jedn' jsi $p_den. $p_mes. $p_rok zvladl/a u aktivity '$sport'?"
								        read x < /dev/tty
								        echo $x > .odpoved

									udelano=`cat .odpoved`
        								rm .odpoved

									echo "$p_rok:$p_mes:$p_den:$udelano" >> "$i"

									break
								fi
								;;
							*)
								echo "Kolik '$jedn' jsi $p_den. $p_mes. $p_rok zvladl/a u aktivity '$sport'?" 

							        read x < /dev/tty
							        echo $x > .odpoved 
	
        							udelano=`cat .odpoved`
							        rm .odpoved

        							echo "$p_rok:$p_mes:$p_den:$udelano" >> "$i"

								;;

								
						esac
					fi

					fi
					p_den=$((p_den+1))
				done
				p_den=1
				p_mes=$((p_mes+1))
			done
			p_mes=1
			p_rok=$((p_rok+1))
		done

	fi

	fi
}

if [ `ls .aktivity | wc -l` -eq 0 ]
then
	echo "Neni zaznam o zadne aktivite.\
		Prejete si vytvorit novou? [Y]/N"
	read odp < /dev/tty
	case $odp in
		n* | N* )
			:
			;;
		*)
			vytvor_aktivitu && continue
			;;
	esac
fi

for i in .aktivity/*
do
	jednotky=`echo $i | cut -f2 -d"_"`
	sport=`echo $i | cut -f1 -d"_" | cut -f2 -d"/"`

	# jsou nevyplnene dny?
	
	cti=1
	
	if [ `cat "$i" | wc -l` -gt 0 ]
	then

	posl=`cat "$i" | tail -1`
	p_d=`echo $posl | cut -f3 -d":"`
	p_m=`echo $posl | cut -f2 -d":"`
	p_r=`echo $posl | cut -f1 -d":"`


	if [ "$p_r:$p_m:$p_d" = `date +%Y:%m:%d` ]
	then
		echo dnes uz bylo zapsano
		cti=0
	elif [ "$p_r" -lt `date +%Y` ] || [ "$p_m" -lt `date +%m` ] || [ "$p_d" -lt `date +%d` ]
	then
		dopln_nevyplnene "$i"
	fi
	fi

	if [ "$cti" -eq 1 ]
	then
		echo "Kolik '$jednotky' jsi dnes zvladl/a u aktivity '$sport'?"

		read x < /dev/tty
		echo $x > .odpoved

		udelano=`cat .odpoved`
		rm .odpoved

		datum=`date +%Y:%m:%d`
		echo "$datum:$udelano" >> "$i"
	fi
done

echo `date +%Y:%m:%d` > .posledni_zapis
