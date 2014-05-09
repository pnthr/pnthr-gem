require 'spec_helper'
require 'pnthr'

describe Pnthr do

  host_url = 'https://pnthr-api.herokuapp.com/'
  ssl_on = true
  app_id = '536d49b86336350002000000'
  app_secret = '15e0497a57c6340ccd81b74f0e5de1d7'

  pnthr = Pnthr::Security.new(app_id, app_secret, url: host_url, ssl: ssl_on, iv: app_id[0..15])
  response = pnthr.roar('this is a test')

  it "should have a valid host url" do
    URI.parse(host_url).should be_a_kind_of(URI::HTTP)
  end

  it "should have a host url with a trailing slash" do
    /\/$/.match(host_url).should_not be_nil
  end

  it "should request the root path" do
    pnthr.request[:uri].path.should eq "/"
  end

  it "should not use SSL for local tests" do
    pnthr.request[:ssl].should be true
  end

  it "should properly set the request url" do
    pnthr.request[:url].should eq host_url
  end

  it "should properly set the ssl option" do
    pnthr.request[:ssl].should eq ssl_on
  end

  it "should properly set the app id" do
    pnthr.request[:id].should eq app_id
  end

  it "should properly set the app secret" do
    pnthr.request[:secret].should eq app_secret
  end

  it "should properly set the app initialization vector" do
    pnthr.request[:iv].should eq app_id[0..15]
  end

  it "should respond with HTTP 200 code" do
    response.code.should eq '200'
  end

  it "should respond with a predictable string" do
    response.body.should eq 'uUeZihDFPJ/Pm7k/HqA=-536d49b863363500'
  end

  it "should encrypt with a predictable string" do
    test = Base64.encode64(pnthr.encrypt('this is a test')).strip! + "-#{app_id[0..15]}"

    test.should eq 'ynXLtC+JSE/ApHPT/PQ=-536d49b863363500'
  end

  it "should cage with a predictable string" do
    pnthr.cage('this is a test').should eq 'ynXLtC+JSE/ApHPT/PQ=-536d49b863363500'
  end

  it "should release with a predictable string" do
    pnthr.release('uUeZihDFPJ/Pm7k/HqA=-536d49b863363500', 'testes123').should eq 'this is a test'
  end

end
