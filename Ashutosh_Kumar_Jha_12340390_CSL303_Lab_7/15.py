import sqlite3
import time
import random

# Connect to the database
conn = sqlite3.connect("university.db")
cursor = conn.cursor()


# Function to generate a random enrollment
def generate_random_enrollment():
    student_id = random.randint(1, 2000)  # assuming 2000 students
    course_id = random.randint(1, 100)  # assuming 100 courses
    grade = round(random.uniform(2.0, 4.0), 2)
    return (student_id, course_id, grade)


# Generate 500 random enrollments
enrollments = [generate_random_enrollment() for _ in range(500)]

# -----------------------------
# 1️⃣ INSERT with indexes
# -----------------------------
# Ensure indexes exist
cursor.execute(
    "CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON Enrollments(student_id);"
)
cursor.execute(
    "CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON Enrollments(course_id);"
)
conn.commit()

start_time = time.time()
cursor.executemany(
    "INSERT INTO Enrollments (student_id, course_id, grade) VALUES (?, ?, ?)",
    enrollments,
)
conn.commit()
elapsed_with_index = time.time() - start_time
print(f"Time to insert 500 enrollments WITH indexes: {elapsed_with_index:.6f} seconds")

# -----------------------------
# 2️⃣ INSERT without indexes
# -----------------------------
# First, drop the indexes
cursor.execute("DROP INDEX IF EXISTS idx_enrollments_student_id;")
cursor.execute("DROP INDEX IF EXISTS idx_enrollments_course_id;")
conn.commit()

# Generate a fresh set of 500 enrollments
enrollments_no_index = [generate_random_enrollment() for _ in range(500)]

start_time = time.time()
cursor.executemany(
    "INSERT INTO Enrollments (student_id, course_id, grade) VALUES (?, ?, ?)",
    enrollments_no_index,
)
conn.commit()
elapsed_without_index = time.time() - start_time
print(
    f"Time to insert 500 enrollments WITHOUT indexes: {elapsed_without_index:.6f} seconds"
)

# -----------------------------
# 3️⃣ Comparison
# -----------------------------
speedup = elapsed_with_index / elapsed_without_index
print(f"Inserts are {speedup:.2f}x faster without indexes")

# Close connection
conn.close()
