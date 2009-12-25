#--
#
# Copyright (c) 2009 by Thoughtcrime, llc. All Rights Reserved.
#
# File name: client.rb
# Author:    Jay Hoover
# Date:      12/23/2009
#
#++
#
# === File Description
# Submits a job to the fetch redis-queue

require 'fetch/extend.rb'

module Fetch
  
  class Client
    public
    def self.create_crawl_id
      String.random(20)
    end
    
    public
    def submit(crawl_id, type, urls)
      urls = [urls] if !urls.is_a?(Array)
      urls.each do |url|
        job = Job.new(type, url)
        connection.submit(crawl_id, job)
      end
    end

    private
    def connection
      @connection ||= Connection.new
      @connection
    end
  end
end
