import psycopg2
from psycopg2 import sql, OperationalError, errors
import sys
import getpass
import os  
from dotenv import load_dotenv

# Load variables from .env file
load_dotenv()

DEFAULTS = {
    "host": os.getenv("HOST", "localhost"),
    "port": int(os.getenv("PORT", 5432)),
    "dbname": os.getenv("DB_NAME", "studentdb"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "admin123"),  # fallback password
}


def get_conn_params():
    print("Enter PostgreSQL connection details. Press Enter to accept default shown in [brackets].")
    host = input(f"Host [{DEFAULTS['host']}]: ") or DEFAULTS['host']
    port_input = input(f"Port [{DEFAULTS['port']}]: ") or str(DEFAULTS['port'])
    try:
        port = int(port_input)
    except ValueError:
        print("Invalid port; using default 5432.")
        port = DEFAULTS['port']
    dbname = input(f"Database name [{DEFAULTS['dbname']}]: ") or DEFAULTS['dbname']
    user = input(f"User [{DEFAULTS['user']}]: ") or DEFAULTS['user']
    password = getpass.getpass(f"Password [{DEFAULTS['password']}]: ") or DEFAULTS['password']
    return dict(host=host, port=port, dbname=dbname, user=user, password=password)

def connect(params, connect_db=True):
    try:
        conn = psycopg2.connect(**params) if connect_db else psycopg2.connect(
            host=params['host'], port=params['port'], dbname='postgres', user=params['user'], password=params['password'])
        return conn
    except OperationalError as e:
        print("Error connecting to database:", e)
        return None

def ensure_database(params):
    """Try creating the target database if it does not exist (connects to 'postgres' first)."""
    try:
        tmp_params = params.copy()
        tmp_params['dbname'] = 'postgres'
        conn = connect(tmp_params)
        if conn is None:
            print("Cannot connect to postgres DB to ensure database exists. Skipping auto-create.")
            return False
        conn.autocommit = True
        cur = conn.cursor()
        cur.execute("SELECT 1 FROM pg_database WHERE datname = %s;", (params['dbname'],))
        exists = cur.fetchone()
        if not exists:
            print(f"Database '{params['dbname']}' does not exist. Creating...")
            cur.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(params['dbname'])))
            print("Database created.")
        cur.close()
        conn.close()
        return True
    except Exception as e:
        print("Error while ensuring database exists:", e)
        return False

def create_table(conn, table_name, columns_def):
    """
    columns_def: list of tuples (col_name, data_type_and_constraints)
    Example: [("id", "SERIAL PRIMARY KEY"), ("name", "VARCHAR(100) NOT NULL"), ...]
    """
    try:
        cur = conn.cursor()
        cols = ", ".join([f"{sql.Identifier(c[0]).string} {c[1]}" for c in columns_def])
        create_q = sql.SQL("CREATE TABLE IF NOT EXISTS {} ({})").format(
            sql.Identifier(table_name), sql.SQL(cols)
        )
        cur.execute(create_q)
        conn.commit()
        print(f"Table '{table_name}' created (or already exists).")
        cur.execute("""
            SELECT table_schema, table_name
            FROM information_schema.tables
            WHERE table_name = %s;
        """, (table_name,))
        rows = cur.fetchall()
        if rows:
            print("Confirmed creation in information_schema.tables:")
            for r in rows:
                print(" -", r[0], r[1])
        else:
            print("Table not found in information_schema.tables (unexpected).")
        cur.close()
    except Exception as e:
        print("Error creating table:", e)

def insert_student(conn, table_name):
    try:
        cur = conn.cursor()
        print("Enter student details. To stop inserting, leave name blank and press Enter.")
        while True:
            name = input("Name: ").strip()
            if name == "":
                break
            age_input = input("Age: ").strip()
            try:
                age = int(age_input)
            except:
                print("Invalid age. Try again.")
                continue
            dept = input("Department: ").strip()
            email = input("Email (optional): ").strip() or None
            cur.execute(sql.SQL("INSERT INTO {} (name, age, department, email) VALUES (%s, %s, %s, %s) RETURNING id;")
                        .format(sql.Identifier(table_name)), (name, age, dept, email))
            new_id = cur.fetchone()[0]
            conn.commit()
            print(f"Inserted student with id={new_id}.")
        cur.close()
    except Exception as e:
        print("Error inserting student(s):", e)

def update_department_by_name(conn, table_name):
    try:
        cur = conn.cursor()
        name = input("Enter student's name for which to update department: ").strip()
        new_dept = input("Enter new department: ").strip()
        cur.execute(sql.SQL("UPDATE {} SET department = %s WHERE name = %s RETURNING id, name, department;")
                    .format(sql.Identifier(table_name)), (new_dept, name))
        rows = cur.fetchall()
        conn.commit()
        if rows:
            print("Updated the following rows:")
            for r in rows:
                print(r)
        else:
            print("No student found with that name.")
        cur.close()
    except Exception as e:
        print("Error updating student:", e)

