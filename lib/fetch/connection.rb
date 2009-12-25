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

module Fetch
  
  class Connection  
    def submit(crawl_id, job)
      puts "Submitting to crawl:#{crawl_id}: #{pack(job)}"
    end

    private
    def pack(job)
      job.to_json
    end

    private
    def unpack(str)
    end
  end
end

