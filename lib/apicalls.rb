require 'commit'

module ApiCalls

    def ApiCalls::issues(options)
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

    def ApiCalls::issues_p_w(issues)
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

    def ApiCalls::commits(options)
        commits = options[:client].list_commits(options[:repo], per_page:100)
        last_response = options[:client].last_response
        loop do
            last_response = last_response.rels[:next].get
            data = last_response.data
            commits.concat data
            break if last_response.rels[:next].nil?
        end until last_response.rels[:next].nil?
        return commits
    end

  def ApiCalls::files_p_c(repo, commits)
      files_per_commit = Hash.new
      commits.each do |c|
          current = repo.get_commit(c[:sha]) 
          files_per_commit[c[:sha]] = current.file_changes
      end
      return files_per_commit
  end

  def ApiCalls::changes_p_c(repo,commits)
      changes_per_commit = Hash.new
      commits.each do |c|
          current = repo.get_commit(c[:sha])
          changes_per_commit[c[:sha]] = current.total_changes
      end
      return changes_per_commit
  end

end

