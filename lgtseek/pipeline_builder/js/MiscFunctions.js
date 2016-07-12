

// Hitting the Reset button will toggle the Select All button to select all checkboxes
function ChangeLabel() {
	var FormName = document.forms["lgt_pipeline_step1_form"];
	var Field = FormName.selections;
	var textFields = ["tsra", "tdonor", "thost", "trefseq"];
	FormName.elements['bsubmit'].disabled = false;
    for (i in textFields) {
		field = FormName.getElementsByName(i);
       	field.value = '';
	}
}
