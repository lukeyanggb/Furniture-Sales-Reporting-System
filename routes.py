from flask import render_template
from lsrsapp import app, db
 
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
    query = \
    """
    SELECT G.category_name,
        Count(*),
        Min(G.regular_price),
        Avg(G.regular_price),
        Max(G.regular_price)
    FROM   (SELECT T.category_name,
                P.regular_price
            FROM   (SELECT C.category_name,
                        I.productid
                    FROM   category AS C
                        LEFT JOIN incategory AS I
                                ON C.category_name = I.category_name) AS T
                LEFT JOIN product AS P
                        ON T.productid = P.productid) AS G
    GROUP  BY category_name
    ORDER  BY G.category_name ASC;
    """
    header, table = db.execute(query)
    return render_template('category_report.html', table=table, header=header)

@app.route('/sofa')
def couacheSofas():
    return render_template('sofa.html')   

@app.route('/storeRev')
def storeRev():
    query = \
    """
    SELECT s.store_number,
       address,
       city_name,
       Extract(year FROM t.date) AS Year,
       Sum(quantity * ( CASE
                          WHEN d.discount_price IS NULL THEN regular_price
                          WHEN d.discount_price IS NOT NULL THEN
                          d.discount_price
                        END ))   AS Revenue
    FROM   store AS s
        natural JOIN city
        natural JOIN TRANSACTION AS t
        natural JOIN product AS p
        LEFT OUTER JOIN discount AS d
                        ON t.productid = d.productid
                        AND t.date = d.date
    WHERE  city_name IN (SELECT city_name
                        FROM   city
                        WHERE  state = '$state')
    GROUP  BY s.store_number,
            year
    ORDER  BY year,
            revenue DESC;
    """
    header, table = db.execute(query)
    return render_template('storeRev.html', table=table, header=header)   

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