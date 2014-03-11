module Utils
    def Utils::printHeader(file, name)
        file << ["REPOSITORY NAME", name]
    end

    def Utils::printTotalIssues(file, repo)
        file << ["TOTAL CLOSED ISSUES", repo.closed_issues.size]
        file << ["TOTAL OPEN ISSUES", repo.open_issues.size]
    end

    def Utils::printLine(file)
        file << ["##################################"]
    end

    def Utils::printIPW(file, issues)
        issues.each do |key,value|
            file << [key[:year].to_s,key[:week],value.to_s] 
        end
    end

    def Utils::printPC(file, commits)
        commits.each do |key,value|
            file << [key, value]
        end
    end

    def Utils::printAIPW(issues)
        total = 0
        issues.each do |key,value|
            total += value
        end
        return (total/issues.size.to_f).round(2)
    end

    def  Utils::printAIPC(issues, commits)
        return (issues.size/commits.size.to_f).round(2)
    end
    
    
    def Utils::printAPC(commits)
        total = 0
        commits.each do |key,value|
            total += value
        end
        return (total/commits.size.to_f).round(2)
    end

    def  Utils::printCPU(file, cpu)
        cpu.each do |key,value|
            file << [key, value[0], value[1]]
        end
    end

    def  Utils::printACPU(cpu)
        total = 0
        cpu.each do |key, value|
            total += value[0]
        end
        return (total/cpu.size.to_f).round(2)
    end

    def  Utils::printALPU(cpu)
        total = 0
        cpu.each do |key, value|
            total += value[1]
        end
        return (total/cpu.size.to_f).round(2)
    end

end


