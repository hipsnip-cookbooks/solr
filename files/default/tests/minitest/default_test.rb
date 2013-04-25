require File.expand_path('../support/helpers', __FILE__)
require 'net/http'

describe_recipe "hipsnip-jetty::default" do
  include Helpers::CookbookTest

  # is Jetty up?
  before do
    uri = URI("http://127.0.0.1:#{node.jetty.port}/solr/")
    attempts_total = 3;
    attempts_remaining = attempts_total
    wait_between_attempt = 10
    while attempts_remaining != 0
      begin
        if attempts_remaining != attempts_total
          puts "New attempt in #{wait_between_attempt} seconds..."
          sleep(wait_between_attempt)
        end
        attempts_remaining = attempts_remaining - 1
        response = Net::HTTP.get_response(uri)
        break
      rescue Errno::ECONNREFUSED => econnrefused
        #catch connection error
        puts econnrefused.inspect
        puts "#{attempts_remaining}/#{attempts_total} remaining attempt(s) ..."
        if attempts_remaining == 0
         raise econnrefused
        end
      end
    end
  end

  it "should have deployed Solr on the Jetty server" do
    uri = URI("http://127.0.0.1:#{node.jetty.port}/solr/")
    response = Net::HTTP.get_response(uri)
    assert_instance_of(Net::HTTPOK, response,"HTTP response on the Solr root")
  end
  it "should be possible to ping Solr admin" do
    uri = URI("http://127.0.0.1:#{node.jetty.port}/solr/admin/ping?wt=json")
    response = Net::HTTP.get_response(uri)
    assert_instance_of(Net::HTTPOK,response,'HTTP response of the ping')
  end
  it "should be possible to query Solr" do
    collection = get_default_collection
    response = query_documents(collection,'*','*')
    assert_instance_of(Net::HTTPOK,response,'HTTP response of the query command')
  end
  it "should be possible to add documents into Solr" do
    collection = get_default_collection
    data = [
      {
        'id' => '1',
        'title' => 'title1'
      },
      {
        'id' => '2',
        'title' => 'title2'
      }
    ]
    response = add_documents(collection,data)
    assert_instance_of(Net::HTTPOK,response,'HTTP response of the add command')
  end
  it "should be possible to query documents just added in Solr and delete them after" do
    collection = get_default_collection
    documents = [
      {
        'id' => '10',
        'title' => 'random10'
      },
      {
        'id' => '20',
        'title' => 'random20'
      }
    ]
    add_response = add_documents(collection,documents)
    assert_instance_of(Net::HTTPOK,add_response,'HTTP response of the add command')
    query_response = query_documents(collection,'title','random*')
    assert_instance_of(Net::HTTPOK,query_response,'HTTP response of the query command')
    delete_response = delete_documents(collection,'title','random*')
    assert_instance_of(Net::HTTPOK,delete_response,'HTTP response of the delete command')
    data = JSON.parse(query_response.body)
    assert_equal(0,data['responseHeader']['status'],'status of the Solr query')
    assert_equal(2,data['response']['numFound'],'number of products found')
  end
  it "should be possible to delete documents in Solr" do
    collection = get_default_collection
    response = delete_documents(collection,'title','title*')
    assert_instance_of(Net::HTTPOK,response,'HTTP response of the delete command')
  end

  ################################################################################################
  # Helpers for Solr

  def add_documents(collection,documents)
    uri = URI("http://127.0.0.1:#{node.jetty.port}/solr#{collection}/update/json?commit=true&wt=json")
    http = Net::HTTP.new(uri.host,uri.port)
    body = documents.to_json
    request = Net::HTTP::Post.new(uri.path + '?' + uri.query)
    request.body = body
    request['Content-Type'] = 'application/json'
    request['Content-Length'] = body.bytesize
    response = http.request(request)
    return response
  end

  def query_documents(collection,field,value)
    uri = URI("http://127.0.0.1:#{node.jetty.port}/solr#{collection}/select?q=#{field}:#{value}&wt=json")
    response = Net::HTTP.get_response(uri)
    return response
  end

  def delete_documents(collection,field,value)
    uri = URI("http://127.0.0.1:#{node.jetty.port}/solr#{collection}/update/json?commit=true&wt=json")
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

  def get_default_collection
    # on Solr 4 the default collection is not at the root
    collection = ''
    if /^4\.[0-9]{1,}\.[0-9]{1,}/.match(node['solr']['version'])
      collection = '/collection1'
    end
    return collection
  end
end

