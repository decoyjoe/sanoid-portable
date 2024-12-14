#!/usr/bin/env bash

set -eu

output_dir=$(pwd)
prod_disk="${output_dir}/disk-production.raw"
backup_disk="${output_dir}/disk-backup.raw"

echo 'Create sparse files to use as disks for ZFS...'
for disk_file in $prod_disk $backup_disk; do
  truncate -s 64M $disk_file
  ls -l $disk_file
done

prod_pool='production-pool'
backup_pool='backup-pool'

echo 'Create ZFS pools...'
zpool create $prod_pool $prod_disk
zpool create $backup_pool $backup_disk

zpool status

prod_dataset="${prod_pool}/test"
backup_dataset="${backup_pool}/test"

echo "Create dataset \"${prod_dataset}\"..." # backup dataset created from syncoid replication
zfs create $prod_dataset
zfs list -rt all

echo 'Get sanoid.defaults.conf...'
mkdir /etc/sanoid
wget -O /etc/sanoid/sanoid.defaults.conf https://github.com/jimsalterjrs/sanoid/raw/refs/tags/v2.2.0/sanoid.defaults.conf

echo 'Create /etc/sanoid/sanoid.conf...'
cat << EOF > /etc/sanoid/sanoid.conf
[${prod_dataset}]
  use_template = default
  frequently = 60
  frequent_period = 1
EOF

test_file_path="/${prod_dataset}/date.txt"

echo 'Create an initial test file in the dataset...'
date > $test_file_path

echo 'Run sanoid to take snapshots of the dataset...'
./sanoid --take-snapshots --verbose

echo 'Update test file with new data...'
date > $test_file_path

echo 'Wait 1 minute to take another snapshot...'
sleep 1m

echo 'Taking new snapshot with sanoid...'
./sanoid --take-snapshots --verbose

echo 'List all snapshots...'
zfs list -rt all

echo 'Execute findoid to locate snapshots containing a given file...'
./findoid $test_file_path

echo 'Execute syncoid to replicate snapshots to backup pool...'
./syncoid $prod_dataset $backup_dataset

echo 'List all snapshots on both pools...'
zfs list -rt all

echo "Adjust sanoid config to prune minute-ly snapshots on ${prod_dataset}..."
cat << EOF > /etc/sanoid/sanoid.conf
[${prod_dataset}]
  use_template = default
  frequently = 0
EOF

echo "Execute sanoid to prune snapshots on ${prod_dataset}..."
./sanoid --prune-snapshots --verbose

echo "List all snapshots on ${prod_dataset}..."
zfs list -rt all $prod_dataset

echo ''
echo 'sanoid, findoid, and syncoid tested successfully!'
echo ''

echo 'Destroying test pools...'
for pool in $prod_pool $backup_pool; do
  zpool destroy -f $pool
done
