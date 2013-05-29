define mysql_backup($mysql,$directory,$when,$logoutput){
if $mysql =='true'{
      exec {"mysql":
      path    => "/usr/bin:/usr/sbin:/bin",
      command => "test -d ${directory} || mkdir -p ${directory};mysqldump -u root -p${mysqlpasswd} --all-databases | gzip -9 > ${directory}/mysql.sql.gz",
      timeout => 3600,
      schedule => $when,
      logoutput => $logoutput,
    }
  }
  else{
   exec {"mysql":
      path    => "/usr/bin:/usr/sbin:/bin",
      command => "/bin/echo",
      schedule => $when,
      logoutput => $logoutput,
    }
  }
}
