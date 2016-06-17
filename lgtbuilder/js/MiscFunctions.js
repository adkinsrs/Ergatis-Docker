

// Hitting the Reset button will toggle the Select All button to select all checkboxes
function ChangeLabel() {
	var FormName = document.forms["lgt_pipeline_step1_form"];
	var Field = FormName.selections;
	FormName.elements['bsubmit'].disabled = false;
    for (i = 0; i < Field.length; i++) {
       	Field[i].disabled = false;
	}
}

// Will hide and unhide the relevant reference input fields depending on which
//  references are needed between donor and host
function ToggleRefTextFields() {
    var FormName = document.forms["prok_pipeline_step1_form"];
	var Field = FormName.selections;
    // TODO:  if/else to determine which text fields to hide
}

// Keeps track of the status of each checkbox
function CheckSubmit() {
	var FormName = document.forms["prok_pipeline_step1_form"];
	var Field = FormName.selections;
	var box_checked = false;
	for (i = 0; i < Field.length; i++) {
		if (Field[i].checked) {
			box_checked = true;
		}
	}
	if(box_checked == true){
		FormName.elements['bsubmit'].disabled = false;
	} else {
		FormName.elements['bsubmit'].disabled = true;
	}
}
