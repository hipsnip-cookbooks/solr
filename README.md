# hipsnip-solr

Chef cookbook for setting up Apache Solr from mirrors.

## Requirements

Built to run on Linux distributions. Tested on Ubuntu 12.04.
Depends on the `hipsnip-jetty` cookbook.

## Usage

By default the Jetty server setups thanks to the `hipsnip-jetty` cookbook set the port number to 8080, so do not forget to override `node[:jetty][:port]` in your role or env to run the Solr server on the port that you wish (reminder: the standard port for Solr is 8983).
Otherwise you should not need to override others attributes.

## Attributes

```
['solr']['version']   = "3.6.2"
# url of the solr archive (tar.gz)
#
['solr']['link']      = "http://apache.mirrors.timporter.net/lucene/solr/#{solr.version}/apache-solr-#{solr.version}.tgz"
# sha265sum of the solr archive, used to check the integrity of the archive
['solr']['checksum']  = "537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6"
# directory where the archive will be downloaded
['solr']['directory'] = "/usr/local/src"
# path of the solr archive
['solr']['download']  = "#{solr.directory}/apache-solr-#{solr.version}.tgz"
# path of the solr source after extraction
['solr']['extracted'] = "#{solr.directory}/apache-solr-#{solr.version}"
# name of the solr war extracted
['solr']['war']       = "apache-solr-#{solr.version}.war"

# home directory of the Solr server
['solr']['home']      = "/usr/share/solr"
# path of the folder containing solr configuration files
['solr']['config']    =  "#{node.solr.home}/conf"
# path of the folder containing solr index
['solr']['data']      = "/usr/local/solr/data"

# log level (SEVERE WARNING INFO CONFIG FINE FINER FINEST)
['solr']['log']['level'] = 'FINE'
['solr']['log']['class'] = 'java.util.logging.ConsoleHandler'
['solr']['log']['formatter'] = 'java.util.logging.SimpleFormatter'
```