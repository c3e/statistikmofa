#!/usr/bin/python
# -*- coding: utf-8 -*-

import re, os, rrdtool, time, requests

# define url for widgets
widgets = [
"http://docker.chaospott.de:3030/widgets/temp_baellebad"
]

# define pathes to 1-wire sensor data
# Sensor1: Bällebad

pathes = [
"/sys/bus/w1/devices/28-00000609cfcd/w1_slave"
]

sensor_values = []

# function: read and parse sensor data file
def read_sensor(path):
	value = "U"
	try:
		f = open(path, "r")
		line = f.readline()
		if re.match(r"([0-9a-f]{2} ){9}: crc=[0-9a-f]{2} YES", line):
			line = f.readline()
			m = re.match(r"([0-9a-f]{2} ){9}t=([+-]?[0-9]+)", line)
			if m:
				value = float(m.group(2)) / 1000.0
		f.close()
	except (IOError), e:
		print time.strftime("%x %X"), "Error reading", path, ": ", e
	return value

def get_sensor_values():
	for path in pathes:
		sensor_values.append(read_sensor(path))
		time.sleep(1)
		
def update_rrd():
	data = "N"
	for value in sensor_values:
		data += ":"
		data += str("{:.2f}".format(value))
		#insert data into round-robin-database
		rrdtool.update("%s/temperature.rrd" % (os.path.dirname(os.path.abspath(__file__))), data)

def update_dashboard():
	for i, url in enumerate(widgets):
		temp = "{:.2f}".format(sensor_values[i])
		payload = { "auth_token": "42foobar23", "current": temp}
		r = requests.post(url, json=payload)

get_sensor_values()
update_rrd()
update_dashboard()

exit(0)
