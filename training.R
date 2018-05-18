setwd('D:/projects/클릭스트림/Click_stream_Competition')

setwd('E:/Data')
trn_click <- read.delim('train_clickstreams.tab', stringsAsFactors = F)

####################### PreProcessing ###############################

####################### training start ##############################

trn_click$month <- substr(trn_click$TIME_ID, start = 5, stop = 6)

str(trn_click)

trn_click$bweeks <- substr(trn_click$TIME_ID, start = 1, stop=8 )
trn_click$weeks <- weekdays(as.POSIXlt(as.character(trn_click$TIME_ID), format='%Y%m%d'))
trn_click$bweeks <- NULL
trn_click$btimes <- substr(as.character(trn_click$TIME_ID), start = 9, stop=10)
trn_click$btimes <- as.integer(trn_click$btimes)
trn_click$times <- ifelse(trn_click$btimes<6, 'x00-05',
                          ifelse(trn_click$btimes<12,'x06-11',
                                 ifelse(trn_click$btimes<18,'x12-17','x18-23')))
trn_click$btimes <- NULL

str(trn_click)

cv_val <- function(x){
  result <- sd(x)/mean(x)
}

library(reshape2)

#total_view
agg_TR <- aggregate(data=trn_click, SITE_CNT~CUS_ID, sum)
#month
mlevels <- levels(as.factor(trn_click$month))
month_df <- aggregate(data=trn_click, SITE_CNT~CUS_ID+month, sum)
month_df_re <- dcast(month_df, CUS_ID~month, value.var = 'SITE_CNT')
month_df_re[is.na(month_df_re)] <- 0
agg_TR <- merge(agg_TR,month_df_re, by='CUS_ID')
agg_TR[mlevels] <- agg_TR[mlevels]/agg_TR$SITE_CNT

#month_cv
agg_TR$month_cv <- apply(agg_TR[mlevels],1,cv_val)

#weeks
wlevels <- c('friday','thursday','wednsday','monday','sunday','saturday','thuesday')
weeks_df <- aggregate(data=trn_click, SITE_CNT~CUS_ID+weeks, sum)
weeks_df_re <- dcast(weeks_df, CUS_ID~weeks, value.var = 'SITE_CNT')
colnames(weeks_df_re) <- c('CUS_ID','friday','thursday','wednsday','monday','sunday','saturday','thuesday')
agg_TR <- merge(agg_TR,weeks_df_re, by='CUS_ID')
agg_TR[is.na(agg_TR)] <- 0
agg_TR[wlevels] <- agg_TR[wlevels]/agg_TR$SITE_CNT


#week_cv
agg_TR$week_cv <- apply(agg_TR[wlevels],1,cv_val)

#category
clevels <- levels(as.factor(trn_click$BACT_NM))
BACT_NM_df <- aggregate(data=trn_click, SITE_CNT~CUS_ID+BACT_NM, sum)
BACT_NM_df_re <- dcast(BACT_NM_df, CUS_ID~BACT_NM, value.var = 'SITE_CNT')
agg_TR <- merge(agg_TR,BACT_NM_df_re, by='CUS_ID')
agg_TR[is.na(agg_TR)] <- 0
agg_TR[clevels] <- agg_TR[clevels]/agg_TR$SITE_CNT
str(agg_TR)

#cv_category
agg_TR$category_cv <- apply(agg_TR[clevels],1,cv_val)

#times
tlevels <- levels(as.factor(trn_click$times))
times_df <- aggregate(data=trn_click, SITE_CNT~CUS_ID+times, sum)
times_df_re <- dcast(times_df, CUS_ID~times, value.var = 'SITE_CNT')
times_df_re[is.na(times_df_re)] <- 0
agg_TR <- merge(agg_TR,times_df_re, by='CUS_ID')
agg_TR[tlevels] <- agg_TR[tlevels]/agg_TR$SITE_CNT

#cv_times
agg_TR$times_cv <- apply(agg_TR[tlevels],1,cv_val)

train_pro <- read.csv('train_profiles.csv')

agg_TR_trained <- merge(agg_TR_trained, train_pro,by='CUS_ID')
save(agg_TR_trained, file='trained.Rdata')

####################### train end #########################
