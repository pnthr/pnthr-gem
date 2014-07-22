require 'pnthr/version'
require 'uri'
require 'net/http'
require 'net/https'
require 'base64'

#
# Pnthr Module
#
# + Needs initializer or config
#
module Pnthr
  #
  # Everything lives in the security class for now
  #
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
    # Encrypt the payload, makes the request and returns the response
    #
    def roar(payload)
      https = Net::HTTP.new(@request[:uri].host, @request[:uri].port)
      https.use_ssl = @request[:ssl]
      https.post(@request[:uri].path, cage(payload), { 'pnthr' => @request[:id] })
    end

    #
    # Cage - Will make our payload without sending
    #
    def cage(payload)
      Base64.encode64(encrypt(payload)).strip! + "-" + @request[:iv]
    end

    #
    # Release - Will fully decrypt a payload to raw text
    #
    def release(payload, password)
      part = payload.split('-')

      level1 = decrypt(Base64.decode64(part[0]), @request[:secret], part[1])
      decrypt(level1, Digest::MD5.hexdigest(password), part[1])
    end

    #
    # Encrypt - Simple AES encryption
    #
    # - a variable length key is used for greatest flexibility
    # - CFB is used
    #
    # + Needs HMAC
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
    def decrypt(data, key = nil, iv = nil)
      key ||= @request[:secret]
      iv ||= @request[:iv]

      @cipher.decrypt
      @cipher.key = key
      @cipher.iv = iv

      @cipher.update(data)
    end

  end
end
