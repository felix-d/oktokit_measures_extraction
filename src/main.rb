#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__),"#{File.dirname(__FILE__)}/../lib")
require 'bundler/setup'
require 'csv'
require 'credentials'
require 'repository'
require 'date'
require 'issues'
require 'utils'


Bundler.require(:default)

#New client
client = Octokit::Client.new :login => Credentials::username, :password => Credentials::password 

#New Repository from client
tp2_repo = Repository.new(client: client, repo: "fernandezpablo85/scribe-java")

#Get specific commits (versions)
version110 = tp2_repo.get_commit("380d858b13f21461ff278333a79d0a8dcecdb395")
version120 = tp2_repo.get_commit("97f45d75e76e45bd24ec810a90dffee793020a6a")
version130 = tp2_repo.get_commit("0a63f935d231eb50ba9db52c0735fbcb96e7589c")

#remplissage des tableaux
issues_11_12 = tp2_repo.issues_in_range(version110.date,version120.date);
issues_12_13 = tp2_repo.issues_in_range(version120.date,version130.date);

#remplissage du hash issues_per_week
issues_per_week_110_120 = Issues::issues_p_w(issues_11_12)
issues_per_week_120_130 = Issues::issues_p_w(issues_12_13)

#Output
CSV.open("../output/results.csv", 'w') do |f|
    Utils::printHeader(f,tp2_repo.repo)
    Utils::printLine(f)
    Utils::printTotalIssues(f,tp2_repo) 
    Utils::printLine(f)
    f << ["ISSUES PER WEEK V1.1.0-1.2.0"]
    Utils::printIPW(f,issues_per_week_110_120)
    f << ["ISSUES PER WEEK V1.2.0-1.3.0"]
    Utils::printIPW(f,issues_per_week_120_130)
    Utils::printLine(f)
    f << ["AVERAGE OF ISSUES PER WEEK"]
    f << ["V1.1.0-V1.2.0"]
    Utils::printAIPW(f, issues_per_week_110_120)
    f << ["V1.2.0-V1.3.0"]
    Utils::printAIPW(f, issues_per_week_120_130)
    Utils::printLine(f)   
end
