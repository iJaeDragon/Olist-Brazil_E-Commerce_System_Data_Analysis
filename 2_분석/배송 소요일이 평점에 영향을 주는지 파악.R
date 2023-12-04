# 필요한 패키지 불러오기
library(ggplot2)

library(rJava)
library(RJDBC)

# Oracle JDBC 연결 설정
jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath = "C://ojdbc6.jar")
conn <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@192.168.114.128:1515:XE", "dev", "tester")

# SQL 쿼리 실행하여 데이터 불러오기
sql <- "SELECT TO_DATE(TO_CHAR(TO_DATE(ORDER_DELIVERED_CUSTOMER_DATE, 'YYYY-MM-DD HH24:MI:SS'), 'YYYYMMDD')) - TO_DATE(TO_CHAR(TO_DATE(ORDER_ESTIMATED_DELIVERY_DATE, 'YYYY-MM-DD HH24:MI:SS'), 'YYYYMMDD')) as OVERTIME,
       OORD.REVIEW_SCORE
FROM OLIST_ORDERS_DATASET OOD, OLIST_ORDER_REVIEWS_DATASET OORD
WHERE 1=1
AND ORDER_ESTIMATED_DELIVERY_DATE < ORDER_DELIVERED_CUSTOMER_DATE
AND OOD.ORDER_ID = OORD.ORDER_ID
GROUP BY ORDER_DELIVERED_CUSTOMER_DATE, ORDER_ESTIMATED_DELIVERY_DATE, OORD.REVIEW_SCORE"

result <- dbGetQuery(conn, sql)

# 데이터 프레임 생성
data <- data.frame(Ratings = result$REVIEW_SCORE, DeliveryDelay = result$OVERTIME)

# 산점도 그래프 생성 및 추세선 추가
ggplot(data, aes(x = DeliveryDelay, y = Ratings)) +
  geom_point() +                   # 산점도 추가
  geom_smooth(method = "lm",       # 선형 회귀 모델을 사용한 추세선
              se = FALSE,          # 신뢰 구간 표시 생략
              color = "blue") +    # 선 색상 설정
  labs(title = "배송지연 일과 평점의 산점도 그래프", 
       x = "배송지연 일", y = "평점") +  # 라벨 추가
  theme_minimal()                  # 그래프 테마 설정