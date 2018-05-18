
####################### test start ########################

setwd('E:/Data')
tested_df <- read.delim('test_clickstreams.tab', stringsAsFactors = F)


tested_df$month <- substr(tested_df$TIME_ID, start = 5, stop = 6)

str(tested_df)

tested_df$bweeks <- substr(tested_df$TIME_ID, start = 1, stop=8 )
tested_df$weeks <- weekdays(as.POSIXlt(as.character(tested_df$TIME_ID), format='%Y%m%d'))
tested_df$bweeks <- NULL
tested_df$btimes <- substr(as.character(tested_df$TIME_ID), start = 9, stop=10)
tested_df$btimes <- as.integer(tested_df$btimes)
tested_df$times <- ifelse(tested_df$btimes<6, 'x00-05',
                          ifelse(tested_df$btimes<12,'x06-11',
                                 ifelse(tested_df$btimes<18,'x12-17','x18-23')))
tested_df$btimes <- NULL

str(tested_df)

cv_val <- function(x){
  result <- sd(x)/mean(x)
}

library(reshape2)

#total_view
agg_TR <- aggregate(data=tested_df, SITE_CNT~CUS_ID, sum)
#month
mlevels <- levels(as.factor(tested_df$month))
month_df <- aggregate(data=tested_df, SITE_CNT~CUS_ID+month, sum)
month_df_re <- dcast(month_df, CUS_ID~month, value.var = 'SITE_CNT')
month_df_re[is.na(month_df_re)] <- 0
agg_TR <- merge(agg_TR,month_df_re, by='CUS_ID')
agg_TR[mlevels] <- agg_TR[mlevels]/agg_TR$SITE_CNT

#month_cv
agg_TR$month_cv <- apply(agg_TR[mlevels],1,cv_val)

#weeks
wlevels <- c('friday','thursday','wednsday','monday','sunday','saturday','thuesday')
weeks_df <- aggregate(data=tested_df, SITE_CNT~CUS_ID+weeks, sum)
weeks_df_re <- dcast(weeks_df, CUS_ID~weeks, value.var = 'SITE_CNT')
colnames(weeks_df_re) <- c('CUS_ID','friday','thursday','wednsday','monday','sunday','saturday','thuesday')
agg_TR <- merge(agg_TR,weeks_df_re, by='CUS_ID')
agg_TR[is.na(agg_TR)] <- 0
agg_TR[wlevels] <- agg_TR[wlevels]/agg_TR$SITE_CNT


#week_cv
agg_TR$week_cv <- apply(agg_TR[wlevels],1,cv_val)

#category
clevels <- levels(as.factor(tested_df$BACT_NM))
BACT_NM_df <- aggregate(data=tested_df, SITE_CNT~CUS_ID+BACT_NM, sum)
BACT_NM_df_re <- dcast(BACT_NM_df, CUS_ID~BACT_NM, value.var = 'SITE_CNT')
agg_TR <- merge(agg_TR,BACT_NM_df_re, by='CUS_ID')
agg_TR[is.na(agg_TR)] <- 0
agg_TR[clevels] <- agg_TR[clevels]/agg_TR$SITE_CNT
str(agg_TR)

#cv_category
agg_TR$category_cv <- apply(agg_TR[clevels],1,cv_val)

#times
tlevels <- levels(as.factor(tested_df$times))
times_df <- aggregate(data=tested_df, SITE_CNT~CUS_ID+times, sum)
times_df_re <- dcast(times_df, CUS_ID~times, value.var = 'SITE_CNT')
times_df_re[is.na(times_df_re)] <- 0
agg_TR <- merge(agg_TR,times_df_re, by='CUS_ID')
agg_TR[tlevels] <- agg_TR[tlevels]/agg_TR$SITE_CNT

#cv_times
agg_TR$times_cv <- apply(agg_TR[tlevels],1,cv_val)

agg_TR_tested <- agg_TR
save(agg_TR_tested, file='testeded.Rdata')

str(agg_TR_trained)
data_pre <- agg_TR_trained[-1] 
str(data_pre)

######################### test end ##########################
