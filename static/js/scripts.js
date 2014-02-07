function loadTable() {
    $("#grad").tablesorter({
        headers: {
            5: {
                sorter: false
            },
            6: {
                sorter: false
            },
            7: {
                sorter: false
            }
        }
    });
}



/**
*  Uses AJAX to send a row's data back to the server to be updated
*  when its value is changed.
*/
function ajaxUpdate(student_uid) {
    $('.update-notification').html("Autosaving...");
    $.ajax({
        type: "POST",
        url: "update/" + student_uid,
        data: {
            status: $('#' + student_uid + '_status').val(),
            last: $('#' + student_uid + '_last').val(),
            first: $('#' + student_uid + '_first').val(),
            full: $('#' + student_uid + '_full').val(),
            email: $('#' + student_uid + '_email').val()
        },
        success: function() {
            window.setTimeout(function() {
                $('.update-notification').html('Saved.');
            }, 250);
        },
        error: function() {
            window.setTimeout(function() {
                $('.update-notification').html('Autosave failed.');
            }, 250);
        }
    });
}



/**
*  Uses AJAX to send data back to the server which creates the new entry.
*
*  NOTE: slight bug exists. After adding new row, tablesorter can only sort
*        one-way.
*/
function createGrad() {
    var validInput = checkInput();
    var uid = $('#uid_new').val();
    var full = $('#full_new').val();
    var split_name = full.split(' ');
    var first = split_name[0];
    var last = $('#last_new').val();
    var email = $('#email_new').val();
    
    if (validInput) {
        $.ajax({
            type: "POST",
            url: "/new",
            data: {
                uid: uid,
                full: full,
                last: last,
                email: email
            },
            success: function() {
                $('tbody').append(
                    "<tr> \
                        <td><input type='number' id='" + uid + "_status' name='status' value='1' size='1' maxlength='1' onChange='ajaxUpdate(" + uid + ");'>1</td> \
                        <td><input type='number' class='unselectable' id='" + uid + "' name='uid' value='" + parseInt(uid) + "' size='10' maxlength='20' readonly='readonly'>" + parseInt(uid) + "</td> \
                        <td><input type='text' id='" + uid + "_last' name='last' value='" + last + "' size='10' maxlength='20' onChange='ajaxUpdate(" + uid + ");'>" + last + "</td> \
                        <td><input type='text' id='" + uid + "_first' name='first' value='" + first + "' size='10' maxlength='20' onChange='ajaxUpdate(" + uid + ");'>" + first + "</td> \
                        <td><input type='text' id='" + uid + "_full' name='full' value='" + full + "' maxlength='20' onChange='ajaxUpdate(" + uid + ");'>" + full + "</td> \
                        <td><input type='text' id='" + uid + "_email' name='email' value='" + email + "' size='30' maxlength='50' onChange='ajaxUpdate(" + uid + ");'>" + email + "</td> \
                        <td class='hide'><select name='delete' id='" + uid + "_deleteSelection'><option value='no' selected>No</option><option value='yes'>Yes</option></select></td> \
                        <td><button type='button' class='delete' id='" + uid + "_delete' onclick='deleteButtonClick(" + uid + ");'/></td> \
                    </tr>");

                closeForm();                
                $('.update-notification').html('Successfully created.');

                $("#grad").trigger("update");
            },
            error: function() {
                $('.update-notification-new-grad').html('Failed.');
            }
        });
    }
    else {
        $('.update-notification-new-grad').html('Please fill in every field.');
    }
}

/**
*  Checks the input values to make sure none are empty.
*/
function checkInput() {
    if($('#uid_new').val() == '' || $('#full_new').val() == '' ||
            $('last_new').val() == '' || $('#email_new').val() == '')
        return false;

    return true;
}



/**
*  Handles the modal window that pops up when creating a new entry.
*/
function showForm() {
    $('#md-1').addClass('md-open');
    window.setTimeout(function() {
        $('#uid_new').focus();
    }, 100); //Will not autofocus without the delay. (Due to transition?)
}

function closeForm() {
    $('#md-1').removeClass('md-open');
    
    // Reset input values to ''
    window.setTimeout(function() {
        document.getElementById('uid_new').value = '';
        document.getElementById('full_new').value = '';
        document.getElementById('last_new').value = '';
        document.getElementById('email_new').value = '';
        $('.update-notification-new-grad').html('');
    }, 100);
}



/**
*  Delete button
*/
function deleteButtonClick(uid) {
    // Disables the inputs and marks the row for deletion
    $('#' + uid + '_status').attr('readonly', true);
    $('#' + uid + '_last').attr('readonly', true);
    $('#' + uid + '_first').attr('readonly', true);
    $('#' + uid + '_full').attr('readonly', true);
    $('#' + uid + '_email').attr('readonly', true);
    
    // Changes the delete value to 'yes'
    $('#' + uid + '_deleteSelection').val('yes');
    
    // Changes onclick so that the next click reverts the mark of deletion
    $('#' + uid + '_delete').attr('onclick', 'reenableButtonClick('+ uid + ');');
    
    // Rotates this delete button 45 degrees
    rotate(uid + '_delete', 45);
}

function reenableButtonClick(uid) {
    $('#' + uid + '_status').attr('readonly', false);
    $('#' + uid + '_last').attr('readonly', false);
    $('#' + uid + '_first').attr('readonly', false);
    $('#' + uid + '_full').attr('readonly', false);
    $('#' + uid + '_email').attr('readonly', false);
    
    $('#' + uid + '_deleteSelection').val('no');
    
    $('#' + uid + '_delete').attr('onclick', 'deleteButtonClick(' + uid + ');');

    rotate(uid + '_delete', 0);
}

function rotate(id, degree) {
    $('#' + id).css({'transform': 'rotate(' + degree + 'deg)'});
    $('#' + id).css({'-ms-transform': 'rotate(' + degree + 'deg)'});
    $('#' + id).css({'-moz-transform': 'rotate(' + degree + 'deg)'});
    $('#' + id).css({'-o-transform': 'rotate(' + degree + 'deg)'});
    $('#' + id).css({'-webkit-transform': 'rotate(' + degree + 'deg)'});
}







