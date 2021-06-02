# CRUDSpace
2005 Myspace recreation with Sinatra and Ruby. 
The recreation is a representation of Myspace how it was originally in the year 2005.
#### It features a lot of the original websites functionality including
* User Signup
* Profile Comments
* Messages and message notifcation
* Friend requests and friend request notifcations
* Custom CSS for user profiles (Old myspace layout site codes work here too! Although a bit buggy sometimes)
* Profile pictures and user photo albums

## Screenshots
![userProfile](https://i.gyazo.com/633ac419b9a7680b486fd301efc58902.jpg)

https://user-images.githubusercontent.com/11550216/120419217-02ef0f00-c330-11eb-990a-03e2fa082937.mp4


## Setup

These are the steps to get the app up and running:

###  Step 1. Clone this repository
Make a local copy of this project and move into the directory. This project requires Ruby and RubyGems. If you don't have Ruby installed yet, you can find [installation instructions here](https://www.ruby-lang.org/en/).
```
  $ git clone git@github.com:Libaration/CRUDspace.git
  $ cd CRUDspace
```

### Step 2. Create and seed the database
(Do not skip seeding!)
```
  $ rake db:migrate
  $ rake db:seed
```  
This will seed "Tom" into the database with his profile picture being the one located
at /public/images/tom.jpeg.<br>
It's important Tom is seeded because he will send a default greeting and friend request
to every user who signs up. To change the greeting or user who does the greeting
Find the #tomswelcome helper method in users_controller.rb

### Step 3. Run the server
```
  $ bundle exec rackup
```
