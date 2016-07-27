#!/bin/bash

function quit_setup {
    echo -ne "\n Exiting setup.  Bye."
    exit 0
}

#########################
# MAIN
#########################

echo "----------------------------------------------------------------------------------------------------"
echo -e "\nWelcome to the LGTSeek Docker installer. Please follow the prompts below that will help the Docker container access your usable data."
echo -e "\n*******************\n"

# First ask for location of donor reference directory
echo "----------------------------------------------------------------------------------------------------"
echo -e "\nFirst, if you have a donor reference genome or multiple genomes to align against, please specify the directory they are located.  If you wish to skip alignment to a donor, then leave blank."
echo -e "\nType 'quit' or 'q' to exit setup."
read donor_mnt
if [ $donor_mnt == 'q' ] || [ $donor_mnt == 'quit' ]; then
    quit_setup
fi
if [ -z $donor_mnt ]; then
    donor_mnt="./input_data/donor_ref"
fi
sed -i "s/###DONOR_MNT###/$donor_mnt/" docker-compose.yml
echo -e "----------------------------------------------------------------------------------------------------"

# Second ask for location of host reference directory
echo "----------------------------------------------------------------------------------------------------"
echo -e "\nSecond, if you have a host reference genome or multiple genomes to align against, please specify the directory they are located.  If you wish to skip alignment to a host, then leave blank."
echo -e "\nType 'quit' or 'q' to exit setup."
read host_mnt
if [ $host_mnt == 'q' ] || [ $host_mnt == 'quit' ]; then
    quit_setup
fi
if [ -z $host_mnt ]; then
    host_mnt="./input_data/host_ref"
fi
sed -i "s/###HOST_MNT###/$host_mnt/" docker-compose.yml
echo -e "----------------------------------------------------------------------------------------------------"

# Third ask for location of Refseq reference directory
echo "----------------------------------------------------------------------------------------------------"
echo -e "\nFirst, if you have a RefSeq reference genome or multiple genomes to align against, please specify the directory they are located.  This directory is required."
echo -e "\nType 'quit' or 'q' to exit setup."
read refseq_mnt
if [ $refseq_mnt == 'q' ] || [ $refseq_mnt == 'quit' ]; then
    quit_setup
fi
while [ -z $refseq_mnt ]; do
    echo -e "\nThe RefSeq reference genome directory path is required.  Please enter one."
    read refseq_mnt
done
sed -i "s/###REFSEQ_MNT###/$refseq_mnt/" docker-compose.yml
echo -e "----------------------------------------------------------------------------------------------------"

# Lastly ask where the output data should be written to
echo "----------------------------------------------------------------------------------------------------"
echo -e "\nLastly, what directory should output be written to?  Note that if you close the Docker container, this output data may disappear, so it is recommended it be copied to a more permanent directory location.  If left blank, the output will be located at './output_data'"
echo -e "\nType 'quit' or 'q' to exit setup."
read output_dir
if [ $output_dir == 'q' ] || [ $output_dir == 'quit' ]; then
    quit_setup
fi
if [ -z $output_dir ]; then
    output_dir="./output_data"
fi
sed -i "s/###OUTPUT_DIR###/$output_dir/" docker-compose.yml
echo -e "----------------------------------------------------------------------------------------------------"


echo -e "\nGoing to build and run the Docker containers now......"

# Now, establish the following Docker containers:
# 1. ergatis_lgtseek_1
#  - Houses the Apache server and LGTview related code
# 2. ergatis_mongo_1
#  - Houses the MongoDB server
# 3. ergatis_mongodata_1
#  - A container to establish persistent MongoDB data

docker-compose up -d

echo -e "\n----------------------------------------------------------------------------------------------------"
echo "Docker containers done building and ready to go!"
echo -e "\n In order to build the LGTSeek pipeline please point your browser to http://localhost:8080/pipeline_builder"
echo -e "----------------------------------------------------------------------------------------------------"

exit 0
