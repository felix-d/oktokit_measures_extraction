require_relative "issues"

class Repository
   attr_accessor :closed_issues, :open_issues
    def initialize(options)
        @repo = options[:repo]
        @client = options[:client]
        @closed_issues = Issues::issues(client: @client, repo: @repo, state: "closed")
        @open_issues = Issues::issues(client: @client, repo: @repo, state: "open")
    end    
end


