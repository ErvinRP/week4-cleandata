run_Analysis<-function() {
    library(dplyr)
    # read datasets   
    x_test<-read.table("X_test.txt")
    x_train<-read.table("X_train.txt")
    activ<-read.table("activity_labels.txt")
    sub_trn<-read.table("subject_train.txt")
    sub_tst<-read.table("subject_test.txt")
    y_train<-read.table("y_train.txt")
    y_test<-read.table("y_test.txt")
    feature<-read.table("features.txt")
    
# concatenate test and train data    
    x_tot<-rbind(x_test,x_train)
    y_tot<-rbind(y_test,y_train)
    y_tot<-rename(y_tot,Activity=V1)
    subj_tot<-rbind(sub_tst,sub_trn)
    subj_tot<-rename(subj_tot,Subject=V1)
# merge tables together
    z_tot<-cbind(x_tot,y_tot,subj_tot)
    
#   z_tot<-rename(z_tot,Subject=V1)
#    describe(table_tot,n=FALSE)
    
#    st_sum<-describe(table_tot)
#    st_sum1<-select(st_sum,mean,sd)
#   merge test and train subject data    
# rename V1 in subject file to Subject    
#  merge activity labels 
    table_final_0<-merge(z_tot,activ,by.x='Activity',by.y='V1')
    table_final_1<-rename(table_final_0,Activity=V2.y, Actnum=Activity)
    
    data_names<-"subjectNumber"
    data_names<-append(data_names, feature$V2)
#    View(data_names)
    data_names<-append(data_names,"Subject")
    data_names<-append(data_names,"Activity")
    colnames(table_final_1)<-cbind(data_names)
#    View(table_final)
    
    wanted_columns<-select(table_final_1, matches("Subject|activity|mean|std"))
  #  View(wanted_columns)
    table_ans<-wanted_columns %>% group_by(Activity,Subject) %>% summarize(across(everything(),mean))
    table_ans<-select(table_ans,-"subjectNumber")
    View(table_ans)                                                               
#    table_ans<-rename(table_ans,Activity=Activity,"Average by Activity and Subject"=mean1)
 #   table_ans<-select(table_ans,Activity,Subject,'Average by Activity and Subject')
    write.table(table_ans,"ans4.txt",row.names=FALSE)
}