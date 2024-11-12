#!/bin/bash

# Check available partitions and list them
printf "Available partitions/disks:\n"
lsblk -o NAME,SIZE,MOUNTPOINT | awk '{print "/dev/"$1 "\t("$2")\t" $3}'

read -p "Input partition you wish to check: " partition
if ! lsblk | grep -q "$(basename $partition)"; then
    echo "Partition does not exist!"
    exit 1
fi

partition_space=$(df -h | grep "$partition" | awk '{print $4}')
if [ -z "$partition_space" ]; then
    echo "Error: Can't get storage value of $partition."
    exit 1
fi

timestamp=$(date +"%Y%m%d-%H%M%S")
report_file="Report_${timestamp}.txt"

{
    echo "Available disks and partitions: "
    lsblk -o NAME,SIZE,MOUNTPOINT | awk '{print "/dev/"$1 "\t("$2")\t" $3}'
    echo
    echo "Available disk space on $partition: $partition_space"
} > "$report_file"

echo "File named $report_file has been successfully stored at $(pwd)"

