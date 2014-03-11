#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__),"#{File.dirname(__FILE__)}/../lib")
require 'bundler/setup'
require 'csv'
require 'credentials'
require 'repository'
require 'date'
require 'apicalls'
require 'utils'

Bundler.require(:default)

#New client
puts "Initializing client..."
client = Octokit::Client.new :login => Credentials::username, :password => Credentials::password 

#New Repository from client
puts "Initiaizing repository..."
tp2_repo = Repository.new(client: client, repo: "fernandezpablo85/scribe-java")

#Get specific commits (versions)
puts "Getting versions..."
version110 = tp2_repo.get_commit("380d858b13f21461ff278333a79d0a8dcecdb395")
version120 = tp2_repo.get_commit("97f45d75e76e45bd24ec810a90dffee793020a6a")
version130 = tp2_repo.get_commit("0a63f935d231eb50ba9db52c0735fbcb96e7589c")

#remplissage des tableaux
puts "Getting issues..."
issues_11_12 = tp2_repo.issues_in_range(version110.date,version120.date)
issues_12_13 = tp2_repo.issues_in_range(version120.date,version130.date)

puts "Getting commits..."
commits_11_12 = tp2_repo.commits_in_range(version110.date, version120.date)
commits_12_13 = tp2_repo.commits_in_range(version120.date, version130.date)

#remplissage du hash issues_per_week
puts "Listing issues per week..."
issues_per_week_110_120 = ApiCalls::issues_p_w(issues_11_12)
issues_per_week_120_130 = ApiCalls::issues_p_w(issues_12_13)

#remplissage du hash changes_per_commiter
puts "Listing number of commits and changes per user..."
changes_per_user_11_12 = ApiCalls::changes_p_u(tp2_repo, commits_11_12)
changes_per_user_12_13 = ApiCalls::changes_p_u(tp2_repo, commits_12_13)

#remplissage du hash files_per_commit
puts "Listing number of files modified per commit..."
files_per_commit_11_12 = ApiCalls::files_p_c(tp2_repo, commits_11_12)
files_per_commit_12_13 = ApiCalls::files_p_c(tp2_repo, commits_12_13)

#remplissage du hash changes_per_commit
puts "Listing number of changes per commit..."
changes_per_commit_11_12 = ApiCalls::changes_p_c(tp2_repo, commits_11_12)
changes_per_commit_12_13 = ApiCalls::changes_p_c(tp2_repo, commits_12_13)

#output
puts "Writing output..."
CSV.open("../output/results.csv", 'w') do |f|

    Utils::printHeader(f,tp2_repo.repo)
    Utils::printLine(f)

    Utils::printTotalIssues(f,tp2_repo) 
    Utils::printLine(f)

    f << ["Dates of the analysis"]
    f << ["v1.1.0-v1.2.0"]
    f << [version110.date.to_s,version120.date.to_s]
    f << ["v1.2.0-v1.3.0"]
    f << [version120.date.to_s,version130.date.to_s]
    Utils::printLine(f)

    f << [" Nb of Issues per week v1.1.0-1.2.0"]
    Utils::printIPW(f,issues_per_week_110_120)
    f << ["Nb of Issues per week v1.2.0-1.3.0"]
    Utils::printIPW(f,issues_per_week_120_130)
    Utils::printLine(f)

    f << ["average of issues per week"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printAIPW(f, issues_per_week_110_120)
    f << ["v1.2.0-v1.3.0"]
    Utils::printAIPW(f, issues_per_week_120_130)
    Utils::printLine(f)

    f << ["Number of commits"]
    f << ["v1.1.0-v1.2.0"]
    f << [commits_11_12.size]
    f << ["v1.2.0-v1.3.0"]
    f << [commits_12_13.size]
    Utils::printLine(f)

    f << ["Files modified per commit"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printPC(f,files_per_commit_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printPC(f,files_per_commit_12_13)
    Utils::printLine(f)

    f << ["Average of files per commit"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printAPC(f, files_per_commit_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printAPC(f, files_per_commit_12_13)
    Utils::printLine(f)

    
    f << ["Changed LOC per commit"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printPC(f, changes_per_commit_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printPC(f, changes_per_commit_12_13)
    Utils::printLine(f)

    f << ["Average of changed LOC per commit"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printAPC(f, changes_per_commit_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printAPC(f, changes_per_commit_12_13)
    Utils::printLine(f)

    f << ["Number of committers"]
    f << ["v1.1.0-v1.2.0"]
    f << [changes_per_user_11_12.size]
    f << ["v1.2.0-v1.3.0"]
    f << [changes_per_user_12_13.size]
    Utils::printLine(f)

    f << ["Number of commits and changes per user"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printCPU(f, changes_per_user_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printCPU(f, changes_per_user_12_13)
    Utils::printLine(f)

    f << ["Average of commits per user"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printACPU(f, changes_per_user_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printACPU(f, changes_per_user_12_13)
    Utils::printLine(f)

    f << ["Average of LOC changed per user"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printALPU(f, changes_per_user_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printALPU(f, changes_per_user_12_13)
    Utils::printLine(f)



end

puts "DONE!"
