#!/usr/bin/python
# -*- coding: utf-8 -*-

import pyowm
import json
import rrdtool
import time

owm = pyowm.OWM('732d75c2dd14b88ef978f13b2eaea921')

# Search for current weather in Essen (DE)
observation = owm.weather_at_place('Essen,de')
w = observation.get_weather()

# Weather details
a = w.get_temperature('celsius')  # {'temp_max': 10.5, 'temp': 9.7, 'temp_min': 9.0}

# Update rrd
out_owm0 = 'N:'+ str(a['temp'])
rrdtool.update('/home/temp/tempsensor/temp_outdoor_owm.rrd',out_owm0)
