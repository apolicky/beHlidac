usage(){
	echo "Usage: ./hlidac.sh [option | prikaz]

OPTIONS
-h, --help      Vypise napovedu.
-n, --nova-akt  Zalozi novou aktivitu, kterou si prejete sledovat.

-m, --mesic     Vypise zaznam vsech Vasich cinnosti za poslednich 30 dnu.
-t, --tyden     Vypise zaznam vsech Vasich cinnosti za poslednich  7 dnu.
-p[pocet], --prumer=[pocet]
                Vypise zaznam vsech Vasich cinnosti za poslednich *pocet* dnu.

-g, --graficky  Vytvori grafove podani vsech Vasich cinnosti za casovy usek zvoleny jednim z optionu
                *p[.], m, t*

-c, --pref-cas  Nastavi cas, ve ktery se bude ptat.
--terminal      Nastavi Vami oblibeny terminal, skrz ktery se Vas bude dotazovat.
                (implicitne je nastaveny gnome-terminal, zmena terminalu by potrebovala jeste
                 upravu zdrojoveho kodu v castech, kde se volani terminalu kona.

                Jde o casti:
                )

PRIKAZY
start           Spusti hlidani.
stop            Zastavi hlidani.

"


}

vytvor_aktivitu(){
	term=`cat .oblibeny_terminal`
	"$term" -- "./.n_akt.sh"
	 
}

pro_x_dnu(){
	dnu="$1"
	if [ "$graficky" -eq 1 ]
	then

		for i in .aktivity/*
		do
			if [ `cat "$i" | wc -l` -gt 0 ]
			then
				jmeno=`echo "$i" | cut -f1 -d":" | cut -f2 -d"/"`
				cat "$i" | tail -"$dnu" | awk '
					BEGIN { FS=":" }
					{	i++;
						printf "%d	%d.%d.%d	%d\n", i, $3,$2,$1,$4; 
					}
				' > graf_"$jmeno".dat
			fi
		done
	
		# tady uz bu nemely byt soubory bez rakdu
		for i in graf*.dat
		do

			jmeno=`echo "$i" | sed 's/graf_//' | cut -f1 -d"_"`

			max=0
			while read rad #< $i	
			do
			#	echo rad $rad	
				cislo=`echo "$rad" | tr "\t" " " | tr -s " " | cut -f3 -d" "`
				if [ "$cislo" -gt "$max" ]
				then
					max="$cislo"
				fi
			done < "$i"
			
			max=$((max+4))
	
			echo "set term png
			set output '$jmeno.png'
			set style fill solid
			set boxwidth 0.3
			plot [] [0:$max] '$i' using 1:3:xtic(2) with boxes " | gnuplot

		done

		rm -f graf*.dat

	else
		for i in .aktivity/*
		do
			p_r=`cat "$i" | wc -l`
			
			if [ "$p_r" -gt 0 ]
			then			

				soucet=0
				echo
				echo "$i" | cut -f1 -d"_" | cut -f2 -d"/"
				cat "$i" | tail -"$dnu" | awk '
					BEGIN { FS=":" }
					{ printf "%d. %d. %d: %d\n", $3, $2, $1, $4; }
				'
				for rad in `cat "$i" | tail -"$dnu"`
				do
					soucet="$soucet+$(echo $rad | cut -f4 -d":")"
				done
		
			
				if [ "$dnu" -lt $p_r ]
				then
					p_r="$dnu"
				fi 

				soucet=`echo "scale=2; ($soucet)"/"$p_r" | bc`
				echo Prumer je tedy: $soucet
			fi
		done
	fi
}






preferovany_cas="17:00"
term="gnome-terminal"
echo "$term" > .oblibeny_terminal
zobraz=""
graficky=0
za_dni=0

slozka_kde=`pwd`

if [ "$#" -eq 0 ];
then
	usage
	exit
fi

while [ "$#" -gt 0 ]
do

	case "$1" in
		-h | --help)
			usage
			exit 1
			;;
		--terminal)
			shift
			term="$1"
			echo "$term" > .oblibeny_terminal
			shift
			;;
		-c | --pref-cas)
			shift 
			tmp=`echo "$1" | grep -E "^[0-9]:[0-5][0-9]$|^1[0-9]:[0-5][0-9]$|^2[0-3]:[0-5][0-9]$"`
			if [ -n "$tmp" ]
			then
				preferovany_cas="$tmp"
				echo "$preferovany_cas" > "$slozka_kde/.ptej_se_v_cas"
			else
				echo spatny format casu 0:00 - 23:59
			fi
			shift
			;;
		-p* | --prumer=*)	
			zobraz="p"
			
			case "$1" in
				--p*)
					za_dni=`echo "$1" | sed 's/--prumer=//'`
					;;
				-p*)
					za_dni=`echo "$1" | sed 's/-p//'`	
					;;
			esac

			shift
			;;
		-m | --mesic)
			zobraz="m"
			shift
			;;
		-t | --tyden)
			zobraz="t"
			shift
			;;
		-n | --nova-akt)
			shift
			vytvor_aktivitu 
			exit
			;;

		-g | --graficky)
			graficky=1
			shift
			;;
		start)
			echo "$preferovany_cas" > "$slozka_kde"/.ptej_se_v_cas
			echo "$term" > .oblibeny_terminal
			"$slozka_kde/.hlidanicko.sh" &
			echo "$!" > "$slozka_kde"/.demon_pid
			exit
	  		;;
		stop)
			kill `cat "$slozka_kde"/.demon_pid`
			echo -n > "$slozka_kde"/.demon_pid
			shift
			exit
			;;
		*)
			usage
			exit 1
			;;
	esac
done

if [ -n "$zobraz" ]
then
	case "$zobraz" in
		m*)
			pro_x_dnu 30
			;;
		t*)
			pro_x_dnu 7
			;;
		p*)
			pro_x_dnu "$za_dni"
			;;
		*)
			:
			;;
	esac
fi

