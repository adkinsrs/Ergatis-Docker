# Ergatis Code Differences

This is a collection of differences between component code used in the internal IGS version of the LGTSeek pipeline in Ergatis, and the Docker version.

* sra2fastq
  * The --data\_dir option was removed from the XML, since it is not necessary to pass fastq files back to the user in a Docker container
* ncbi-blastn
  * Modified pretty much whole component to work with blast+ instead of the legacy blastall.  This allows for querying of remote databases on the NCBI servers, rather than having to use local ones.  Eventually I will develop a standalone blast+ component and use that instead.
* blast2lca
  * Removed config file references to taxanomy dump files
  * Changed MongoDB connection address in config file
* sam2lca
  * Removed config file references to taxanomy dump files
  * Changed MongoDB connection address in config file
* blast\_lgt\_finder
  * Removed config file references to taxanomy dump files
  * Changed MongoDB connection address in config file
* split\_multifasta
  * Changed the number of sequences per output file to 500 (was 100 internally)
