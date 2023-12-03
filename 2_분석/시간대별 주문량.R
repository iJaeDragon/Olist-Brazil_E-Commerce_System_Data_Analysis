# 라이브러리 불러오기
library(ggplot2)

library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath = "C://ojdbc6.jar");

conn <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@192.168.114.128:1515:XE", "dev", "tester");


sql <- "SELECT SUBSTR(ORDER_PURCHASE_TIMESTAMP, 12, 2) AS HH, COUNT(*) AS CNT
    FROM OLIST_ORDERS_DATASET
    WHERE 1=1
    AND ORDER_PURCHASE_TIMESTAMP IS NOT NULL
    AND REGEXP_LIKE(ORDER_DELIVERED_CARRIER_DATE, '[0-9]')
    GROUP BY SUBSTR(ORDER_PURCHASE_TIMESTAMP, 12, 2)
    ORDER BY HH ";

result <- dbGetQuery(conn, sql);

print(result)

ggplot(result, aes(x = as.numeric(HH), y = CNT)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  labs(title = "시간대별 주문량",
       x = "주문량",
       y = "시간") +
  theme_minimal()