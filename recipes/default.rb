#
# Cookbook Name:: hipsnip-solr
# Recipe:: default
#
# Copyright 2013, HipSnip Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "hipsnip-jetty"

require 'fileutils'


################################################################################
# Download and unpack

remote_file node['solr']['download'] do
  source   node['solr']['link']
  checksum node['solr']['checksum']
  mode     0644
end


ruby_block 'Extract Solr' do
  block do
    Chef::Log.info "Extracting Solr archive #{node['solr']['download']} into #{node['solr']['directory']}"
    `tar xzf #{node['solr']['download']} -C #{node['solr']['directory']}`
    raise "Failed to extract Solr package" unless ::File.exists?(node['solr']['extracted'])
  end

  action :create

  not_if do
    ::File.exists?(node['solr']['extracted'])
  end
end

################################################################################
# Install into Jetty

ruby_block 'Copy Solr war into Jetty webapps folder' do
  block do
    Chef::Log.info "Copying #{node['solr']['war']} into #{node['solr']['webapps']}"

    ::FileUtils.cp ::File.join(node['solr']['extracted'], 'solr/dist', node['solr']['war']), node['solr']['webapps']

    raise "Failed to copy Solr war" unless ::File.exists?(::File.join(node['solr']['webapps'], node['solr']['war']))
  end

  action :create
  notifies :restart, resources(:service => "jetty")

  not_if do
    if not ::File.exists?(::File.join(node['solr']['webapps'], node['solr']['war']))
      false
    else
      downloaded_signature = `sha256sum #{node['solr']['extracted']}/solr/dist/#{node['solr']['war']} | cut -d ' ' -f 1`
      installed_signature = `sha256sum #{node['solr']['webapps']}/#{node['solr']['war']} | cut -d ' ' -f 1`
      downloaded_signature == installed_signature
    end
  end
end

# template "#{node.jetty.contexts}/solr.xml" do
#   owner  node['jetty']['user']
#   source "solr.context.erb"
#   notifies :restart, resources(:service => "jetty")
# end

directory node['solr']['data'] do
  owner node['jetty']['user']
  group node['jetty']['group']
  mode "755"
  recursive true
  action :create
end


################################################################################
# Configure

directory node['solr']['config'] do
  owner node['jetty']['user']
  group node['jetty']['group']
  mode "755"
  recursive true
  action :create
end

ruby_block 'Copy Solr configurations files' do
  block do
    config_files = Dir.glob(::File.join(node['solr']['extracted'],'/solr/example/solr/conf/') + '**')
    Chef::Log.info "Copying #{config_files} into #{node['solr']['config']}"
    ::FileUtils.cp_r config_files, node['solr']['config']
    raise "Failed to copy Solr configurations files" unless ::File.exists?(::File.join(node['solr']['config'], 'solrconfig.xml'))
  end

  action :create
  notifies :restart, resources(:service => "jetty")

  not_if do
    if not ::File.exists?(::File.join(node['solr']['config'], 'solrconfig.xml'))
      false
    else
      downloaded_signature = `sha256sum #{node['solr']['extracted']}/solr/dist/#{node['solr']['war']} | cut -d ' ' -f 1`
      installed_signature = `sha256sum #{node['solr']['webapps']}/#{node['solr']['war']} | cut -d ' ' -f 1`
      downloaded_signature == installed_signature
    end
  end
end

######################################################################################
# Set log level

# directory node.solr.log_dir do
#   owner node['jetty']['user']
#   group node['jetty']['group']
#   mode  '755'
# end

template "#{node['jetty']['home']}/etc/logging.properties" do
  source 'logging.properties.erb'
  mode '644'
  notifies :restart, resources(:service => 'jetty')
end