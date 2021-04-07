from flask import Flask, render_template

from flask_sqlalchemy import SQLAlchemy

from sqlalchemy import create_engine

from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, String, MetaData, ForeignKey
from sqlalchemy import inspect

app = Flask(__name__)

# # app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:password@localhost:5432/test'
# db = SQLAlchemy(app)
# # class companyReport(db.Model):
# #     __tablename__ = "category"

# engine = create_engine('postgresql://postgres:password@localhost:5432/test')


# engine = db.engine
# # connection = engine.connect()

# with engine.connect() as con:

#     Category = con.execute("SELECT category_name FROM category")

#     for row in Category:
#         print(row)



    
# dummy data base
all_city = [
    {
    'state':'NY',
    'city_name': 'New York',
    'Population': '122345'
},
 {
    'state':'NY',
    'city_name': 'West Chester',
    'Population': '13213132'
},
 {
    'state':'TX',
    'city_name': 'Austin',
    'Population': '31313131'
},
{
    'state':'TX',
    'city_name': 'Dallas',
    'Population': '3131314'
},
]


States = [
    {
    'state':'NY',
    
},
 {
    'state':'CA',
   
},
 {
    'state':'GA',
   
},
{
    'state':'TX',
  
},
]


@app.route('/')
def index():
    return render_template('main_menu.html')

@app.route('/holiday')
def holiday():
    return render_template('holiday.html') 

@app.route('/cityPop')
def cityPop():
    return render_template('cityPop.html', posts = all_city)   

@app.route('/category_report')
def category_report():
    return render_template('category_report.html')

@app.route('/sofa')
def couacheSofas():
    return render_template('sofa.html')   

@app.route('/storeRev')
def storeRev():
    return render_template('storeRev.html',posts = States)   

@app.route('/highestVol')
def highestVol():
    return render_template('highestVol.html')   

@app.route('/revByPop')
def revByPop():
    return render_template('revByPop.html')   

@app.route('/childcare')
def childcare():
    return render_template('childcare.html')   

@app.route('/restaurant')
def restaurant():
    return render_template('restaurant.html')  

@app.route('/campaign')
def campaign():
    return render_template('campaign.html')   






def hello(name):
    return "hello, " + name


@app.route('/onlyget',methods = ['GET'])
def get_req():
    return "You can only get this webpage"




if __name__ == "__main__":
    app.run(debug = True)