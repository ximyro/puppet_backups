#! /bin/bash

# Configure
 SERVERS_PUBLIC=$2
 SERVERS_PRIVATE=$3
 FILESERVER_CONF=$1
#

 CLIENTS=( `puppetca -la | grep ^+ | cut -d '/' -f 2 | cut -d ' ' -f 2  | sed 's/"//' | sed 's/"//'`) 

 ELEMENT_COUNT=${#CLIENTS[@]}
  if [ ! -d "$SERVERS_PUBLIC" ];then
   mkdir -p $SERVERS_PUBLIC
  fi
  if [ ! -d "$SERVERS_PRIVATE" ];then
   mkdir -p $SERVERS_PRIVATE
  fi
create_backups_keys(){
  for((index=0;index<$ELEMENT_COUNT;index++))
  do
      if [ ! -d "$SERVERS_PUBLIC/${CLIENTS[${index}]}" ]; then
	mkdir -p  $SERVERS_PUBLIC/${CLIENTS[${index}]}/backup
	mkdir -p  $SERVERS_PRIVATE/${CLIENTS[${index}]}/backup
          generated_pass=`apg -n 1 -m 64 -M NC`
          rngd -r /dev/urandom
gpg --gen-key --homedir $SERVERS_PUBLIC/${CLIENTS[${index}]}/backup --batch <<GPG 
          Key-Type: DSA 
          Key-Length: 2048 
          Subkey-Type: ELG-E 
          Subkey-Length: 1024 
          Name-Real: Duplicity 
          Name-Comment: key for duplicity backup 
          Name-Email: duplicity@dup.dup
          Expire-Date: 0
          Passphrase: $generated_pass
GPG
    echo "$generated_pass" > $SERVERS_PRIVATE/${CLIENTS[${index}]}/backup/pass
    echo `gpg --homedir $SERVERS_PUBLIC/${CLIENTS[${index}]}/backup --list-keys Duplicity | head -n 1 | cut -d '/' -f 2 | cut -d ' ' -f 1` > $SERVERS_PRIVATE/${CLIENTS[${index}]}/backup/gpg_key
      fi
  done
}
add_mount_permission(){
for((index=0;index<$ELEMENT_COUNT;index++))
do
  grep "allow ${CLIENTS[${index}]}" $FILESERVER_CONF >>/dev/null
  if [ "$?" -ne "0" ]
  then
     id=`< /dev/urandom tr -dc 0-9 | head -c${1:-10}`
     echo "["$id"]" >> $FILESERVER_CONF
     echo "path "$SERVERS_PUBLIC/${CLIENTS[${index}]} >> $FILESERVER_CONF
     echo "allow "${CLIENTS[${index}]} >> $FILESERVER_CONF
     RESTART="true"
     if [ ! -d "$SERVERS_PRIVATE/${CLIENTS[${index}]}" ]; then
        mkdir -p $SERVERS_PRIVATE/${CLIENTS[${index}]}
     fi
     echo $id" => "${CLIENTS[${index}]} >> $SERVERS_PRIVATE/id_servers.txt
     echo $id > $SERVERS_PRIVATE/${CLIENTS[${index}]}/id
  fi
done
}
create_backups_keys
add_mount_permission
