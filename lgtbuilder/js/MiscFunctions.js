
// Operates the Select All button
function SelectUnselectAll() {		
    var FormName = document.forms["lgt_pipeline_step1_form"];
    var Field = FormName.selections
	if (FormName.elements['bselect_all'].value == 'Deselect All') {
        for (i = 0; i < Field.length; i++) {
        	Field[i].checked = false;
        	Field[i].disabled = false;
		}
		FormName.elements['bsubmit'].disabled = true;
		FormName.elements['bselect_all'].value = "Select All";
	} else {
		for (i = 0; i < Field.length; i++) {
			Field[i].checked = true;
			Field[i].disabled = false;
		}
		FormName.elements['bsubmit'].disabled = false;
		FormName.elements['bselect_all'].value = "Deselect All";
	}
}

// Hitting the Reset button will toggle the Select All button to select all checkboxes		
function ChangeLabel() {		
	var FormName = document.forms["lgt_pipeline_step1_form"];
	var Field = FormName.selections;	
	FormName.elements['bsubmit'].disabled = false;
    for (i = 0; i < Field.length; i++) {
       	Field[i].disabled = false;
	}	
	if (FormName.elements['bselect_all'].value == 'Deselect All') {
		FormName.elements['bselect_all'].value = "Select All";
	} 
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

