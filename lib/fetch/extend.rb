#--
#
# Copyright (c) 2009 by Thoughtcrime, llc. All Rights Reserved.
#
# File name: extend.rb
# Author:    Jay Hoover
# Date:      12/23/2009
#
#++
#
# === File Description
# Some random useful injections


class String
  def self.random(len)
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
    val = ""
    srand
    len.times do
      pos = rand(chars.length)
      val += chars[pos..pos]
    end
    val
  end
end
