<?php
	ini_set('display_errors', 'On');
	error_reporting(E_ALL | E_STRICT);

	$formFieldsArr = Array("output_dir" => "Output directory", "log_file" => "Log file", "rinput" => "Input type", "trefseq" => "Refseq file");
	$args = "--build_indexes ";	# Want to build indexes in pipeline by default
	$local_dir = "/usr/local/scratch/pipeline_dir";
	$ergatis_config = "/var/www/html/ergatis/cgi/ergatis.ini";
	$errFlag = 0;

	# Shouldn't hard-code things but this is just being used in the Docker container
	$repo_root = "/opt/projects/lgtseek";

# The first thing to do is to create the config and layout files for the pipeline
	if (isset($_POST['bsubmit'])) {

		$dir = create_pipeline_dir($local_dir);
		$formValuesArr['output_dir']['default'] = $dir;
		$formValuesArr['output_dir']['error'] = 0;
		$args .= "--output_directory $dir ";

		$formValuesArr['log_file']['error'] = 0;
		if (isset($dir)) {
			$formValuesArr['log_file']['create'] = $dir."/create_lgt_pipeline.log";
			$formValuesArr['log_file']['run'] = $dir."/run_lgt_pipeline.log";
			$args .= "--log {$formValuesArr['log_file']['create']} ";
		} else {
			$errFlag++;
			$formValuesArr['log_file']['error'] = $errFlag;
			$formValuesArr['log_file']['msg'] = "Could not create log file";
		}

		if ( trim($_POST['rinput'])=='sra' && ! empty($_POST['tsra']) ) {
			$args .= "--sra_id " . trim($_POST['tsra']) . " ";
			$formValuesArr['rinput']['error'] = 0;
		} elseif ( trim($_POST['rinput'])=='bam' && ! empty($_POST['tbam']) ) {
			$bam = trim($_POST['tbam']);
			$bam = adjust_paths($bam, $dir, "/mnt/input_data");
			$args .= "--bam_input $bam ";
			$formValuesArr['rinput']['error'] = 0;
		} else {
			$errFlag++;
			$formValuesArr['rinput']['error'] = $errFlag;
			$formValuesArr['rinput']['msg'] = "An SRA ID or BAM input path is required.";
		}
		if ( isset($_POST['tdonor']) && ! empty($_POST['tdonor']) ) {
			$donor = trim($_POST['tdonor']);
			$donor = adjust_paths($donor, $dir, "/mnt/input_data/donor_ref");
			$args .= "--donor_reference $donor ";
		}
		if ( isset($_POST['thost']) && ! empty($_POST['thost']) ) {
			$host = trim($_POST['thost']);
			$host = adjust_paths($host, $dir, "/mnt/input_data/host_ref");
			$args .= "--host_reference $host ";

		}
		if ( isset($_POST['trefseq']) ) {
			$refseq = trim($_POST['trefseq']);
			$refseq = adjust_paths($refseq, $dir, "/mnt/input_data/refseq_ref");
			$args .= "--refseq_reference $refseq ";
			$formValuesArr['trefseq']['error'] = 0;
		} else {
			$errFlag++;
			$formValuesArr['trefseq']['error'] = $errFlag;
			$formValuesArr['trefseq']['msg'] = "A reference of refseq data information is required.";
		}

	}

	if ($errFlag == 0) {
		$output = `/usr/bin/perl ./perl/create_lgt_pipeline_config.pl $args --template_directory /opt/ergatis/pipeline_templates`;
	} else {
		# Exact code as in lgt_pipeline_complete.php ... need to eliminate redundancy later
		echo "<br>";
		echo "<h3>Hit the browser's Back button and resolve the following errors to proceed:</h3>";
		echo "<ul>";
		foreach ($formFieldsArr as $formField => $val) {
			if ( $formValuesArr[$formField]['error'] > 0) {
				echo "<li><font color=\"red\">ERROR !! {$formValuesArr[$formField]['msg']}</font></li>";
			}
		}
		echo "</ul>";
		exit(1);
	}

	# Find our newly created pipeline_config and layout files, and create the pipeline and run
	$pipeline_config = `find {$formValuesArr['output_dir']['default']} -name "*.config" -type f`;
	$pipeline_layout = `find {$formValuesArr['output_dir']['default']} -name "*.layout" -type f`;

	if (!( isset($pipeline_config) && isset($pipeline_layout) )) {
		echo "<font color='red'>Error creating pipeline.config and pipeline.layout files</font><br>";
		exit(1);
	}

	$p_config = trim($pipeline_config);
	$p_layout = trim($pipeline_layout);

	if (!file_exists( $p_config )){
		echo "<li><font color=\"red\">ERROR !! $p_config does not appear to exist!</font></li>";
		exit(1);
	}
	if (!file_exists( $p_layout )){
		"<li><font color=\"red\">ERROR !! $p_layout does not appear to exist!</font></li>";
		exit(1);
	}

	# This function checks if the input file is a list.
	# If it is a list, the paths of each file in list will be changed to reflect the location of the volume in the Docker container.  A new list file is created, and returned
	# If not a list, path of the input file is changed to reflect the location of the volume in the Docker container and is returned
	function adjust_paths ($filename, $new_dir, $mounted_dir) {
		$file_parts = pathinfo($filename);
		$file_base = basename($filename);
		# File needs to reflect the mounted directory path, not the path on the host
		$mounted_file = $mounted_dir . "/" . $file_base;

		if ($file_parts['extension'] == 'list') {
			# Construct filename for new list
			$new_list = $new_dir . "/" . $file_base;

			$fh = fopen($mounted_file, "r");
			$new_fh = fopen($new_list, "w");
			while (($line = fgets($fh)) !== false) {
				$path_base = basename(trim($line));
				fwrite($new_fh, $mounted_dir . "/" . $path_base . "\n");
		    }
			fclose($new_fh);
		    fclose($fh);

			return $new_list;
		}
		# This is the 'else' case
		return $mounted_file;
	}

	function create_pipeline_dir ($local_dir) {
		$dir_num = mt_rand(1, 999999);
		$temp_num = str_pad($dir_num, 6, "0", STR_PAD_LEFT);
		$dir = $local_dir.$temp_num;
		if (!file_exists($dir)) {
			if(!(mkdir($dir, 0777, true))) {
				echo "<font color='red'>Error creating temporary pipeline directory $dir</font><br>";
				exit(1);
			} else {
				return($dir);
			}
		} else {
			create_pipeline_dir();
		}
	}
?>
