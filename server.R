library(shiny)


shinyServer(
        function(input, output) {

                output$help <- renderUI({HTML(paste("<h3>Birthday problem</h3>", 
                                                    "This application was made to explain the Birthday Problem, by showing the theoretical probability and the probability using simulations.",
                                                    "", 
                                                    "The birthday problem is to find the probability that, in a group of N people, there is at least one pair of people who have the same birthday.",
                                                    "This problem is extended in this application by also having the posibility to calculate the probability for 3, 4 and 5 people having their birthday on the same day.",
                                                    "", 
                                                    "<h3>Inputs:</h3>", 
                                                    "<b>Probability</b>: Select the probability you wish to calculate the group size for.", 
                                                    "<b>Number of same birthdays</b>: Select the number of people that should have their birthday on the same day.", 
                                                    "<b>Number of simulations</b>: Number of simulations required to calculate the probability for the number of same birthdays. More simulation will make for a better result. Note that more simulations will require more time to compute!", 
                                                    "", 
                                                    "Move the sliders around to see how the selected values affect the groupsize required to meet the selected parameters.", 
                                                    "", 
                                                    "<h3>Plots:</h3>", 
                                                    "<b>Theoretical</b>: This plot shows the theoretical probability for the selected probability for the number of same birthdays.", 
                                                    "<b>Simulation</b>: This plot shows the  probability for the selected probability for the number of same birthdays having done the selected number of simulations.", 
                                                    "", 
                                                    "Both plots show the cutoff values for the selected probability (horizontal) and the calculated group size (vertical) required for X people to have their birthday on the same day.", 
                                                    "", sep="<br>"))})

                output$Tbday <- renderPlot({
                        
                        numberofdays <- 365
                        prob <- input$prob
                        coincident <- input$coincident
                        
                        nPeople <- qbirthday(prob, numberofdays, coincident)
                        
                        theta.val = nPeople*1.5
                        dayofyear = seq(from=1, to=numberofdays, by=1)
                        sim.mat = matrix(NA, nrow=theta.val, ncol=coincident)
                        
                        getProb = function(n){
                                p = pbirthday(n, numberofdays, coincident)
                        }
                        
                        theta.list = seq(from=2, to=theta.val, by=1)
                        p.graph = sapply(theta.list, getProb)
                        cutoff = which(p.graph > prob)[1]
                        plot(p.graph, main=paste("Probability", coincident, "People Have the Same Birthday - Theoretical"), ylab='Probability', xlab="Number of People in Group")
                        lines(p.graph)
                        abline(h=prob, v=cutoff)
                        text(cutoff+((theta.val-nPeople)/15), 0, cutoff)
                        text(1, prob+0.05, prob)
                        
                        
                })
                output$Sbday <- renderPlot({

                        numberofdays <- 365
                        prob <- input$prob
                        coincident <- input$coincident
                        n.rep = input$sims
                        
                        nPeople <- qbirthday(prob, numberofdays, coincident)
                        
                        theta.val = nPeople*1.5
                        dayofyear = seq(from=1, to=numberofdays, by=1)

                        sim.mat <- rep(NA, theta.val)
                        
                        for(i in 2:theta.val){
                                bday = replicate(n.rep, sample(dayofyear, size=i, replace=T) )
                                bday[1,]
                                bday.table = apply(bday, 2, table)
                                
                                sim = ifelse( unlist( lapply(bday.table, max) ) >= coincident, 1, 0)
                                
                                sim.mat[i] = sum(sim)/length(sim)
                        }
                        
                        cutoff = which(sim.mat > prob)[1]
                        
                        plot(sim.mat, main=paste("Probability", coincident, "People Have the Same Birthday - Simulation"), ylab='Probability', xlab="Number of People in Group")
                        lines(sim.mat)
                        abline(h=prob, v=cutoff)
                        text(cutoff+((theta.val-nPeople)/15), 0, cutoff)
                        text(1, prob+0.05, prob)
                        
                        })
        }
)