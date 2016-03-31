#!/bin/bash
#set -e

if [ ! -e /var/www/data/temp_data ];
then
    mkdir /var/www/data/temp_data
fi

wget -O /var/www/data/temp_data/stadion.jpg  http://stadion-essen.de/webcams/cam2/aktuell.jpg \
&& jpegoptim --strip-all /var/www/data/temp_data/stadion.jpg \
&& mogrify -resize 497x /var/www/data/temp_data/stadion.jpg \
&& cp /var/www/data/temp_data/stadion.jpg /var/www/data/stadion.jpg

wget -O /var/www/data/temp_data/printer.jpg http://10.42.1.200:8080/?action=snapshot

if [ ! $? -eq 0 ];
then
	cp ~/tempsensor/printer.jpg /var/www/data/temp_data/printer.jpg
fi

mogrify -resize 497x -rotate 180 /var/www/data/temp_data/printer.jpg \
&& jpegoptim --strip-all /var/www/data/temp_data/printer.jpg \
&& convert /var/www/data/temp_data/printer.jpg  -gravity north -background black -box black -fill white -pointsize 12 -gravity southwest -annotate +5+5 'Made with fairydust.' -gravity southeast -annotate +5+5 "Last update: `ddate +'%A'` `date +%H:%M`" -quality 99% /var/www/data/printer.jpg
