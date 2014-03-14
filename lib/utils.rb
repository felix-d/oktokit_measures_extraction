module Utils
    #print header
    def Utils::printHeader(file, name)
        file << ["REPOSITORY NAME", name]
    end

    #print total number of issues
    def Utils::printTotalIssues(file, repo)
        file << ["TOTAL CLOSED ISSUES", repo.closed_issues.size]
        file << ["TOTAL OPEN ISSUES", repo.open_issues.size]
    end

    #print line
    def Utils::printLine(file)
        file << ["##################################"]
    end

    #get issues per week
    def Utils::getIPW(file, issues)
        issues.each do |key,value|
            file << [key[:year].to_s,key[:week],value.to_s] 
        end
    end

    #print number of files modified per commit
    def Utils::printPC(file, commits)
        commits.each do |key,value|
            file << [key, value]
        end
    end

    #get average of issues per week
    def Utils::getAIPW(issues)
        total = 0
        issues.each do |key,value|
            total += value
        end
        return (total/issues.size.to_f).round(2)
    end

    #get average of issues per commit
    def  Utils::getAIPC(issues, commits)
        return (issues.size/commits.size.to_f).round(2)
    end
    
    
    #get average of given value for commits
    def Utils::getAPC(commits)
        total = 0
        commits.each do |key,value|
            total += value
        end
        return (total/commits.size.to_f).round(2)
    end

    #print number of commits per user
    def  Utils::printCPU(file, cpu)
        cpu.each do |key,value|
            file << [key, value[0], value[1]]
        end
    end

    #get average commit number per committer
    def  Utils::getACPU(cpu)
        total = 0
        cpu.each do |key, value|
            total += value[0]
        end
        return (total/cpu.size.to_f).round(2)
    end

    #get average LOC changes per committer
    def  Utils::getALPU(cpu)
        total = 0
        cpu.each do |key, value|
            total += value[1]
        end
        return (total/cpu.size.to_f).round(2)
    end

    #Get number of days for a given time lapse
    def Utils::getDaysOfRange(date1, date2)
        range = date2 - date1
        dd = range.div(60).div(60).div(24)
        return dd
    end


end


