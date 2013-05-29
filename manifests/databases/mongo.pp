define mongo_backup($mongo, $when, $directory,$logoutput){
if $mongo == 'true' {
    exec {"mongo_backup":
      path    => "/usr/bin:/usr/sbin:/bin",
      command => "test -d ${directory} || mkdir -p ${directory};mongodump -o ${directory}/mongo;cd ${directory} && tar -zcvf mongodb.tar.bz mongo;rm -r mongo;",
      user => root,
      timeout => 3600,
      schedule => $when,
      logoutput => $logoutput,
    }
   }
   else {
    exec {"mongo_backup":
      path    => "/usr/bin:/usr/sbin:/bin",
      command => "/bin/echo",
      schedule => $when,
      logoutput => $logoutput,
    }
   }
}
