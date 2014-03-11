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

    def Issues::issues_p_w(issues)
        issues_per_week = Hash.new
        issues.each do |e|

            current = {
                :week => e[:created_at].strftime('%U').to_i,
                :year => e[:created_at].strftime('%Y').to_i
            }

            if !(issues_per_week[current].nil?)
                issues_per_week[current]+=1 
            else
                issues_per_week[current] = 1
            end
        end
        return issues_per_week.sort_by{ |key, value| key[:year] }.sort_by{ |key,value| key[:week]}
    end

end

