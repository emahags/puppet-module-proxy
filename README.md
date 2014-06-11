# puppet-module-proxy
===

[![Build Status](https://travis-ci.org/emahags/puppet-module-proxy.png?branch=master)](https://travis-ci.org/emahags/puppet-module-proxy)

Brief description here.

===

# Compatibility
---------------
This module is built for use with Puppet v3 with Ruby versions 1.8.7, 1.9.3, and 2.0.0 on the following OS families.

* EL 6
* Suse

===

# Parameters
------------

proxy_enabled
-------------
PROXY_ENABLED variable in Suse sysconfig file. Available values are 'yes', 'no', true, false

- *Default*: 'yes'

http_proxy
----------
HTTP proxy.

- *Default*: undef

https_proxy
-----------
HTTPS proxy.

- *Default*: undef

ftp_proxy
---------
FTP proxy. Only used on Suse.

- *Default*: undef

gopher_proxy
------------
Gopher proxy. Only used on Suse.

- *Default*: undef

no_proxy
--------
Domains and IPs that should not be proxied.

proxy_sysconfig_path
--------------------
Path to sysconfig file on Suse

- *Default*: '/etc/sysconfig/proxy'

proxy_sysconfig_mode
--------------------
Mode of sysconfig file on Suse

- *Default*: '0644'

proxy_sysconfig_owner
---------------------
Owner of sysconfig file on Suse

- *Default*: 'root'

proxy_sysconfig_group
---------------------
Group of sysconfig file on Suse

- *Default*: 'root'

proxy_profile_sh_ensure
-----------------------
Ensure profile.sh file exists on RedHat. Valid values are 'file' and 'absent'

- *Default*: 'file'

proxy_profile_sh_path
---------------------
Path to profile.sh file on RedHat.

- *Default*: '/etc/profile.d/proxy.sh'

proxy_profile_sh_mode
---------------------
Mode of profile.sh file on RedHat.

- *Default*: '0755'

proxy_profile_sh_owner
----------------------
Owner of profile.sh file on RedHat.

- *Default*: 'root'

proxy_profile_sh_group
----------------------
Group of profile.sh file on RedHat.

- *Default*: 'root'

proxy_profile_csh_ensure
------------------------
Ensure profile.csh file exists on RedHat. Valid values are 'file' and 'absent'

- *Default*: 'file'

proxy_profile_csh_path
----------------------
Path to profile.csh file on RedHat.

- *Default*: '/etc/profile.d/proxy.csh'

proxy_profile_csh_mode
----------------------
Mode of profile.csh file on RedHat.

- *Default*: '0755'

proxy_profile_csh_owner
-----------------------
Owner of profile.csh file on RedHat.

- *Default*: 'root'

proxy_profile_csh_group
-----------------------
Group of profile.csh file on RedHat.

- *Default*: 'root'

