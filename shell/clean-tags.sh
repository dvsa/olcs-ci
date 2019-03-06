#!/usr/bin/env bash

pwd=`pwd`
report=$pwd/tag-cleanup.txt

echo "Tag Clean Up Report" > $report
echo "-------------------" >> $report
echo "" >> $report

for project in $pwd/*/ ; do
    echo "+--------------------+" >> $report
    echo "|Processing $project " >> $report
    echo "+--------------------+" >> $report
    cd $project
    pwd
    git fetch --tags 2>/dev/null
    count=0
    echo "<Tag History>" > TAGS
    for tag in $(git for-each-ref refs/tags --sort=-taggerdate --format='%(refname:short)') ; do
        hash=`git rev-parse $tag`
        echo "${hash} -> ${tag}" >> TAGS
        if (( $count > 2 )); then
            git push --delete origin refs/tags/$tag
            `git tag -d $tag`;
            echo "DELETED: $tag for $hash" >> $report
        else
            echo "KEPT:    $tag for $hash" >> $report
        fi
        count=$((count+1))
    done
    git checkout develop 2>/dev/null
    git checkout -b feauture/tag-cleanup 2>/dev/null 
    git add TAGS
    git commit -m '[AUTO] Added file to track tags following cleanup'
    git push --set-upstream origin feauture/tag-cleanup
    echo "" >> $report
done