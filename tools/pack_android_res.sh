#!/bin/bash
TOOL_DIR=$(dirname $0)
cd $TOOL_DIR
if [ ! -d "../res_android" ]; then
	mkdir ../res_android
fi
sh ./pack_images.sh android $@
