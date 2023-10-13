for d in start/*/ ; do (cd "$d" && git checkout master || git checkout main && git pull); done
