import json
from mysql.connector import connect
from mysql.connector import Error
from config import *


class DbManager:
    def __init__(self):
        self.status = ' '
        try:
            self.conn = connect(user=USER,
                                password=PASSWORD,
                                host=HOST,
                                database=DB,
                                auth_plugin=AUTH)
            if self.conn.is_connected():
                self.status = 'connected'
            else:
                self.status = 'connection failed.'
        except Error as error:
            self.status = error

    # ---------------------------------------------------------------------------------------
    def add_course(self, course_number, course_name, course_credits):
        course = {
            "course_number": course_number,
            "course_name": course_name,
            "course_credits": course_credits
        }
        params = [json.dumps(course, ensure_ascii=False)]

        response_json = self.execute_sql_procedure('addCourse', params)
        return json.loads(response_json[0][0])

    def single_course(self, course_number):
        params = [course_number]  
        return self.execute_sql_procedure('readCourse', params)

    def update_course(self, oldCourse, course_number, course_name, course_credits):
        params = [oldCourse, course_number, course_name, course_credits]
        return self.execute_sql_procedure('updateCourse', params)

    def delete_course(self, course_number):
        params = [course_number]  
        return self.execute_sql_procedure('deleteCourse', params)


    # ---------------------------------------------------------------------------------------
    def add_track_course(self, course_number, semester_id, is_mandatory):
        trackcourse = {
            "course_number": course_number,
            "semester_id": semester_id,
            "is_mandatory": is_mandatory
        }
        params = [json.dumps(trackcourse, ensure_ascii=False)]

        response_json = self.execute_sql_procedure('AddTrackCourse', params)
        params = [course_number,semester_id,is_mandatory]

        return json.loads(response_json[0][0])


    def single_track_course(self, track_id, course_number):
        pass


    def update_track_course(self, track_id, course_number, semester_id, is_mandatory):
        pass


    def delete_track_course(self, track_id, course_number):
        pass


    # ---------------------------------------------------------------------------------------
    def add_semester(self, semester_name, semester_starts, semester_ends, academic_year):
        pass


    def single_semester(self, semester_id):
        pass


    def update_semester(self, semester_id, semester_name, semester_starts, semester_ends, academic_year):
        pass


    def delete_semester(self, semester_id):
        pass


    # ---------------------------------------------------------------------------------------
    def execute_sql_function(self, function_name, parameters=None):
        returns = []
        try:
            cursor = self.conn.cursor(prepared=True)
            if parameters:
                cursor.execute(function_name, parameters)
            else:
                cursor.execute(function_name)

            returns = cursor.fetchone()
            cursor.close()
        except Error as error:
            self.status = error
            returns.append(None)
        finally:
            return returns[0]

    def execute_sql_procedure(self, procedure_name, parameters=None):
        results = []
        try:
            cursor = self.conn.cursor()
            if parameters:
                cursor.callproc(procedure_name, parameters)
            else:
                cursor.callproc(procedure_name)

            self.conn.commit()

            for result in cursor.stored_results():
                results = result.fetchall()

        except Error as error:
            self.status = error
        finally:
            return results


db = DbManager()

print(db.status)
print(db.single_course('DANS2BM05AT'))
print(db.single_course('GAGN3FS05EU'))
print(db.update_course('DANS2BM05AT', 'LÁRU2UN05CU', 'Lárus Ármann Kjartansson', 5))
# print(db.delete_course('LÁRU2UN05CU'))
print(db.single_course('LÁRU2UN05CU'))

# db.add_track_course('GAGN3FS05EU', 1, 0)
# print(db.student_list_json_II())
# print(db.single_student(14))
# print(db.add_student_json('Komaso','Takida','2000-05-11', 9))
# print(db.add_student('Anita','Schmidt','2001-09-27', 9))
