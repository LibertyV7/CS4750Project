from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

db_config = {
    'user': 'sqm8uk',
    'password': 'ponyo123',
    'host': 'localhost',
    'port': 3306,
    'database': 'washsoc'
}
def get_db_connection():
    conn = mysql.connector.connect(**db_config)
    return conn
@app.route('/')
def index():
    return render_template('home.html')

@app.template_filter('status_to_check')
def status_to_check(value):
    return '✔️' if value else '❌'

@app.route('/members')
def members():  # put application's code here
    filters = {
        'memberID': request.args.get('id'),
        'firstName': request.args.get('firstName'),
        'lastName': request.args.get('lastName'),
        'computingID': request.args.get('computingID'),
        'provideSemester': request.args.get('provieSemester'),
        'duesPaid': request.args.get('duesPaid')
    }
    sort = request.args.get('sort')
    query = "SELECT * FROM member WHERE 1=1"
    params = []

    for key,value in filters.items():
        if value:
            if key == 'duesPaid':
                if value == 'paid':
                    query += " AND duesPaid=1"
                elif value == 'unpaid':
                    query += " AND duesPaid=0"
            else:
                query += f" AND {key} LIKE %s"
                params.append(f"{value}%")
    if sort:
        query += f" ORDER BY {sort}"


    print(query)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    members = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('members.html', members=members)



@app.route('/provisional-members')
def provisional_members():
    filters = {
        'm.memberID': request.args.get('id'),
        'firstName': request.args.get('firstName'),
        'lastName': request.args.get('lastName'),
        'completed': request.args.get('completed')
    }
    sort = request.args.get('sort')
    query = "SELECT pm.*, m.firstName, m.lastName FROM provisionalmember pm JOIN member m ON pm.memberID = m.memberID WHERE 1 = 1"
    params = []
    for key,value in filters.items():
        if value:
            if key == 'completed':
                if value == 'completed':
                    query += "AND completed=1"
                if value == 'uncompleted':
                    query += "AND completed=0"
            else:
                query += f" AND {key} LIKE %s"
                params.append(f"{value}%")
    if sort:
        query += f" ORDER BY {sort}"
    print(query)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    provisionalmembers = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('provisional-member.html', provisionalmembers=provisionalmembers)

@app.route('/requirements')
def requirements():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('select * from provierequirements')
    provierequirements = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('requirements.html', provierequirements=provierequirements)

@app.route('/debates')
def debates():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('select * from debate')
    debates = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('debates.html', debates=debates)

@app.route('/literary-presentations')
def literary_presentations():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('select * from literarypresentation')
    literarypresentations = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('literary_presentations.html', literarypresentations=literarypresentations)

@app.route('/officers')
def officers():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('select * from officers')
    officers = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('officers.html', officers=officers)

if __name__ == '__main__':
    app.run(debug=True)
