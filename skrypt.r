# ustawianie nazwy pliku z danymi 
filename_full <- "C:\\Users\\Krzysiek\\Documents\\rps_projekt\\rps-projekt\\wyczyszczone_dane.csv"

# ładowanie pliku csv do listy
file_full <- read.csv(filename_full)

# tworzenie list dat i czasów logowań
dates <- as.Date(as.POSIXct(file_full$authtime, origin="1970-01-01"))
datetimes <- as.POSIXct(file_full$authtime, origin="1970-01-01")

# agregcj dat logowań po datach (uniklnych dniach), miesiącach i latach
plot(hist(dates, breaks="days"))
plot(hist(dates, breaks="months"))
plot(hist(dates, breaks="years"))

# agregacja czasów logowań po godzinie 
dates_hours <- format(datetimes, "%H")
barplot(prop.table(table(dates_hours)))

# agregacja czasów logowań po dniu tygodnia
dates_weekdays <- format(datetimes, "%u")
barplot(prop.table(table(dates_weekdays)))

#agregacja oczekiwanych encoding types
barplot(table(file_full$etypes))