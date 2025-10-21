import sqlite3
import time
import random

# Connect to the database
conn = sqlite3.connect("university.db")
cursor = conn.cursor()

# Ensure indexes exist
cursor.execute(
    "CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON Enrollments(student_id);"
)
cursor.execute(
    "CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON Enrollments(course_id);"
)
conn.commit()


# Function to generate a random enrollment
def generate_random_enrollment():
    student_id = random.randint(1, 2000)  # assuming 2000 students
    course_id = random.randint(1, 100)  # assuming 100 courses
    grade = round(random.uniform(2.0, 4.0), 2)
    return (student_id, course_id, grade)


# Generate 500 random enrollments
enrollments = [generate_random_enrollment() for _ in range(500)]

# Measure INSERT time
start_time = time.time()

cursor.executemany(
    "INSERT INTO Enrollments (student_id, course_id, grade) VALUES (?, ?, ?)",
    enrollments,
)
conn.commit()

end_time = time.time()
elapsed_time = end_time - start_time
print(f"Time to insert 500 enrollments with indexes: {elapsed_time:.6f} seconds")

# Close connection
conn.close()
