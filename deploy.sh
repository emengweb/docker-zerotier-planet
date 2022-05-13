#!/bin/sh
imageName="zerotier-planet"


echo "清除原有内容"
rm /opt/planet
docker stop $imageName
docker rm $imageName
docker rmi $imageName


echo "打包镜像"
docker build --network host -t $imageName .

echo "启动服务"
for i in $(lsof -i:9993 -t);do kill -2 $i;done
#docker run -d --network host --name $imageName --restart unless-stopped $imageName
docker run -d -p9993:9993/udp -p127.0.0.1:3443:3443 \
    -v ./ztncui:/opt/key-networks/ztncui/etc \
    -v ./zt1:/var/lib/zerotier-one \
    --name $imageName --restart unless-stopped $imageName
docker cp zerotier-planet:/app/bin/planet ./planet/planet
