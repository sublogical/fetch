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

module Fetch
  class Handler
    @@handler_registry = {}
    
    def self.register_type(type)
      @@handler_registry[type] = self
    end

    def self.process(job)
      puts "registry = #{@@handler_registry.inspect}"
      handler_klass = @@handler_registry[job.handler_type.to_sym]
      if !handler_klass.nil?
        handler = handler_klass.new
        handler.process(job)
      end
    end
    
    def process(job)
      puts "processing #{job.url}"
      # todo: go get hte file
      # todo: get links to follow
      extract_links(file)
      
      # todo: get data to mine
      extract_output(file)
    end

    def extract_links(file)
    end

    def extract_output(file)
    end
  end
end
