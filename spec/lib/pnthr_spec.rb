require 'spec_helper'
require 'pnthr'

describe Pnthr do

  host_url = 'https://pnthr-api.herokuapp.com/'
  ssl_on = true
  id = '53a1c59f6239370002000000'
  secret = 'aa88906ffcf6c59aaf5908d3900f21a6'
  iv = id[0..15]

  pnthr = Pnthr::Security.new(id, secret, url: host_url, ssl: ssl_on, iv: iv)
  response = pnthr.roar('this is a test')

  it 'should have a valid host url' do
    expect(URI.parse(host_url)).to be_a_kind_of(URI::HTTP)
  end

  it 'should have a host url with a trailing slash' do
    expect(/\/$/.match(host_url)).not_to be_nil
  end

  it 'should request the root path' do
    expect(pnthr.request[:uri].path).to eq '/'
  end

  it 'should not use SSL for local tests' do
    expect(pnthr.request[:ssl]).to be true
  end

  it 'should properly set the request url' do
    expect(pnthr.request[:url]).to eq host_url
  end

  it 'should properly set the ssl option' do
    expect(pnthr.request[:ssl]).to eq ssl_on
  end

  it 'should properly set the app id' do
    expect(pnthr.request[:id]).to eq id
  end

  it 'should properly set the app secret' do
    expect(pnthr.request[:secret]).to eq secret
  end

  it 'should properly set the app initialization vector' do
    expect(pnthr.request[:iv]).to eq id[0..15]
  end

  it 'should respond with HTTP 200 code' do
    expect(response.code).to eq '200'
  end

  it 'should respond with a predictable string' do
    expect(response.body).to eq 'U13j4B/NMU7QjkE5IHU=-53a1c59f62393700'
  end

  it 'should encrypt with a predictable string' do
    test = Base64.encode64(pnthr.encrypt('this is a test')).strip! + '-' + iv
    expect(test).to eq 'PtDh+VSHLceJSRGnNOk=-53a1c59f62393700'
  end

  it 'should cage with a predictable string' do
    expect(pnthr.cage('this is a test')).to eq 'PtDh+VSHLceJSRGnNOk=-53a1c59f62393700'
  end

  it 'should release with a predictable string' do
    expect(pnthr.release('U13j4B/NMU7QjkE5IHU=-53a1c59f62393700', 'password')).to eq 'this is a test'
  end

end
