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
WHERE B.RN <= 10
AND CNT >= 100
ORDER BY RN ";

r <- dbGetQuery(conn, sql)

bp<-barplot(r$CNT, names.arg=r$CUSTOMER_CITY, las=1, col=rainbow(5), ylim = c(0,1200), main="가장 인기 있는 카테고리")

text(x=bp, y=r$CNT* 1.1, labels = r$PRODUCT_CATEGORY_NAME, col="black", cex=1.2)