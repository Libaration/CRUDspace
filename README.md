
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
