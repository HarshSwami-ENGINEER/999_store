from flask import Flask, render_template, request
import mysql
import mysql.connector

app = Flask(__name__)

def connectToDB():
    # create a connection to the database
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Arjun$123",
        database="onlineStore"
    )
    return conn

@app.route('/')
def login():
    return render_template('login.html')

@app.route('/register')
def register():
    return render_template('register.html')

@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/checkout')
def checkout():
    return render_template('checkout.html')

# API for customer login
@app.route('/login_validation', methods=['POST'])
def login_validation():
    email = request.form.get('email')
    password = request.form.get('password')
    conn = connectToDB()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM customer_login WHERE email LIKE '{}' and password LIKE '{}'".format(email,password))
    users = cursor.fetchall()
    if len(users)>0:
        return render_template('home.html')
    else:
        return render_template('login.html')
    conn.close()

# add customer information
@app.route('/add_user', methods=['POST'])
def add_user():
     name = request.form.get('uname')
     DOB = request.form.get('DOB')
     address = request.form.get("customer_address")
     phone_no = request.form.get("phone_no")
     email = request.form.get('uemail')
     password = request.form.get('upassword')
     confirm_password = request.form.get("confirm_password")
     conn = connectToDB()
     cursor = conn.cursor()
     cursor.execute("INSERT INTO users (customer_name, DOB, customer_address, phone_no, customer_email, password, confirm_password) VALUES ('{}', '{}', '{}', '{}', '{}', '{}', '{}')".format(name, DOB, address, phone_no, email, password, confirm_password))
     cursor.execute("INSERT INTO customer_login (customer_ID, email, password) VALUES (NULL, '{}', '{}')".format(email, password))
     conn.commit()
     conn.close()
     return " USER Registered Successfully"

# add category information
@app.route('/addCategory/<string:name>/<string:info>')
def addCategory(name, info):
    try:
        db = connectToDB()
        cursor = db.cursor()
        cursor.execute(f"insert into category(category_name, category_info) values('{name}','{info}')")
        db.commit()
        db.close()
        return "Success"
    except Exception as e:
        return str(e)

# API for deleting category
@app.route('/deleteCategory/<string:categoryname>')
def deleteCategory(categoryname):
    try:
        db = connectToDB()
        c = db.cursor()
        c.execute(f"delete from category where category_name='{categoryname}'")
        db.commit()
        db.close()
        return "Success"
    except Exception as e:
        return str(e)


# API for updating category information
@app.route('/updateCategory/<string:categoryname>/<string:description>')
def updateCategory(categoryname, description):
    try:
        db = connectToDB()
        c = db.cursor()
        c.execute(f"update category set category_info = '{description}' where category_name='{categoryname}'")
        db.commit()
        db.close()
        return "Success"
    except Exception as e:
        return str(e)


# API for updating product cost
@app.route('/updateCost/<int:productID>/<int:cost>')
def updateCost(productID, cost):
    try:
        db = connectToDB()
        c = db.cursor()
        c.execute(f"update product set product_cost = {cost} where product_id={productID}")
        db.commit()
        db.close()
        return "Success"
    except Exception as e:
        return str(e)


# API for adding in belongs to table
@app.route('/addBelongsTo/<int:productID>/<int:categoryID>')
def addBelongsTo(productID, categoryID):
    try:
        db = connectToDB()
        c = db.cursor()
        c.execute(f"insert into belongsto(product_id, category_id) values ({productID},{categoryID})")
        db.commit()
        db.close()
        return "Success"
    except Exception as e:
        return str(e)


# API for deleting in belongs to table
@app.route('/deleteBelongsTo/<int:productID>/<int:categoryID>')
def deleteBelongsTo(productID, categoryID):
    try:
        db = connectToDB()
        c = db.cursor()
        c.execute(f"delete from belongsto where product_id = {productID} and category_id = {categoryID}")
        db.commit()
        db.close()
        return "Success"
    except Exception as e:
        return str(e)


# API for displaying belongsTo
@app.route('/BelongsTo')
def BelongsTo():
    try:
        db = connectToDB()
        c = db.cursor()
        c.execute(f"select * from belongsto")
        result = c.fetchall()
        db.close()
        return flask.jsonify(result)
    except Exception as e:
        return str(e)


if __name__ == '__main__':
    app.run(debug=True)