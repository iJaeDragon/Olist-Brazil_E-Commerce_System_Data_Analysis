library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath = "C://ojdbc6.jar");

conn <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@192.168.114.128:1515:XE", "dev", "tester");


sql <- "SELECT A.*
FROM (
    SELECT CUSTOMER_CITY, COUNT(*) CNT, RANK() OVER ( ORDER BY COUNT(*) DESC) RANK
    FROM olist_customers
    GROUP BY CUSTOMER_CITY
) A
WHERE RANK <= 5 ";

r <- dbGetQuery(conn, sql);

bp<-barplot(r$CNT, names.arg=r$CUSTOMER_CITY, las=1, col=rainbow(5),ylim = c(0,20000), main="유치치율이 높은 지역");

text(x=bp, y=r$CNT* 1.1,labels = r$CNT,col="black",cex=1.2)