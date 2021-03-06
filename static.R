library(tidyverse)
library(Rfast)
df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

#bar chart of top ten countries with the most co2 in a given year
yr <- "2013"

new_df <- df %>% 
  #select(cement_co2, coal_co2, flaring_co2, gas_co2, oil_co2, 
         #other_industry_co2) %>% 
  select(cement_co2, other_industry_co2) %>% 
  data.matrix() %>% 
  rowMaxs(value = F) %>%
  as.data.frame() %>% 
  mutate(year = df$year) 
colnames(new_df)<- c("row", "year")
df <- mutate(df, rows = new_df$row) %>% 
  mutate(industry = if_else(rows ==  1, "Cement", "other")) %>% 


chart_data <- df %>% 
  filter(year == yr) %>% 
  top_n(10, co2)

ggplot(chart_data, aes(x = country, y = co2)) +
  geom_col(aes(fill = industry)) +
  labs(x = "Country", title = paste0("CO2 emissions by country in ", yr), 
       y = "CO2 emissions (mil. tonnes)") + 
  scale_fill_discrete(name = "Industry most emissions")   

  