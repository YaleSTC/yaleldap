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
  LDAP_ATTRS = %w(uid givenname sn mail collegename college class UPI)

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
  def self.lookup(lookup_hash)
    lookup_type = lookup_hash.keys.first
    # lookup_type = convertTheLookupType(lookup_type)
    lookup_query = lookup_hash[lookup_type]
    lookup_filter = Net::LDAP::Filter.eq(lookup_type, lookup_query)

    # execute query
    ldap = Net::LDAP.new host: LDAP_HOST, port: LDAP_PORT
    ldap_response = ldap.search(base: LDAP_BASE,
                     filter: lookup_filter,
                     attributes: LDAP_ATTRS)
    extract_attributes(ldap_response)
  end

private
  #
  # Input a raw LDAP response
  #
  # Output is a hash with keys: first_name, last_name, upi, netid, email, collegename, college, class_year
  #
  def self.extract_attributes(ldap_response)
    # everyone has these
    first_name = ldap_response[0][:givenname][0]
    last_name = ldap_response[0][:sn][0]
    upi = ldap_response[0][:UPI][0]

    # not everyone has these
    netid = ldap_response[0][:uid][0] || ""
    email = ldap_response[0][:mail][0] || ""
    collegename = ldap_response[0][:collegename][0] || ""
    college = ldap_response[0][:college][0] || ""
    class_year = ldap_response[0][:class][0] || ""

    return {
      first_name: first_name,
      last_name: last_name,
      yale_upi: upi,
      netid: netid,
      email: email,
      collegename: collegename,
      college: college,
      class_year: class_year
    }
  end

end