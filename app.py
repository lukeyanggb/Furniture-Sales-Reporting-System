from flask import Flask, render_template

from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://PostgreSQL 13:Testpassword@localhost:5432/test'
# db = SQLAlchemy(app)

# class companyReport(db.model):
    

all_posts = [
    {
    'title':'post 1',
    'content': 'This is the content of post 1'
},
 {
    'title':'post 2',
    'content': 'This is the content of post 2'
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
    return render_template('cityPop.html')   

@app.route('/category_report')
def category_report():
    return render_template('category_report.html')


@app.route('/sofa')
def couacheSofas():
    return render_template('sofa.html')   


@app.route('/storeRev')
def storeRev():
    return render_template('storeRev.html')   

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