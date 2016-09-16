<?php
$page_title = 'Pipeline Builder - Complete';
include_once('header.php');
/*
<html>
	<head>
	</head>
	<body>
		<div id='page_container'>

			<div id='content_container'>
*/  ?>
                <?php
                    ini_set('display_errors', 'On');
                    error_reporting(E_ALL | E_STRICT);

                    # All form submission-related errors are taken care of here, as well as the config and layout files being created
                    include_once('lgt_pipeline_step1_submit.php');

                    # Start the pipeline, and provide a link
					$pipeline_url = `/usr/bin/perl ./perl/run_pipeline.pl --layout $p_layout --config $p_config --repository_root $repo_root --ergatis_config $ergatis_config`;
					#echo "/usr/bin/perl ./perl/run_pipeline.pl --layout $p_layout --config $p_config --repository_root $repo_root --ergatis_config $ergatis_config";
					if (preg_match('/pipeline_id/',$pipeline_url,$matches)) {
						$res = array();
						$temp = preg_split("/\|/",$pipeline_url);
						foreach ($temp as $t) {
							list($label, $val) = preg_split("/\-\>/",$t);
							trim($label);
							$res[$label] = trim($val);
						}
						echo "<br>";
						echo "<h2>STEP FINAL : Pipeline {$res['pipeline_id ']} created successfully<sup><a href=\"./help.php\">?</a></sup></h2>";
						echo "<h3>Following files have been created :</h3>";
						echo "<ul>";
						echo "<li>Pipeline Configuration File : $pipeline_config</li>";
						echo "<li>Pipeline Layout File : $pipeline_layout</li>";
						echo "<li>Repository Root : $repo_root";
						echo "</ul>";
						echo "<h3>Click the link below to view and run the pipeline in Ergatis. Hit rerun to start the pipeline</h3>";
						echo "<font color=\"blue\">Note : Open the link below in a browser. The pipeline should start running automatically.</font><br><br>";
						echo "<a href=\"{$res[' pipeline_url ']}\" target=\"_blank\">{$res[' pipeline_url ']}</a>";
					} else {
						echo "<br>";
						echo "<h3><font color=\"red\">Error creating the pipeline !! Contact system administrator.</font></h3>";
						echo "<br>";
						echo "Error : $pipeline_url<br>";
					}
				?>
<?php
include_once('footer.php');
/*			</div>
		</div>
	</body>
</html>
*/
?>
