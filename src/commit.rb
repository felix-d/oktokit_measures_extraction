class Commit
    attr_accessor :sha, :commit, :date
    def initialize(options)
        @client = options[:client]
        @repo = options[:repo]
        @sha = options[:sha]
        @commit = @client.commit(@repo, sha)
        @date = @commit[:commit][:author][:date]
    end
end
        
