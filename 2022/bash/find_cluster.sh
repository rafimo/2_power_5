#!/bin/bash
# cerner_2tothe5th_2022

# Find all AWS EMR cluster created after a given time containing a pattern
# print out cluster-id, status, sorted by newest cluster

# example - find_cluster.sh 2022-09-15T19:03:20 incremental us-west-2
# assuming the user has run the aws-cli setup
print_line() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

aws emr list-clusters --created-after $1 --query "Clusters[?contains(Name, '$2')][Status.Timeline.CreationDateTime, Id, Status.State, Status.StateChangeReason.Message, NormalizedInstanceHours, Name]" --region $3 --output text | sort -r > /tmp/$$

print_line
printf "\x1b[31m Failed Clusters \x1b[0m\n";
print_line
cat /tmp/$$ | grep --color "Steps completed with errors"

print_line
echo -ne "Running Clusters\n"
print_line
cat /tmp/$$  | egrep "BOOTSTRAPPING|RUNNING"

print_line
echo -ne "Completed clusters\n"
print_line
cat /tmp/$$ | egrep -v "Steps completed with errors|BOOTSTRAPPING|RUNNING"

print_line
rm /tmp/$$
