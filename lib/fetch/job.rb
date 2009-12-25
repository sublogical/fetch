#--
#
# Copyright (c) 2009 by Thoughtcrime, llc. All Rights Reserved.
#
# File name: job.rb
# Author:    Jay Hoover
# Date:      12/23/2009
#
#++
#
# === File Description
# Job that can be submitted to the redis-queue

require 'json'

module Fetch
  class Job
    attr_accessor :handler_type
    attr_accessor :url
    
    def initialize(handler_type, url)
      @handler_type = handler_type
      @url = url
    end

    def self.from_json(json)
      self.from_hash(JSON.parse(json))
    end

    def self.from_hash(hash)
      raise "Expected Hash" if !hash.is_a?(Hash)
      raise "Expected Type" if hash['type'].nil?
      raise "Expected URL" if hash['url'].nil?

      Job.new(hash["type"], hash["url"])
    end

    def to_json
      self.to_hash.to_json
    end

    def to_hash
      {
        'type' => @handler_type,
        'url' => @url
      }
    end

    def describe
      "#{@type}: #{@url}"
    end
  end
end
