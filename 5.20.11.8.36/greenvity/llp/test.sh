#./llp_cli.out -c slave -a get
while true
do
    ./llp_cli.out -c update -a get -1 01:0b:ee:bf:03:00
    sleep 0.01
    ./llp_cli.out -c update -a get -1 01:e5:63:2b:04:00
    sleep 0.01
    ./llp_cli.out -c update -a get -1 00:3e:7a:a0:08:00
    sleep 0.01        
    ./llp_cli.out -c update -a get -1 00:99:b1:7b:07:00
    sleep 0.01
    ./llp_cli.out -c stats -a get
    sleep 0.01        
done

