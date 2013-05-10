node.set['solr']['version'] = '3.6.2'
node.set['solr']['checksum'] = '537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6'

node.set['jetty']['port'] = 8983
node.set['jetty']['version'] = '8.1.10.v20130312'
node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/8.1.10.v20130312/dist/jetty-distribution-8.1.10.v20130312.tar.gz&r=1'
node.set['jetty']['checksum'] = 'e966f87823adc323ce67e99485fea126b84fff5affdc28aa7526e40eb2ec1a5b'

node.set['java']['jdk_version'] = 6

include_recipe 'hipsnip-solr'