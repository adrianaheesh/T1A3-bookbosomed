# Software Development Plan 
## Adriana Heesh T1A3

Source control repository: https://github.com/adrianaheesh/T1A3-bookbosomed
Insert screen shot here

## Purpose and Scope

Problem: I have a book club but struggle to organise and allocate books for the month.

Solution: An app that lets me search through Google Books by title, author, topic or randomly chose a book for me. I can then add a book to my calendar to keep track of what I'm reading each month. 

My application Book-Bosomed (which means to always carry a book on one's person), is designed to solve the problem of which book to dive into next for a book club each month. The user of the app can be allocated a book from the Google Books API by either searching the title or author, or selecting 'random' and having the app generate a book for them. If the user selects random, the app while randomly output a keyword to search based on a list of common genres or topics. 

The app will output five books from the search in order of highest rating to lowest, then provide the user with the option to add any one of these titles to their book club calendar. The calendar can be viewed at any time from the main menu, and the user also has the option to review a book, or read a review for a book. 

Book-bosomed has a target audience of younger, tech-savvy book enthusiasts. Traditional book clubs meet in a book store or library and often have an older demographic. Book-bosomed however, reaches out to a younger audience because it is all managed digitally. The use is intended for the club organiser or admnistrator, however future expansion could include login features that enable different classes of users, breaking the users up into club administrators or members. 

The book club manager or administrator would use this app to find a specific book/author they are looking for, or to peruse random titles and seek inspiration for their upcoming month's read. The built-in calendar feature enables them to keep track of what month has been allocated to and for what book. Any notes or ideas they had about the book can be added to the reviews section of the app, which allows them to keep all key data about the club in one place. This would help keep book club administrators organised. 

## Features

### Feature 1: Finding a book by searching a title, author, topic, or randomly generating a book. 

This will be possible by getting an API key from google, requiring a gem 'httparty' and setting a max search parameter of 5 to control vast amounts of data. The URL can then be parsed into a JSON file, making the data easy to work with. The JSON file is then iterated over and selected pieces of data such as 'title', 'author' are pushed to an empty list. This list is then output to the user as the top 5 search results based on their keywords. 

The user input will be checked for the value 'random'. If the input is equal to random, a list of common topics and genres will be iterated through to randomly output one of those list items to use as the search word. 

The output of both random or keyword search is automatically ranked by best rated/most popular, and each one gets their index + 1 printed so it appears on screen as any easy to read numbered list. 

The search function is looping and only breaks if the user selects to not do a new search, in which case they are returned to the main menu.

### Feature 2: Add a book to the book club calendar.

Once the top 5 results have been output, the user will be asked if they'd like to add any of these titles to their calendar. If yes, they will be prompted to provide the month they wish to allocate the title to. If no, they can search again.

The gem 'smarter_csv' enables data in a CSV to be output into a variable (and therefore object) as an array of hashes where the key is the column header, and the value is the cell contents. 

This variable is then iterated over to check if the selected month exists. If the user has indicated an overwrite, the variable will be manipulated to reflect the new choice, then the built-in CSV ruby function is used to rewrite the file and add the variable values back in. 

When the month doesn't already exist, the CSV file is simply appended and the chosen month and data is pushed to the end of the file. 

### Feature 3: The ability to review/make notes on books. 

If a month that the user is trying to review exists in the CSV, they are able to push a string to this month. This data can then be output and read at any time. 

This is executed by retrieving a selected month from the user, checking to see if the month exists, and if it does, reminding the user what book title was allocated to that month. The string is stored in a variable which then gets pushed to the calendar CSV so all data about a book is accessible to the user from one easy-to-access file. 

## User Interaction

The main menu is the first thing that appears when the app is launched. It asks the user what they would like to do from 5 options. Because user input can cause mutliple errors, the gem 'tty-prompt' has been utilised to handle potential errors. Given a long list of options, the user simply has to scroll up and down through the options instead of typing the menu option. 

The gem 'tty-prompt' enables command line prompts to be received at multiple stages of the app with built-in error handling.

This app will also feature a help/about option that tells the user more about the apps features. One of the other benefits of 'tty-prompt' is that each time a new question is posed, it demonstrates to the user how to answer correctly. 


By opting to add an item to the calendar, the user will select a month, and if the month is free, a confirmation message will show the customer this has been successful. However, should a title already be allocated to the month, the user will be given the option to pick a new month, or overwrite the month with their new book choice.

The gem 'tty-prompt' manages most user input error issues, however some issues could arise in the Google API output, for example missing data pieces. In the case, a rescue statement will be used in order to not break the flow of the app, and tell the customer some data is missing from this title, thus creating a seamless user experience.

## Diagram of Control Flow

Style standard set by Lucidchart 2020. 


## Implementation Plan

Link to my Trello board: https://trello.com/b/tlgodYZ7/t1a3-ruby-app 

The book finding feature will be implemented by:
1. Write pseudocode to guide implementation of feature
1. Create a method for finding a book. This method will take one argument as search results will either be randomised or generated from a user's keyword, but processed in the same way.
1. Create a Google Books API key and use this to search through their API, pulling this data into a JSON file.
1. Pull only the required data from the Google results JSON into an array of top-result values.
1. Output the data in an easily readable way including numbers so the user doesn't have to re-type the book title.
1. Prompt the user to suggest if they'd like to add to calendar, or start a new search.
1. Create if/else statement that allows them to choose which of the 5 results they would like to add to the calendar.
1. Loop these options until either a calendar call is made, or start a new search is answered no.
1. Test for errors and handle appropraitely
This feature should be finished and working by Wednesday, September 30. As one of the harder features to implement with lots of new techniques, I have allowed more time to complete this task. 

The add to calendar feature will be implemented by:
1. Write pseudocode to guide implementation of feature
1. Create a blank CSV file with headers of Month, Title, Author, Review
1. Use the gem Smarter CSV to store this CSV data as an array of hashes with a relevant variable title
1. Create a method to add to calendar, which takes two arguments, list of Google results, and the index of the book chosen.
1. Prompt user to select a month to add their book to.
1. Iterate through the variable to check if the month already exists in the file
1. Create an if/else statement where a variable is set to true if the month is found in the CSV, then outputs the index and breaks the iteration.
1. Create a case statement that prompts the user to select to rewrite a month's allocation, or choose a new month when the variable from the last step is true. If new month is chosen, loop back to choosing a month.
1. When the above variable is false, append the CSV file with the new data.
1. Test for errors and handle appropraitely
This feature should be finished and working by Thursday, October 1. It has a medium level of difficulty as it relies heavily on accurate logirithmic thinking. 

Implementing book reviews will be done by:
1. Write pseudocode to guide implementation of feature
1. Use the gem Smarter CSV to store the CSV file in a variable
1. Prompt the user to chose a month
1. Iterate through the variable to check if the month exists. 
1. Create if/else statement that either tells the user there is no book for that month, or prompts them to type their review.
1. Assign the review to the variable that contains the CSV file
1. Rewrite the CSV file, by first pushing the column titles, then pushing each of the hashes in the variable.
1. Enable users to read these reviews by choosing a month, and similarly to earlier, checking if the month exists. When it does, output the review. 
1. Test for errors and handle appropraitely
This feature should be finished and working by Friday, October 2. It has a medium to easy level of difficulty as it reuses some of the thinking from the previous function. 

## Help Documentation

- steps to install the app
- any dependencies
- system/hardware requirements

### Steps to install

All files needed to run this app are uploaded to Canvas in a zip file. This file should be downloaded from Canvas, as it contains hidden files (hiding my API key) that aren't available from my public Github repository. Once this file has been downloaded, navigate into the AdrianaHeesh_T1A3 directory in your terminal, then execute
```
cd src
```
followed by 
```
./run_bookbosomed.sh
```
This will launch my app! 

### Dependencies

A number of Ruby gems are required to run this program, each of which come with their own dependencies. For this reason I have used bundler, which is initiated in the bash script. Once the commands under steps to install have been run, the app should take care of loading these requirements.

### System hardware requirements

This app should be deployed through the terminal using Ruby script. Ruby will need to be installed on the local machine for this app to work. 

## References

Lucidchart 2020, What is a Flowchart, viewed 25 September 2020, < https://www.lucidchart.com/pages/what-is-a-flowchart-tutorial#top>