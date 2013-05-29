import "**"
import "databases/*"


define backups ( 
  $gpg_key,
  $passphraze,
  $id,
  $mongo = 'false' ,
  $postgres = 'false',
  $ensure = 'present',
  $when = 'daily',
  $mysql = 'false',
  $mysqlpasswd= 'root password',
  $_dest_id =   "YOU ID",
  $_dest_key =  "YOU KEY",
  $directory ="/tmp/backup",
  $autorestore ='false',
  $directories ='false',
  $logoutput ='false',){

include schedules

require install_packages

gpg_keys{"gpg_keys":
    id =>$id,
}

mongo_backup{"mongo":
   mongo => $mongo,
   directory => $directory,
   when => $when, 
   logoutput => $logoutput,
}

postgres_backup{"postgres":
   postgres => $postgres,
   directory => $directory,
   when => $when, 
   logoutput => $logoutput,
}

mysql_backup{"mysql":
   mysql => $mysql,
   directory => $directory,
   when => $when, 
   logoutput => $logoutput,
}

 case  $ensure { 
  present:{
  if $directories =='false'{
    exec{"run_backups":
       command =>"duplicity full --timeout 360 --include ${directory} --s3-use-new-style --exclude '**' --encrypt-key=${gpg_key} --sign-key=${gpg_key} / s3+http://itforest/backups/$hostname ",
       path    => "/usr/bin:/usr/sbin:/bin",
       environment => ["AWS_ACCESS_KEY_ID=$_dest_id", "AWS_SECRET_ACCESS_KEY=$_dest_key", "HOME=/root", "SIGN_PASSPHRASE=$passphraze", "PASSPHRASE=$passphraze"],
       timeout => 3600,
       logoutput => $logoutput,
       user => root,
       require => [Gpg_keys["gpg_keys"],Mongo_backup["mongo"],Postgres_backup["postgres"],Mysql_backup["mysql"]],
       #schedule => $when
     }
 }else{
    exec{"run_backups":
       command =>"duplicity full --timeout 360 ${directories} --include ${directory} --s3-use-new-style --exclude '**' --encrypt-key=${gpg_key} --sign-key=${gpg_key} / s3+http://itforest/backups/$hostname",
       path    => "/usr/bin:/usr/sbin:/bin",
       environment => ["AWS_ACCESS_KEY_ID=$_dest_id", "AWS_SECRET_ACCESS_KEY=$_dest_key", "HOME=/root", "SIGN_PASSPHRASE=$passphraze", "PASSPHRASE=$passphraze"],
       timeout => 3600,
       user => root,
       logoutput => $logoutput,
       require => [Gpg_keys["gpg_keys"],Mongo_backup["mongo"],Postgres_backup["postgres"],Mysql_backup["mysql"]],
       #schedule => $when
     }
 }
  exec {"delete_files":
      path    => "/usr/bin:/usr/sbin:/bin",
      command => "rm -r ${directory}",
      require => Exec ["run_backups"],
      onlyif => "test -d ${directory}",
      schedule => $when
  } 
 }
  absent :{
      exec{"restore_backups":
        command =>"duplicity restore  --encrypt-key=${gpg_key} --sign-key=${gpg_key} --s3-use-new-style  s3+http://itforest/backups/$title ${directory}/restore/",
        path    => "/usr/bin:/usr/sbin:/bin",
        environment => ["AWS_ACCESS_KEY_ID=$_dest_id", "AWS_SECRET_ACCESS_KEY=$_dest_key", "HOME=/root", "SIGN_PASSPHRASE=$passphraze", "PASSPHRASE=$passphraze"],
        timeout => 3600,
        logoutput => $logoutput,
        user => root,
        require => Gpg_keys["gpg_keys"],
       }
      }  
   }
}
