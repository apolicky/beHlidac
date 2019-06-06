zeptej_se(){
	term=`cat .oblibeny_terminal`
	
	"$term" -- "./.otazka.sh"
}



cd "$1"


#echo preferovany cas  je $hod:$min

while true;
do
	po_za=`cat .posledni_zapis`
	datum=`date +%Y:%m:%d`


	if [ "$po_za" != "$datum" ]
	then	
	
		min=`cat .ptej_se_v_cas | cut -f2 -d":"`
		hod=`cat .ptej_se_v_cas | cut -f1 -d":"`
	
		min_ted=`date +%M`
		hod_ted=`date +%H`

		if [ "$hod_ted" -gt "$hod" ]
		then
			zeptej_se
			sleep 600
		elif [ "$hod_ted" -eq "$hod" ] && [ "$min_ted" -ge "$min" ]
		then
			zeptej_se
			sleep 600
		else
			sleep 60
		fi

	else	
#		echo dnes uz bylo zapsano, mel bych spat.
		sleep 600
	fi
done
