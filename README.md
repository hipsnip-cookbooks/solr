# hipsnip-solr

Chef cookbook for setting up Apache Solr 3.6.x/4.x from mirrors.

[![Build Status](https://travis-ci.org/hipsnip-cookbooks/solr.png?branch=master)](https://travis-ci.org/hipsnip-cookbooks/solr) [![Dependency Status](https://gemnasium.com/hipsnip-cookbooks/solr.png)](https://gemnasium.com/hipsnip-cookbooks/solr)

## Requirements

Built to run on Linux distributions. Tested on Ubuntu 12.04.
Depends on the `hipsnip-jetty` cookbook.

## Usage

For example if you want to install Solr 4.2, you could create a cookbook with a recipe containing this code:

    node.set['solr']['version'] = '4.2.1'
    node.set['solr']['checksum'] = '648a4b2509f6bcac83554ca5958cf607474e81f34e6ed3a0bc932ea7fac40b99'

    node.set['jetty']['port'] = 8983
    node.set['jetty']['version'] = '9.0.2.v20130417'
    node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.0.2.v20130417.tar.gz&r=1'
    node.set['jetty']['checksum'] = '6ab0c0ba4ff98bfc7399a82a96a047fcd2161ae46622e36a3552ecf10b9cddb9'

    include_recipe 'hipsnip-solr'


> NOTE: Jetty 9 now requires Java 1.7 to be installed. However, the Opscode Java cookbook we use installs version 1.6 by default. To change the version of Java being installed, you'll need to put the following in your Role or Environment config file:

    {
      "default_attributes": {
        "java" : {
          "jdk_version" : 7
        }
      }
    }


For more usage examples, have a look at the recipes in `test/cookbooks/hipsnip-solr_test/recipes/`.

## Attributes

* `node['solr']['version']` - version of Solr, default "3.6.2"
* `node['solr']['checksum']` - checksum using algo sha256 of the Solr archive, default "537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6"
* `node['solr']['directory']` - directory where Solr archive is downloaded and extracted, default "/usr/local/src"

* `node['solr']['home']` - home directory of Solr, all configuration files are there, default "/usr/share/solr".
* `node['solr']['data']` - directory where indexes are stored, default "/usr/local/solr/data"

* `node['solr']['context_path']` - route where Solr is deployed, default '/solr'
* `node['solr']['env_vars']` -  variables passed to Solr, default "{'solr.solr.home' => node['solr']['home'],'solr.data.dir' => node['solr']['data']}".

* `node['solr']['log']['level']` -  log level , default "INFO". levels: SEVERE ERROR WARNING INFO CONFIG FINE FINER FINEST
* `node['solr']['log']['class']` - log class used, default 'java.util.logging.ConsoleHandler'. This class logs messages into stdout/stderr.
* `node['solr']['log']['formatter']` - log formatter used, default 'java.util.logging.SimpleFormatter'

__Note:__ These attributes don't need to be customized in order to install Solr.

* `node['solr']['link']` - link used to download Solr archive, if empty "", the recipe guesses the good link
* `node['solr']['download']` - path of the Solr archive is downloaded, by default empty "". If the link is guessed by the recipe, the recipe does the job.
* `node['solr']['extracted']` - path of the Solr folder after extractiong, by default empty "". If the link is guessed by the recipe, the recipe does the job.
* `node['solr']['war']` -  Solr war filename, by default empty "". If the link is guessed by the recipe, the recipe does the job.



## Cookbook development

You will need to do a couple of things to be up to speed to hack on this cookbook.
Everything is explained [here](https://github.com/hipsnip-cookbooks/cookbook-development) have a look.

## Test

    bundle exec rake cookbook:full_test

## Licence

Author: Rémy Loubradou

Copyright 2013 HipSnip Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
