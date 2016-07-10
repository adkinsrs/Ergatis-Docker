<?php
	$formFieldsArr = Array("output_dir" => "Output directory", "log_file" => "Log file");
	$args = "";
	$local_dir = "/usr/local/scratch/pipeline_dir";
	$ergatis_config = "/var/www/html/ergatis/cgi/ergatis.ini";
	$errFlag = 0;

	# Shouldn't hard-code things but this is just being used in the Docker container
	$repo_root = "/opt/projects/lgtseek";

	# Safeguarding in case this wasn't created
	if (!file_exists($local_dir)) {
		if(!(mkdir($local_dir, 0777, true))) {
			echo "<font color='red'>Error creating temporary pipeline directory $local_dir</font><br>";
			exit(1);
		}
	}

# The first thing to do is to create the config and layout files for the pipeline
	if (isset($_POST['bsubmit'])) {

		error_reporting(0);
		$dir = create_pipeline_dir($local_dir);
		$formValuesArr['output_dir']['default'] = $dir;
		if(!dir) {
			$errFlag++;
			$formValuesArr['output_dir']['error'] = 1;
			$formValuesArr['output_dir']['msg'] = "Default output directory could not be created";
		} else {
			$args .= "--output_directory $dir ";
		}
		error_reporting(-1);
		if (isset($dir)) {
			$formValuesArr['log_file']['default'] = $dir."/create_lgt_pipeline.log";
			$args .= "--log $dir"."/create_lgt_pipeline.log ";
		} else {
			$errFlag++;
			$formValuesArr['log_file']['error'] = 1;
			$formValuesArr['log_file']['msg'] = "Could not create log file";
		}

		if (isset($_POST['tsra'] {
			$args .= "--sra_id " . trim($_POST['tsra'] . " ";
			$formValuesArr['tsra']['error'] = 0;
			$formValuesArr['tsra']['msg'] = "";
		} else {
			$errFlag++;
			$formValuesArr['tsra']['error'] = $errFlag;
			$formValuesArr['tsar']['msg'] = "An SRA ID is required.";
		}
		if (isset($_POST['tdonor'] {
			$donor = trim($_POST['tdonor'];
			$donor = handle_if_list($donor, $dir, "/mnt/input_data/donor_ref");
			$args .= "--donor_reference $donor ";
		}
		if (isset($_POST['thost'] {
			$host = trim($_POST['thost'];
			$host = handle_if_list($host, $dir, "/mnt/input_data/host_ref");
			$args .= "--host_reference $host ";

		}
		if (isset($_POST['trefseq'] {
			$refseq = trim($_POST['trefseq'];
			$refseq = handle_if_list($refseq, $dir, "/mnt/input_data/refseq_ref");
			$args .= "--refseq_reference $refseq ";
			$formValuesArr['trefseq']['error'] = 0;
			$formValuesArr['trefseq']['msg'] = "";
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
		foreach ($formFieldsArr as $formField) {
			if ($formValuesArr[$formField]['error'] > 0) {
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
	chmod($pipeline_config, 0777);
	chmod($pipeline_layout, 0777);

	# This function checks if the input file is a list.
	# If it is a list, the paths of each file in list will be changed to reflect the location of the volume in the Docker container.  A new list file is created, and returned
	# If not a list, the same file is returned
	function handle_if_list ($filename, $new_dir, $new_input_dir) {
		$file_parts = pathinfo($filename);

		if ($file_parts['extension'] == 'list') {
			# Construct filename for new list
			$list_base = basename($filename);
			$new_list = $new_dir . "/" . $list_base;

			$fh = fopen($filename, "r");
			$new_fh = fopen($new_list, "w");
			while (($line = fgets($fh)) !== false) {
				$path_base = basename(trim($line));
				fwrite($new_fh, $new_input_dir . "/" . $path_base . "\n");
		    }
			fclose($new_fh);
		    fclose($fh);

			return $new_list;			
		}
		# This is the 'else' case
		return $filename
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
