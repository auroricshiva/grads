<!DOCTYPE html>
<html>
<head>
    <title>Table</title>
    <link rel="stylesheet" href="{{ get_url('static', path='tablesorter/themes/blue/style.css') }}">
    <link rel="stylesheet" href="{{ get_url('static', path='css/style.css') }}">
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javascript" src="{{ get_url('static', path='tablesorter/jquery.tablesorter.js') }}"></script>
    <script type="text/javascript" src="{{ get_url('static', path='js/scripts.js') }}"></script>
    <script>
        $(document).ready(function() {
            loadTable();
        });
    </script>
</head>

<body>

%#template to generate a HTML table from a list of tuples (or list of lists, or tuple of tuples or ...)
<p>The open items are as follows:</p>

<form action="/update" method="POST">
<table id="grad" class="tablesorter">
<thead>
<tr>
    <th>Hidden</th>
    <th>UID</th>
    <th>Last Name</th>
    <th>First Name</th>
    <th>Full Name</th>
    <th>Email</th>
    <th>Delete</th>
</tr>
</thead>
<tbody>
% for i, row in enumerate(rows):
    <tr>
        <td><input type="text" id="{{uids[i]}}_status" name="status" value="{{row[0]}}" size="1" maxlength="1" onChange='ajaxUpdate({{uids[i]}});'>{{row[0]}}</td>
        <td><input type="text" id="{{uids[i]}}" name="uid" value="{{uids[i]}}" size="10" maxlength="20" readonly="readonly">{{uids[i]}}</td>
        <td><input type="text" id="{{uids[i]}}_last" name="last" value="{{row[2]}}" size="10" maxlength="20" onChange='ajaxUpdate({{uids[i]}});'>{{row[2]}}</td>
        <td><input type="text" id="{{uids[i]}}_first" name="first" value="{{row[3]}}" size="10" maxlength="20" onChange='ajaxUpdate({{uids[i]}});'>{{row[3]}}</td>
        <td><input type="text" id="{{uids[i]}}_full" name="full" value="{{row[4]}}" maxlength="20" onChange='ajaxUpdate({{uids[i]}});'>{{row[4]}}</td>
        <td><input type="text" id="{{uids[i]}}_email" name="email" value="{{row[5]}}" size="30" maxlength="50" onChange='ajaxUpdate({{uids[i]}});'>{{row[5]}}</td>
        <!--<td><input type="submit" name="update" value="Save"></td>
            Uncomment to re-implement row-by-row Save button -->
        <td class="hide">
            <select name="delete" id="{{uids[i]}}_deleteSelection">
                <option value="no" selected>No</option>
                <option value="yes">Yes</option>
            </select>
        </td>
        <td><button type="button" class="delete" id="{{uids[i]}}_delete" onclick="deleteButtonClick({{uids[i]}});"/>
    </tr>
% end
</tbody>
</table>
<input type="submit" name="update" value="Save">
</form>

<span class="update-notification"></span>

<br/>
<br/>

<div id="md-1" class="md-new md-effect-1">
    <div class="md-content">
        <h2>Create a new graduate student</h2>
        <form id="create_grad">
            <input type="number" id="uid_new" name="uid_new" maxlength="20" autocomplete="off" placeholder="UID; 12348765">
            <input type="text" id="full_new" name="full_new" autocomplete="off" placeholder="Full name; John Robert Smith">
            <input type="text" id="last_new" name="last_new" autocomplete="off" placeholder="Last name; Smith">
            <input type="text" id="email_new" name="email_new" autocomplete="off" placeholder="Email; jrsmith@berkeley.edu">
            <!--<input type="submit" value="Create" onclick="createGrad()">-->
        </form>
        <span class="update-notification-new-grad"></span>
        <br/>
        <button onclick="createGrad();">Submit</button><button onclick="closeForm();">Cancel</button>
    </div>
</div>
<button onclick="showForm();" data-modal="md-1">Create a New Graduate</button>

<div class="md-overlay"></div>

</body>
</html>
