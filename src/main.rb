$:.unshift(File.dirname(__FILE__),"#{File.dirname(__FILE__)}/../lib")
require 'bundler/setup'
require 'csv'
require 'credentials'
require 'repository'
Bundler.require(:default)

#New client
client = Octokit::Client.new :login => Credentials::username, :password => Credentials::password 

#New Repository from client
tp2_repo = Repository.new(client: client, repo: "nostra13/Android-Universal-Image-Loader")

#Output
CSV.open("../output/results.csv", 'w') do |f|
    f << ["Repository Name", tp2_repo.repo]
    f << ["# Closed issues", tp2_repo.closed_issues.size]
    f << ["# Open issues", tp2_repo.open_issues.size]
end
