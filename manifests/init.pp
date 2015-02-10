# == Class: proxy
#
# Module to manage proxy
#
class proxy (
  $proxy_enabled = 'yes',
  $http_proxy = undef,
  $https_proxy = undef,
  $ftp_proxy = undef,
  $gopher_proxy = undef,
  $no_proxy = 'localhost, 127.0.0.1',
  $proxy_sysconfig_path = '/etc/sysconfig/proxy',
  $proxy_sysconfig_mode = '0644',
  $proxy_sysconfig_owner = 'root',
  $proxy_sysconfig_group = 'root',
  $proxy_profile_sh_ensure = 'file',
  $proxy_profile_sh_path = '/etc/profile.d/proxy.sh',
  $proxy_profile_sh_mode = '0755',
  $proxy_profile_sh_owner = 'root',
  $proxy_profile_sh_group = 'root',
  $proxy_profile_csh_ensure = 'file',
  $proxy_profile_csh_path = '/etc/profile.d/proxy.csh',
  $proxy_profile_csh_mode = '0755',
  $proxy_profile_csh_owner = 'root',
  $proxy_profile_csh_group = 'root',
) {
  if is_string($proxy_enabled) {
    validate_re($proxy_enabled, '^(yes|no)$', "proxy::proxy_enabled may be either 'yes' or 'no' and is set to <${proxy_enabled}>.")
    $proxy_enabled_real = $proxy_enabled
  } elsif is_bool($proxy_enabled) {
    if $proxy_enabled == true {
      $proxy_enabled_real = 'yes'
    } else {
      $proxy_enabled_real = 'no'
    }
  } else {
    fail('proxy::proxy_enabled type must be string or bool')
  }
  validate_re($proxy_profile_sh_ensure, '^(file|absent)$', "proxy::proxy_profile_sh_ensure may be either 'file' or 'absent' and is set to <${proxy_profile_sh_ensure}>.")
  validate_re($proxy_profile_csh_ensure, '^(file|absent)$', "proxy::proxy_profile_csh_ensure may be either 'file' or 'absent' and is set to <${proxy_profile_csh_ensure}>.")
  if $http_proxy != undef {
    validate_string($http_proxy)
  }
  if $https_proxy != undef {
    validate_string($https_proxy)
  }
  if $ftp_proxy != undef {
    validate_string($ftp_proxy)
  }
  if $gopher_proxy != undef {
    validate_string($gopher_proxy)
  }
  if $no_proxy != undef {
    validate_string($no_proxy)
  }

  case $::osfamily {
    'Suse': {
      validate_absolute_path($proxy_sysconfig_path)
      file { 'proxy_sysconfig':
        path => $proxy_sysconfig_path,
        mode => $proxy_sysconfig_mode,
        owner => $proxy_sysconfig_owner,
        group => $proxy_sysconfig_group,
        content => template('proxy/proxy_sysconfig.erb'),
      }
    }
    'RedHat': {
      validate_absolute_path($proxy_profile_sh_path)
      file { 'proxy_profile.sh':
        ensure => $proxy_profile_sh_ensure,
        path => $proxy_profile_sh_path,
        mode => $proxy_profile_sh_mode,
        owner => $proxy_profile_sh_owner,
        group => $proxy_profile_sh_group,
        content => template('proxy/proxy_profile.sh.erb'),
      }
      validate_absolute_path($proxy_profile_sh_path)
      file { 'proxy_profile.csh':
        ensure => $proxy_profile_csh_ensure,
        path => $proxy_profile_csh_path,
        mode => $proxy_profile_csh_mode,
        owner => $proxy_profile_csh_owner,
        group => $proxy_profile_csh_group,
        content => template('proxy/proxy_profile.csh.erb'),
      }
    }
    default: {
      fail("proxy module only supported on RedHat and Suse. Detected osfamily is <${::osfamily}>")
    }
  }
}
