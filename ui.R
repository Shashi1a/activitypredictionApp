#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
shinyUI(fluidPage(

    # Application title
    titlePanel("Predicting activity based on sensor data"),

    tags$h3("Introduction"),
    tags$p("The Human Activity Recognition dataset has records of various activities performed
            by six different users. The dataset consists of observations of various sensors during different
            exercises. The dataset can be used to train a supervised machine learning algorithm where the 
            sensor data is treated as feature and the activity is treated as label. A successful training can 
            allow the trained model to predict activity based on sensor data. In hindsight, this may look
            like just a glorified academic problem but if one thinks carefully this can have far reaching uses.
            An implementation of this problem can help users to get instant feedback on their exercises and help
            them keep track of their workout. Users can also look at their progress and plan their exercise routine
           accordingly ( A feature used by almost all smart watches these days). More information about the dataset can be found in the links shown below."),
    
   
    hr(),
    tags$ol(
    tags$li(tags$a(href="http://web.archive.org/web/20161125212224/http://groupware.les.inf.puc-rio.br/work.jsf?p1=10335", "Ugulino, W.; Cardador, D.; Vega, K.; Velloso, E.; Milidiu, R.; Fuks, H. 
    Wearable Computing: Accelerometers' Data Classification of Body Postures and Movements")),

    hr(),
    tags$li(tags$a(href="http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har", "More information about dataset"))),
    
    hr(),
    tags$h3("Instructions"),
    tags$p("The app uses a pretrained model( a Gradient Boosted Model with tuned hyperparameter) for making predictions. The model
            only uses observations obtained from the accelerometer sensor attached in belt, forearm, arm and dumbbell. To make a 
            prediction these sensor readings can be supplied to the algorithm using input widgets (sliderInput and numericInput)."), 
            
    tags$h5("Once the input data is created using sliderInput and numericInput fields. The app allows for only three operations in this version."),
    tags$ol(
    tags$li("Visualize the datapoint along with points in the original dataset (these points were not used during training procedure). To do so select
            the axes you want to use for visualization(from the input box). Click on Data visualization tab and click on plot the data button. The new data point
            is shown with a black square along with circles of different color. Each color corresponds to a different activity."),
    tags$li("To check the input data, switch to Input data and results panel and click on Show the input data button. This will show the input data
            as a dataframe, with the column name corresponding to the sensor and their respective input values."),
    tags$li("To predict the activity corresponding to that particular set of input values click on Make prediction button. The result will
            be displayed as Activity performed"),),
    hr(),
    fluidRow(style = "margin: 6px;",
        
        column(3,
            sliderInput("total_belt","Accelerometer reading from belt sensor (total_accel_belt):", min = 0,max =29,value = 0.1),
            sliderInput("total_forearm","Accelerometer reading from forearm sensor (total_accel_forearm):",min =0 ,max = 108,value = 0.1),
            sliderInput("total_arm","Accelerometer reading from arm sensor (total_accel_arm):",min = 0.1,max = 66,value = 0.1),
            sliderInput("total_dumbell","Accelerometer reading from dumbell sensor (total_accel_dumbbell):",min = 0,max = 58,value = 0.1)
            ),
        column(3,
            
            numericInput("xb","Accelerometer reading (x-axis) from the belt sensor (accel_belt_x)",value=0,min=-120,max = 83,step=1),
            numericInput("xf","Accelerometer reading (x-axis) from the forearm sensor (accel_forearm_x)",value=0,min=-498,max = 477,step=1),
            numericInput("xa","Accelerometer reading (x-axis) from the arm sensor (accel_arm_x)",value=0,min=-404,max = 437,step=1),
            numericInput("xd","Accelerometer reading (x-axis) from the dumbell sensor (accel_dumbbell_x)",value=0,min=-419,max = 219,step=1),
        ),
        column(3,
               
            numericInput("yb","Accelerometer reading (y-axis) from the belt sensor (accel_belt_y)",value=0,min=-69,max = 164,step=1),
            numericInput("yf","Accelerometer reading (y-axis) from the forearm sensor (accel_forearm_y)",value=0,min=-595,max = 923,step=1),
            numericInput("ya","Accelerometer reading (y-axis) from the arm sensor (accel_arm_y)",value=0,min=-318,max = 308,step=1),
            numericInput("yd","Accelerometer reading (y-axis) from the dumbell sensor (accel_dumbbell_y)",value=0,min=-182,max = 302,step=1),
        ),
        column(3,
               
            numericInput("zb","Accelerometer reading (z-axis) from the belt sensor (accel_belt_z)",value=0,min=-275,max = 105,step=1),
            numericInput("zf","Accelerometer reading (z-axis) from the forearm sensor (accel_forearm_z)",value=0,min=-446,max = 291,step=1),
            numericInput("za","Accelerometer reading (z-axis) from the arm sensor (accel_arm_z)",value=0,min=-636,max = 292,step=1),
            numericInput("zd","Accelerometer reading (z-axis) from the dumbell sensor (accel_dumbbell_z)",value=0,min=-334,max = 318,step=1),
        ),
        
        
        selectInput(inputId = "inputc","Please select axes for plotting(only 3)",
                    choices = c("total_accel_belt","accel_belt_x","accel_belt_y","accel_belt_z",
                            "total_accel_forearm","accel_forearm_x","accel_forearm_y","accel_forearm_z",
                            "total_accel_arm","accel_arm_x","accel_arm_y","accel_arm_z",
                            "total_accel_dumbbell","accel_dumbbell_x","accel_dumbbell_y","accel_dumbbell_z"),
                    multiple=TRUE,selectize = 3),

        actionButton(inputId="actionplot",label="Plot the data",icon=NULL,width = NULL),
        actionButton(inputId="actiontable",label="Show the input data",icon=NULL,width = NULL),
        actionButton(inputId="actionpred",label="Make prediction",icon=NULL,width = NULL)
        
        
        ),
    
        mainPanel(
            
            tabsetPanel(
            tabPanel("Data visualization",plotlyOutput("plot",width="150%",height="300%")),
            
            tabPanel("Input data and results",tableOutput("data"),textOutput("result")))
            )
    )
)
