import mysql.connector

# create a connection to the database
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Arjun$123",
    database="99retailstore-schema.sql"
)

# create a cursor object
mycursor = mydb.cursor()

# execute a SQL query
mycursor.execute("SELECT * FROM table_name")

# fetch the results
results = mycursor.fetchall()

# print the results
for result in results:
    print(result)