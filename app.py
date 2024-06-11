from flask import Flask, render_template
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


@app.route('/members')
def members():  # put application's code here
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('select * from member')
    members = cursor.fetchall()
    cursor.close()
    conn.close()
    print(members)
    return render_template('members.html', members=members)


@app.route('/provisional-members')
def provisional_members():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('select * from provisionalmember')
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
