```#!/usr/bin/env bash

pwd=`pwd`
report=$pwd/tag-cleanup.txt
cd
echo "Tag Clean Up Report" > $report
echo "-------------------" >> $report
echo "" >> $report

for project in */ ; do
    echo "+--------------------+" >> $report
    echo "|Processing $project " >> $report
    echo "+--------------------+" >> $report
    cd $pwd/$project
    git fetch --tags 2>/dev/null
    count=0
    echo "<Tag History>" > TAGS
    for tag in $(git for-each-ref refs/tags --sort=-taggerdate --format='%(refname)') ; do
        hash=`git rev-parse $tag`
        echo "${hash} -> ${tag}" >> TAGS
        count=$((count+1))
        if (( $count > 3 )); then
            # git push --delete origin $tag
            # git tag -d $tag
            echo "DELETED: $tag for $hash" >> $report
        else
            echo "KEPT:    $tag for $hash" >> $report
        fi
    done
    # git checkout develop 2>/dev/null
    # git branch -b tag-cleanup 2>/dev/null
    # git add TAGS
    # git commit -m '[AUTO] Added file to track tags for cleanup'
    # git push --set-upstream origin feature/tag-cleanup
    echo "" >> $report
done```

