
class LinkedIn < Handler
  register_type :linked_in
  
# Idea for simple DSL for link filtering
#
#  link_filter :domain => /linkedin\.com$/
#  link_filter :uri => /

# Idea for simple DSL for output filters:
#
#  output_filter('//strong[@class="connection-count"]') do |el|
#    :count => el.strip.to_i
#  end
  
  def extract_output(doc)
    doc.css('li.education h3.org').each do |el|
      puts "University = [#{el.content.strip}]"
    end
    
    doc.xpath('//strong[@class="connection-count"]').each do |count|
      puts "Count [#{count.content.strip.to_i}]"
    end        
  end
end
