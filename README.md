# hipsnip-solr

Chef cookbook for setting up Apache Solr from mirrors.

[![Build Status](https://travis-ci.org/hipsnip-cookbooks/solr.png?branch=master)](https://travis-ci.org/hipsnip-cookbooks/solr)

## Requirements

Built to run on Linux distributions. Tested on Ubuntu 12.04.
Depends on the `hipsnip-jetty` cookbook.

## Usage

By default the Jetty server setups thanks to the `hipsnip-jetty` cookbook set the port number to 8080, so do not forget to override `node[:jetty][:port]` in your role or env to run the Solr server on the port that you wish (reminder: the standard port for Solr is 8983).
Otherwise you should not need to override others attributes.

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