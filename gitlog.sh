today=$(date +"%d %b %Y")
to_default=$(date -d "$today" +"01 %b %Y")
from_default=$(date -d "$to_default -1 month" +"%d %b %Y")

DEV_HOME="/c/dev"
file="$DEV_HOME/_repos.txt"


read -p "from? ($from_default): " from
read -p "to  ? ($to_default): " to

if [ -z $from ]; then from=$from_default; fi
if [ -z $to ]; then to=$to_default; fi

echo "" >&2
echo "from: $from" >&2
echo "to  : $to" >&2
echo "" >&2

echo "repo,who,yyyy-mm-dd,day,date,descr" > /tmp/$$

for a in `cat $file | grep -v ^# `
do  
	repodir=`echo $a`

	pushd $repodir >/dev/null
    if [ $? -ne 0 ]; then
        echo "$repodir not cloned..."
    else
	    git log --since="$from" --until="$to" --pretty=format:'%cn,%ai,%aD,"%s"' | sed "s/^/${repodir},/" >>/tmp/$$

	    popd >/dev/null
	    echo "" >>/tmp/$$
    fi

done



cat /tmp/$$ | sort -k3 | grep -v "^$"

rm /tmp/$$



