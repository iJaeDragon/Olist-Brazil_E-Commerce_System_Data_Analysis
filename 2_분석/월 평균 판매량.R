library(rJava)
library(RJDBC)
library(ggplot2)
library(forecast)
library(tsibble)

jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath = "C://ojdbc6.jar");

conn <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@192.168.114.128:1515:XE", "dev", "tester");


sql <- "SELECT TO_CHAR(TO_DATE(SUBSTR(ORDER_DELIVERED_CARRIER_DATE, 0, 7), 'YYYY-MM'), 'YYYY-MM') AS DT, COUNT(*) as VALUE
FROM OLIST_ORDERS_DATASET
WHERE 1=1
AND ORDER_DELIVERED_CARRIER_DATE IS NOT NULL
AND REGEXP_LIKE(ORDER_DELIVERED_CARRIER_DATE, '[0-9]')
GROUP BY SUBSTR(ORDER_DELIVERED_CARRIER_DATE, 0, 7) ";

result <- dbGetQuery(conn, sql);

minDate <- min(result$DT);
maxDate <- max(result$DT);

ts_data <- ts(result$VALUE, start = c(substr(minDate, 0, 4), substr(minDate, 6, 7)), end = c(substr(maxDate, 0, 4), substr(maxDate, 6, 7)), frequency = 12);

print(ts_data);

ggseasonplot(ts_data, year.labels = TRUE, xlab = "Month", ylab = "판매 량") 