from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

db_config = {
    'user': 'admin',
    'password': 'w4shington',
    'host': 'washsoc.cng8gg0savul.us-east-1.rds.amazonaws.com',
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
def members():
    filters = {
        'computingID': request.args.get('id'),
        'firstName': request.args.get('firstName'),
        'lastName': request.args.get('lastName'),
        'provieSemester': request.args.get('provieSemester'),
        'duesPaid': request.args.get('duesPaid')
    }
    sort = request.args.get('sort')
    query = "SELECT computingID, firstName, lastName, provieSemester, duesPaid FROM Member WHERE 1=1"
    params = []

    for key, value in filters.items():
        if value:
            if key == 'provieSemester':
                if value != 'select':
                    query += f" AND {key} LIKE %s"
                    params.append(f"{value}%")
            elif key == 'duesPaid':
                if value == 'paid':
                    query += " AND duesPaid = 1"
                elif value == 'unpaid':
                    query += " AND duesPaid = 0"
            else:
                query += f" AND {key} LIKE %s"
                params.append(f"{value}%")
    if sort:
        query += f" ORDER BY {sort}"

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    members = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('members.html', members=members)

@app.route('/add_member', methods=['GET', 'POST'])
def add_member():
    if request.method == 'POST':
        computing_id = request.form['computing_id']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        mem_type = request.form['mem_type']
        provie_semester = request.form['provie_semester']
        dues_paid = request.form.get('dues_paid', '0')

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('INSERT INTO Member (computingID, firstName, lastName, memType, provieSemester, duesPaid) VALUES (%s, %s, %s, %s, %s, %s)',
                       (computing_id, first_name, last_name, mem_type, provie_semester, dues_paid))
        conn.commit()
        cursor.close()
        conn.close()

        return redirect(url_for('members'))

    return render_template('add_member.html')

@app.route('/delete_member', methods=['POST'])
def delete_member():
    computing_id = request.form['computing_id']

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM Member WHERE computingID = %s', (computing_id,))
    conn.commit()
    cursor.close()
    conn.close()

    return redirect(url_for('members'))

@app.route('/provisional-members')
def provisional_members():
    filters = {
        'm.computingID': request.args.get('id'),
        'firstName': request.args.get('firstName'),
        'lastName': request.args.get('lastName'),
        'completed': request.args.get('completed')
    }
    sort = request.args.get('sort')
    query = ("SELECT pm.*, m.firstName, m.lastName FROM ProvisionalMember pm JOIN Member m ON pm.computingID ="
             " m.computingID WHERE 1 = 1")
    params = []
    for key,value in filters.items():
        if value:
            if key == 'completed':
                if value == 'completed':
                    query += " AND completed=1"
                if value == 'uncompleted':
                    query += " AND completed=0"
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
    print(provisionalmembers)
    cursor.close()
    conn.close()
    return render_template('provisional-member.html', provisionalmembers=provisionalmembers)

@app.route('/requirements')
def requirements():
    filter = {
        'm.computingID': request.args.get('id'),
        'm.firstName': request.args.get('firstName'),
        'm.lastName': request.args.get('lastName')
    }
    sort = request.args.get('sort')
    query = """
        SELECT pr.*, m.firstName, m.lastName, m.computingID, m.duesPaid 
        FROM ProvieRequirements pr
        JOIN ProvisionalMember pm ON pr.provID = pm.provID
        JOIN Member m ON pm.computingID = m.computingID
    """
    params = []
    for key,value in filter.items():
        if value:
            query += f" AND {key} LIKE %s"
            params.append(f"{value}%")
    if sort:
        query += f" ORDER BY {sort}"
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    provierequirements = cursor.fetchall()
    cursor.close()
    print(provierequirements)
    conn.close()
    return render_template('requirements.html', provierequirements=provierequirements)

@app.route('/edit_requirements', methods=['GET', 'POST'])
def edit_requirements():
    if request.method == 'POST':
        updates = request.form.to_dict()
        conn = get_db_connection()
        cursor = conn.cursor()

        # Map column indices to database column names
        column_mapping = {
            '2': 'completed',
            '3': 'attendance',
            '4': 'fullMeeting',
            '5': 'historyTour',
            '6': 'majorService',
            '7': 'minorService',
            '8': 'debate',
            '9': 'literaryPresentation'
        }

        # Fetch current state to determine what was unchecked
        query = """
            SELECT provID, completed, attendance, fullMeeting, historyTour, majorService, minorService, debate, literaryPresentation
            FROM ProvieRequirements
        """
        cursor.execute(query)
        current_state = cursor.fetchall()
        current_state_dict = {str(record[0]): record[1:] for record in current_state}

        for provID, state in current_state_dict.items():
            for col, db_col in column_mapping.items():
                field_name = f"{provID}_{col}"
                new_value = updates.get(field_name, 'false') == 'true'
                current_value = state[int(col) - 2]  # Adjusting for 0-based index

                if new_value != current_value:
                    query = f"UPDATE ProvieRequirements SET {db_col} = %s WHERE provID = %s"
                    cursor.execute(query, (new_value, provID))

        conn.commit()
        cursor.close()
        conn.close()
        return redirect('/requirements')

    # Fetch data for display
    query = """
        SELECT pr.*, m.firstName, m.lastName, m.computingID, m.duesPaid 
        FROM ProvieRequirements pr
        JOIN ProvisionalMember pm ON pr.provID = pm.provID
        JOIN Member m ON pm.computingID = m.computingID
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    provierequirements = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('edit_requirements.html', provierequirements=provierequirements)


@app.route('/debates')
def debates():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('select * from Debate')
    debates = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('debates.html', debates=debates)

@app.route('/literary-presentations')
def literary_presentations():
    query = "SELECT lp.*, m.firstName, m.lastName FROM LiteraryPresentation lp JOIN Member m ON lp.computingID = m.computingID WHERE 1 = 1"
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    literarypresentations = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('literary_presentations.html', literarypresentations=literarypresentations)

@app.route('/officers')
def officers():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""SELECT o.*, m.firstName, m.lastName FROM Officers o JOIN Member m ON o.computingID = m.computingID WHERE 1 = 1""");
    officers = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('officers.html', officers=officers)

