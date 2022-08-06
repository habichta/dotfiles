for d in ./*/ ; do (cd "$d" && git checkout master || git checkout main && git pull); done
