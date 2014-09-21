[![Gem Version](https://badge.fury.io/rb/yaleldap.svg)](http://badge.fury.io/rb/yaleldap)
[![Dependency Status](https://gemnasium.com/YaleSTC/yaleldap.svg)](https://gemnasium.com/YaleSTC/yaleldap)
[![Build Status](https://travis-ci.org/YaleSTC/yaleldap.svg?branch=testinghound)](https://travis-ci.org/YaleSTC/yaleldap)
[![Code Climate](https://codeclimate.com/github/YaleSTC/yaleldap/badges/gpa.svg)](https://codeclimate.com/github/YaleSTC/yaleldap)
[![Test Coverage](https://codeclimate.com/github/YaleSTC/yaleldap/badges/coverage.svg)](https://codeclimate.com/github/YaleSTC/yaleldap)
[![Inline docs](http://inch-ci.org/github/YaleSTC/yaleldap.png?branch=master)](http://inch-ci.org/github/YaleSTC/yaleldap)
[![Coverage Status](https://coveralls.io/repos/YaleSTC/yaleldap/badge.png)](https://coveralls.io/r/YaleSTC/yaleldap)

# YaleLDAP

Offers the most common Yale LDAP search queries, returning a convenient ruby hash with names you can understand. Makes it easy to conserve your Yale users' time and energy, saving them from typing again and again that basic information they *know* mother Yale already has on record.

The LDAP server can only be connected to from Yale's campus or on Yale's VPN.

## Installation

Add this line to your application's Gemfile:

    gem 'yaleldap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaleldap

## Usage

###UPI
```
YaleLDAP.lookup(upi: "12714662")
=> {:first_name=>"Casey", :nickname=>"", :last_name=>"Watts", :upi=>"12714662", :netid=>"csw3", :email=>"casey.watts@yale.edu", :college_name=>"", :college_abbreviation=>"", :class_year=>"", :school=>"", :telephone=>"", :address=>"ITS Student Technology Collaborative\nPO BOX 208300\nNew Haven, CT 06520-8300"}
```

###NetID
```
YaleLDAP.lookup(netid: "csw3")
=> {:first_name=>"Casey", :nickname=>"", :last_name=>"Watts", :upi=>"12714662", :netid=>"csw3", :email=>"casey.watts@yale.edu", :college_name=>"", :college_abbreviation=>"", :class_year=>"", :school=>"", :telephone=>"", :address=>"ITS Student Technology Collaborative\nPO BOX 208300\nNew Haven, CT 06520-8300"}
```

###Email
```
YaleLDAP.lookup(email: "casey.watts@yale.edu")
=> {:first_name=>"Casey", :nickname=>"", :last_name=>"Watts", :upi=>"12714662", :netid=>"csw3", :email=>"casey.watts@yale.edu", :college_name=>"", :college_abbreviation=>"", :class_year=>"", :school=>"", :telephone=>"", :address=>"ITS Student Technology Collaborative\nPO BOX 208300\nNew Haven, CT 06520-8300"}
```


## Documentation
The source code is documented thoroughly, view it on [rdoc.info](http://rdoc.info/github/YaleSTC/yaleldap/master/frames)

For more background on how the `net-ldap` gem works with specific Yale examples, check out this [Yale net-ldap gist](https://gist.github.com/caseywatts/ddea3996853050d1e5ad).

## Contributing

1. Fork it ( http://github.com/YaleSTC/yaleldap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
