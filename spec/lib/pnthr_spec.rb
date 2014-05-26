require 'spec_helper'
require 'pnthr'

describe Pnthr do

  host_url = 'https://pnthr-api.herokuapp.com/'
  # host_url = 'http://localhost:3000/'
  ssl_on = true
  app_id = '538362a63832640002020000'
  app_secret = '8d1067143a608920a56f4d4a7c6e3d4b'
  app_password = '22e5ab5743ea52caf34abcc02c0f161d'

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
    response.body.should eq 'VlxVfECSfl9Gd+Coafs=-538362a638326400'
  end

  it "should encrypt with a predictable string" do
    test = Base64.encode64(pnthr.encrypt('this is a test')).strip! + "-#{app_id[0..15]}"

    test.should eq 'Xwt+WH8rcvyxw6t28LA=-538362a638326400'
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
