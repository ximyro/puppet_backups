define postgres_backup($postgres,$directory,$when,$logoutput){
if $postgres == 'true' {
    exec {"postgres":
      path    => "/usr/bin:/usr/sbin:/bin",
      command => "su -l postgres -c \"pg_dumpall | gzip -9  >  ~/postgres.sql.gz\";test -d ${directory} || mkdir -p ${directory};mv /var/lib/postgresql/postgres.sql.gz ${directory}",
      user => root,
      timeout => 3600,
      schedule => $when,
      logoutput => $logoutput,
    }
   }
   else {
    exec {"postgres":
      path    => "/usr/bin:/usr/sbin:/bin",
      command => "/bin/echo",
      schedule => $when,
      logoutput => $logoutput,
    }
   }
}
