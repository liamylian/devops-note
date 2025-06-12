#!/bin/bash

VM=mongodb
WD=/home/liam/VMs/mongodb


# Generate keyfile if it doesn't exist
if [ ! -f "$WD/mongodb-keyfile" ]; then
    sudo openssl rand -base64 756 > "$WD/mongodb-keyfile"
    sudo chmod 400 "$WD/mongodb-keyfile"
    sudo chown 999:999 "$WD/mongodb-keyfile"
fi

sudo docker rm -f $VM

sudo docker run -d \
  --name $VM \
  --hostname mongodb \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD=changeme \
  -v $WD/data:/data/db \
  -v $WD/mongodb-keyfile:/etc/mongodb-keyfile \
  -p 27017:27017 \
  mongo:7.0.5 \
  --replSet rs0 \
  --keyFile /etc/mongodb-keyfile \
  --auth \
  --bind_ip_all

# 初始化副本集（必须步骤！）
sudo docker exec -it $VM mongosh -u root -p changeme --eval "rs.initiate()"

# rs.reconfig({
#   _id: "rs0", version: 1,
#   members: [
#     { _id: 0, host: "mongodb:27017" }  
#   ]
# }, { force: true })
