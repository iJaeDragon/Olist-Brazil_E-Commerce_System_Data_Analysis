# 패키지 불러오기
library(sf)
library(ggplot2)
library(rnaturalearth)
library(dplyr)

library(rJava)
library(RJDBC)

# Oracle JDBC 연결 설정
jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath = "C://ojdbc6.jar")
conn <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@192.168.114.128:1515:XE", "dev", "tester")

# SQL 쿼리 실행하여 데이터 불러오기
sql <- "SELECT CUSTOMER_STATE, COUNT(*) AS CNT
        FROM olist_customers
        GROUP BY CUSTOMER_STATE"

customer_data <- dbGetQuery(conn, sql)

print(c(customer_data$CUSTOMER_STATE))

# 영어에서 포르투갈어로 변환을 위한 데이터프레임 생성
translation_data <- data.frame(
  english_name = c("RJ", "MG", "RN", "SP", "RS", "PR", "AL", "ES", "PE", "MA", "AM", "PB", "AC", "RR", "SE", "DF", "BA", "RO", "GO", "SC", "MT", "CE", "AP", "MS", "PI", "TO", "PA" ),
  portuguese_name = c("Rio de Janeiro", "Minas Gerais", "Rio Grande do Norte", "São Paulo", "Rio Grande do Sul", "Paraná", "Alagoas", "Espírito Santo", "Pernambuco", "Maranhão", "Amazonas", "Paraíba", "Acre", "Roraima", "Sergipe", "Distrito Federal", "Bahia", "Rondônia", "Goiás", "Santa Catarina", "Mato Grosso", "Ceará", "Amapá", "Mato Grosso do Sul", "Piauí", "Tocantins", "Pará")
)

# 영어에서 포르투갈어로 변환
customer_data <- left_join(customer_data, translation_data, by = c("CUSTOMER_STATE" = "english_name"))
customer_data$CUSTOMER_STATE <- ifelse(!is.na(customer_data$portuguese_name), customer_data$portuguese_name, customer_data$CUSTOMER_STATE)

# 브라질 주(State) 경계 데이터 불러오기
brazil_states <- ne_states(country = "Brazil", returnclass = "sf")

# 불러온 데이터와 브라질 주(State) 데이터 합치기
map_data <- left_join(brazil_states, customer_data, by = c("name" = "CUSTOMER_STATE"))

# 브라질 지도 시각화 (주문량에 따라 색칠)
ggplot() +
  geom_sf(data = map_data, aes(fill = CNT), color = "white", size = 0.2) +
  scale_fill_viridis_c(name = "Order Count") +
  theme_minimal() +
  labs(title = "유치율이 높은 행정지역")