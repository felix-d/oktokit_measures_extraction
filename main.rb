require 'bundler/setup'
require_relative 'credentials'
require_relative 'repository'
Bundler.require(:default)
client = Octokit::Client.new :login => Credentials::username, :password => Credentials::password 
tp2_repo = Repository.new(client: client, repo: "nostra13/Android-Universal-Image-Loader")
puts tp2_repo.open_issues.size
# puts tp2_repo.
