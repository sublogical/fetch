#--
#
# Copyright (c) 2009 by Thoughtcrime, llc. All Rights Reserved.
#
# File name: fetch.rb
# Author:    Jay Hoover
# Date:      12/23/2009
#
#++
#
# === File Description
# Primary include for fetch library
#

require 'net/http'
require 'nokogiri'

module Fetch
  class Handler
    @@handler_registry = {}
    
    def self.register_type(type)
      @@handler_registry[type] = self
    end

    def self.process(job)
      handler_klass = @@handler_registry[job.handler_type.to_sym]
      if !handler_klass.nil?
        handler = handler_klass.new
        handler.process(job)
      end
    end

    # ripped from net/http example
    def fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      response = Net::HTTP.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess
        response
      when Net::HTTPRedirection
        fetch(response['location'], limit - 1)
      else
        response.error!
      end
    end

    def process(job)
      resp = fetch(job.url)

      doc = Nokogiri::HTML.parse(resp.body)

      ####
      # Search for nodes by xpath

      doc.xpath('//a').each do |link|
        puts link['href']
      end
      
      # todo: go get hte file
      # todo: get links to follow
      extract_links(doc)
      
      # todo: get data to mine
      extract_output(doc)
    end

    def extract_links(file)
    end

    def extract_output(file)
    end
  end
end
