import sqlite3
import time

# Connect to the database
conn = sqlite3.connect("university.db")
cursor = conn.cursor()

# Drop the index if it exists
cursor.execute("DROP INDEX IF EXISTS idx_major;")
conn.commit()

# Define the query
query = "SELECT * FROM Students WHERE major = 'Computer Science';"

# Number of times to run the query
num_runs = 100
total_time = 0.0

for i in range(num_runs):
    start_time = time.time()  # Record start time
    cursor.execute(query)  # Execute the query
    cursor.fetchall()  # Fetch all results (important for timing)
    end_time = time.time()  # Record end time
    elapsed = end_time - start_time
    total_time += elapsed

average_time = total_time / num_runs
print(f"Average execution time over {num_runs} runs: {average_time:.6f} seconds")

# Close the connection
conn.close()
