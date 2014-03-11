class Commit
    attr_accessor :sha, :commit, :date, :file_changes, :total_changes, :author, :files
    def initialize(options)
        @client = options[:client]
        @repo = options[:repo]
        @sha = options[:sha]
        @commit = @client.commit(@repo, sha)
        @files = @commit[:files]
        @file_changes = @commit[:files].size
        @total_changes = getTotalChanges(@commit[:files])
        @date = @commit[:commit][:author][:date]
        @author = @commit[:commit][:author][:name]
    end

    def getTotalChanges(files)
        total = 0
        files.each do |f|
            total += f[:changes]
        end
        return total
    end
end
        
