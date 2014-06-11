require 'spec_helper'
describe 'proxy' do

  context 'with defaults on Suse' do
    let(:facts) do
    {  :osfamily => 'Suse',
    }
    end
    it { should contain_file('proxy_sysconfig').with({
      'path' => '/etc/sysconfig/proxy',
      'mode' => '0644',
      'owner' => 'root',
      'group' => 'root',
      'content' => 'PROXY_ENABLED="yes"
HTTP_PROXY=""
HTTPS_PROXY=""
FTP_PROXY=""
GOPHER_PROXY=""
NO_PROXY="localhost, 127.0.0.1"
',
    })}
  end

  context 'with defaults on Redhat' do
    let(:facts) do
    {  :osfamily => 'RedHat',
    }
    end
    it { should contain_file('proxy_profile.sh').with({
      'path' => '/etc/profile.d/proxy.sh',
      'ensure' => 'file',
      'mode' => '0755',
      'owner' => 'root',
      'group' => 'root',
      'content' => 'export no_proxy=localhost,127.0.0.1
',
    })}
    it { should contain_file('proxy_profile.csh').with({
      'path' => '/etc/profile.d/proxy.csh',
      'ensure' => 'file',
      'mode' => '0755',
      'owner' => 'root',
      'group' => 'root',
      'content' => 'setenv no_proxy localhost,127.0.0.1
',
    })}
  end

  context 'with parameters set on Redhat' do
    let(:facts) do
    {  :osfamily => 'RedHat',
    }
    end
    let(:params) do
    { :proxy_profile_sh_path => '/etc/proxy.sh',
      :proxy_profile_sh_mode => '0777',
      :proxy_profile_sh_owner => 'username',
      :proxy_profile_sh_group => 'group',
      :proxy_profile_csh_path => '/etc/proxy.csh',
      :proxy_profile_csh_mode => '0775',
      :proxy_profile_csh_owner => 'otherusername',
      :proxy_profile_csh_group => 'othergroup',
      :http_proxy => 'http://proxy.example.com:8080',
      :https_proxy => 'http://proxy.example.com:8080',
      :no_proxy => 'example.com,localhost,127.0.0.1',
    }
    end
    it { should contain_file('proxy_profile.sh').with({
      'path' => '/etc/proxy.sh',
      'mode' => '0777',
      'owner' => 'username',
      'group' => 'group',
      'content' => 'export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080
export no_proxy=example.com,localhost,127.0.0.1
',
    })}
    it { should contain_file('proxy_profile.csh').with({
      'path' => '/etc/proxy.csh',
      'mode' => '0775',
      'owner' => 'otherusername',
      'group' => 'othergroup',
      'content'  => 'setenv http_proxy http://proxy.example.com:8080
setenv https_proxy http://proxy.example.com:8080
setenv no_proxy example.com,localhost,127.0.0.1
',
    })}
  end

  context 'with parameters set on Suse' do
    let(:facts) do
    {  :osfamily => 'Suse',
    }
    end
    let(:params) do
    { :proxy_sysconfig_path => '/etc/proxy',
      :proxy_sysconfig_mode => '0777',
      :proxy_sysconfig_owner => 'username',
      :proxy_sysconfig_group => 'group',
      :proxy_enabled => 'yes',
      :http_proxy => 'http://httpproxy.example.com:8080',
      :https_proxy => 'http://httpsproxy.example.com:8080',
      :ftp_proxy => 'http://ftpproxy.example.com:8080',
      :gopher_proxy => 'http://gopherproxy.example.com:8080',
      :no_proxy => 'example.com,localhost,127.0.0.1',
    }
    end
    it { should contain_file('proxy_sysconfig').with({
      'path' => '/etc/proxy',
      'mode' => '0777',
      'owner' => 'username',
      'group' => 'group',
      'content' => 'PROXY_ENABLED="yes"
HTTP_PROXY="http://httpproxy.example.com:8080"
HTTPS_PROXY="http://httpsproxy.example.com:8080"
FTP_PROXY="http://ftpproxy.example.com:8080"
GOPHER_PROXY="http://gopherproxy.example.com:8080"
NO_PROXY="example.com,localhost,127.0.0.1"
',
    })}
  end

  ['yes',true].each do |value|
    context "specified a valid value #{value} for proxy_enabled" do
      let(:params) { { :proxy_enabled => value } }
      let(:facts) do
        { :osfamily  => 'Suse',
        }
      end

      it { should contain_file('proxy_sysconfig').with_content(/^PROXY_ENABLED="yes"$/) }
    end
  end

  ['no',false].each do |value|
    context "specified a valid value #{value} for proxy_enabled" do
      let(:params) { { :proxy_enabled => value } }
      let(:facts) do
        { :osfamily  => 'Suse',
        }
      end

      it { should contain_file('proxy_sysconfig').with_content(/^PROXY_ENABLED="no"$/) }
    end
  end

  context 'with invalid value for proxy_enabled' do
    let(:params) do
    { :proxy_enabled => 'maybe'
    }
    end
    let(:facts) do
    {  :osfamily => 'Suse',
    }
    end
    it 'should fail' do
      expect {
        should contain_class('proxy')
      }.to raise_error(Puppet::Error,/proxy::proxy_enabled may be either 'yes' or 'no' and is set to <maybe>./)
    end
  end

  context 'with invalid type for proxy_enabled' do
    let(:params) do
    { :proxy_enabled => [ 'maybe' ]
    }
    end
    let(:facts) do
    {  :osfamily => 'Suse',
    }
    end
    it 'should fail' do
      expect {
        should contain_class('proxy')
      }.to raise_error(Puppet::Error,/proxy::proxy_enabled type must be string or bool/)
    end
  end

  context 'with proxy_profile_sh_ensure set to absent' do
    let(:params) do
    { :proxy_profile_sh_ensure => 'absent',
    }
    end
    let(:facts) do
    {  :osfamily => 'RedHat',
    }
    end
    it { should contain_file('proxy_profile.sh').with({
      'ensure' => 'absent',
    })}
  end

  context 'with invalid value for proxy_profile_sh_ensure' do
    let(:params) do
    { :proxy_profile_sh_ensure => 'directory'
    }
    end
    let(:facts) do
    {  :osfamily => 'RedHat',
    }
    end
    it 'should fail' do
      expect {
        should contain_class('proxy')
      }.to raise_error(Puppet::Error,/proxy::proxy_profile_sh_ensure may be either 'file' or 'absent' and is set to <directory>./)
    end
  end

  context 'with proxy_profile_csh_ensure set to absent' do
    let(:params) do
    { :proxy_profile_csh_ensure => 'absent',
    }
    end
    let(:facts) do
    {  :osfamily => 'RedHat',
    }
    end
    it { should contain_file('proxy_profile.csh').with({
      'ensure' => 'absent',
    })}
  end

  context 'with invalid value for proxy_profile_csh_ensure' do
    let(:params) do
    { :proxy_profile_csh_ensure => 'directory'
    }
    end
    let(:facts) do
    {  :osfamily => 'RedHat',
    }
    end
    it 'should fail' do
      expect {
        should contain_class('proxy')
      }.to raise_error(Puppet::Error,/proxy::proxy_profile_csh_ensure may be either 'file' or 'absent' and is set to <directory>./)
    end
  end

  context 'with unsupported osfamily' do
    let(:facts) do
    {  :osfamily => 'Debian',
    }
    end
    it 'should fail' do
      expect {
        should contain_class('proxy')
      }.to raise_error(Puppet::Error,/proxy module only supported on RedHat and Suse. Detected osfamily is <Debian>/)
    end
  end
end
