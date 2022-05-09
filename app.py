from flask import Flask, request, render_template, redirect, url_for
from flask_bootstrap import Bootstrap
from flask_wtf import FlaskForm
from wtforms import StringField, DateField, SubmitField
from wtforms.fields.html5 import DateField
from wtforms.validators import DataRequired
import db
from datetime import datetime

app = Flask(__name__)

Bootstrap(app)
# Flask-WTF requires an encryption key - the string can be anything
app.config['SECRET_KEY'] = 'TEAM054_DB6400'

# assign each form control to a unique variable
class MonthHighestVol(FlaskForm):
    date = DateField("Pick a date to show the report for that month", format='%Y-%m-%d', validators=[DataRequired()])
    submit = SubmitField('Submit')

class HolidayAdd(FlaskForm):
    date = DateField("Pick a date: ", format='%Y-%m-%d', validators=[DataRequired()])
    name = StringField('Enter the holiday name', validators=[DataRequired()])
    submit = SubmitField('Submit')


@app.route('/')
def index():
    query = \
    """
    Select (select count(store_number) from store) As count_of_stores,
    (select count(store_number) from store where restaurant = 1 or snack_bar = 1) AS store_that_offers_food,
    (select count(store_number) from store where maximum_time>0) AS store_that_offers_childCare,
    (select count(productid) from product) AS count_of_products,
    (select count(campaign_description) from campaign) As count_of_distinct_campaigns;
    """
    header,table = db.execute(query)
    return render_template('main_menu.html', header = header, table = table)
   

@app.route('/holiday', methods=['GET', 'POST'])
def holiday():
    # header, table = db.execute(query)
    query = \
    """
    SELECT distinct holiday_name FROM holiday;                          
    """
    _, holidays = db.execute(query)
    query = \
    """
    SELECT distinct date FROM holiday;                   
    """
    _, dates = db.execute(query)

    form = HolidayAdd()

    message = ""
    if form.validate_on_submit():
        date = form.date.data
        year = date.year
        month = date.month
        day = date.day
        name = form.name.data
        # check if the selected date is holiday or not:
        query = \
        """
        SELECT * FROM holiday WHERE date = '%d-%d-%d';             
        """
        _, table = db.execute(query % (year, month, day))
        # if no record:
        if len(table) == 0:
            query = \
            """
            INSERT INTO holiday VALUES ('%d/%d/%d', '%s');             
            """
            db.insert(query % (year, month, day, name))
        # if already has a holiday
        else:
            name += table[0][1]
            name = name.replace("'", "''")
            query = \
            """
            UPDATE holiday SET holiday_name = '%s' WHERE date = '%d/%d/%d';             
            """
            db.update(query % (name, year, month, day))
        return redirect( url_for('holidayShowDate', yr=year, m=month, d=day))
    else:
        message = 'Invalid input.'

    return render_template('holiday.html', posts1 =dates, posts2 = holidays, form=form, message=message) 

@app.route('/holiday/<selecthol>')
def holidayShowHD(selecthol):
    # header, table = db.execute(query)
  
    query = """SELECT distinct holiday_name FROM holiday;"""
    _, holidays = db.execute(query)

    query = """SELECT distinct date FROM holiday;"""
    _, dates = db.execute(query)
    
    lable = False 

    for item in holidays:
        if selecthol in item:
            lable = True
            if selecthol.find("'") != -1:
                index = selecthol.find("'")
                selecthol = selecthol[:index] + "'" + selecthol[index:]
        
    if lable is True:
        holquery = \
        """
        SELECT *  FROM holiday WHERE holiday_name =  \'%s\';                   
        """
        header, table = db.execute(holquery % selecthol)
    
    else:
        date = datetime.strptime(selecthol, '%Y-%m-%d')
        yr = date.year
        m = date.month 
        d = date.day
        query = \
        """
        SELECT * FROM holiday WHERE date = '%d-%d-%d';             
        """
        header, table = db.execute(query % (yr, m, d))

    return render_template('holidayShow.html', posts1 = dates, posts2 = holidays, table=table, header=header) 



