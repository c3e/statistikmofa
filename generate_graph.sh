#!/bin/bash
RRDPATH="/home/temp/tempsensor"
RAWCOLOUR="#FF0000"
TRENDCOLOUR="#0000FF"

#Stunde
rrdtool graph $RRDPATH/hour.png --start -6h \
DEF:temp0=$RRDPATH/temperature.rrd:temp0:AVERAGE \
CDEF:trend=temp0,1800,TREND \
LINE1:temp0$RAWCOLOUR:"Stündlich" \

#Tag
rrdtool graph $RRDPATH/day.png --start -1d \
DEF:temp0=$RRDPATH/temperature.rrd:temp0:AVERAGE \
CDEF:trend=temp0,21600,TREND \
LINE1:temp0$RAWCOLOUR:"Täglich" \

#Woche
rrdtool graph $RRDPATH/week.png --start -1w \
DEF:temp0=$RRDPATH/temperature.rrd:temp0:AVERAGE \
LINE1:temp0$RAWCOLOUR:"Wöchentlich" \

#Monat
rrdtool graph $RRDPATH/month.png --start -1m \
DEF:temp0=$RRDPATH/temperature.rrd:temp0:AVERAGE \
LINE1:temp0$RAWCOLOUR:"Monatlich" \

#Jahr
rrdtool graph $RRDPATH/year.png --start -1y \
DEF:temp0=$RRDPATH/temperature.rrd:temp0:AVERAGE \
LINE1:temp0$RAWCOLOUR:"Bällebad" \

#Grafiken auf Webserver kopieren
cp /home/temp/tempsensor/*.png /var/www/data
