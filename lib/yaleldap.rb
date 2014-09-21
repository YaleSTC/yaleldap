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

  # ##
  # # Lookup LDAP information by upi
  # # 
  # # @param
  # #   upi as a string, ex "12714662"
  # #
  # # @return
  # #   Standard hash (see extract_attributes)
  # # 
  # # @example
  # #   YaleLDAP.lookup_by_upi("12714662")

  # def self.lookup_by_upi(upi)
  #   ldap = Net::LDAP.new host: LDAP_HOST, port: LDAP_PORT
  #   upifilter = Net::LDAP::Filter.eq('UPI', upi)
  #   ldap_response = ldap.search(base: LDAP_BASE,
  #                    filter: upifilter,
  #                    attributes: LDAP_ATTRS)
  #   extract_attributes(ldap_response)
  # end

  # ##
  # # Lookup LDAP information by netid
  # # 
  # # @param
  # #   netid as a string, ex "csw3"
  # #
  # # @return
  # #   Standard hash (see extract_attributes)
  # # 
  # # @example
  # #   YaleLDAP.lookup_by_netid("csw3")
  # #
  # def self.lookup_by_netid(netid)
  #   ldap = Net::LDAP.new host: LDAP_HOST, port: LDAP_PORT
  #   upifilter = Net::LDAP::Filter.eq('uid', netid)
  #   ldap_response = ldap.search(base: LDAP_BASE,
  #                    filter: upifilter,
  #                    attributes: LDAP_ATTRS)
  #   extract_attributes(ldap_response)
  # end

  # ##
  # # Lookup LDAP information by Yale email address
  # # 
  # # @param
  # #   email as a string, ex "casey.watts@yale.edu"
  # #
  # # @return
  # #   Standard hash (see extract_attributes)
  # # 
  # # @example
  # #   YaleLDAP.lookup_by_email("casey.watts@yale.edu")
  # #
  # def self.lookup_by_email(email)
  #   lookup_type = 'mail'
  #   lookup_query = email
  #   ldap = Net::LDAP.new host: LDAP_HOST, port: LDAP_PORT
  #   upifilter = Net::LDAP::Filter.eq(lookup_type, lookup_query)
  #   ldap_response = ldap.search(base: LDAP_BASE,
  #                    filter: upifilter,
  #                    attributes: LDAP_ATTRS)
  #   extract_attributes(ldap_response)
  # end

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
  def lookup(lookup_type, lookup_query)
    # construct query
    # hardcoded for now
    # lookup_type = 'mail'
    # lookup_query = 'casey.watts@yale.edu'
    lookup_filter = Net::LDAP::Filter.eq(lookup_type, lookup_query)

    # execute query
    ldap = Net::LDAP.new host: LDAP_HOST, port: LDAP_PORT
    ldap_response = ldap.search(base: LDAP_BASE,
                     filter: lookup_filter,
                     attributes: LDAP_ATTRS)
    extract_attributes(ldap_response)
  end

  ##
  # auto-generates many lookup methods for us.
  #
  # @example
  #   YaleLDAP.lookup_by_email("casey.watts@yale.edu")
  #     => YaleLDAP.lookup("email", "casey.watts@yale.edu")
  #
  def method_missing(method_name, *arguments, &block)
    if method_name.to_s =~ /lookup_by_(.*)/
      lookup.send($1, *arguments, &block)
    else
      super
    end
  end

  def respond_to?(method_name, include_private = false)
    method_name.to_s.start_with?('lookup_by_') || super
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