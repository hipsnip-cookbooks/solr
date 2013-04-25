# hipsnip-solr

Chef cookbook for setting up Apache Solr 3.6.x/4.x from mirrors.

[![Build Status](https://travis-ci.org/hipsnip-cookbooks/solr.png?branch=master)](https://travis-ci.org/hipsnip-cookbooks/solr)

## Requirements

Built to run on Linux distributions. Tested on Ubuntu 12.04.
Depends on the `hipsnip-jetty` cookbook.

## Usage

For example if you want to install Solr 4.2, you will have to edit the attributes as following:

```
attributes:
    solr:
      version: 4.2.1
      checksum: 648a4b2509f6bcac83554ca5958cf607474e81f34e6ed3a0bc932ea7fac40b99
    jetty:
      port: 8983
      version: 9.0.2.v20130417
      link: http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.0.2.v20130417.tar.gz&r=1
      checksum: 6ab0c0ba4ff98bfc7399a82a96a047fcd2161ae46622e36a3552ecf10b9cddb9
    java:
      jdk_version: 7
```

For more usage examples, read the configuration file of kitchen called `.kitchen.yml`. Each test suite describes a valid way to use this cookbook.

## Attributes

```
['solr']['version'] = "3.6.2"
# sha256 sum of the solr archive
['solr']['checksum'] = "537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6"
# directory where solr archive is downloaded and extracted
['solr']['directory'] = "/usr/local/src"

# Guess by the cookbook if empty
['solr']['link'] = ""
['solr']['download'] = ""
['solr']['extracted'] = ""
['solr']['war'] = ""
['solr']['dist'] = ""

# location of solr (configuration files)
['solr']['home'] = "/usr/share/solr"
# location of the indexes
['solr']['data'] = "/usr/local/solr/data"

['solr']['context_path'] = '/solr'
['solr']['env_vars'] = {
	'solr.solr.home' => node['solr']['home'],
	'solr.data.dir' => node['solr']['data']
}

# SEVERE (highest value) WARNING INFO CONFIG FINE FINER FINEST (lowest value)
['solr']['log']['level'] = 'FINE'
['solr']['log']['class'] = 'java.util.logging.ConsoleHandler'
['solr']['log']['formatter'] = 'java.util.logging.SimpleFormatter'
```
## Cookbook development

You will need to do a couple of things to be up to speed to hack on this cookbook.
Everything is explained [here](https://github.com/hipsnip-cookbooks/cookbook-development) have a look.

## Test

```
bundle exec rake cookbook:full_test
```

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