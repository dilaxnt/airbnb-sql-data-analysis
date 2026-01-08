**# Airbnb SQL Analysis Project**



**## Project Overview**

This project analyses Airbnb listing data to uncover pricing patterns,

room-type distributions and neighbourhood-level affordability insights

using SQL.



**## Objectives**

\- Analyse how total Airbnb listings are split across room types, including each room type’s percentage share of the overall market.

\- Group listings into price bands to understand how pricing varies across different room types and identify affordability patterns.

\- Identify the minimum and maximum prices for each room type to highlight pricing spread and potential outliers. 

\- Help in identifying cost-effective locations for different accommodation styles.

\- Focused analysis on the lowest and highest prices within the ‘Entire home/apt’ category to assess market range and premium positioning.



**## Dataset**

\- Source: AB\_NYC\_Dataset

\- Size: 280 rows, 16 columns

\- Key fields: price, room\_type, neighbourhood\_group, number\_of\_reviews



**## Tools Used**

\- SQL (CTEs, window functions, aggregations)

\- MySQL 



**## Key Insights**

**1. Listing distribution by room type**

Entire home/apt listings account for the largest share of the dataset, while shared rooms represent a very small proportion. The significant imbalance suggests shared rooms may be an outlier category and warrants further investigation to understand demand and pricing behaviour.



**2. Price distribution by room type**

Private rooms dominate the lower price bands, whereas entire homes/apt listings are concentrated in higher price buckets. This aligns with the observed minimum and maximum prices, where private rooms consistently appear at the lower end of the price range.



**3. Cheapest neighbourhoods by room type**

Different neighbourhoods emerge as the cheapest option depending on room type:



**Private rooms:** Staten Island 



**Entire home/apt:** Brooklyn



This highlights how affordability varies not just by room type, but also by location.



**4. Price range disparity for entire homes/apt**

Entire home/apt listings show a wide price range (£65–£800). The unusually low minimum price (£65) is atypical for this room type and may indicate pricing anomalies, data quality issues, or exceptional listings. This category was analysed in more detail given its relevance to families and longer stays.



**## Repository Structure**

\- `sql/AB\_NYC\_Data\_Cleaning.sql`

\- `sql/AB\_NYC\_Exploratory\_Data\_Analysis.sql`



**## Next Steps**

\- Visualise findings in Power BI / Tableau



