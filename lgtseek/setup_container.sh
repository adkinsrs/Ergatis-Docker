#!/bin/bash

function quit_setup {
    printf "\nExiting setup.  Bye."
    exit 0
}

#########################
# MAIN
#########################

printf "\nWelcome to the LGTSeek Docker installer. Please follow the prompts below that will help the Docker container access your usable data.\n"

# First ask for location of donor reference directory
printf  "\nFirst, if you have a donor reference genome or multiple genomes to align against, please specify the directory they are located.  If you wish to skip alignment to a donor, then leave blank.\n"
printf  "Type 'quit' or 'q' to exit setup."
read donor_mnt
if [[ $donor_mnt == 'q' ]] || [[ $donor_mnt == 'quit' ]]; then
    quit_setup
fi
if [[ -z $donor_mnt ]]; then
    donor_mnt="./input_data/donor_ref"
fi
sed -i "s/###DONOR_MNT###/$donor_mnt/" docker-compose.yml

# Second ask for location of host reference directory
printf  "\nSecond, if you have a host reference genome or multiple genomes to align against, please specify the directory they are located.  If you wish to skip alignment to a host, then leave blank.\n"
printf  "Type 'quit' or 'q' to exit setup.\n"
read host_mnt
if [[ $host_mnt == 'q' ]] || [[ $host_mnt == 'quit' ]]; then
    quit_setup
fi
if [[ -z $host_mnt ]]; then
    host_mnt="./input_data/host_ref"
fi
sed -i "s/###HOST_MNT###/$host_mnt/" docker-compose.yml

# Third ask for location of Refseq reference directory
printf  "\nFirst, if you have a RefSeq reference genome or multiple genomes to align against, please specify the directory they are located.  This directory is required.\n"
printf  "Type 'quit' or 'q' to exit setup.\n"
read refseq_mnt
if [[ $refseq_mnt == 'q' ]] || [[ $refseq_mnt == 'quit' ]]; then
    quit_setup
fi
while [[ -z $refseq_mnt ]]; do
    printf  "\nThe RefSeq reference genome directory path is required.  Please enter one.\n"
    read refseq_mnt
done
sed -i "s/###REFSEQ_MNT###/$refseq_mnt/" docker-compose.yml

# Next, ask where the output data should be written to
printf  "\nLastly, what directory should LGTView output be written to?  Note that if you close the Docker container, this output data may disappear, so it is recommended it be copied to a more permanent directory location.  If left blank, the output will be located at './output_data'\n"
printf  "Type 'quit' or 'q' to exit setup.\n"
read output_dir
if [[ $output_dir == 'q' ]] || [[ $output_dir == 'quit' ]]; then
    quit_setup
fi
if [[ -z $output_dir ]]; then
    output_dir="./output_data"
fi
sed -i "s/###OUTPUT_DIR###/$output_dir/" docker-compose.yml

# Time to determine what Docker host will run the container
printf  "\nWhat IP is the docker host machine on?  Leave blank if you are using local resources for the host (localhost)\n"
printf  "Type 'quit' or 'q' to exit setup.\n"
read ip_address
if [[ $ip_address == 'q' ]] || [[ $ip_address == 'quit' ]]; then
    quit_setup
fi
if [[ -z $ip_address ]]; then
    ip_address="localhost"
fi
sed -i "s/###IP_HOST###/$ip_address/" docker-compose.yml


# Next, figure out the BLAST db and if local/remote
printf  "\nWhat database would you like to use for BLASTN querying?  Default is 'nt'\n"
printf  "Type 'quit' or 'q' to exit setup.\n"
read blast_db
if [[ $blast_db == 'q' ]] || [[ $blast_db == 'quit' ]]; then
    quit_setup
fi
if [[ -z $blast_db ]]; then
    blast_db="nt"
fi

printf  "\nWould you like to query against a remote database from the NCBI servers?  Using a remote database saves you from having to have a pre-formatted database exist on your local machine, but is not recommended if you anticipate a lot of queries or have sensitive data. Please enter 'yes' (default) if you would like to use the remote NCBI database or 'no' if you would prefer querying against a local database\n"
printf  "Type 'quit' or 'q' to exit setup.\n"
read y_n
if [[ $y_n == 'q' ]] || [[ $y_n == 'quit' ]]; then
    quit_setup
fi
if [[ -z $y_n ]]; then
    remote=1
fi

while [[ $y_n !~ ^[Yy]$ ]] && [[ $y_n ! ^[Nn]$ ]]; do
    printf  "\nPlease enter 'yes' (Y) or 'no' (N).\n"
    read y_n
done

if [[ $y_n =~ ^[Yy]$ ]]; then
    remote=1
else
    remote=0
fi

if [[ $remote ]]; then
    blast_path=''
fi
if [[ ! $remote ]]; then
    printf  "\nYou chose to use a local pre-formatted database.  Please provide the database path (leave out the database name).\n"
    printf  "Type 'quit' or 'q' to exit setup.\n"
    read blast_path
    while [[ -z $blast_path ]]; do
        printf  "\nThe directory path to the database is required.  Please enter one.\n"
        read blast_path
    done
fi

sed -i "s/###BLAST_PATH###/$blast_path/" docker-compose.yml
sed -i "s/###BLAST_DB###/$blast_db/" docker-compose.yml

sed -i "s/###REMOTE###/$remote/" docker-compose.yml

printf  "\nGoing to build and run the Docker containers now....."

# Now, establish the following Docker containers:
# 1. ergatis_lgtseek_1
#  - Houses the Apache server and LGTview related code
# 2. ergatis_mongo_1
#  - Houses the MongoDB server
# 3. ergatis_mongodata_1
#  - A container to establish persistent MongoDB data

docker-compose up -d

printf  "Docker container is done building!\n"
printf  "Next it's time to customize some things within the container\n\n";

### TODO:
# 1) Use Blast DB information to fix blast-plus template configs
# 2) Use docker host IP in the blast_lgt_finder, blast2lca, and sam2lca template configs

printf  "\nDocker container is ready for use!\n"
printf  "In order to build the LGTSeek pipeline please point your browser to http://${ip_address}:8080/pipeline_builder\n"

exit 0
