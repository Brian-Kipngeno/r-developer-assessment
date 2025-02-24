# Step 1: Load Libraries
library(ambiorix)
library(DBI)
library(RSQLite)

# Step 2: Connect to SQLite Database
db <- dbConnect(SQLite(), "flights.db")

# Step 3: Create Ambiorix App
app <- AmbiorixApp$new()

# Step 4: Define API Routes

## GET all flights
app$get("/flights", function(req, res) {
  query <- "SELECT * FROM flights"
  data <- dbGetQuery(db, query)
  res$json(data)
})

## GET a specific flight by flight number
app$get("/flight/:flight", function(req, res) {
  flight_num <- as.integer(req$params$flight)
  query <- sprintf("SELECT * FROM flights WHERE flight = %d", flight_num)
  data <- dbGetQuery(db, query)
  res$json(data)
})

## POST a new flight
app$post("/flight", function(req, res) {
  data <- req$json()
  
  query <- sprintf(
    "INSERT INTO flights (year, month, day, dep_time, sched_dep_time, dep_delay, arr_time,
        sched_arr_time, arr_delay, carrier, flight, tailnum, origin, dest, air_time, distance, hour, minute, time_hour)
        VALUES (%d, %d, %d, %d, %d, %f, %d, %d, %f, '%s', %d, '%s', '%s', '%s', %d, %d, %d, %d, '%s')",
    data$year, data$month, data$day, data$dep_time, data$sched_dep_time, data$dep_delay,
    data$arr_time, data$sched_arr_time, data$arr_delay, data$carrier, data$flight,
    data$tailnum, data$origin, data$dest, data$air_time, data$distance, data$hour, data$minute, data$time_hour
  )
  
  dbExecute(db, query)
  res$json(list(message = "Flight added successfully"))
})

## DELETE a flight by flight number
app$delete("/flight/:flight", function(req, res) {
  flight_num <- as.integer(req$params$flight)
  query <- sprintf("DELETE FROM flights WHERE flight = %d", flight_num)
  dbExecute(db, query)
  res$json(list(message = "Flight deleted successfully"))
})

# Step 5: Run the API
app$run(host = "0.0.0.0", port = 8080)

