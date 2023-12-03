library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath = "C://ojdbc6.jar");

conn <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@192.168.114.128:1515:XE", "dev", "tester");


sql <- "SELECT B.*
FROM (
        SELECT A.*, ROWNUM RN
        FROM (
            SELECT OPD.PRODUCT_CATEGORY_NAME, ROUND(AVG(REVIEW_SCORE), 1) AVG, COUNT(*) CNT
            FROM olist_order_items_dataset ORID, olist_order_reviews_dataset OORD, olist_products_dataset OPD
            WHERE 1=1
            AND ORID.ORDER_ID = OORD.ORDER_ID
            AND ORID.PRODUCT_ID = OPD.PRODUCT_ID
            GROUP BY OPD.PRODUCT_CATEGORY_NAME
            ORDER BY AVG DESC, CNT DESC
        ) A
     ) B
WHERE B.RN <= 10 ";

r <- dbGetQuery(conn, sql)

r