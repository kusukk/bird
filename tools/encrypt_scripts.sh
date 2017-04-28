#!/bin/bash
if [ ! -d ../csrc ]; then
	mkdir ../csrc
fi
cocos luacompile -s ../src -d ../csrc -e --disable-compile -k mybo-blast -b mybo-cs---107
