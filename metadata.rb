name			 "hipsnip-solr"
maintainer       "HipSnip"
maintainer_email "adam@hipsnip.com/remy@hipsnip.com"
license          "Apache 2.0"
description      "Installs/Configures Solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
supports 		 'ubuntu', ">= 12.04"
version          "0.5.0"

depends "hipsnip-jetty", "~> 0.9.0"
