require "yaleldap/version"
require "net-ldap"

#YaleLDAP Module is xyz
module YaleLDAP
  # Yale's LDAP Host
  LDAP_HOST = 'directory.yale.edu'

  # Yale's LDAP Port
  LDAP_PORT = 389

  # Specify to LDAP that we are searching for people
  LDAP_BASE = 'ou=People,o=yale.edu'

  # The most common Yale LDAP atttributes that we care about extracting
  # LDAP_ATTRS = %w(uid givenname sn mail collegename college class UPI)

  ##
  # lookup by an arbitrary query (netid, email, upi, etc)
  #
  # @param
  #   a hash with the format {:querytype => specificquery}
  #   querytype accepts 'mail', 'uid', 'UPI'
  #
  # @return
  #   standard hash (see extract_attributes)
  #
  # @example
  #   YaleLDAP.lookup(mail: "casey.watts@yale.edu")
  #   YaleLDAP.lookup(uid: "csw3")
  #   YaleLDAP.lookup(UPI: "12714662")
  #
  def self.lookup(input_hash)
    lookup_filter = construct_filter(input_hash)
    ldap_response = execute_query(lookup_filter)
    attributes = extract_attributes(ldap_response)
    return attributes
  end

# private
  #
  # Input a raw LDAP response
  #
  # Output is a hash with keys: first_name, last_name, upi, netid, email, collegename, college, class_year
  #
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
      "college_name" => "collegename",
      "college_abbreviation" => "college",
      "class_year" => "class",
      "school" => "organizationUnitName",
      "telephone" => "officePhone",
      "address" => "postalAddress"
    }
  end

  # Constructs a Net::LDAP::Filter object out of our user input
  # @params the input hash we want users to input, such as {:email => "casey.watts@yale.edu"}
  # @return a net-ldap Net::LDAP::Filter object with our desired query
  def self.construct_filter(input_hash)
    query_type_nickname = input_hash.keys.first
    query_value = input_hash.values.first
    query_type_ldapname = convert_from_nickname(query_type_nickname)
    lookup_filter = Net::LDAP::Filter.eq(query_type_ldapname, query_value)
    return lookup_filter
  end

  # Executes the query on the LDAP server.
  # @params a net-ldap Net::LDAP::Filter object with our desired query
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
    # first_name = extract_attribute(ldap_response, :givenname)
    # last_name = extract_attribute(ldap_response, :sn)
    # upi = extract_attribute(ldap_response, :UPI)
    # netid = extract_attribute(ldap_response, :uid)
    # email = extract_attribute(ldap_response, :mail)
    # collegename = extract_attribute(ldap_response, :collegename)
    # college = extract_attribute(ldap_response, :college)
    # class_year = extract_attribute(ldap_response, :class)

    # return {
    #   first_name: first_name,
    #   last_name: last_name,
    #   yale_upi: upi,
    #   netid: netid,
    #   email: email,
    #   collegename: collegename,
    #   college: college,
    #   class_year: class_year
    # }
  end

  def self.extract_attribute(ldap_response, attribute_name)
    attribute = ldap_response[0][attribute_name][0]
    attribute ||= ""
  end

end