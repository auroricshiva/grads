<!-- Next step create in-table editable entries and search function -->
<html>
<head>
    <title>Template</title>
    <link rel="stylesheet" href="{{ get_url('static', path='css/style.css') }}">
    <link rel="stylesheet" href="{{ get_url('static', path='tablesorter/themes/blue/style.css') }}">
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javascript" src="{{ get_url('static', path='tablesorter/jquery-latest.js') }}"></script>
    <script type="text/javascript" src="{{ get_url('static', path='tablesorter/jquery.tablesorter.js') }}"></script>
    <script type="text/javascript" src="{{ get_url('static', path='js/scripts.js') }}"></script>
</head>

<body>

%#template to generate a HTML table from a list of tuples (or list of lists, or tuple of tuples or ...)
<p>The open items are as follows:</p>

<form action="/update" method="post">
<table id="grad" class="tablesorter">
<thead>
<tr>
    <th>Hidden</th>
    <th>UID</th>
    <th>Last Name</th>
    <th>First Name</th>
    <th>Full Name</th>
    <th>Email</th>
    <!--<th>Edit</th> Uncomment to re-implement row-by-row Save button -->
    <th>Delete</th>
</tr>
</thead>
<tbody>
% for i, row in enumerate(rows):
    <tr>
        <td><input type="number" id="{{uids[i]}}_status" name="status" value="{{row[0]}}" size="1" maxlength="1" onChange='ajaxUpdate({{uids[i]}});'>{{row[0]}}</td>
        <td id="normal"><input type="hidden" id="{{uids[i]}}" name="uid" value="{{uids[i]}}" size="10" maxlength="20">{{uids[i]}}</td>
        <td><input type="text" id="{{uids[i]}}_last" name="last" value="{{row[2]}}" size="10" maxlength="20" onChange='ajaxUpdate({{uids[i]}});'>{{row[2]}}</td>
        <td><input type="text" id="{{uids[i]}}_first" name="first" value="{{row[3]}}" size="10" maxlength="20" onChange='ajaxUpdate({{uids[i]}});'>{{row[3]}}</td>
        <td><input type="text" id="{{uids[i]}}_full" name="full" value="{{row[4]}}" maxlength="20" onChange="ajaxUpdate({{uids[i]}});">{{row[4]}}</td>
        <td><input type="text" id="{{uids[i]}}_email" name="email" value="{{row[5]}}" size="30" maxlength="50" onChange='ajaxUpdate({{uids[i]}});'>{{row[5]}}</td>
        <!--<td><input type="submit" name="update" value="Save"></td>
            Uncomment to re-implement row-by-row Save button -->
        <td><select name="delete">
                <option value="no" selected>No</option>
                <option value="yes">Yes</option>
            </select></td>
    </tr>
% end
</tbody>
</table>
<input type="submit" name="update" value="Save">
</form>

<span class="update-notification"></span><br/>

<br/>

<form id="create_grad" action="/new" method="get">
    <p>Create a new graduate student by entering their UID</p>
    <input id="uid_input" type="number" size="15" maxlength="15" required="true" autocomplete="off">
    <input type="submit" value="Create" onclick="createGrad()">
</form>

</body>
</html>
