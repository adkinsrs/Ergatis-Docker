<?php
	$formFieldsArr = Array("output_dir" => "Output directory", "log_file" => "Log file");
	$args = "";
	$local_dir = "/usr/local/scratch/pipeline_dir";
	$errFlag = 0;

	# Shouldn't hard-code things but this is just being used in the Docker container
	$repo_root = "/opt/projects/lgtseek";

# The first thing to do is to create the config and layout files for the pipeline
	if (isset($_POST['bsubmit'])) {
		if (isset($_POST['tsra'] {
			$args .= "--donor_reference " . trim($_POST['tsra'] . " ";
			$formValuesArr['tsra']['error'] = 0;
			$formValuesArr['tsra']['msg'] = "";
		} else {
			$errFlag++;
			$formValuesArr['tsra']['error'] = $errFlag;
			$formValuesArr['tsar']['msg'] = "An SRA ID is required.";
		}
		if (isset($_POST['tdonor'] {
			$args .= "--donor_reference " . trim($_POST['tdonor'] . " ";
		}
		if (isset($_POST['thost'] {
			$args .= "--host_reference " . trim($_POST['thost'] . " ";

		}
		if (isset($_POST['trefseq'] {
			$args .= "--refseq_reference " . trim($_POST['trefseq'] . " ";
			$formValuesArr['trefseq']['error'] = 0;
			$formValuesArr['trefseq']['msg'] = "";
		} else {
			$errFlag++;
			$formValuesArr['trefseq']['error'] = $errFlag;
			$formValuesArr['trefseq']['msg'] = "A reference of refseq data information is required.";
		}

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

	$pipeline_config = `find {$formValuesArr['output_dir']['default']} -name "*.config" -type f`;
	$pipeline_layout = `find {$formValuesArr['output_dir']['default']} -name "*.layout" -type f`;

	if (!( isset($pipeline_config) && isset($pipeline_layout) )) {
		echo "<font color='red'>Error creating pipeline.config and pipeline.layout files</font><br>";
		exit(1);
	}
	chmod($pipeline_config, 0777);
	chmod($pipeline_layout, 0777);


	function create_pipeline_dir ($local_dir) {
		$dir_num = mt_rand(1, 999999);
		$temp_num = str_pad($dir_num, 6, "0", STR_PAD_LEFT);
		$dir = $local_dir.$temp_num;
		if (!file_exists($dir)) {
			if(!(mkdir($dir, 0777, true))) {
				return(0);
			} else {
				return($dir);
			}
		} else {
			create_pipeline_dir();
		}
	}
?>
