
<?php
$page_title = 'Pipeline Builder - Help';
$extra_head_tags = '<meta http-equiv="Content-Language" content="en-us">' . "\n";
$extra_head_tags .= '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' . "\n";
$extra_head_tags .= '<link rel="stylesheet" type="text/css" href="./css/documentation.css">';
include_once('header.php');
/*
<html>
	<head>
	</head>
	<body>
		<div id='page_container'>

			<div id='content_container'>
*/  ?>
				<h2><a href="help.php">Documentation</a></h2>
				<p>
					This is a simple interface build to create and configure the lateral gene transfer (LGTSeek) pipeline in
					<a href="http://ergatis.igs.umaryland.edu" target="_blank"><strong>Ergatis</strong></a>. It involves the following steps :
				</p>
				<ol>
					<li>Specifying the SRA ID and reference files that will be used in the pipeline
						The reference files include:
						<ul>
							<li>Donor genome reference - Either a single fasta sequence or a list file (ending in .list) consisting of paths to fasta references is accepted.  If passing a list file, the references must all be in the same directory as the list file.  If the field is left blank, then the pipeline is assumed to have a good host but an uncharacterized donor reference</li>
							<li>Host/recipient genome reference - Either a single fasta sequence or a list file (ending in .list) consisting of paths to fasta references is accepted.  If passing a list file, the references must all be in the same directory as the list file.  If the field is left blank , then the pipeline is assumed to have a good donor but an uncharacterized host reference</li>
							<li>RefSeq reference - <strong>Required</strong>.  A list of annotated nucleotide sequences located within the NCBI Reference Sequence database</li>
						</ul>
						The SRA ID provided is downloaded from the Sequence Read Archive.  This field is <strong>required</strong> and can be any of the following:
						<ul>
							<li>SRP - Study ID</li>
							<li>SRR - Run ID</li>
							<li>SRS - Sample ID</li>
							<li>SRX - Experiment ID</li>
						</ul>
					    An output directory will be created and listed on the next page after Submit is clicked.  This output directory will contain the requisite pipeline.config and pipeline.layout files needed to create the pipeline in addition to a log file.  For the LGTSeek pipeline, the config file parameters will be automatically configured.
					</li>
					<li>The last page will display a link to the newly created Ergatis pipeline. Clicking on the link will take you directly to the Ergatis interface to run the and monitor the pipeline.</li>
				</ol>
				<p>
					If there are any issues with the Pipeline Builder interface, or if you have any questions, comments, etc. then feel free to send an e-mail to <strong>sadkins [at] som.umaryland.edu</strong>
				</p>
<?php
include_once('footer.php');
/*			</div>
		</div>
	</body>
</html>
*/
?>
