<?php
$page_title = 'Pipeline Builder - Step 1';
$extra_head_tags = '<script type="text/javascript" src="./js/MiscFunctions.js"></script>';
include_once('header.php');
/*
<html>
	<head>
	</head>
	<body>
		<div id='page_container'>

			<div id='content_container'>
*/  ?>
				<form id='lgt_pipeline_step1_form' name='lgt_pipeline_step1_form' method='post' action='lgt_pipeline_complete.php'>
					<br>
					<h2>STEP 1 : Configure the LGTSeek pipeline<sup><a href='./help.php#form' target='_blank'>?</a></sup></h2>
					<h3>Please provide name of input SRA ID and path of reference FASTA files.  At least one of the donor or host references must be provided. A list file containing paths to multiple reference files may be provided (file must end in .list)</h3>
					<table cellspacing=10>
						<tr>
							<td>DONOR REFERENCE</td>
							<td><input type='text' name="tdonor" size=80></td>
						</tr>
						<tr>
							<td>HOST REFERENCE</td>
							<td><input type='text' name="thost" size=80></td>
						</tr>
						<tr>
							<td>REFSEQ REFERENCE</td>
							<td><input type='text' name="trefseq" size=80></td>
						</tr>
						<tr>
							<td>SRA ID</td>
							<td><input type='text' name="tsra" size=80></td>
						</tr>
					</table>
					<br>
						<tr>
							<td><input type="reset" name="breset" onclick="ChangeLabel()" value="Reset"></td>
							<td><input type="submit" name="bsubmit" value="Submit"></td>
						</tr>
					</table>
				</form>

<?php
include_once('footer.php');
/*			</div>
		</div>
	</body>
</html>
*/
?>
