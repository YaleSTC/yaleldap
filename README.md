# Yaleldap

Automatically connects to the LDAP server if you are on campus/VPN. Can be queried by UPI, and it will return a simple ruby hash with the relevant information.

## Installation

Add this line to your application's Gemfile:

    gem 'yaleldap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaleldap

## Usage

`YaleLDAP.lookup_by_upi("123456")` will return a hash with commonly needed LDAP attributes.



## Contributing

1. Fork it ( http://github.com/<my-github-username>/yaleldap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