@app.route('/holiday/<int:yr>/<int:m>/<int:d>')
def holidayShowDate(yr, m, d):
    # header, table = db.execute(query)
    query = """SELECT distinct holiday_name FROM holiday;"""
    _, holidays = db.execute(query)

    query = """SELECT distinct date FROM holiday;"""
    _, dates = db.execute(query)
    query = \
    """
    SELECT * FROM holiday WHERE date = '%d-%d-%d';             
    """
    header, table = db.execute(query % (yr, m, d))
    return render_template('holidayShow.html', posts1 = dates, posts2 = holidays, table=table, header=header) 


@app.route('/cityPopSelect')
def cityPopSelect():
    #selectCity
    # added city selection dropdown
    statequery = \
    """
    SELECT  distinct(state, city_name) FROM city;

    """
    _, cities = db.execute(statequery)
    return render_template('cityPopSelect.html', posts = cities)


@app.route('/cityPop/<selectCity>')
def cityPop(selectCity):
    #selectCity
    # added city selection dropdown
    stateandcity =selectCity.split(',')
    state = stateandcity[0][1::]
    city = stateandcity[1][0:-1]
    if city[0]=='\"':
        city = city[1:-1]
    print(state)
    print(city)
    
    statequery = \
    """
    SELECT distinct(state, city_name) FROM city;
                         
    """
    _, cities = db.execute(statequery)
    query = \
        """
         SELECT state, city_name, city_population FROM city
         WHERE state =  \'%s\' and city_name =  \'%s\';
        """
    header, table = db.execute(query % (state, city))
 
    return render_template('cityPopSelect.html', posts = cities, table=table, header=header)


@app.route('/cityPopUpdate', methods=["POST"])
def cityPopUpdate():
    #selectCity
    # added city selection dropdown


    # *****************************************************************************
    # city and population number data has been received
    # you can print data and its types

    selectCity = str(request.form.get("cityoption"))
    cityPopNum = int(request.form.get("Population"))
    stateandcity =selectCity.split(',')
    state = stateandcity[0][1::]
    city = stateandcity[1][0:-1]
    if city[0]=='\"':
        city = city[1:-1]

    statequery = \
    """
    SELECT distinct(state, city_name) FROM city;
                         
    """
    _, cities = db.execute(statequery)

    query = """ UPDATE city SET city_population = '%d' WHERE  state = '%s' and city_name = '%s' """
    db.insert(query % (cityPopNum, state, city))

    statequery = \
    """
    SELECT distinct(state, city_name) FROM city;
                         
    """
    _, cities = db.execute(statequery)

    query = """SELECT state, city_name, city_population FROM city
         WHERE state = '%s' and city_name = '%s';"""
    header, table = db.execute(query % (state, city))

    return render_template('cityPopSelect.html', posts = cities, header = header, table = table)



