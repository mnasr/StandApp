# StandApp #
========================

## Main features ##

### Users ###

* Only monaqasat team members are allowed to signup
* Users can create an entry per day
* At least one admin should exist
* A Scrum Master role is automatically assigned for a period of time, defined in the configuration file, in a way that the same user cannot be a Scrum Master for two consecutive times
* A user has two options to fill in from his profile page: Start of Week pattern and Time Zone
* An administrator can access extended user info and all users entries
* An administrator or a Scrum Master can create/modify absences for all users

###Entries###

* A user can manage his own entries
* A user can see other users' entries
* A user can link fill in the number of Redmine ticket(s)
* A user can categorize tickets he's working on
* A user can check the list of absent employees

###Search###

* All entries are searchable by including a keyword. Search matches against description, category, and ticket number
* All users are searchable by name and email account

###Emails###

* Daily email reminders are sent to users who did not submit an entry before a predefined time set by the admin
* Emails are disabled automatically in the case the user is flagged as absent

## Installation ##