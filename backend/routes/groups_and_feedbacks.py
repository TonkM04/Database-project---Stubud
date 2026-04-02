'''
Code template
Remember to pip3 install flask and flask_sqlalchemy
'''


from flask import *
from flask_sqlalchemy import *
from sqlalchemy import *

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'copied from https://supabase.com/dashboard/project/jzlurmtftlvhvdfsokxn?showConnect=true&connectTab=direct'
db = SQLAlchemy(app)

#Groups page
@app.route('/groups')
def groups():
    sql_select_all_groups = text("SELECT * FROM public.meeting")
    result = db.session.execute(sql_select_all_groups)
    return jsonify([dict(row._mapping) for row in result])
    
#Create New Group
@app.route('/create_new_groups', methods=['POST'])
def create_new_group():
    course_name = request.form['course_name']
    course_id = request.form['course_id']
    date = request.form['start_date']
    start_time = date + " " + request.form['start_time']
    end_time = date + " " + request.form['end_time']
    notes = request.form['notes']
    building = request.form['building']
    capacity = request.form['capacity']
    room = request.form['room']
    
    '''
    #test data
    course_name = "CS TESTEST"
    course_id = "100000"
    date = "2024-09-01"
    start_time = date + " 10:00:00"
    end_time = date + " 11:00:00"
    notes = "This is a study group for CS 101."
    building = "Hall"
    capacity = 5
    room = "101"
    '''
    
    sql_insert_new_course = text("INSERT INTO public.course (course_name, course_id) VALUES (:course_name, :course_id) ON CONFLICT (course_id) DO NOTHING")
    sql_insert_new_location = text("INSERT INTO public.location (building, room, capacity) VALUES (:building, :room, :capacity) ON CONFLICT (building, room) DO NOTHING")
    sql_insert_new_meeting = text("INSERT INTO public.meeting (start_time, end_time, meeting_note, num_of_students, course_id, location_id) VALUES (:start_time, :end_time, :meeting_note, :num_of_students, :course_id, :location_id)")
    db.session.execute(sql_insert_new_course, {'course_name': course_name, 'course_id': course_id})
    db.session.execute(sql_insert_new_location, {'building': building, 'room': room, 'capacity': capacity})
    
    location_id = db.session.execute(
        text("""
            SELECT location_id FROM location
            WHERE building = :building AND room = :room
        """),
        {"building": building, "room": room}
    ).scalar()
    
    db.session.execute(sql_insert_new_meeting, {'start_time': start_time, 'end_time': end_time, 'meeting_note': notes, 'num_of_students': None, 'course_id': course_id, 'location_id': location_id})
    db.session.commit()
    return jsonify({'message': 'Group created successfully'})

#Group feedback page
@app.route('/group_feedback', methods=['GET'])
def group_feedback():
   meeting_id = request.args.get('meeting_id')
   sql_select_feedback = text("SELECT * FROM public.feedback WHERE meeting_id = :meeting_id")
   result = db.session.execute(sql_select_feedback, {'meeting_id': meeting_id})
   return jsonify([dict(row._mapping) for row in result])

if __name__ == '__main__':    
    app.run(debug=True)
