#!/usr/bin/env python
# coding=utf-8

import os

lang_lua_path='../../src/app/language/iosSourceFile'
lang_lua_folder=["de","en","es","fr","it","ja","ko","pt","ru","tr","zh"]
lang_lua_file='Localizable.lua'
lang_ios_path='../../frameworks/runtime-src/proj.ios_mac/ios'
lang_ios_folder=["de.lproj","en.lproj","es.lproj","fr.lproj","it.lproj","ja.lproj","ko.lproj","pt.lproj","ru.lproj","tr.lproj","zh-Hans.lproj"]
lang_ios_file='Localizable.strings'

def loadFile(filePath):
	fileData = None
	if os.path.exists(filePath):
		file_object = open(filePath)
		try:
		    fileData = file_object.readlines()
		finally:
		     file_object.close()
	else:
		print(' filePath {} not exist!'.format(filePath))

	return fileData

def loadLuaFile(luaLangFolder):
	data=loadFile(lang_lua_path +'/' + luaLangFolder + '/' + lang_lua_file)
	lua_dict={}
	if data: 
		for line in data:
			sp=line.split('=')
			if len(sp) == 2:
				lua_dict[sp[0].strip().strip('[]')]=sp[1].strip().strip(',').strip()
				# print('key:{} value:{}'.format(sp[0].strip().strip('[]'),sp[1].strip().strip(',').strip()))
	else:
		print('get lua lang file data {} failed!'.format(luaLangFolder))

	return data,lua_dict

def loadIOSFile(iosLangFolder):
	data=loadFile(lang_ios_path +'/' + iosLangFolder + '/' + lang_ios_file)
	ios_dict={}
	if data:
		data_len=len(data)
		for i in range(data_len):
			sp=data[i].split('=')
			if len(sp) == 2:
				ios_dict[sp[0].strip()]=i
	else:
		print('get ios lang file data {} failed!'.format(iosLangFolder))
	return data,ios_dict

def saveIOSFile(data,iosLangFolder):
	file_object = open(lang_ios_path +'/' + iosLangFolder + '/' + lang_ios_file,'w')
	for i in data:
	    file_object.write(i)
	file_object.close()

def make(lua_dict_data,ios_dict_data,ios_source_data):
	for k,v in lua_dict_data.items():
		if k in ios_dict_data:
			ios_source_data[ios_dict_data[k]] ='{} = {};\n'.format(k,v)

def checkConfig():
	return len(lang_lua_folder) == len(lang_ios_folder)

def run():
	count=len(lang_lua_folder)
	for i in range(count):
		lua_source_data,lua_dict_data=loadLuaFile(lang_lua_folder[i])
		ios_source_data,ios_dict_data=loadIOSFile(lang_ios_folder[i])
		make(lua_dict_data,ios_dict_data,ios_source_data)
		saveIOSFile(ios_source_data,lang_ios_folder[i])

def main():
	if checkConfig() :
		run()
	else:
		print('lua language config counts was different with ios language config counts!')

if __name__=='__main__':
	main()
