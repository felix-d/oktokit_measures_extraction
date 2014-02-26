module Issues

    #takes :client => Octokit::Client, :repo => string, :state => string 
    def Issues::issues(options)
        issues = options[:client].list_issues(options[:repo], state: options[:state], per_page: 100)
        last_response = options[:client].last_response
        loop do
            last_response = last_response.rels[:next].get
            data = last_response.data
            issues.concat data
            break if last_response.rels[:next].nil?
        end until last_response.rels[:next].nil?
        return issues
    end
end

