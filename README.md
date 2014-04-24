# Pnthr

A Ruby Gem for using the pnthr security service

## Installation

Add this line to your application's Gemfile:

    gem 'pnthr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pnthr

## Usage

    @pnthr = Pnthr.new(app_id, app_secret)
    @pnthr.roar('data to be encrypted')
    # Response will be a string like: PR/Sfl7o4Y0gjlYZyWg=-534c33bb66373500

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pnthr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
