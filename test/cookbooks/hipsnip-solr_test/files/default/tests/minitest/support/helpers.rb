module Helpers

  module CookbookTest
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources
  end

  module Solr

  	require 'net/http'

  	class Client
  		attr_accessor :host, :port, :collection
  		def initialize(host= '127.0.0.1', port= 8983, collection= '')
  			@host = host
  			@port = port
  			@collection = collection
  		end

  		def add_documents(documents)
	    uri = URI("http://#{@host}:#{@port}/solr#{@collection}/update/json?commit=true&wt=json")
	    http = Net::HTTP.new(uri.host,uri.port)
	    body = documents.to_json
	    request = Net::HTTP::Post.new(uri.path + '?' + uri.query)
	    request.body = body
	    request['Content-Type'] = 'application/json'
	    request['Content-Length'] = body.bytesize
	    response = http.request(request)
	    return response
	  end

	  def query_documents(field,value)
	    uri = URI("http://#{@host}:#{@port}/solr#{@collection}/select?q=#{field}:#{value}&wt=json")
	    response = Net::HTTP.get_response(uri)
	    return response
	  end

	  def delete_documents(field,value)
	    uri = URI("http://#{@host}:#{@port}/solr#{@collection}/update/json?commit=true&wt=json")
	    http = Net::HTTP.new(uri.host,uri.port)
	    data = {
	      'delete' => {
	        'query' => "#{field}:#{value}"
	      }
	    }
	    body = data.to_json
	    request = Net::HTTP::Post.new(uri.path + '?' + uri.query)
	    request.body = body
	    request['Content-Type'] = 'application/json'
	    request['Content-Length'] = body.bytesize
	    response = http.request(request)
	    return response
	  end

	  def get_default_collection(version)
	  	@collection = ''
	    # on Solr 4 the default collection is not at the root
	    if /^4\.[0-9]{1,}\.[0-9]{1,}/.match(version)
	      @collection = '/collection1'
	    end
	    return @collection
	  end

  	end

  end

end