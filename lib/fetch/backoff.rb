#--
#
# Copyright (c) 2009 by Thoughtcrime, llc. All Rights Reserved.
#
# File name: backoff.rb
# Author:    Jay Hoover
# Date:      12/23/2009
#
#++
#
# === File Description
# Implements a backoff timer

module Fetch
  class Backoff
    def initialize(start, inc, max)
      @start = start
      @current = start
      @inc = inc
      @max = max
    end

    def reset
      @current = @start
    end

    def sleep
      Kernel.sleep(@current/1000.0)
      @current = [@max, @current * (1 + @inc)].min 
    end
  end
end
