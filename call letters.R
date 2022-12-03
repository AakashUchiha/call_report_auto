library('RSelenium')
library(tidyverse)
library(tidyr)
library(netstat)   #used for port
library(mailR)
library("gmailr")
require(mailR)



##################    USER INPUTS     ##############################

Year<- 2022
Qtr<-3 #(quarter of the desired report)

#####################################################



#functions used
`%notin%`<- negate(`%in%`)

#kill java process
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

#starting the serveer
rs_driver_object<-rsDriver(
  browser="chrome",
  chromever = '107.0.5304.62',
  port= 4444L
)

remDr<-rs_driver_object$client

remDr$open()

#call report data

remDr$navigate("https://ncua.gov/analysis/credit-union-corporate-call-report-data/quarterly-data")


repeat {
  
  remDr$refresh()
  Sys.sleep(10)
  login_xpath<-paste("/html/body/div/div[1]/main/div/div/div[3]/article/div/div[1]/table/tbody/tr[1]/td[",Qtr+1,"]/a",sep="")
  t<-try(login_link <- remDr$findElement(using = "xpath", value = login_xpath))
  
  if ("try-error" %notin% class(t)){
    break
  }
}



#login_link$clickElement()

remDr$close()
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)


#sending mail

send.mail(from = "username@gmail.com",
          to = "username@gmail.com",
          subject = "Quarterly call report file available",
          body = "Body of the email",
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "username@gmail.com", passwd = "mmlclujyhdfvqqbr", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
  
