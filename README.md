[![Gem Version](https://badge.fury.io/rb/yaleldap.svg)](http://badge.fury.io/rb/yaleldap)
[![Dependency Status](https://gemnasium.com/YaleSTC/yaleldap.svg)](https://gemnasium.com/YaleSTC/yaleldap)
[![Build Status](https://travis-ci.org/YaleSTC/yaleldap.svg?branch=testinghound)](https://travis-ci.org/YaleSTC/yaleldap)
[![Code Climate](https://codeclimate.com/github/YaleSTC/yaleldap/badges/gpa.svg)](https://codeclimate.com/github/YaleSTC/yaleldap)
[![Test Coverage](https://codeclimate.com/github/YaleSTC/yaleldap/badges/coverage.svg)](https://codeclimate.com/github/YaleSTC/yaleldap)
[![Inline docs](http://inch-ci.org/github/YaleSTC/yaleldap.png?branch=master)](http://inch-ci.org/github/YaleSTC/yaleldap)

# YaleLDAP

Offers the most common Yale LDAP search queries, returning a convenient ruby hash with names you can understand. Makes it easy to conserve your Yale users' time and energy, saving them from typing again and again that basic information they *know* mother Yale already has on record.

The LDAP server behaves differently depending on whether you are on Yale's network (on campus/VPN) or not. Some information (like name, upi) are available from anywhere, while other information (like netid, office phone number) are only available on Yale's network.

## Installation

Add this line to your application's Gemfile:

    gem 'yaleldap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yaleldap

To play with it, open `irb` and try these:

```
require 'yaleldap'
attributes = YaleLDAP.lookup(netid: "csw3")
attributes = YaleLDAP.lookup(email: "casey.watts@yale.edu")
attributes = YaleLDAP.lookup(upi: "12714662")
```


## Usage

###NetID
```
YaleLDAP.lookup(netid: "csw3")
=> {:first_name=>"Casey", :nickname=>"", :last_name=>"Watts", :upi=>"12714662", :netid=>"csw3", :email=>"casey.watts@yale.edu", :title=>"Assistant Manager", :division=>"Information Technology Services", :school=>"Information Technology Services", :school_abbreviation=>"", :organization=>"ITSCCT Web Technologies", :major=>"", :curriculum=>"", :college_name=>"", :college_abbreviation=>"", :class_year=>"", :telephone=>"203-436-5986", :address=>"ITS Student Technology Collaborative\nPO BOX 208300\nNew Haven, CT 06520-8300"}
```

###Email
```
YaleLDAP.lookup(email: "casey.watts@yale.edu")
=> {:first_name=>"Casey", :nickname=>"", :last_name=>"Watts", :upi=>"12714662", :netid=>"csw3", :email=>"casey.watts@yale.edu", :title=>"Assistant Manager", :division=>"Information Technology Services", :school=>"Information Technology Services", :school_abbreviation=>"", :organization=>"ITSCCT Web Technologies", :major=>"", :curriculum=>"", :college_name=>"", :college_abbreviation=>"", :class_year=>"", :telephone=>"203-436-5986", :address=>"ITS Student Technology Collaborative\nPO BOX 208300\nNew Haven, CT 06520-8300"}
```

###UPI
```
YaleLDAP.lookup(upi: "12714662")
=> {:first_name=>"Casey", :nickname=>"", :last_name=>"Watts", :upi=>"12714662", :netid=>"csw3", :email=>"casey.watts@yale.edu", :title=>"Assistant Manager", :division=>"Information Technology Services", :school=>"Information Technology Services", :school_abbreviation=>"", :organization=>"ITSCCT Web Technologies", :major=>"", :curriculum=>"", :college_name=>"", :college_abbreviation=>"", :class_year=>"", :telephone=>"203-436-5986", :address=>"ITS Student Technology Collaborative\nPO BOX 208300\nNew Haven, CT 06520-8300"}
```


## Return Data
###What data is returned?
>"What does the returned data look like? Where does it come from?"

We map a memorable nickname to each of the less memorable formal LDAP names.
- The easiest way to see what attributes are available is to test it out.
- Our full list of nicknames is in `lib/yaleldap.rb` under `self.nicknames`
- Yale's list of formal LDAP attribute names are listed [here](http://directory.yale.edu/phonebook/help.htm).
- Here are some examples of what the more vague LDAP terms contain. We've included multiple aliases for some of these.
```
Division [listed as division, school] - general category, most people have this. For students, this is their school)
  Yale College
  Graduate School of Arts & Sci
  Architecture School
  Pharmacology
  MYSM School Of Medicine
  Information Technology Services

Curriculum Code [listed as school_abbreviation] - seems to be abbreviation of division if they are a school?)
  YC
  GS
  AC

Organization [listed as organization] - more specific, staff tend to have these
  MPHARM Administration
  ITSCCT Web Technologies

Curriculum/Major [listed as curriculum, major] - more specific, students tend to have these
  Pharmacology
  Architecture School
  Physics
```

### Something's Missing?
>"I want some data that's in the [Yale Phonebook](http://directory.yale.edu/phonebook/index.htm) but it's not in the `YaleLDAP` gem."

- If you think there is a commonly used field we missed, file a github issue! :D
- If you'd like more control over your YaleLDAP connection, you could do this all manually. [Here is a gist](https://gist.github.com/caseywatts/ddea3996853050d1e5ad) of how to use the 'net-ldap' gem to access Yale's LDAP.


## Use in Rails
You can use an "after_create" filter to have these attributes filled out after the user is created (maybe after first login if that's how your app works). `.slice(:first_name, :last_name, :netid)` will extract only the attributes you want to save to ActiveRecord. If your database uses diferent names you will have to rename the appropriate attributes manually using your own ruby code.
```
class User < ActiveRecord::Base
  after_create :get_ldap_attributes

  def get_ldap_attributes
    attributes = YaleLDAP.lookup(netid: netid)
      .slice(:first_name, :last_name, :netid)
    self.update_attributes(attributes)
  rescue
    false # don't actually save it if LDAP lookup fails
  end
end
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

### Development
1. You can load the file you're working on by opening irb and running `load "./lib/yaleldap.rb"` (from the directory this repo is in).
2. You can run our testing suite by running `bundle exec guard`, which uses guard-rspec to run our testing suite.
3. We use YARD for in-line documentation , to view the documentation locally run `yard` then open `docs/index.html` to view them.
4. Our testing suite is automatically run on Travis CI.

