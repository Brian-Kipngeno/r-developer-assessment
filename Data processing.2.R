library(data.table)
library(nycflights13)
library(DBI)
library(RSQLite)
library(ambiorix)

library(data.table)
library(nycflights13)

# Convert flights data to data.table
flights_dt <- as.data.table(flights)

# View structure of the dataset
str(flights_dt)

avg_dep_delay <- flights_dt[, .(avg_delay = mean(dep_delay, na.rm = TRUE)), by = carrier]
print(avg_dep_delay)

flights_dt[, flight_id := .I]  # Assign a unique ID based on row index
flights_dt[, delayed_15 := dep_delay > 15]  # TRUE if delayed over 15 mins, FALSE otherwise

library(DBI)
library(RSQLite)

# Connect to SQLite and save the processed table
db <- dbConnect(RSQLite::SQLite(), "flights_data.sqlite")
dbWriteTable(db, "flights", flights_dt, overwrite = TRUE)
dbDisconnect(db)

library(nycflights13)
library(data.table)

# Load dataset
flights_dt <- as.data.table(flights)

# Check if it exists
print(flights_dt)

avg_dep_delay <- flights_dt[, .(avg_delay = mean(dep_delay, na.rm = TRUE)), by = carrier]
print(avg_dep_delay)

top_destinations <- flights_dt[, .N, by = dest][order(-N)][1:5]
print(top_destinations)

flights_dt[, flight_id := .I]  # Assign a unique ID based on row index
flights_dt[, delayed_15 := dep_delay > 15]  # TRUE if delayed over 15 mins, FALSE otherwise

library(DBI)
library(RSQLite)

# Connect to SQLite and save the processed table
db <- dbConnect(RSQLite::SQLite(), "flights_data.sqlite")
dbWriteTable(db, "flights", flights_dt, overwrite = TRUE)
dbDisconnect(db)


