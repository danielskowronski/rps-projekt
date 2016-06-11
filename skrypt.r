# ustawianie nazwy pliku z danymi 
filename_full <- "C:\\Users\\Krzysiek\\Documents\\rps_projekt\\rps-projekt\\wyczyszczone_dane.csv"

# ładowanie pliku csv do listy
file_full <- read.csv(filename_full)

# tworzenie list dat i czasów logowań
dates <- as.Date(as.POSIXct(file_full$date, origin="1970-01-01"))
datetimes <- as.POSIXct(file_full$date, origin="1970-01-01")

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

#czasy miedzy logowaniami do systemu
shift <- function (x, shift) c(rep(NA,times=shift), x[1:(length(x)-shift)])
differences <- file_full$date - shift(file_full$date, 1)
differences <- differences[!is.na(differences)]
differences <- differences[differences>=0]
differences_Q2 <- quantile(differences, 0.5)
differences_Q1<- quantile(differences, 0.25)
differences_Q3 <- quantile(differences, 0.75)
differences_IQR <- IQR(differences)
differences_lbound <- differences_Q1-(differences_IQR*1.5)
differences_ubound <- differences_Q3+(differences_IQR*1.5)
differences_trimmed <- differences[(differences>differences_lbound) & (differences<differences_ubound)]
plot (hist(differences_trimmed))
require(MASS)
fit <- fitdistr(differences_trimmed, "exponential")
ks.test(differences_trimmed, "pexp", fit$estimate)
#kontrola poprawności wykonywania testu
control <- abs(rnorm(10000))
fit2 <- fitdistr(control, "exponential")
ks.test(control, "pexp", fit2$estimate)
#proba testu chi kwadrat
tmp <-rexp(length(differences_trimmed), rate = differences_trimmed_rate)
chisq.test(differences_trimmed, p = tmp/sum(tmp))