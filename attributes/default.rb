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

default['solr']['version']   = "3.6.2"
default['solr']['link']      = "http://apache.mirrors.timporter.net/lucene/solr/#{solr.version}/apache-solr-#{solr.version}.tgz"
default['solr']['checksum']  = "537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6" #sha265
default['solr']['directory'] = "/usr/local/src"
default['solr']['download']  = "#{solr.directory}/apache-solr-#{solr.version}.tgz"
default['solr']['extracted'] = "#{solr.directory}/apache-solr-#{solr.version}"
default['solr']['war']       = "apache-solr-#{solr.version}.war"

default['solr']['home']      = "/usr/share/solr"
default['solr']['config']    =  "#{node.solr.home}/conf"
default['solr']['data']      = "/usr/local/solr/data"

# SEVERE (highest value) WARNING INFO CONFIG FINE FINER FINEST (lowest value)
default['solr']['log']['level'] = 'FINE'
default['solr']['log']['class'] = 'java.util.logging.ConsoleHandler'
default['solr']['log']['formatter'] = 'java.util.logging.SimpleFormatter'