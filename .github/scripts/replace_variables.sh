#!/bin/bash

values_file="values-DEV.yaml"
json_file="vars.json"

cp $values_file ${values_file}.new

curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $MY_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/orgs/willin2/actions/variables > $json_file

# # jq
# num=`cat $json_file |jq ".variables |length"`
# for ((i=0; i<$num; i++))
# do
#     name=`cat $json_file |jq .variables[$i].name |sed 's/"//g'`
#     value=`cat $json_file |jq .variables[$i].value |sed 's/"//g'`

#     if grep -q "<\$$name>" $values_file
#     then
#         sed -i "s|<\$$name>|$value|" ${values_file}.new
#     fi
# done

# non jq
num=`grep "\"name\":" $json_file |wc -l`
for ((i=1; i<=$num; i++))
do
    name=`grep "\"name\":" $json_file |sed -n "${i}p" |awk -F\" '{print $4}'`
    value=`grep "\"value\":" $json_file |sed -n "${i}p" |awk -F\" '{print $4}'`

    if grep -q "<\$$name>" $values_file
    then
        sed -i "s|<\$$name>|$value|" ${values_file}.new
    fi
done
