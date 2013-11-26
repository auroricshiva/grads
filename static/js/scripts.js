$(document).ready(function() {
    $("#grad").tablesorter({
        headers: {
            5: {
                sorter: false
            },
            6: {
                sorter: false
            }
            /*7: {
                sorter: false
            }Uncomment to re-implement row-by-row Save button */
        }
    });
});

function ajaxUpdate(student_uid) {
    $('.update-notification').html("Autosaving...");
    $.ajax({
        url: "update/" + student_uid,
        data: {
            status: $('#' + student_uid + '_status').val(),
            last: $('#' + student_uid + '_last').val(),
            first: $('#' + student_uid + '_first').val(),
            full: $('#' + student_uid + '_full').val(),
            email: $('#' + student_uid + '_email').val()
        },
        success: function() {
            $('.update-notification').html('Saved.');
        },
        error: function() {
            $('.update-notification').html('Autosave failed.');
        }
    });
}

function createGrad() {
    var uid = document.getElementById('uid_input').value;
    document.getElementById('create_grad').action="/new/" + uid;
}
