from time import sleep, strftime
import sqlite3
import bottle
from bottle import route, run, template, debug, request, redirect, BaseTemplate, static_file, abort

app = bottle.default_app()
BaseTemplate.defaults['get_url'] = app.get_url

@route('/static/:path#.+#', name='static')
def static(path):
    return static_file(path, root='static')


@route('/new', method='POST')
def new_student():
    uid = request.forms.get('uid')
    full_name = request.forms.get('full')
    last_name = request.forms.get('last')
    email = request.forms.get('email')
    name_split = full_name.split()
    first_name = name_split[0]
    
    conn = sqlite3.connect('grads.db')
    c = conn.cursor()
    c.execute("INSERT INTO grads (status, uid, last, first, full, email) VALUES (?,?,?,?,?,?)", (1, uid, last_name, first_name, full_name, email))
    conn.commit()
    c.close()
    return


# Saves all changes at once; save button
@route('/update', method='POST')
def update():
    # List of the names of the inputs we care to update
    key_list = ['status', 'uid', 'last', 'first', 'full', 'email', 'delete']

    # Retrieve the list of values of all the inputs associated with each key,
    # then create or add it to a list of dictionaries where each student has
    # their own dictionary of values
    for key in key_list:
        values_list = request.forms.getall(key)
        #print(key, values_list, len(values_list))
        if key == 'status':
            student_list = [{key: value} for value in values_list]
        else:
            for index, value in enumerate(values_list):
                student_list[index][key] = value
    
    conn = sqlite3.connect('grads.db')
    c = conn.cursor()
    for student in student_list:
        if 'delete' in student and student['delete'] == 'yes':
            c.execute("DELETE FROM grads WHERE uid LIKE ?", (student['uid'],))
        else:
            c.execute("UPDATE grads SET last=?, first=?, full=?, email=?, status=? WHERE uid LIKE ?", (student['last'], student['first'], student['full'], student['email'], student['status'], student['uid']))
    conn.commit()
        
    return '<script>alert("Saved.");\
             window.location.href="/";</script>'


# Asynchronous method of saving users
@route('/update/<uid>', method='POST')
def update2(uid):
    key_list = ['status', 'last', 'first', 'full', 'email']
    for key in key_list:
        values_list = request.forms.getall(key)
        if key == 'status':
            student_list = [{key: value} for value in values_list]
        else:
            for index, value in enumerate(values_list):
                student_list[index][key] = value
    
    conn = sqlite3.connect('grads.db')
    c = conn.cursor()
    for student in student_list:
        if 'delete' in student and student['delete'] == 'yes':
            c.execute("DELETE FROM grads WHERE uid LIKE ?", (uid,))
        else:
            c.execute("UPDATE grads SET last=?, first=?, full=?, email=?, status=? WHERE uid LIKE ?", (student['last'], student['first'], student['full'], student['email'], student['status'], uid))
    conn.commit()


# Loads the main page
@route('/')
@route('/grads')
def grad_list():
    conn = sqlite3.connect('grads.db')
    c = conn.cursor()
    try:
        c.execute("SELECT uid FROM grads")
    except sqlite3.OperationalError:
        c.execute("CREATE TABLE grads(status BOOL, uid INTEGER PRIMARY KEY, last char(20), first char(20), full char(40), email char(40))")
    uid_tuple_list = c.fetchall()
    uids = []
    for uid in uid_tuple_list:
        uids.append(uid[0])
    c.execute("SELECT status, uid, last, first, full, email FROM grads")
    result = c.fetchall()
    c.close()
    output = template('templates/grad_table.tpl', rows=result, uids=uids)
    return output

run()
