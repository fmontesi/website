#!/bin/zsh

# shopt -s nullglob

declare -A bliki
ids=()
lastUpdated="2023-06-15T10:28:07+02:00"

for f in web/bliki/*.md
do
	id=`basename $f .md`
	ids+=($id)
	bliki[$id.published]=`git log --follow --format=%ad --date iso-strict $f | tail -1`
	bliki[$id.updated]=`git log --follow --format=%ad --date iso-strict $f | head -1`

	if [ $(date -d $bliki[$id.updated] +%s) -ge $(date -d $lastUpdated +%s) ];
	then
		lastUpdated=$bliki[$id.updated]
	fi
done

jsonEntries=()

for id in $ids
do
	jsonEntries+=("\"$id\":{\"published\":\"$bliki[$id.published]\",\"updated\":\"$bliki[$id.updated]\"}")
done

echo "{\"lastUpdated\":\"$lastUpdated\",\"entries\":{${(j:,:)jsonEntries}}}" > data/bliki.json