def delete_student_by_id(conn, table_name):
    try:
        cur = conn.cursor()
        id_input = input("Enter ID of student to delete: ").strip()
        try:
            sid = int(id_input)
        except:
            print("Invalid ID.")
            return
        cur.execute(sql.SQL("DELETE FROM {} WHERE id = %s RETURNING id, name;").format(sql.Identifier(table_name)), (sid,))
        row = cur.fetchone()
        conn.commit()
        if row:
            print(f"Deleted student: id={row[0]}, name={row[1]}")
        else:
            print("No student found with that ID.")
        cur.close()
    except Exception as e:
        print("Error deleting student:", e)

def display_all(conn, table_name):
    try:
        cur = conn.cursor()
        cur.execute(sql.SQL("SELECT * FROM {} ORDER BY id;").format(sql.Identifier(table_name)))
        rows = cur.fetchall()
        if rows:
            colnames = [desc[0] for desc in cur.description]
            print(" | ".join(colnames))
            print("-" * 50)
            for r in rows:
                print(" | ".join(str(x) if x is not None else "NULL" for x in r))
        else:
            print("No records found.")
        cur.close()
    except Exception as e:
        print("Error displaying records:", e)

def display_by_department(conn, table_name):
    try:
        dept = input("Enter department to filter by: ").strip()
        cur = conn.cursor()
        cur.execute(sql.SQL("SELECT * FROM {} WHERE department = %s ORDER BY id;").format(sql.Identifier(table_name)), (dept,))
        rows = cur.fetchall()
        if rows:
            for r in rows:
                print(r)
        else:
            print("No students in that department.")
        cur.close()
    except Exception as e:
        print("Error querying by department:", e)

def display_avg_age_by_dept(conn, table_name):
    try:
        cur = conn.cursor()
        cur.execute(sql.SQL("SELECT department, AVG(age)::numeric(5,2) as avg_age, COUNT(*) FROM {} GROUP BY department ORDER BY department;").format(sql.Identifier(table_name)))
        rows = cur.fetchall()
        if rows:
            print("Department | Average Age | Count")
            print("-" * 40)
            for r in rows:
                print(f"{r[0]} | {r[1]} | {r[2]}")
        else:
            print("No data to group.")
        cur.close()
    except Exception as e:
        print("Error computing averages:", e)

def display_name_startswith(conn, table_name):
    try:
        ch = input("Enter the starting letter/pattern: ").strip()
        if not ch:
            print("Empty pattern.")
            return
        pattern = ch + "%"
        cur = conn.cursor()
        cur.execute(sql.SQL("SELECT * FROM {} WHERE name ILIKE %s ORDER BY id;").format(sql.Identifier(table_name)), (pattern,))
        rows = cur.fetchall()
        if rows:
            for r in rows:
                print(r)
        else:
            print("No matching students.")
        cur.close()
    except Exception as e:
        print("Error pattern matching names:", e)

def print_menu():
    print("""
1. Create Table
2. Insert Student(s)
3. Update Student Department by Name
4. Delete Student by ID
5. Display All Students
6. Display Students by Department
7. Display Average Age by Department
8. Find Students whose names start with letter
9. Exit
""")

def default_students_table_definition():
    return [
        ("id", "SERIAL PRIMARY KEY"),
        ("name", "VARCHAR(100) NOT NULL"),
        ("age", "INT"),
        ("department", "VARCHAR(100)"),
        ("email", "VARCHAR(255)")
    ]

def main():
    params = get_conn_params()
    ensured = ensure_database(params)
    conn = connect(params)
    if conn is None:
        print("Could not connect to the target database. Exiting.")
        sys.exit(1)
    try:
        table_name = "students"
        while True:
            print_menu()
            choice = input("Enter your choice: ").strip()
            if choice == "1":
                print("Creating table. You can accept default 'students' table or provide custom columns.")
                use_default = input("Use default students table (id, name, age, department, email)? [Y/n]: ").strip().lower() or "y"
                if use_default.startswith("y"):
                    cols = default_students_table_definition()
                    create_table(conn, table_name, cols)
                else:
                    tname = input(f"Table name [{table_name}]: ").strip() or table_name
                    cols = []
                    print("Enter columns one per line in format: name TYPE [constraints]. Example: id SERIAL PRIMARY KEY")
                    print("When done, enter a blank line.")
                    while True:
                        line = input("Column definition: ").strip()
                        if not line:
                            break
                        parts = line.split(None, 1)
                        if len(parts) == 1:
                            print("Invalid format. Provide at least a name and a type.")
                            continue
                        col_name = parts[0]
                        col_def = parts[1]
                        cols.append((col_name, col_def))
                    if cols:
                        create_table(conn, tname, cols)
                        table_name = tname
                    else:
                        print("No columns provided. Aborting create.")
            elif choice == "2":
                insert_student(conn, table_name)
            elif choice == "3":
                update_department_by_name(conn, table_name)
            elif choice == "4":
                delete_student_by_id(conn, table_name)
            elif choice == "5":
                display_all(conn, table_name)
            elif choice == "6":
                display_by_department(conn, table_name)
            elif choice == "7":
                display_avg_age_by_dept(conn, table_name)
            elif choice == "8":
                display_name_startswith(conn, table_name)
            elif choice == "9":
                print("Exiting. Closing connection.")
                break
            else:
                print("Invalid choice. Try again.")
    except KeyboardInterrupt:
        print("\nInterrupted by user.")
    finally:
        try:
            conn.close()
            print("Database connection closed.")
        except:
            pass

if __name__ == "__main__":
    main()
