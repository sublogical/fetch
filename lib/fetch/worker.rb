#--
#
# Copyright (c) 2009 by Thoughtcrime, llc. All Rights Reserved.
#
# File name: worker.rb
# Author:    Jay Hoover
# Date:      12/23/2009
#
#++
#
# === File Description
# Implements a worker thread that processes 

require 'rand'

module Fetch
  class Worker < Connection
    @@templates = []

    public
    def run(iterations)
      backoff = Backoff.new(100,  # 100ms starting timer
                            0.10, # 10% increase in backoff per iteration
                            2000) # 2s max timer
      
      while iterations > 0
        job_spec = self.next_job
        if job_spec
          Fetch::Handler.process(job_spec)
          backoff.reset
        else
          backoff.sleep
        end
      end
    end

    public
    def self.load_handlers(working_dir)
      self.templates_in_path(working_dir) do |template|
        template.load
        @@templates << template
      end
    end

    private
    def self.templates_in_path(working_dir)
      (Dir.glob("#{working_dir}/app/*/**") | Dir.glob("#{working_dir}/app/**")).each do |file|
        unless File.directory?(file)
          yield Template.new(file.split("#{working_dir}/app/").last, file)
        end
      end
    end
  end

  class Template
    def initialize(name, path)
      @name = name
      @path = path
    end

    def load
      require @path
    end

    def describe
      "#{@name}: #{@path}"
    end
  end
end
