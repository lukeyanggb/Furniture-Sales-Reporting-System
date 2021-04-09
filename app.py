from flask import Flask, request, render_template, redirect, url_for
app = Flask(__name__)
import db


@app.route('/')
def index():
    return render_template('main_menu.html')

@app.route('/holiday')
def holiday():
    # header, table = db.execute(query)
    statequery = \
    """
   SELECT distinct holiday_name FROM holiday;
                         
    """
    header, holidies = db.execute(statequery)
    

    return render_template('holiday.html',posts = holidies) 

@app.route('/cityPop')
def cityPop():
    # added city selection dropdown
    statequery = \
    """
   SELECT distinct city_name FROM city;
                         
    """
    header, cities = db.execute(statequery)
    
 
    return render_template('cityPop.html', posts = cities)   

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
    query = \
    """
    SELECT Sum(p.regular_price * quantity * 0.75) - Sum(( CASE
                                                        WHEN (
              d.productid = p.productid
              AND d.date = t.date ) THEN d.discount_price
                                                        ELSE p.regular_price
                                                      END ) * quantity) AS
       difference,
       p.product_name                                                   AS
       product_name,
       p.productid                                                      AS
       product_ID,
       p.regular_price                                                  AS
       retail_price,
       Sum(t.quantity)                                                  AS
       total_quantity
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
    HAVING Sum(p.regular_price * quantity * 0.75) - Sum(( CASE
                                                            WHEN (
                d.productid = p.productid
                AND d.date = t.date ) THEN d.discount_price
                                                            ELSE p.regular_price
                                                        END ) * quantity) < -5000
            OR Sum(p.regular_price * quantity * 0.75) - Sum((
                CASE
                WHEN ( d.productid =
                        p.productid
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
                        WHERE  state = \'%s\')
    GROUP  BY s.store_number,
            year
    ORDER  BY year,
            revenue DESC;
    """
    header, table = db.execute(query % selectstate)
    return render_template('storeRev.html', posts = States, table=table, header=header)  


@app.route('/highestVolSelect')
def highestVolSelect():
    return render_template('highestVolSelect.html')

@app.route('/highestVol/<int:yr>/<int:m>')
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
    SELECT *
    FROM   crosstab ( 'WITH CityRevenue(year, city_size, revenue) AS (SELECT   year,
            city_size,
            Sum(revenue)AS revenue
    FROM    (
                    SELECT year,
                        city_name,
                        state,
                        revenue
                    FROM  (
                                    SELECT    Extract(year FROM t.date) AS year,
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
                    JOIN   city                                         AS c) AS f natural
    JOIN
            (
                    SELECT city_name,
                        state,
                        CASE
                                WHEN city_population<3700000 THEN ''small''
                                WHEN city_population>=3700000
                                AND    city_population<6700000 THEN ''medium''
                                WHEN city_population>=6700000
                                AND    city_population<9000000 THEN ''large''
                                WHEN city_population>=9000000 THEN ''extra_large''
                        END AS city_size
                    FROM   city) AS c
    GROUP BY year,
            city_size
    ORDER BY year) 
    SELECT year, city_size, revenue FROM CityRevenue ORDER BY 1,2' ) AS PIVOT(year double PRECISION, small DOUBLE PRECISION, medium DOUBLE PRECISION, large DOUBLE PRECISION, extra_large DOUBLE PRECISION);
    """
    header, table = db.execute(query)
    return render_template('revByPop.html', table=table, header=header)   

@app.route('/childcare')
def childcare():
    query = \
    """
    SELECT   *
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
                        date_trunc(''month'', CURRENT_DATE) - INTERVAL ''1 year'') AS Price

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
                    WHEN restaurant IS TRUE THEN 'Restaurant'
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
    (SELECT b.productid,
            product_name,
            Sum(inside)                AS sold_during_campaign,
            Sum(outside)               AS sold_outside_campaign,
            Sum(inside) - Sum(outside) AS difference
    FROM   (SELECT Max(CASE
                        WHEN camp = 'inside' THEN quantity
                        ELSE 0
                        end) AS inside,
                    Max(CASE
                        WHEN camp = 'outside' THEN quantity
                        ELSE 0
                        end) AS outside,
                    productid,
                    a.date
            FROM   (SELECT CASE
                            WHEN transaction.date BETWEEN
                                a.start_date AND a.end_date THEN
                            'inside'
                            ELSE 'outside'
                            end              AS camp,
                            productid,
                            transaction.date AS date,
                            quantity
                    FROM   transaction
                            LEFT JOIN (SELECT date,
                                            start_date,
                                            end_date
                                    FROM   belongto
                            INNER JOIN campaign
                                    ON belongto.campaign_description =
                                    campaign.campaign_description) a
                                ON transaction.date = a.date) AS a
            GROUP  BY productid,
                    camp,
                    a.date) b
            LEFT JOIN product
                ON b.productid = product.productid
    GROUP  BY b.productid,
            product_name
    ORDER  BY difference DESC
    -- our dummy data can only show top 2 and bottom 2 due to limited number of data
    -- if using our data to run please change the LIMIT from 10 to 2.
    LIMIT  10)
    UNION
    (SELECT b.productid,
            product_name,
            Sum(inside)                AS sold_during_campaign,
            Sum(outside)               AS sold_outside_campaign,
            Sum(inside) - Sum(outside) AS difference
    FROM   (SELECT Max(CASE
                        WHEN camp = 'inside' THEN quantity
                        ELSE 0
                        end) AS inside,
                    Max(CASE
                        WHEN camp = 'outside' THEN quantity
                        ELSE 0
                        end) AS outside,
                    productid,
                    a.date
            FROM   (SELECT CASE
                            WHEN transaction.date BETWEEN
                                a.start_date AND a.end_date THEN
                            'inside'
                            ELSE 'outside'
                            end              AS camp,
                            productid,
                            transaction.date AS date,
                            quantity
                    FROM   transaction
                            LEFT JOIN (SELECT date,
                                            start_date,
                                            end_date,
                                            campaign.campaign_description
                                    FROM   belongto
                            INNER JOIN campaign
                                    ON belongto.campaign_description =
                                    campaign.campaign_description) a
                                ON transaction.date = a.date) AS a
            GROUP  BY productid,
                    camp,
                    a.date) b
            LEFT JOIN product
                ON b.productid = product.productid
    GROUP  BY b.productid,
            product_name
    ORDER  BY difference ASC
    -- our dummy data can only show top 2 and bottom 2 due to limited number of data
    -- if using our data to run please change the LIMIT from 10 to 2.
    LIMIT  10)
    ORDER  BY difference DESC; 
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