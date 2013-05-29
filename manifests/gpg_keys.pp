define gpg_keys($id){
file { "dir_keys" :
                    path => "/root/.gnupg",
                    ensure => "directory",
                    mode => "600",
                    owner => "root",
                    group => "root",
                    replace => true
  }
  file { "gpg_keys_1":
                    path => "/root/.gnupg/pubring.gpg",
                    ensure => "present",
                    mode => "600",
                    owner => "root",
                    group => "root",
                    source => "puppet:///$id/backup/pubring.gpg",
                    require => File[dir_keys],
                    replace => true

  }
 file { "gpg_keys_2":
                    path => "/root/.gnupg/random_seed",
                    ensure => "present",
                    mode => "600",
                    owner => "root",
                    group => "root",
                    source => "puppet:///$id/backup/random_seed",
                    require => File[dir_keys],
                    replace => true
        }
  file { "gpg_keys_3":
                    path => "/root/.gnupg/secring.gpg",
                    ensure => "present",
                    mode => "600",
                    owner => "root",
                    group => "root",
                    source => "puppet:///$id/backup/secring.gpg",
                    require => File[dir_keys],
                    replace => true
        }
  file { "gpg_keys_4":
                    path => "/root/.gnupg/trustdb.gpg",
                    ensure => "present",
                    mode => "600",
                    owner => "root",
                    group => "root",
                    source => "puppet:///$id/backup/trustdb.gpg",
                    require => File[dir_keys],
                    replace => true
        }
}
