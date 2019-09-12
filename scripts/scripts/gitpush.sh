#!/run/current-system/sw/bin/bash
read -p "Commit description: " desc
git add .
git commit -m "$desc"
git push origin master
