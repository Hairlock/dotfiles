#!/run/current-system/sw/bin/bash
git add .
read -p "Commit description: " desc
git commit -m "$desc"
git push origin master
