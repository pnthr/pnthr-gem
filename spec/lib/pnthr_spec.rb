require 'spec_helper'
require 'pnthr'

describe Pnthr do

  host_url = 'https://pnthr-api.herokuapp.com/'
  ssl_on = true
  app_id = '534c33bb6637350002000000'
  app_secret = '9857ec6046ee8d22b90ce68214a8304b'

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
    response.body.should eq 'NuCn7VFKvrcLzneoRG4=-534c33bb66373500'
  end

  it "should encrypt with a predictable string" do
    test = Base64.encode64(pnthr.encrypt('this is a test')).strip! + "-#{app_id[0..15]}"

    test.should eq 'PR/Sfl7o4Y0gjlYZyWg=-534c33bb66373500'
  end

  # it "should fail without user, password, name, city, state, and products" do
  #   expect { CorteraApi.new(user: 'foo').login }.to raise_error(RuntimeError, 'A password must be provided for Cortera API')
  #   expect { CorteraApi.new(password: 'bar').login }.to raise_error(RuntimeError, 'A user must be provided for Cortera API')
  #
  #   cortera.get()["ReportResult"]["Status"].should eq 400
  # end
  #
  # it "should fail authentication" do
  #   cortera.get({:params => {name: "Arrae", city: "Denver", state: "CO"}})["ReportResult"]["Status"].should eq 401
  # end

end
