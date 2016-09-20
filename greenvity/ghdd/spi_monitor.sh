#! /bin/bash
#
# Montior SPI Interface  - Send secmode command to SPI. The Parent script(track_host.sh) 
#			   monitor the traffice on SPI using ifconfig.
#


if [ ! -f /opt/greenvity/ghdd/spi_monitor.txt ]; then
	touch /opt/greenvity/ghdd/spi_monitor.txt
fi

while [ true ]; do
	/opt/greenvity/ghdd/ghdd_cli_imx287.out secmode > /opt/greenvity/ghdd/spi_monitor.txt
	sleep 1
done

