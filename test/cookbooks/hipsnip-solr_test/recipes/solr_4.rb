node.set['solr']['version'] = '4.5.1'
node.set['solr']['checksum'] = '8f53f9a317cbb2f0c8304ecf32aa3b8c9a11b5947270ba8d1d6372764d46f781'

node.set['jetty']['port'] = 8983
node.set['jetty']['version'] = '9.0.6.v20130930'
node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/9.0.6.v20130930/dist/jetty-distribution-9.0.6.v20130930.tar.gz&r=1'
node.set['jetty']['checksum'] = 'c35c6c0931299688973e936186a6237b69aee2a7912dfcc2494bde9baeeab58f'

include_recipe 'hipsnip-solr'