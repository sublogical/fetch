#--
#
# Copyright (c) 2009 by Thoughtcrime, llc. All Rights Reserved.
#
# File name: connection.rb
# Author:    Jay Hoover
# Date:      12/23/2009
#
#++
#
# === File Description
# Submits a job to the fetch redis-queue

require 'redis'

module Fetch
  
  class Connection
    OPTIONS = {
      :crawl_prefix => 'crawl:',
      :db => 0,
      :ttl => 10000
    }

    def initialize(options = {})
      @options = OPTIONS.update(options)
      @redis = Redis.new(:host => @options[:host],
                         :port => @options[:port],
                         :db => @options[:db])
    end

    public
    def submit(crawl_id, job)
      @redis.push_tail(crawl_key(crawl_id), pack(job))
    end

    public
    def status(crawl_id, from = 0, to = 20)
      count = @redis.list_length(crawl_key(crawl_id))
      jobs_json = @redis.list_range(crawl_key(crawl_id), from, to)
      jobs = jobs_json.collect { |job_json| unpack(job_json) }

      {
        :count => count,
        :jobs => jobs
      }
    end

    public
    def next_job
      queues = self.list.shuffle
      queues.each do |queue|
        job_str = @redis.pop_head(crawl_key(queue))
        if job_str
          if (@redis.list_length(crawl_key(queue)) == 0) then
            @redis.expire(crawl_key(queue), @options[:ttl])
          end
          job = unpack(job_str)
          return job if job
        end
      end
      return nil
    end
    
    public
    def list
      prefix_len = crawl_key('').length
      keys = @redis.keys(crawl_key('*'))
      keys.collect { |key| key[prefix_len..-1]}
    end

    public
    def reset(crawl_id = nil)
      crawl_ids = crawl_id if crawl_id.is_a?(Array)
      crawl_ids = [crawl_id] if !crawl_id.is_a?(Array) && !crawl_id.nil?
      crawl_ids = self.list if crawl_ids.nil? || (crawl_id.is_a?(Array) && crawl_ids.length == 0)

      count = 0
      
      crawl_ids.each do |crawl_id|
        if @redis.del(crawl_key(crawl_id))
          count += 1
        end
      end
      
      count
    end

    private
    def crawl_key(crawl_id) 
      @options[:crawl_prefix]+crawl_id
    end
    
    private
    def pack(job)
      job.to_json
    end

    private
    def unpack(str)
      Job.from_json(str)
    end
  end
end

