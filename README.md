## beHlidac

beHlidac je pomocnik pro sportovce, kteri radi sleduji svoje vykony.

beHlidac Vas dokaze kontrolovat pri vice aktivitach zaroven, at jde o jizdu na kole, beh ci posilovani. Nejde o zadneho ukriceneho otravu, kdyz ma dobry den, zepta se Vas jen jednou a pote uz o nem nevite. Rad se pta v cas, ktery vyhovuje Vam, proto se mu da nastavit vas oblibeny cas. Samozrejme se nemusite bat, ze si nebudete moci zapsat data, kdyz nebudete mit pocitac u sebe. beHlidac se na chybejici zaznamy dopta pri dalsim zapisu.

Bohuzel jde jeste o rozpracovanou verzi, beHlidac se zatim musi spoustet ze slozky, kam jste si ho ulozili, po kazdem vypnuti pocitace. Je to na nasem todo listu.

```

OPTIONS	
-h, --help	Vypise napovedu.
-n, --nova-akt	Zalozi novou aktivitu, kterou si prejete sledovat.

-m, --mesic	Vypise zaznam vsech Vasich cinnosti za poslednich 30 dnu.
-t, --tyden	Vypise zaznam vsech Vasich cinnosti za poslednich  7 dnu.
-p[pocet], --prumer=[pocet]
		Vypise zaznam vsech Vasich cinnosti za poslednich *pocet* dnu.

-g, --graficky	Vytvori grafove podani vsech Vasich cinnosti za casovy usek zvoleny jednim z optionu
		*p[.], m, t*

-c, --pref-cas	Nastavi cas, ve ktery se bude ptat.
--terminal	Nastavi Vami oblibeny terminal, skrz ktery se Vas bude dotazovat. 
		(implicitne je nastaveny gnome-terminal, zmena terminalu by potrebovala jeste
		 upravu zdrojoveho kodu v castech, kde se volani terminalu kona.
		
		Jde o casti: hlidac.sh - radka 35; .hlidanicko.sh - radka 4
		)

PRIKAZY
start		Spusti hlidani.
stop		Zastavi hlidani.


PRIKLAD POUZITI:	./hlidac.sh start
			./hlidac.sh -c 21:35
			./hlidac.sh -p20 -g

```
