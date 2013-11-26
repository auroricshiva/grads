<html>
<head>
    <title>Create new student</title>
    <link rel="stylesheet" href="{{ get_url('static', path='css/style.css') }}">
</head>

<body>

<div id="form_style">
<p>Add a new student with UID {{uid}} to the database:</p>
<form action="/new/{{uid}}" method="GET">
    Full Name
    <input type="text" size="30" maxlength="40" name="full" required="true" autocomplete="off"><br/>
    Last Name<br/>
    <input type="text" size="15" maxlength="20" name="last" required="true" autocomplete="off"><br/>
    Email<br/>
    <input type="text" size="20" maxlength="40" name="email" autocomplete="off"><br/>
    <input type="submit" name="save" value="Save">
    <a href="/grads">Go back</a>
</form>
</div>

</body>
</html>
