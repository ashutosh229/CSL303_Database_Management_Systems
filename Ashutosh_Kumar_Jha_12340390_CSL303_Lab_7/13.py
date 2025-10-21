import sqlite3
import time

# Connect to the database
conn = sqlite3.connect("university.db")
cursor = conn.cursor()


# Function to measure average execution time
def measure_query_time(cursor, query, runs=100):
    total_time = 0.0
    for _ in range(runs):
        start_time = time.time()
        cursor.execute(query)
        cursor.fetchall()  # Fetch results to ensure query is fully executed
        end_time = time.time()
        total_time += end_time - start_time
    return total_time / runs


# Query from Question 4
query = "SELECT * FROM Students WHERE major = 'Computer Science';"

# ---------------------------
# 1️⃣ Measure without index
# ---------------------------
# Drop index if it exists
cursor.execute("DROP INDEX IF EXISTS idx_major;")
conn.commit()

avg_time_without_index = measure_query_time(cursor, query)
print(f"Average execution time WITHOUT index: {avg_time_without_index:.6f} seconds")

# ---------------------------
# 2️⃣ Measure with index
# ---------------------------
# Create the index
cursor.execute("CREATE INDEX IF NOT EXISTS idx_major ON Students(major);")
conn.commit()

avg_time_with_index = measure_query_time(cursor, query)
print(f"Average execution time WITH index: {avg_time_with_index:.6f} seconds")

# ---------------------------
# 3️⃣ Compare performance
# ---------------------------
speedup = avg_time_without_index / avg_time_with_index
print(f"Speedup factor: {speedup:.2f}x faster with index")

# Close the connection
conn.close()
