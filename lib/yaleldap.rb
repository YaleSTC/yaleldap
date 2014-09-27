require "yaleldap/version"
require "net-ldap"

#YaleLDAP Module contains the logic for YaleLDAP
module YaleLDAP
  # Yale's LDAP Host
  LDAP_HOST = 'directory.yale.edu'

  # Yale's LDAP Port
  LDAP_PORT = 389

  # Specify to LDAP that we are searching for people
  LDAP_BASE = 'ou=People,o=yale.edu'

  ##
  # lookup by an arbitrary query (netid, email, upi, etc)
  #
  # @param [Hash] input_hash the query we're looking up with just one key-value pair. It expects the keys 'email', 'netid', 'upi'.
  #
  # @return [hash]
  #   our standard return hash (see README.md for a description of what it returns)
  #
  # @example
  #   YaleLDAP.lookup(email: "casey.watts@yale.edu")
  #   YaleLDAP.lookup(netid: "csw3")
  #   YaleLDAP.lookup(upi: "12714662")
  #
  def self.lookup(input_hash)
    lookup_filter = construct_filter(input_hash)
    ldap_response = execute_query(lookup_filter)
    attributes = extract_attributes(ldap_response)
    return attributes
  end

private

  ###
  # Nickname Logic
  ###

  def self.convert_from_nickname(attribute)
    attribute = attribute.to_s
    nicknames[attribute]
  end

  def self.convert_to_nickname(attribute)
    attribute = attribute.to_s
    nicknames.invert[attribute]
  end

  def self.search_attributes
    nicknames.values
  end

  def self.nicknames
    # a list of attributes we care about
    # "nickname" => "ldapname"
    # "somethingthatmakessense" => "somethingjargony"
    return {
      "first_name" => "givenname",
      "nickname" => "eduPersonNickname",
      "last_name" => "sn",
      "upi" => "UPI",
      "netid" => "uid",
      "email" => "mail",
      "title" => "title",
      "division" => "o",
      "school" => "o",
      "school_abbreviation" => "curriculumshortname",
      "organization" => "ou",
      "major" => "curriculum",
      "curriculum" => "curriculum",
      "college_name" => "collegename",
      "college_abbreviation" => "college",
      "class_year" => "class",
      "telephone" => "telephoneNumber",
      "address" => "postalAddress"
    }
  end



  ###
  #LDAP Search Logic
  ###


  # Constructs a Net::LDAP::Filter object out of our user input
  # @param the input hash we want users to input, such as {:email => "casey.watts@yale.edu"}
  # @return a net-ldap Net::LDAP::Filter object with our desired query
  def self.construct_filter(input_hash)
    query_type_nickname = input_hash.keys.first.to_s
    query_value = input_hash.values.first.to_s
    query_type_ldapname = convert_from_nickname(query_type_nickname)
    lookup_filter = Net::LDAP::Filter.eq(query_type_ldapname, query_value)
    return lookup_filter
  end

  # Executes the query on the LDAP server.
  # @param a net-ldap Net::LDAP::Filter object with our desired query
  # @return the raw net-ldap LDAP response object
  def self.execute_query(lookup_filter)
    ldap = Net::LDAP.new host: LDAP_HOST, port: LDAP_PORT
    ldap_response = ldap.search(base: LDAP_BASE,
                     filter: lookup_filter,
                     attributes: search_attributes)
    return ldap_response
  end


  def self.extract_attributes(ldap_response)
    attributes = {}
    nicknames.each do |nickname, ldapname|
      attribute = extract_attribute(ldap_response, ldapname)
      attribute = attribute.gsub(/\$/,"\n") #for address
      attributes[nickname.to_sym] = attribute
    end
    return attributes
  end

  def self.extract_attribute(ldap_response, attribute_name)
    attribute = ldap_response[0][attribute_name][0]
    attribute ||= ""
  end

end