@app.route('/category_report')
def category_report():
    query = \
    """
    SELECT G.category_name as cat_name,
        Count(*) as count,
        Min(G.regular_price) as min,
        cast(Avg(G.regular_price) as DECIMAL(9,2)) as avg,
        Max(G.regular_price) as max
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

@app.route('/groundhog')
def groundhog():
    query = \
    """
    SELECT cast(a.year as int), 
    Totalnumber_for_a_whole_year,
    avenumber, 
    groundhognum 
    FROM (SELECT Extract(year FROM t.date) AS Year,
    Sum(quantity) As Totalnumber_for_a_whole_year,
    round(Sum(quantity) * 1.0 / 365, 2) AS AveNumber 
    FROM TRANSACTION AS t 
    natural JOIN product 
    natural JOIN incategory 
    WHERE productid IN (SELECT productid 
    FROM incategory 
    WHERE category_name = 'Outdoor Furniture') 
    GROUP BY year 
    ORDER BY year) a 
    LEFT JOIN (SELECT Sum(quantity) AS Groundhognum, 
    Extract(year FROM date) AS year 
    FROM TRANSACTION 
    WHERE Extract(month FROM date) = 2 
    AND Extract(day FROM date) = 2 
    GROUP BY date 
    ORDER BY Extract(year FROM date)) b 
    ON a.year = b.year; 
    """
    header, table = db.execute(query)
    return render_template('groundhog.html', table=table, header=header)

@app.route('/sofa')
def sofa():
    query = \
    """
        SELECT 
       p.productid                                                      AS
       product_ID,
	   p.product_name                                                   AS
       product_name,
       p.regular_price                                                  AS
       retail_price,
       Sum(t.quantity)                                                  AS
       total_quantity,
	   Sum( case when (d.date = t.date) then t.quantity end) as discount_quantity,
	   Sum( case when (d.date <> t.date) then t.quantity end) as retail_price_quantity,
	   round(cast(Sum(( CASE
                                                        WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN d.discount_price
                                                        ELSE p.regular_price
                                                      END ) * quantity) as float)) as actual_revenue,
	   round(Sum(( CASE
			  WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN p.regular_price * 0.75
                                                        ELSE p.regular_price
                                                      END ) * quantity))	as predicted_revenue,
	   round(Sum(( CASE
			  WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN p.regular_price * 0.75
                                                        ELSE p.regular_price
                                                      END ) * quantity)
													  -
													  Sum(( CASE
                                                        WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN d.discount_price
                                                        ELSE p.regular_price
                                                      END ) * quantity)) AS       difference
    FROM   TRANSACTION AS t
        LEFT JOIN product AS p
                ON t.productid = p.productid
        LEFT JOIN discount AS d
                ON d.productid = p.productid
        LEFT JOIN incategory AS ic
                ON ic.category_name = 'Couches'
                    OR ic.category_name = 'Sofas'
    GROUP  BY p.product_name,
            p.productid
    HAVING Sum(( CASE
			  WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN p.regular_price * 0.75
                                                        ELSE p.regular_price
                                                      END ) * quantity)
													  -
													  Sum(( CASE
                                                        WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN d.discount_price
                                                        ELSE p.regular_price
                                                      END ) * quantity) < -5000
            OR Sum(( CASE
			  WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN p.regular_price * 0.75
                                                        ELSE p.regular_price
                                                      END ) * quantity)
													  -
													  Sum(( CASE
                                                        WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN d.discount_price
                                                        ELSE p.regular_price
                                                      END ) * quantity) >
            5000
    ORDER  BY difference DESC; 
 
    """
    header, table = db.execute(query)
    return render_template('sofa.html', table=table, header=header) 

@app.route('/storeRevSelect')
def storeRevSelect():
    # add selection for states
    statequery = \
    """
    SELECT distinct state FROM city;                         
    """
    _, States = db.execute(statequery)

    # if request.method == 'POST':
    #     selectstate = request.form.get('selectstate')
    #     return render_template('storeRev.html', selectstate)
    return render_template('storeRevSelect.html', posts = States)


@app.route('/storeRev/<selectstate>')
def storeRev(selectstate):
    # add selection for states
    statequery = \
    """
    SELECT distinct state FROM city;                         
    """
    _, States = db.execute(statequery)
    
    query = \
    """
    SELECT s.store_number,
    address,
    city_name,
    cast(Extract(year FROM t.date) as integer) AS Year,
    round(Sum(quantity * ( CASE
                        WHEN d.discount_price IS NULL THEN regular_price
                        WHEN d.discount_price IS NOT NULL THEN
                        d.discount_price
                        END )))  AS Revenue
    FROM   store AS s
        natural JOIN city
        natural JOIN TRANSACTION AS t
        natural JOIN product AS p
        LEFT OUTER JOIN discount AS d
                        ON t.productid = d.productid
                        AND t.date = d.date
    WHERE  city_name IN (SELECT city_name
                        FROM   city
                        WHERE  state = \'%s\')
    GROUP  BY s.store_number,
            year
    ORDER  BY year,
            revenue DESC;
    """
    header, table = db.execute(query % selectstate)
    return render_template('storeRev.html', posts = States, table=table, header=header)  


@app.route('/highestVolSelect', methods=['GET', 'POST'])
def highestVolSelect():
    selectmonth = request.form.get("Monthselect")
   
    if selectmonth is not None:
        print(selectmonth)
        date = datetime.strptime(selectmonth, '%Y-%m')
        yr = date.year
        m = date.month
        return redirect( url_for('highestVol', yr=yr, m=m) )
    else:
        message = 'Sorry. There is no record for selected month.'
    return render_template('highestVolSelect.html')

@app.route('/highestVol/<int:yr>/<int:m>', methods=['GET', 'POST'])
def highestVol(yr, m):
    
    query = \
    """
    SELECT category_name,
        state,
        volume
    FROM  (SELECT category_name,
                state,
                volume,
                Rank()
                    OVER (
                    partition BY category_name
                    ORDER BY volume DESC ) AS Rank
        FROM   (SELECT category_name,
                        Sum(quantity)AS Volume,
                        state
                FROM  (SELECT category_name,
                                quantity,
                                store_number
                        FROM  (SELECT category_name,
                                        quantity,
                                        store_number,
                                        Extract(year FROM T.date) AS YEAR,
                                        Extract(month FROM T.date)AS month
                                FROM   incategory AS I
                                        INNER JOIN TRANSACTION AS T
                                                ON I.productid = T.productid)AS A
                        WHERE  year = %d
                                AND month = %d)AS C
                        INNER JOIN (SELECT S.store_number,
                                            city_name,
                                            state
                                    FROM   store AS S
                                            INNER JOIN TRANSACTION AS T
                                                    ON
                                            S.store_number = T.store_number)AS
                                    L
                                ON C.store_number = L.store_number
                GROUP  BY category_name,
                            state
                ORDER  BY category_name ASC) a) a
    WHERE  rank = 1 
    """
    header, table = db.execute(query % (yr, m)) 
    return render_template('highestVol.html', table=table, header=header) 


@app.route('/revByPop')
def revByPop():
    query = \
    """
    SELECT CAST(year AS VARCHAR(10)), CAST(small AS INT),CAST(medium AS INT),CAST(large AS INT),CAST(extra_large AS INT)
 FROM
 (SELECT *
    FROM   crosstab ( 'WITH CityRevenue(year, city_size, revenue) AS (SELECT   year,
            city_size,
            Sum(revenue)AS revenue
    FROM    (  SELECT    Extract(year FROM t.date) AS year,
                                            store_number,
                                            quantity*(
                                            CASE
                                                        WHEN d.discount_price IS NULL THEN p.regular_price
                                                        WHEN d.discount_price IS NOT NULL THEN d.discount_price
                                            END)        AS revenue
                                    FROM      TRANSACTION AS t
                                    LEFT JOIN discount    AS d
                                    ON        t.productid=d.productid
                                    AND       t.date=d.date
                                    LEFT JOIN product AS p
                                    ON        p.productid=t.productid )AS a natural
    JOIN(SELECT store_number,city_size FROM
            (SELECT city_name,state,
                        CASE
                                WHEN city_population<3700000 THEN ''small''
                                WHEN city_population>=3700000
                                AND    city_population<6700000 THEN ''medium''
                                WHEN city_population>=6700000
                                AND    city_population<9000000 THEN ''large''
                                WHEN city_population>=9000000 THEN ''extra_large''
                        END AS city_size
                    FROM   city) AS c natural JOIN store AS a) AS p
    GROUP BY year,
            city_size
    ORDER BY year) 
    SELECT year, city_size, revenue FROM CityRevenue ORDER BY 1,2' ) AS PIVOT(year double PRECISION, extra_large DOUBLE PRECISION, large DOUBLE PRECISION, medium DOUBLE PRECISION, small DOUBLE PRECISION)) a;
    """
    header, table = db.execute(query)
    return render_template('revByPop.html', table=table, header=header)   

@app.route('/childcare')
def childcare():
    query = \
    """
    CREATE EXTENSION IF NOT EXISTS tablefunc;
    SELECT  mon, round(no_childcare) as no_childcare, round(max_15) as max_15, round(max_30) as max_30,round(max_60) as max_60
    FROM     crosstab ( 
    'WITH aggtable(mon, maximum_time, sum) AS
            (SELECT Sales.mon, Sales.maximum_time, SUM(Sales.revenue) 
            FROM
                (SELECT to_char(PriceChild.date,''Mon'') as mon, PriceChild.maximum_time, 
                PriceChild.quantity*LEAST(PriceChild.regular_price, D.discount_price) 
                AS revenue 
                FROM
                    (SELECT Price.date, Price.productID, Price.regular_price, 
                    Price.quantity, Store.maximum_time 
                    FROM
                        (SELECT T.store_number, T.productID, T.date, T.quantity, 
                        P.regular_price 
                        FROM Transaction AS T
                        LEFT JOIN Product AS P
                        ON T.productID = P.productID
                        WHERE T.date >= 
                        date_trunc(''month'', date ''2012-07-01'') - INTERVAL ''1 year'') AS Price
                    LEFT JOIN Store 
                    ON Price.store_number = Store.store_number) AS PriceChild
                LEFT JOIN Discount AS D
                ON PriceChild.productID = D.productID AND PriceChild.date = D.date) AS Sales
            GROUP BY Sales.mon, Sales.maximum_time)
        SELECT mon, maximum_time, sum 
        FROM AggTable
        ORDER BY 1,2'
    ) AS aggtable(mon text, no_childcare float8, max_15 float8, max_30 float8, max_60 float8)
    ORDER BY
            CASE
                    WHEN mon = 'Jan' THEN 1
                    WHEN mon = 'Feb' THEN 2
                    WHEN mon = 'Mar' THEN 3
                    WHEN mon = 'Apr' THEN 4
                    WHEN mon = 'May' THEN 5
                    WHEN mon = 'Jun' THEN 6
                    WHEN mon = 'Jul' THEN 7
                    WHEN mon = 'Aug' THEN 8
                    WHEN mon = 'Sep' THEN 9
                    WHEN mon = 'Oct' THEN 10
                    WHEN mon = 'Nov' THEN 11
                    WHEN mon = 'Dec' THEN 12
            END;
    """
    header, table = db.execute(query)
    return render_template('childcare.html', table=table, header=header)   

@app.route('/restaurant')
def restaurant():
    query = \
    """
    SELECT category,
        CASE
            WHEN store_type IS NULL THEN 'Non-Restaurant'
            ELSE store_type
        end AS Store_Type,
        quantity_sold
        FROM   (SELECT category_name AS Category,
                    CASE
                        WHEN restaurant = 1 THEN 'Restaurant'
                    end           AS Store_Type,
                    Sum(quantity) AS Quantity_Sold
                FROM   incategory
                    LEFT JOIN(SELECT restaurant,
                                        store.store_number,
                                        quantity,
                                        productid
                                FROM   store
                                        INNER JOIN transaction
                                                ON store.store_number =
                                                transaction.store_number) a
                            ON incategory.productid = a.productid
                GROUP  BY category_name,
                        restaurant
                ORDER  BY category_name) a;
    """
    header, table = db.execute(query)
    return render_template('restaurant.html', table=table, header=header)  

@app.route('/campaign')
def campaign():
    query = \
    """
    (select productid, product_name,totalincampaign, totaloutcampaign,(totalincampaign - totaloutcampaign) as difference from
    (select totalincampaign, totaloutcampaign, productid, (totalincampaign - totaloutcampaign) as difference
        from
        (select productid, sum(quantity) as totalincampaign
        from(
        select *
        from transaction natural join discount
        where date in (select date from campaign)
        order by productid) as a
        group by productid) as n natural join
        (select productid, sum(quantity) as totaloutcampaign
        from(
        select *
        from transaction natural join discount
        where date not in (select date from campaign)
        order by productid) as a
        group by productid) as m) as x natural join product
    order by difference DESC
    LIMIT 10)
    UNION
    (select productid, product_name,totalincampaign, totaloutcampaign,(totalincampaign - totaloutcampaign) as difference from
    (select totalincampaign, totaloutcampaign, productid, (totalincampaign - totaloutcampaign) as difference
        from
        (select productid, sum(quantity) as totalincampaign
        from(
        select *
        from transaction natural join discount
        where date in (select date from campaign)
        order by productid) as a
        group by productid) as n natural join
        (select productid, sum(quantity) as totaloutcampaign
        from(
        select *
        from transaction natural join discount
        where date not in (select date from campaign)
        order by productid) as a
        group by productid) as m) as x natural join product
    order by difference ASC
    LIMIT 10)
    ORDER BY difference DESC;
    """
    header, table = db.execute(query)
    return render_template('campaign.html', table=table, header=header)



@app.route('/test')
def test():
    query = \
    """
   SELECT state FROM city;
                         
    """
    header, table = db.execute(query)
    return render_template('test.html', table=table, header=header) 


if __name__ == '__main__':
    # Tells Flask to run, accessible from the specified host/port pair. Note
    # that the routes are loaded because of the import above.
    app.run(host='127.0.0.1', port=5000, debug=True)