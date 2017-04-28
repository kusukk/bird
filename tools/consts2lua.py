# -*- coding:utf-8 -*-
import os
import re

path_in = '../frameworks/runtime-src/Classes/game/gameboard/consts.h'
path_out = '../src/app/consts.lua'
file_in_obj = open(path_in)
file_out_obj = open(path_out,'w')
lines = file_in_obj.readlines()
file_in_obj.close()
pattern = re.compile(r'\w+\s*=\s*\"?\w+\"?')
out = ''
for line in lines:
	line = line.strip()
	if len(line) > 2 :
		if line[0] != '/' or line[1] != '/' :
			rt = re.findall(pattern,line)
			if len(rt) > 0:
				out += rt[0] + '\n'
file_out_obj.write(out)
file_out_obj.close()
