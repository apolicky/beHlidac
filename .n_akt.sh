echo "Jmeno aktivity? "
read jmeno < /dev/tty
echo "V jakych jednotkach se meri $jmeno? "
read jednotky < /dev/tty
        
tmp=`ls .aktivity | grep "$jmeno"_"$jednotky"`
if [ -n "$tmp" ]
then
	echo "Takova aktivita uz existuje"
	sleep 1
else
	echo -n > ".aktivity/$jmeno"_"$jednotky"
       
	echo "Aktivita $jmeno s jednotkami $jednotky vytvorena."
fi
