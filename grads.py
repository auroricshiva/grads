from time import sleep, strftime
import sqlite3
import bottle
from bottle import route, run, template, debug, request, redirect, BaseTemplate, static_file, abort

app = bottle.default_app()
BaseTemplate.defaults['get_url'] = app.get_url

@route('/static/:path#.+#', name='static')
def static(path):
    return static_file(path, root='static')

@route('/new/<uid>', method='GET')
def new_item(uid):
    if request.GET.get('save','').strip():
        full_name = request.GET.get('full', '').strip()
        first_name = full_name.split()[0]
        last_name = request.GET.get('last', '').strip()
        email = request.GET.get('email', '').strip()
        conn = sqlite3.connect('grads.db')
        c = conn.cursor()

        c.execute("INSERT INTO grads (full, first, last, email, status, uid) VALUES (?,?,?,?,?,?)", (full_name, first_name, last_name, email, 1, uid))

        conn.commit()
        c.close()

        return '<script>alert("The new student %s (UID %s) was inserted into the database");\
                 window.location.href="/";</script>' % (full_name, uid)
    else:
        return template('new_grad.tpl', uid=uid)


@route('/update', method='POST')
def update():
    key_list = ['status', 'uid', 'last', 'first', 'full', 'email', 'delete']
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
            c.execute("DELETE FROM grads WHERE uid LIKE ?", (student['uid'],))
        else:
            c.execute("UPDATE grads SET last=?, first=?, full=?, email=?, status=? WHERE uid LIKE ?", (student['last'], student['first'], student['full'], student['email'], student['status'], student['uid']))
    conn.commit()

    """
    key_values_list = []
    student_list = []
    for key in ['status', 'uid', 'last', 'first', 'full', 'email']:
        key_values_list += [request.forms.getall(key)]
    print key_values_list
    i = 0
    while i < len(key_values_list[0]):
        student_temp = []
        for key_items in key_values_list:
            student_temp.append(key_items[i])
        student_list.append(student_temp)
        i += 1
    print student_list
    """
        
    return '<script>alert("Saved.");\
             window.location.href="/";</script>'


@route('/update/<uid>')
def update2(uid):
    key_list = ['status', 'last', 'first', 'full', 'email']
    for key in key_list:
        values_list = request.query.getall(key)
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


@route('/')
@route('/grads')
def grad_list():
    conn = sqlite3.connect('grads.db')
    c = conn.cursor()
    c.execute("SELECT uid FROM grads")
    uid_tuple_list = c.fetchall()
    uids = []
    for uid in uid_tuple_list:
        uids.append(uid[0])
    c.execute("SELECT status, uid, last, first, full, email FROM grads")
    result = c.fetchall()
    c.close()
    output = template('grad_table.tpl', rows=result, uids=uids)
    return output

run()
