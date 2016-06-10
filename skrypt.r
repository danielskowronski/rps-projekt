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

#badanie adresów IP
ip<-table(unlist(file_full$ip))
plot(ip)
ip<-as.data.frame(ip)
ip<-ip[ip$Freq>6*IQR(ip$Freq),] # ~=> ip00006, ip00008
wysokie_ip<-subset(file_full, ip=="ip00006" | ip=="ip00008")
dates <- as.Date(as.POSIXct(wysokie_ip$authtime, origin="1970-01-01"))
datetimes <- as.POSIXct(wysokie_ip$authtime, origin="1970-01-01")
dates_weekdays <- format(datetimes, "%u")
barplot(prop.table(table(dates_weekdays)))