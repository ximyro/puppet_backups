class install_packages{
package {
    ['duplicity', 'python-boto', 'gnupg','gzip','tar','python-gobject']: ensure => present
  }
}
