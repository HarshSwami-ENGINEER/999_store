import mysql.connector
from mysql.connector import errorcode
from flask import Flask, request

try:
    cnx = mysql.connector.connect(user='root', password='Arjun$123',port=3306, host='127.0.0.1',database='retailstore',
    auth_plugin='mysql_native_password')
except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Something is wrong with your user name or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)


app = Flask(__name__)

@app.route('/submit-form', methods=['POST'])
def submit_form():
    name = request.form['name']
    email = request.form['email']
    phone = request.form['phone']
    
    cursor = cnx.cursor()
    
    # Insert the data into the database
    query = "INSERT INTO mytable (name, email, phone) VALUES (%s, %s, %s)"
    values = (name, email, phone)
    cursor.execute(query, values)
    
    cnx.commit()
    cursor.close()
    
    return 'Form submitted successfully'


@app.route('/update-form', methods=['POST'])
def update_form():
    id = request.form['id']
    new_name = request.form['new_name']
    new_email = request.form['new_email']
    new_phone = request.form['new_phone']
    
    cursor = cnx.cursor()
    
    # Update the record in the database
    query = "UPDATE mytable SET name=%s, email=%s, phone=%s WHERE id=%s"
    values = (new_name, new_email, new_phone, id)
    cursor.execute(query, values)
    
    cnx.commit()
    cursor.close()
    
    return 'Form updated successfully'

@app.route('/customer_sign-form', methods=['POST'])
def customer_sign():
    username = request.form['username']
    password = request.form['password']

    # check if data exist in the database , if exist make sign in else signup
    # if( password):


from flask import Flask
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'  # replace with your MySQL host
app.config['MYSQL_USER'] = 'root'  # replace with your MySQL username
app.config['MYSQL_PASSWORD'] = 'Arjun$123'  # replace with your MySQL password
app.config['MYSQL_DB'] = 'retailstore'  # replace with your MySQL database name

mysql = MySQL(app)

if __name__ == '__main__':
    app.run()