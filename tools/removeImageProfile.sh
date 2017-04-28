#!/bin/bash
echo "you need install ImageMagick and libpng first,continue? (y/n), check install document? (c) "
read ans
if [ ${ans} == 'y' ];
then
    currPath=`pwd`
    tools=`basename ${currPath}`
    if [ ${tools} = "tools" ];
    then
        cd ../res/gfx/
        find . -type f -name "*.png" -exec /opt/ImageMagick/bin/convert {} -strip {} \;
    else
        echo "folder name error,you need enter 'tools' directory"
        exit 1
    fi
elif [ ${ans} == 'c' ];
then
    echo "
    -------install ImageMagick ---------

    curl -O ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz 
    tar xzvf ImageMagick.tar.gz 
    cd ImageMagick-6.7.6-5 
    ./configure --prefix=/opt/ImageMagick --enable-share --enable-static LDFLAGS=\"-L/usr/lib64\" CPPFLAGS=\"-I/usr/include\" 
    make 
    sudo make install 
    

    -------install libpng---------
    
    curl -O http://www.imagemagick.org/download/delegates/libpng-x.x.xx.tar.gz (you need check gz name by yourself)
    tar xzvf libpng-x.xx.xx.tar.gz
    cd libpng.x.x.xx 
    ./configure 
    make 
    sudo make install

    -------check libpng---------
    
    /opt/ImageMagick/bin/convert -list format | grep \"PNG\"
    "
else
    echo "cancel"    
    exit 0
fi

