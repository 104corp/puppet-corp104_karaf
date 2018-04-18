require 'spec_helper'

describe 'corp104_karaf', :type => 'class' do
  context 'with defaults for all parameters' do
    let(:facts) do
      { 
        :os => { :family => 'Debian', :name => 'Ubuntu', :release => { :major => '16.04', :full => '16.04' }},
        :lsbdistrelease  => '16.04',
        :lsbdistid       => 'Ubuntu',
        :osfamily        => 'Debian',
        :lsbdistcodename => 'xenial',
      }
    end
    it do
      should contain_class('corp104_karaf')
      should contain_class('corp104_karaf::install')
			should contain_class('corp104_karaf::config')
      should contain_class('corp104_karaf::service')
    end

    it do
      should compile.with_all_deps
    end

  end
end
