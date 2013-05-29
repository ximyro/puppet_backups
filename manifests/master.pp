define backups_keys($logoutput = false,
$fileserver = '/etc/puppet/fileserver.conf',
$servers_public = '/etc/puppet/servers/public',
$servers_private = '/etc/puppet/servers/private'){
$value = template("backups/create_keys.sh")
 exec {"create_keys":
 command => "/bin/bash /etc/puppet/modules/backups/templates/create_keys.sh ${fileserver} ${servers_public} ${servers_private}",
 logoutput => $logoutput,
 path    => "/usr/bin:/usr/sbin:/bin",
 }
}