@app.route('/events', methods=['GET'])
def events():
    # Get the date from the query parameters
    event_date = request.args.get('date')

    # Construct the query to fetch humorous debates with debaters' names
    humorous_query = """
    SELECT 
        d.debateDate AS eventDate,
        d.resolution AS debateResolution,
        'Humorous' AS debateType,
        m1.firstName AS gov1FirstName, m1.lastName AS gov1LastName,
        m2.firstName AS gov2FirstName, m2.lastName AS gov2LastName,
        m3.firstName AS gov3FirstName, m3.lastName AS gov3LastName,
        m4.firstName AS opp1FirstName, m4.lastName AS opp1LastName,
        m5.firstName AS opp2FirstName, m5.lastName AS opp2LastName,
        m6.firstName AS opp3FirstName, m6.lastName AS opp3LastName,
        NULL AS presentationTitle,
        NULL AS presenterName
    FROM 
        Debate d
    JOIN 
        HumorousDebate hd ON d.debateID = hd.debateID
    LEFT JOIN 
        Member m1 ON hd.computingID_gov1 = m1.computingID
    LEFT JOIN 
        Member m2 ON hd.computingID_gov2 = m2.computingID
    LEFT JOIN 
        Member m3 ON hd.computingID_gov3 = m3.computingID
    LEFT JOIN 
        Member m4 ON hd.computingID_opp1 = m4.computingID
    LEFT JOIN 
        Member m5 ON hd.computingID_opp2 = m5.computingID
    LEFT JOIN 
        Member m6 ON hd.computingID_opp3 = m6.computingID
    WHERE 
        d.debateDate = %s
        AND d.debateType = 'Humorous'
    """

    # Construct the query to fetch serious debates with debaters' names
    serious_query = """
    SELECT 
        d.debateDate AS eventDate,
        d.resolution AS debateResolution,
        'Serious' AS debateType,
        m1.firstName AS ministerFirstName, m1.lastName AS ministerLastName,
        m2.firstName AS member1FirstName, m2.lastName AS member1LastName,
        m3.firstName AS leaderFirstName, m3.lastName AS leaderLastName,
        m4.firstName AS member2FirstName, m4.lastName AS member2LastName,
        NULL AS presentationTitle,
        NULL AS presenterName
    FROM 
        Debate d
    JOIN 
        SeriousDebate sd ON d.debateID = sd.debateID
    LEFT JOIN 
        Member m1 ON sd.computingID_minister_of_government = m1.computingID
    LEFT JOIN 
        Member m2 ON sd.computingID_member_of_government = m2.computingID
    LEFT JOIN 
        Member m3 ON sd.computingID_leader_of_opposition = m3.computingID
    LEFT JOIN 
        Member m4 ON sd.computingID_member_of_opposition = m4.computingID
    WHERE 
        d.debateDate = %s
        AND d.debateType = 'Serious'
    """

    # Construct the query to fetch literary presentations
    presentation_query = """
    SELECT 
        lp.presentationDate AS eventDate,
        lp.title AS presentationTitle,
        m.firstName AS presenterFirstName,
        m.lastName AS presenterLastName,
        NULL AS debateResolution,
        NULL AS debateType
    FROM 
        LiteraryPresentation lp
    JOIN 
        Member m ON lp.computingID = m.computingID
    WHERE 
        lp.presentationDate = %s
    """

    # Connect to the database
    conn = get_db_connection()
    cursor = conn.cursor()

    # Execute the query to fetch humorous debates
    cursor.execute(humorous_query, (event_date,))
    humorous_debates = cursor.fetchall()

    # Execute the query to fetch serious debates
    cursor.execute(serious_query, (event_date,))
    serious_debates = cursor.fetchall()

    # Execute the query to fetch literary presentations
    cursor.execute(presentation_query, (event_date,))
    presentations = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()
    conn.close()

    # Render the template with debates, presentations, and event_date
    return render_template('events.html', humorous_debates=humorous_debates, serious_debates=serious_debates,
                           presentations=presentations, event_date=event_date)

if __name__ == '__main__':
    app.run(debug=True)
