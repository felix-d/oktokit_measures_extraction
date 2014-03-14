#Class that represents repositories. Gives easy access to repositories' attributes.

require "apicalls"
require "commit"

class Repository
   attr_accessor :closed_issues, :open_issues, :repo, :total_issues,
       :code_frequencies, :commits_activity, :repo

    def initialize(options)
        @repo = options[:repo]
        @client = options[:client]
        @closed_issues = ApiCalls::issues(client: @client, repo: @repo, state: "closed")
        @open_issues = ApiCalls::issues(client: @client, repo: @repo, state: "open")
        @total_commits = ApiCalls::commits(client: @client, repo: @repo)
        @total_issues = @closed_issues.concat(@open_issues)
        @total_issues.sort_by { |issue| issue[:created_at]}
    end    

    #Return full commmit
    def get_commit(sha)
        Commit.new(client: @client, repo: @repo,sha: sha)
    end

    #Get issues of a repo in a specific time lapse
    def issues_in_range(date1, date2)
        issues_in_range = Array.new
        @total_issues.each do |iss|
            if iss[:created_at] < date2 and iss[:created_at] > date1
                issues_in_range << iss
            end
        end
        return issues_in_range
    end

    #Get commits of a repo in a specific time lapse
    def commits_in_range(date1, date2)
        commits_in_range = Array.new
        @total_commits.each do |comm|
            if comm[:commit][:author][:date] < date2 and  comm[:commit][:author][:date] > date1
                commits_in_range << comm
            end
        end
        return commits_in_range
    end 

end


