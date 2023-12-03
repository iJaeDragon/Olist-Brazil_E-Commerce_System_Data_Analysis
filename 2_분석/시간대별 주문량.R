# 라이브러리 불러오기
library(ggplot2)

library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath = "C://ojdbc6.jar");

conn <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@192.168.114.128:1515:XE", "dev", "tester");


sql <- "SELECT CASE WHEN SUBSTR(ORDER_PURCHASE_TIMESTAMP, 12, 2) = '00' THEN '24' ELSE SUBSTR(ORDER_PURCHASE_TIMESTAMP, 12, 2) END AS HH, COUNT(*) AS CNT
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
       x = "시간",
       y = "주문량") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(min(result$HH), max(result$HH), by = 2))