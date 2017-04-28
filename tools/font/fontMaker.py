# -*- coding:utf-8 -*-
# first: sudo easy_install biplist 
import re
import sys
from biplist import *

filename = sys.argv[1]

plist = readPlist(filename + ".plist")
frames = plist.frames
out = ""
file_content = open(filename + ".fnt",'rb')
for line in file_content:
	if line.find('info') != -1 :
		out += line
	elif line.find('common') != -1 :
		out +=line
	elif line.find('page id') != -1 :
                out += "page id=0 file=\"%s.png\"\n"%(filename)
	elif line.find('chars') != -1 :
		out +=line
	elif line.find('char id') != -1 :
		pos1 = line.rfind('"')
		pos2 = line.rfind('"',0,pos1)
		id_p1 = line.find(' ')
		id_p2 = line.find(' ',id_p1+1,len(line))
		img_num = line[pos2+1:pos1]
		img = img_num + '.png'
		try:
			imgInfo = frames[img]
			frame = imgInfo['frame']
			frame_num = re.findall(r"\d{1,}",frame)
			offset = imgInfo['offset']
			offset_num = re.findall(r"\d{1,}",offset)
			l ="char "+line[id_p1+1:id_p2]+" x="+frame_num[0]+" y="+frame_num[1]+" width="+frame_num[2]+" height="+frame_num[3]
			r = " xoffset="+offset_num[0]+" yoffset="+offset_num[1]+" xadvance="+frame_num[2]+" page=0 chnl=0 letter=\""+img_num+"\""
			out+= l + r +'\n'
		except Exception, e:
			out+=line
	else:
		out +=line
file_content.close()
output = open(filename + ".fnt",'w')
output.write(out)
output.close()
