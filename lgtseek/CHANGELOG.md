# CHANGELOG

Note: This CHANGELOG is reflective of Docker versions, not the GitHub tags of the Ergatis-Docker repository

## v1.1
* Added new starting input - BAM file
  * This is an alternative to providing an SRA ID
* Added new component - gather\_lgtview\_files
  * This will collect SRA metadata and downstream blast files in one location to easily pass to LGTView
* Added headers to the blast\_lgt\_finder "by clone" output text file
* Various code bug fixes

## v1.0
* Initial working copy of LGTSeek Docker pipeline