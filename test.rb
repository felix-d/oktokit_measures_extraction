require 'bundler/setup'
Bundler.require(:default)

client = Octokit::Client.new :login => 'flexdec', :password => 'samson1234'
# Fetch the current user

client.auto_paginate
issues = client.list_issues("nostra13/Android-Universal-Image-Loader", state: "closed", per_page: 100)
last_response = client.last_response
loop do
    last_response = last_response.rels[:next].get
    data = last_response.data
    issues.concat data
    break if last_response.rels[:next].nil?
end
puts issues.size

#puts "#{number_of_pages} pages!"
# while (client.last_response.rels[:next])
#     issues.concat  client.last_response.rels[:next].get.data
#     puts issues.size
# end
# puts issues.size


# while ((data =  client.last_response.rels[:next].get.data) and data.size != 0)
#
#     issues.concat data
#     puts issues.size
# end
# puts issues.size
