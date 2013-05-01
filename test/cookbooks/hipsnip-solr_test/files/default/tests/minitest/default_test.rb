require File.expand_path('../support/helpers', __FILE__)
require 'net/http'

describe_recipe "hipsnip-jetty_test::solr_3.6" do
  include Helpers::CookbookTest

  # is Jetty up?
  before do
    uri = URI("http://127.0.0.1:#{node['jetty']['port']}/solr/")
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
    client = Helpers::Solr::Client.new('127.0.0.1',node['jetty']['port'])
    client.collection = client.get_default_collection(node['solr']['version'])
    response = client.query_documents('*','*')
    assert_instance_of(Net::HTTPOK,response,'HTTP response of the query command')
  end

  it "should be possible to add documents into Solr" do
    client = Helpers::Solr::Client.new('127.0.0.1',node['jetty']['port'])
    client.collection = client.get_default_collection(node['solr']['version'])
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
    response = client.add_documents(data)
    assert_instance_of(Net::HTTPOK,response,'HTTP response of the add command')
  end

  it "should be possible to query documents just added in Solr and delete them after" do
    client = Helpers::Solr::Client.new('127.0.0.1',node['jetty']['port'])
    client.collection = client.get_default_collection(node['solr']['version'])
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
    add_response = client.add_documents(documents)
    assert_instance_of(Net::HTTPOK,add_response,'HTTP response of the add command')
    query_response = client.query_documents('title','random*')
    assert_instance_of(Net::HTTPOK,query_response,'HTTP response of the query command')
    delete_response = client.delete_documents('title','random*')
    assert_instance_of(Net::HTTPOK,delete_response,'HTTP response of the delete command')
    data = JSON.parse(query_response.body)
    assert_equal(0,data['responseHeader']['status'],'status of the Solr query')
    assert_equal(2,data['response']['numFound'],'number of products found')
  end

  it "should be possible to delete documents in Solr" do
    client = Helpers::Solr::Client.new('127.0.0.1',node['jetty']['port'])
    client.collection = client.get_default_collection(node['solr']['version'])
    response = client.delete_documents('title','title*')
    assert_instance_of(Net::HTTPOK,response,'HTTP response of the delete command')
  end

end