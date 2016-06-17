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
					<h3>Select the components to be included in the pipeline from the following list : (Default selections are shown)</h3>
					<table cellspacing="10">
						<tr>
							<td valign="top"><input type="checkbox" name="selections[]" id="selections" value="calign" checked onclick="CheckSubmit(); ToggleRefTextFields()"></td>
							<td>
								Which references should be used to look for LGT?
								<table cellspacing="10">
									<tr>
										<td><input type="radio" name="rgene_algo" value="cdonor" checked></td>
										<td>Donor reference only</td>
									</tr>
									<tr>
										<td><input type="radio" name="rgene_algo" value="chost"></td>
										<td>Host reference only</td>
									</tr>
									<tr>
										<td><input type="radio" name="rgene_algo" value="cboth"></td>
										<td>Both donor and host</td>
									</tr>
								</table>
							</td>
							<td></td>
						</tr>
						<tr>
							<td>DONOR REFERENCE</td>
							<td><input type='text' name="tdonor"></td>
						</tr>
						<tr>
							<td>HOST REFERENCE</td>
							<td><input type='text' name="thost"></td>
						</tr>
						<tr>
							<td>REFSEQ REFERENCE</td>
							<td><input type='text' name="trefseq"></td>
						</tr>
						<tr>
							<td>SRA ID</td>
							<td><input type='text' name="tsra"></td>
						</tr>
						<tr>
							<td>REPOSITORY_ROOT</td>
							<td><input type='text' name="trepo"></td>
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
