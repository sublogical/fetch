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

require 'fetch/extend'
require 'fetch/connection'

module Fetch
  
  public
  def self.create_crawl_id
    String.random(20)
  end
    
  class Client < Connection
    public
    def submit_urls(crawl_id, type, urls)
      urls = [urls] if !urls.is_a?(Array)
      urls.each do |url|
        job = Job.new(type, url)
        self.submit(crawl_id, job)
      end
    end

    private
    def connection
      @connection ||= Connection.new(@options)
      @connection
    end
  end
end
