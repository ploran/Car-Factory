## Foreword
First of all, thanks for taking the time to take this tech challenge. We really appreciate it. And now, are you ready to rumble? :)

## Robot World

It's the year 2020, the developers are part of the past. You are probably the last dev on the earth and you are pretty busy, so you decide the best is the robots can handle all the work instead of you.

## Robot builder and initial data structure.
This robot will be the one in charge to generate the data that will feed the whole process.

 + Model a Car factory and the cars. The factory will have 3 assembly lines: “Basic structure”, “Electronic devices” and “Painting and final details”. When the car passes throughout the 3 lines we can consider it as complete.
 + The cars have simple parts: 4 wheels, 1 chassis, 1 laser, 1 computer, 1 engine, price, cost price and 2 seats. We should know the car year and the model name. The car computer should know if the car has any defect and where it is (which part). We should know the car model stock.
 + We have a warehouse when the cars are parked after completion. We should know how many cars by the model we have in the warehouse. We call this factory stock.
 + The cars should answer if it's a complete car or not and its current assembly stage.
 + Create a robot builder, once you create the data structure, you have to create a process (our robot builder) which will generate random cars each minute, it will be the one assigning the model names, the year, the parts, the assembly stage, the defects.
Each minute 10 new cars are created, every day the robot builder process start over from scratch wiping all the cars at the end of the day. Even though the generated cars are randomly generated, we have only 10 different car models.


## Guard robot
-  This robot will be looking for any kind of defect, it will send an alert when the defect is detected and it will inform the details using slack.
Here you go, a curl example (of course you’ll do this using Ruby rather than CURL)

curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/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`

You can check the details here:
https://api.slack.com/docs/messages
Note: The URL =>  https://hooks.slack.com/services/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 is a real URL, it will post the message you will format to the person who is reviewing the challenge.


## About the stock
The factory stock is different from the store stock. Every 30 minutes the guard robot beside of watching our defects will transfer the stock from factory stock to store stock in order to be sold (it will transfer only the non-defective cars stock).


## Robot buyer, order model and store stock

Once the cars are ready to be sold, the cars are taken to another place, far from the factory and the factory warehouse. Here is where the Robot buyer comes on the scene, this process will buy a random number of cars always < 10 units each X amount of time (it can buy 10 cars/min top). When the robot buyer purchases a car an order will be placed. The robot only can buy 1 car at a time, so each order will have only 1 item. The stock will be decreased when the order is placed. Well, there’s a detail here, the stock we decreased is the store stock. If when the robot buyer wants to purchase a car model and there’s no stock, it won’t be able to buy it and that event will have to be logged.


## The problem.
You know the robot buyer knows the car models he is able to buy, we want to optimize the sales, as we have lag between the factory stock and the store stock, it may happen that we don’t have stock at the store stock but we actually have brand new cars ready to be sold in the factory stock. How can we optimize the stock management? (sadly we can’t centralize the stock)

## The other problem.
After you finish to code this challenge, imagine you'll receive a text message from the robot buyer, it says that several orders need to be changed because they want to change the cars models.
First, you receive an order_id and the car model, but an hour later you'll start to receive several changes of this kind request per hour.
What is your proposal to solve this need? Also please implement the solution.

## A plus.
Making the robot execs happy would be a good idea, it would be great to pull the daily revenue, how many cars we sell, average order value on a daily basis.

## Notes and considerations
+ This is a pretty open challenge, there are several ways to solve it, the idea behind this you show us how you think, how you solve the problems. So express yourself, apply the good practices and techniques you learned but always with the right balance, keep it simple.
+ Tests are important, we use Rspec, but mini test or another framework will do the job.
+ Don't hesitate to ask, we are here to help.
+ We use Rails and Postgres. The Postgres DB is mandatory for this challenge, but as this challenge doesn't have front-end, if you feel comfortable using plain ruby it's fine (if you decide to use a framework the only allowed is Rails). 

# For start robots in Factory => CarFactory.start_robots
