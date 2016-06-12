# ustawianie nazwy pliku z danymi
filename_full <- "wyczyszczone_dane.csv"

# ładowanie pliku csv do listy
file_full <- read.csv(filename_full)

# tworzenie list dat i czasów logowań
dates <- as.Date(as.POSIXct(file_full$date, origin="1970-01-01"))
datetimes <- as.POSIXct(file_full$date, origin="1970-01-01")

# agregcj dat logowań po datach (uniklnych dniach), miesiącach i latach
hist(dates, breaks="days")
hist(dates[dates>"2008-09-30" & dates<"2016-02-01"], breaks="months")
hist(dates[dates>"2008-12-31" & dates<"2016-01-01"], breaks="years")

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
#test na rozkład gamma
egamma(differences_trimmed)
ks.test(differences_trimmed, "pgamma", shape = 0.5428031, scale = 75.4269334)
#sprawdzenie poprawności testu
tmp <- rgamma(length(differences_trimmed), shape = 0.5428031, scale = 75.4269334)
chisq.test(differences_trimmed, p = tmp/sum(tmp))

#obliczanie danych o rzadko oczekiwanych etypes
records_with_exotic_etypes <- file_full$date[file_full$etypes != "(1 etypes {1})"]
tmp <- table (strftime(as.POSIXct(records_with_exotic_etypes, origin="1970-01-01"), "%Y/%m/%d" ))
tmp_df <- as.data.frame(table (strftime(as.POSIXct(records_with_exotic_etypes, origin="1970-01-01"), "%Y/%m/%d" )))
exotic_dates <- data.frame(date=seq.Date(from = as.Date(as.POSIXct(1222194821, origin="1970-01-01")), to = as.Date(as.POSIXct(1454577728, origin="1970-01-01")), by=1), count=0 )
tmp2 <- data.frame(date=tmp_df$Var1, count=tmp_df$Freq)
tmp0 <- merge(x=exotic_dates, y=tmp2, by="date", all.x = TRUE, all.y = TRUE)
tmp0$count.y[is.na(tmp0$count.y)] <- 0
tmp0$count.x[is.na(tmp0$count.x)] <- 0
tmp0$freq <- tmp0$count.x + tmp0$count.y
final_exotic <- data.frame(date=tmp0$date, freq=tmp0$freq)

#ilość różnych adresów IP
df <- file_full
#po dniu tygodnia
df$authtime <- as.POSIXct(file_full$date, origin="1970-01-01")
df$day <- format(df$authtime, "%y-%m-%d")
df$weekday <- format(df$authtime, "%u")
agg <- aggregate(data=df, ip ~ day, function(x) length(unique(x)))
agg_bez <- aggregate(data=df, ip ~ day, function(x) length(unique(x)))
agg_bez$day <- as.POSIXct(agg_bez$day, format = "%y-%m-%d")
agg_bez$wday <- format(agg_bez$day, "%u")
agg_bez <- aggregate(agg_bez$ip,  by = list(agg_bez$wday), FUN = sum)

#normalizacja bo w dzień z dużą liczbą logowań będzie dużo więcej IP
agg <- aggregate(data=df, ip ~ day, function(x) length(x)/length(unique(x)))
q <- quantile(agg, names=ip)
agg <- subset(agg, ip>q[1]-1.5*IQR(agg$ip) & ip<q[3]+1.5*IQR(agg$ip))
#wyciągamy dzień tygodnia
agg$day <- as.POSIXct(agg$day, format = "%y-%m-%d")
agg$wday <- format(agg$day, "%u")
agg <- aggregate(agg$ip,  by = list(agg$wday), FUN = mean)

#czerwone po znormalizowaniu, zielone bez znormalizowania; odpalać 3 kolejne linie i dopiero wykres
barplot(agg$x, type="h", col=rgb(1,0,0,0.5), ylim=c(0,4))
par(new=TRUE)
barplot(agg_bez$x, type="h", col=rgb(0,1,0,0.5), ylim=c(0,55000))

agg_weekday<-agg

#po miesiącu
agg <- aggregate(data=df, ip ~ day, function(x) length(unique(x)))
q <- quantile(agg, names=ip)
agg <- subset(agg, ip>q[1]-1.5*IQR(agg$ip) & ip<q[3]+1.5*IQR(agg$ip))
agg$day <- as.POSIXct(agg$day, format = "%y-%m-%d")
agg$month <- format(agg$day, "%m")
agg <- aggregate(agg$ip,  by = list(agg$month), FUN = mean)
agg_bez<-agg
agg <- aggregate(data=df, ip ~ day, function(x) length(x)/length(unique(x)))
q <- quantile(agg, names=ip)
agg <- subset(agg, ip>q[1]-1.5*IQR(agg$ip) & ip<q[3]+1.5*IQR(agg$ip))
agg$day <- as.POSIXct(agg$day, format = "%y-%m-%d")
agg$month <- format(agg$day, "%m")
agg <- aggregate(agg$ip,  by = list(agg$month), FUN = mean)
barplot(agg$x, type="h", col=rgb(0,1,0,0.5), ylim=c(0,4.005210))
par(new=TRUE)
barplot(agg_bez$x, type="h", col=rgb(1,0,0,0.5), ylim=c(0,150.80976))


#z ilu IP każdy user
agg <- aggregate(data=df, ip ~ user, function(x) length(unique(x)))
barplot(agg$ip)
var(agg$ip)
mean(agg$ip)
sd(agg$ip)

#odcinamy
q <- quantile(agg$ip)
agg_norm <- subset(agg, ip>=3 & ip<q[3]+1.5*IQR(agg$ip))

plot(density(agg$ip), col="red")
par(new=TRUE)
plot(density(agg_norm$ip), col="green")

shapiro.test(agg_norm$ip)
qqnorm(agg_norm$ip);qqline(agg_norm$ip)

#normalizacja
aggn <- agg
aggn$ip <- (agg$ip-mean(agg$ip))/sd(agg$ip)
X <- aggn$ip
Y <- density(X)
library(zoo)
xt <- diff(Y$x)
yt <- rollmean(Y$y,2)
pole <- sum(xt*yt)
100*(pole-1)/pole


#odrzucanie - liczenie
aggs <- sort(agg$ip)
cnt <- length(aggs)
#...
x<-1000; qqnorm(aggs[0:-x]);qqline(aggs[0:-x])
#...
x/cnt
