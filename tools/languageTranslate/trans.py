#!/usr/bin/env python
# coding=utf-8

import xlrd,sys,os

ios_project_dir='../../frameworks/runtime-src/proj.ios_mac/ios'
localizableFileName='Localizable.strings'
IOS_FILE_DICT={
	u'中文':'zh-Hans.lproj',
	u'English':'en.lproj',
	u'FR':'fr.lproj',
	u'IT':'it.lproj',
	u'Deutsch':'de.lproj',
	u'ES':'es.lproj',
	u'BRPT':'pt.lproj',
	u'Chinese-Traditional':'zh-Hant.lproj',
	u'日本語':'ja.lproj',
	u'KO':'ko.lproj',
	u'RU':'ru.lproj',
	u'Türkçe':'tr.lproj'
}
command_len=len(sys.argv)
if command_len != 3:
	print('Arguments not correct. \nTips: python trans.py /path/to/excel/file  prefix')

class Trans():
	def __init__(self,excelPath,prefix):
		self.data=None
		self.dstData=None
		self.prefix=prefix
		if os.path.exists(excelPath):
			self.data = xlrd.open_workbook(excelPath)
		else:
			print('can not find file:{}'.format(excelPath))
	def loadSourceFile(self,lang):
		self.dstData=None
		if lang in IOS_FILE_DICT:
			file_object = open(ios_project_dir+'/'+IOS_FILE_DICT[lang]+'/'+localizableFileName)
			try:
			    self.dstData = file_object.readlines()
			finally:
			     file_object.close()
		else:
			print('can not find key {} in dict {}'.format(lang.encode('utf-8'),IOS_FILE_DICT))

	def saveSourceFile(self,lang):
		print(lang)
		if self.dstData == None :
			return
		if lang in IOS_FILE_DICT:
			file_object = open(ios_project_dir+'/'+IOS_FILE_DICT[lang]+'/'+localizableFileName,'w')
			for i in self.dstData:
			    file_object.write(i)
			file_object.close()
		else:
			print('can not find key {} in dict {}'.format(lang.encode('utf-8'),IOS_FILE_DICT))

	def run(self):
		if not self.data:
			return
		for sheet_name in self.data.sheet_names():
			table = self.data.sheet_by_name(sheet_name)
			for i in xrange(1,table.ncols):
				langList=table.col_values(i)
				if len(langList) == 0:
					continue
				lang=langList[0]
				self.loadSourceFile(lang)
				tmpDict={}
				for j in xrange(1,len(langList)):
					key=self.prefix+'_'+str(j)
					content='"{}" = "{}";\n'.format(key,langList[j].encode('utf-8'))
					tmpDict[key]=content
				if self.dstData == None:
					continue

				for idx in range(len(self.dstData)):
					if len(tmpDict) == 0:
						break
					for k,v in tmpDict.items():
						if k in self.dstData[idx]:
							self.dstData[idx]=v
							tmpDict.pop(k)
							break
				self.saveSourceFile(lang)


def main():
	trans=Trans(sys.argv[1],sys.argv[2])
	trans.run()

if __name__== '__main__':
	main()

