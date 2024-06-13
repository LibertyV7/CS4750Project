from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

db_config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'port': 3306,
    'database': 'washsocFinal'
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
        'computingID': request.args.get('id'),
        'firstName': request.args.get('firstName'),
        'lastName': request.args.get('lastName'),
        'memType': request.args.get('memberType'),
        'provieSemester': request.args.get('provieSemester'),
        'duesPaid': request.args.get('duesPaid')
    }
    sort = request.args.get('sort')
    query = "SELECT * FROM member WHERE 1=1"
    params = []

    for key, value in filters.items():
        if value:
            if key == 'memType' or key == 'provieSemester':
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


    print(query)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    members = cursor.fetchall()
    print(members)
    cursor.close()
    conn.close()
    return render_template('members.html', members=members)



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
                    query = f"UPDATE provierequirements SET {db_col} = %s WHERE provID = %s"
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
    cursor.execute('select * from debate')
    debates = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('debates.html', debates=debates)

@app.route('/literary-presentations')
def literary_presentations():
    query = "SELECT lp.*, m.firstName, m.lastName FROM literarypresentation lp JOIN member m ON lp.computingID = m.computingID WHERE 1 = 1"
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
    cursor.execute("""SELECT o.*, m.firstName, m.lastName FROM Officers o JOIN member m ON o.computingID = m.computingID WHERE 1 = 1""");
    officers = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('officers.html', officers=officers)

@app.route('/events', methods=['GET'])
def events():
    # Get the date from the query parameters
    event_date = request.args.get('date')

    # Construct the query
    query = """
    SELECT 
        IFNULL(D.debateDate, L.presentationDate) AS eventDate,
        L.title AS presentationTitle,
        D.resolution AS debateResolution,
        D.debateType AS debateType
    FROM 
        Debate D
    LEFT JOIN 
        LiteraryPresentation L
    ON 
        D.debateDate = L.presentationDate
    WHERE 
        IFNULL(D.debateDate, L.presentationDate) = %s

    UNION

    SELECT 
        IFNULL(D.debateDate, L.presentationDate) AS eventDate,
        L.title AS presentationTitle,
        D.resolution AS debateResolution,
        D.debateType AS debateType
    FROM 
        Debate D
    RIGHT JOIN 
        LiteraryPresentation L
    ON 
        D.debateDate = L.presentationDate
    WHERE 
        IFNULL(D.debateDate, L.presentationDaHumorousDebatete) = %s
    """

    # Connect to the database
    conn = get_db_connection()
    cursor = conn.cursor()

    # Execute the query with the user input date
    cursor.execute(query, (event_date, event_date))  # Provide event_date twice

    # Fetch all results
    events = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()
    conn.close()

    # Render the template with events and event_date
    return render_template('events.html', events=events, event_date=event_date)

if __name__ == '__main__':
    app.run(debug=True)
