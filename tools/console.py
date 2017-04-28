#coding=utf-8
import os
import subprocess
import socket
import sys
import threading
import base64
import hashlib
from thread import *
print "欢迎使用:"




print "开始生成 md5表"
sep = os.sep #根据unix或win，s为\或/
root = os.getcwd()+sep+"ab-blast"+ sep + "src" + sep+"app" #要遍历的目录

rootfile =os.getcwd()+sep+"Desktop"+sep+"Version.lua"

# key value
md5Dir = {}


rKey =[];

rloadKey = [
    "/Users/wangqiang/ab-blast/src/app/mapscene/MapSceneUI.lua",
    "/Users/wangqiang/ab-blast/src/app/mapscene/MapScene.lua",
    "/Users/wangqiang/ab-blast/src/app/common/HpBar.lua",
];

# 查找路径
rootStr =os.getcwd()+sep+"ab-blast"+ sep + "src"

def ergodicMd5(typeS):
# 遍历文件
    global rKey
    global md5Dir
    root1 = root
    container ={}
    for root1,subdirs,files in os.walk(root1):
        for filepath in files:
            url =os.path.join(root1,filepath)
            files=open(url, 'r')
            files_str = files.read()
            files.close()
            m2 = hashlib.md5()
            m2.update(files_str)
            md5_str =m2.hexdigest()
            container[url] =md5_str
            if typeS ==1:
                if not container[url] == md5Dir[url]:
                    rKey.append(url)
                    pass
                pass
            elif typeS ==2:
                rKey.append(url)
    md5Dir =container


ergodicMd5(0)
print "md5表完成"

def startUpLoad():
    ergodicMd5(1)

def startUpLoadAll():
    ergodicMd5(2)

def addInput():
    bc = raw_input()
    return bc

def sendOn(st):
    st.send("fps on")

def upLoad(s):
    global rKey
    # if len(rKey)==0:
    #     s.send("fps on ")
    #     return
    value =rKey[0]
    print (rKey)
    files=open(value, 'r')
    xcx =value[len(rootStr):]
    strs ='upload'+' '+xcx+' '+base64.b64encode(files.read())+"\r\n"
    files.close()
    s.send(strs)
    data = s.recv(4025)
    print ('2' ,data)
    reload(s,value)
    rKey.pop(0)
    if len(rKey)<=0:
        data = s.recv(4025)
        print ('3' ,data)
        reloadAll(s)
        pass


def reloadAll(s):
    global rloadKey
    for value in rloadKey:
        reload(s,value)
        pass
    s.send("rscene \r\n ")

def reload(s,value):
    xcx = value[len(rootStr)+1:]
    ags =xcx.split('.')

    # ags =value.split('/')
    l =list(ags[0])
    for index, item in enumerate(l):
        if item =='/':
            l[index] = '.'

    newS = ''.join(l)
    findstr = "popupview"
    a=newS.find(findstr)
    a+10
    if a>= 0:
        newS = newS[a+10:]

    print (newS,"s")

    s.send("reload "+newS+"\r\n ")


def mybolog(s):
    s.send("mybolg "+"\r\n ")


def hotfile():
    files=open(rootfile, 'r')
    ags = files.readlines()
    files.close()
    global rKey
    for value in ags:
        num1 = value.rfind("\r")
        num2 = value.rfind("\n")
        num1 =num1<0 and 1000 or num1
        num2 =num2<0 and 1000 or num2
        print value[:num1>num2  and num2 or num1]
        rKey.append(value[:num1>num2 and num2 or num1])



def clientthread():
    global s
    global rKey
    # global md5Dir
    # while True:
    data = s.recv(4025)
    print ('1',data)
    print len(rKey)
    if len(rKey)>0:
        upLoad(s)
    else:
        strs =addInput()
        if strs=='':
            strs = "uphot "
            pass
        ags =strs.split(' ')
        if ags[0] =="upload":
            print ags[1]
            ags[1]='/ab-blast/res_ios/map/map-4/tower/map-2.json'
            files=open(os.getcwd() + ags[1] , 'r')
            strs =ags[0]+' '+ags[1]+' '+base64.b64encode(files.read())+"\r\n"
            files.close()
            print strs
            s.send(strs)
            # strs = ags[0]+' /'+os.getcwd() + ags[1]+"\r\n"
            # print strs
            # s.send(strs)

            pass
        elif ags[0] == "uphot" :
            # reloadAll(s)
            lomd5Dir =startUpLoad()
            if len(rKey)> 0:
                upLoad(s)
                md5Dir=lomd5Dir
            else:
                s.send("fps on\r\n")
        elif ags[0] == "hotall" :

            lomd5Dir =startUpLoadAll()
            upLoad(s)
            md5Dir=lomd5Dir
        elif ags[0] == "filehot":
            hotfile()
            upLoad(s)
            pass
        elif ags[0] =="reload":
            reload(s,ags[1])
        elif ags[0] =="mybolog":
            mybolog(s)
        else:
            print('13')
            s.send(strs+"\r\n")
    # s.close()


print "输入 配对的手机 ip"
host = addInput()
print host
if host=="":
    host='192.168.16.31'
port = 5678

try:
    #create an AF_INET, STREAM socket (TCP)
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error, msg:
    print 'Failed to create socket. Error code: ' + str(msg[0]) + ' , Error message : ' + msg[1]
    sys.exit();

print 'Socket Created'


try:
    remote_ip = socket.gethostbyname( host )

except socket.gaierror:
    #could not resolve
    print 'Hostname could not be resolved. Exiting'
    sys.exit()

print 'Ip address of ' + host + ' is ' + remote_ip

s.connect((remote_ip , port))

while True:
    clientthread()


# def inputthread(s):
#     bc = raw_input()
#     # threadLock.acquire()
#     s.send(bc)
#     # threadLock.release()
#     # print sendStr
#     inputthread(s)
#
#
# start_new_thread(inputthread,(s,))



# inputthread()
