#!/bin/bash

REPOSROOTS="/c/GITHUB /c/BITBUCKET /c/ASF /c/GITLAB"

today=$(date +"%d %b %Y")
to_default=$(date -d "$today" +"01 %b %Y")
from_default=$(date -d "$to_default -1 month" +"%d %b %Y")


read -p "from? ($from_default): " from
read -p "to  ? ($to_default): " to

if [ -z $from ]; then from=$from_default; fi
if [ -z $to ]; then to=$to_default; fi

echo "" >&2
echo "from: $from" >&2
echo "to  : $to" >&2
echo "" >&2

> /tmp/$$

for REPOSROOT in `echo $REPOSROOTS`
do
    for a in `ls $REPOSROOT/*/* -1d`
    do

		repodir=`echo $a`

		pushd $repodir >/dev/null
		if [ $? -ne 0 ]; then
			echo "$repodir not cloned..."
		else
			git log --date="format:%Y-%m-%d %H:%M,%a" --since="$from" --until="$to" --pretty=format:'%cn,%ad,"%s"' | sed "s|^|$repodir,|" | grep -i "haywood" >>/tmp/$$

			popd >/dev/null
			echo "" >>/tmp/$$
		fi

	done
done



echo "repo,who,date time,day,descr"
cat /tmp/$$ | sort -t, -k3 | grep -v "^$" 

rm /tmp/$$



