#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(caret)
library(plotly)
library(rattle)
library(hash)
library("gbm")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        # collecting all sensor data into a data frame
        # this data is used for prediction
        sensor1<-reactive({data.frame(cbind(total_accel_belt=input$total_belt,
                                            accel_belt_x=input$xb,
                                            accel_belt_y=input$yb,
                                            accel_belt_z=input$zb,
                                            total_accel_forearm=input$total_forearm,
                                            accel_forearm_x=input$xf,
                                            accel_forearm_y=input$yf,
                                            accel_forearm_z=input$zf,
                                            total_accel_arm=input$total_arm,
                                            accel_arm_x=input$xa,
                                            accel_arm_y=input$ya,
                                            accel_arm_z=input$za,
                                            total_accel_dumbbell=input$total_dumbell,
                                            accel_dumbbell_x=input$xd,
                                            accel_dumbbell_y=input$yd,
                                            accel_dumbbell_z=input$zd
        )
        ) })
        
        # this data is used for data visualization
        sensor2<-reactive({data.frame(cbind(total_accel_belt=input$total_belt,
                                            accel_belt_x=input$xb,
                                            accel_belt_y=input$yb,
                                            accel_belt_z=input$zb,
                                            total_accel_forearm=input$total_forearm,
                                            accel_forearm_x=input$xf,
                                            accel_forearm_y=input$yf,
                                            accel_forearm_z=input$zf,
                                            total_accel_arm=input$total_arm,
                                            accel_arm_x=input$xa,
                                            accel_arm_y=input$ya,
                                            accel_arm_z=input$za,
                                            total_accel_dumbbell=input$total_dumbell,
                                            accel_dumbbell_x=input$xd,
                                            accel_dumbbell_y=input$yd,
                                            accel_dumbbell_z=input$zd,
                                            classe="new-data-point"
        )
        ) })
    
        # hash to connect class label to activity name
        activity<-hash()
        activity["A"]<-"Dumbbell Biceps Curl Done properly"
        activity["B"]<-"Throwing elbows to front during Dumbbell Biceps Curl" 
        activity["C"]<-"Lifting dumbbell only halfway during Dumbbell Biceps Curl"
        activity["D"]<-"Lowering dumbbell only halfway during Dumbbell Biceps Curl"
        activity["E"]<-"Throwing hips in front during Dumbbell Biceps Curl"
        
        # loading training data
        trndata<-read.csv('data/pml-training.csv')
        set.seed(42)
        intrain<-createDataPartition(trndata$classe,p=0.7,list = FALSE)
        trdata<-trndata[intrain,]

        # data  corresponding to accelerometer sensor        
        xi<-names(trdata)[grep("*accel*",names(trdata))]
        yi<-xi[grep("^var*",xi)]
        xi<-xi[! xi %in% yi]

        xi<-c(xi,"classe")
        trdata<-trdata[,xi]

        for (i in keys(activity)){
            trdata[trdata$classe==i,]$classe<-activity[[i]]
        
        }

        new_data<-reactive({data.frame(rbind(trdata,sensor2()))})
        # file location for the pre trained model
        
        file="data/model2.rda"
        
        # loading the model
        model<-readRDS(file)

        # plotting training data along with the test data
        observeEvent(input$actionplot,output$plot<-renderPlotly({
                                    layout(plot_ly(x=~new_data()[,input$inputc[1]],
                                            y=~new_data()[,input$inputc[2]],
                                            z=~new_data()[,input$inputc[3]],
                                            color=~new_data()[,"classe"],
                                            type="scatter3d",
                                            mode="markers",
                                            colors = c("red","blue","cyan","black","magenta","green"),
                                            symbol=~new_data()[,"classe"],
                                            symbols=c("circle","circle","circle","square","circle","circle")),
                                           scene=list(xaxis = list(title=input$inputc[1]),
                                                      yaxis = list(title=input$inputc[2]),
                                                      zaxis=list(title=input$inputc[3])))}))
        
        # render the data of all the sensor inputted by the user
        observeEvent(input$actiontable,output$data<-renderTable({sensor1()}))
        
        # make prediction on the input data
        observeEvent(input$actionpred,output$result<-renderText(paste("Activity performed:",activity[[as.character(predict(model,sensor1()))]])))
        
     })


