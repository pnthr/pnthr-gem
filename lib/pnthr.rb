require "pnthr/version"
require "uri"
require "net/http"
require "net/https"
require "base64"

module Pnthr
  class Security

    attr_accessor :request, :cipher

    def initialize(id, secret, options = {})
      @cipher = OpenSSL::Cipher::AES.new(secret.length * 8, :CFB)

      options[:url] ||= 'https://pnthr-api.herokuapp.com/'
      options[:ssl] = options[:ssl].nil? ? true : options[:ssl]
      options[:iv] ||= Base64.encode64(rand.to_s)[0..15]

      @request = {
        url: options[:url],
        uri: URI.parse(options[:url]),
        id: id,
        iv: options[:iv],
        secret: secret,
        ssl: options[:ssl]
      }
    end

    #
    # Roar - Encrypts the payload, makes the request and returns the response
    #
    def roar(payload)
      make_request(encrypt(payload))
    end

    #
    # Encrypt - Simple AES encryption
    #
    # - a variable length key is used for greatest flexibility
    # - CFB is used
    #
    # + Needs HMAC
    # + Needs variable IV to be passed with request
    #
    def encrypt(data, key = nil, iv = nil)
      key ||= @request[:secret]
      iv ||= @request[:iv]

      @cipher.encrypt
      @cipher.key = key
      @cipher.iv = iv

      @cipher.update(data)
    end

    #
    # Decrypt - Simple AES decryption
    #
    # + Needs to retrieve IV from the first layer
    #
    def decrypt(data, key = nil, iv = nil)
      key ||= @request[:secret]
      iv ||= @request[:iv]

      @cipher.decrypt
      @cipher.key = key
      @cipher.iv = iv

      @cipher.update(Base64.decode64(data))
    end

    private

    def make_request(payload)
      https = Net::HTTP.new(@request[:uri].host, @request[:uri].port)
      https.use_ssl = @request[:ssl]

      package = Base64.encode64(payload).strip! + "-" + @request[:iv]

      https.post(@request[:uri].path, package, { 'pnthr' => @request[:id] })
    end

  end
end
