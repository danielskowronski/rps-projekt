filename <- "C:\\Users\\Krzysiek\\Documents\\rps_projekt\\first100"
file <- read.csv(filename)
file
file
file <- read.csv(filename)
file
filename_full <- "C:\\Users\\Krzysiek\\Documents\\rps_projekt\\rps-projekt\\wyczyszczone_dane.csv"
file_full <- read.csv(filename_full)
head file_full, n=100
head (file_full, n=100)
savehistory("~/rps_projekt/history1.r")
dates <- as.Date(file_full$authtime)
dates = c()
dates <- as.Date(file_full$authtime)
file_full <- as.Date(file_full$authtime)
file_full$authtime <- as.Date(file_full$authtime)
dates <- as.Date(1, file_full$authtime)
dates <- as.Date(file_full$authtime, origin="1970-01-01")
head (dates, 100)
dates <- as.Date(as.POSIXct(file_full$authtime, origin="1970-01-01"))
head (dates, 100)
plot(hist(dates))
plot(hist(dates, breaks="days"))
plot(hist(dates, breaks="months"))
savehistory("~/rps_projekt/history1.r")
plot(hist(dates, breaks="years"))
plot(hist(dates, breaks="year"))
plot(hist(dates, breaks="hours"))
plot(hist(dates, breaks="hour"))
dates_hours <- strftime(dates, "%h")
head (dates_hours)
dates_hours <- strftime(dates, "%H")
head (dates_hours)
head (dates_hours, 100)
dates_hours <- strftime(dates, "%hh")
dates_hours <- strftime(dates, "%H")
plot(hist(dates_hours))
plot(hist(1, dates_hours))
dates_hours <- strftime(dates, "%B")
head (dates_hours, 100)
dates_hours <- strftime(dates, "%H")
plot(hist(dates_hours))
barplot(prop.table(table(dates_hours)))
dates_hours <- format(dates, "%H")\
dates_hours <- format(dates, "%H")
barplot(prop.table(table(dates_hours)))
plot(hist(dates_hours))
head (dates_hours, 100)
head (dates_hours, 1000)
head (dates, 100)
datetimes <- as.DateTime(as.POSIXct(file_full$authtime, origin="1970-01-01"))
datetimes <- as.POSIXct(file_full$authtime, origin="1970-01-01")
head (datetimes, 100)
dates_hours <- format(datetimes, "%H")
plot(hist(dates_hours))
barplot(prop.table(table(dates_hours)))
savehistory("~/rps_projekt/history1.r")
