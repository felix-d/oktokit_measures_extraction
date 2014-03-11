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

    def Utils::printAIPW(file, issues)
        total = 0
        issues.each do |key,value|
            total += value
        end
        file << [(total/issues.size.to_f).round(2)]
    end
    
    def Utils::printAPC(file, commits)
        total = 0
        commits.each do |key,value|
            total += value
        end
        file << [(total/commits.size.to_f).round(2)]
    end

    def  Utils::printCPU(file, cpu)
        cpu.each do |key,value|
            file << [key, value[0], value[1]]
        end
    end

    def  Utils::printACPU(file, cpu)
        total = 0
        cpu.each do |key, value|
            total += value[0]
        end
        file << [(total/cpu.size.to_f).round(2)]
    end

    def  Utils::printALPU(file, cpu)
        total = 0
        cpu.each do |key, value|
            total += value[1]
        end
        file << [(total/cpu.size.to_f).round(2)]
    end
end


