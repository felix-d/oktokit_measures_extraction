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

puts "Initializing client..."
#New client
client = Octokit::Client.new :login => Credentials::username, :password => Credentials::password 

puts "Initiaizing repository..."
#New Repository from client
tp2_repo = Repository.new(client: client, repo: "fernandezpablo85/scribe-java")

puts "Getting versions..."
#Get specific commits (versions)
version110 = tp2_repo.get_commit("380d858b13f21461ff278333a79d0a8dcecdb395")
version120 = tp2_repo.get_commit("97f45d75e76e45bd24ec810a90dffee793020a6a")
version130 = tp2_repo.get_commit("0a63f935d231eb50ba9db52c0735fbcb96e7589c")

puts "Getting issues..."
#remplissage des tableaux
issues_11_12 = tp2_repo.issues_in_range(version110.date,version120.date)
issues_12_13 = tp2_repo.issues_in_range(version120.date,version130.date)

puts "Getting commits..."
commits_11_12 = tp2_repo.commits_in_range(version110.date, version120.date)
commits_12_13 = tp2_repo.commits_in_range(version120.date, version130.date)

puts "Listing issues per week..."
#remplissage du hash issues_per_week
issues_per_week_110_120 = ApiCalls::issues_p_w(issues_11_12)
issues_per_week_120_130 = ApiCalls::issues_p_w(issues_12_13)

puts "Listing number of files modified per commit..."
#remplissage du hash files_per_commit
files_per_commit_11_12 = ApiCalls::files_p_c(tp2_repo, commits_11_12)
files_per_commit_12_13 = ApiCalls::files_p_c(tp2_repo, commits_12_13)

puts "Listing number of changes per commit..."
#remplissage du hash changes_per_commit
changes_per_commit_11_12 = ApiCalls::changes_p_c(tp2_repo, commits_11_12)
changes_per_commit_12_13 = ApiCalls::changes_p_c(tp2_repo, commits_12_13)

puts "Writing output..."
#output
CSV.open("../output/results.csv", 'w') do |f|

    Utils::printHeader(f,tp2_repo.repo)
    Utils::printLine(f)

    Utils::printTotalIssues(f,tp2_repo) 
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

    f << ["Changes per commit"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printPC(f, changes_per_commit_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printPC(f, changes_per_commit_12_13)
    Utils::printLine(f)

    f << ["Average of changes per commit"]
    f << ["v1.1.0-v1.2.0"]
    Utils::printAPC(f, changes_per_commit_11_12)
    f << ["v1.2.0-v1.3.0"]
    Utils::printAPC(f, changes_per_commit_12_13)
end

puts "DONE!"
