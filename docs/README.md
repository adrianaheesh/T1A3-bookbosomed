Develop a statement of purpose and scope for your application. It must include:
- describe at a high level what the application will do
- identify the problem it will solve and explain why you are developing it
- identify the target audience
- explain how a member of the target audience will use it

Develop a list of features that will be included in the application. It must include:
- at least THREE features
- describe each feature

Note: Ensure that your features above allow you to demonstrate your understanding of the following language elements and concepts:
- use of variables and the concept of variable scope
- loops and conditional control structures
- error handling


# Software Development Plan 
## Adriana Heesh T1A3

## Purpose and Scope

- describe what the application will do
- identify problem that is being solved
- target audience
- target audience intended use

My application Book-Bosomed (which means to always carry a book on one's person), is designed to solve the problem of which book to dive into next for a book club each month. The user of the app can be allocated a book from the Google Books API by either searching the title or author, or selecting 'random' and having the app generate a book for them. The app will output five books from the search in order of highest rating to lowest, then provide the user with the option to add one of these titles to their book club calendar. The calendar can be viewed at any time, and the user also has the option to review a book, or read a review for a book. 

Book-bosomed has a target audience of younger, tech-savvy book enthusiasts. Traditional book clubs meet in a book store or library and often have an older demographic. Book-bosomed however, reaches out to a younger audience because it is all managed digitally. The use is mostly intended for the club organiser or admnistrator, however future expansion could include login features that enable 

## Features

The features of BookBosed include: 
1. Finding a book through the app based on the title or author, as well as associated data of that book, such as existing reviews. This will be possible by parsing a JSON file from the bookreads API. Depending if the user would prefer an automated output or to look up a book themselves, the output data will then be able to be pushed to an additional calendar file.

1. Share a calendar with other club members of upcoming reads, including disussion topics to think about. This will be a CSV file, enabling multiple data points to be stored for one book, and output as necessary for the month the book is allocated. 

1. The third feature is the ability to review books. This data will be input by the user, and can be pushed back to the Goodreads API and/or to the CSV file full of monthly reads. 


## User Interaction

- how the user will know/find out how to use the app
- how they will interact with each feature
- how the errors will be handled and shown to the user

This app will have a help menu that will offer a guide on how to navigate through the different features. After a welcome message, the user will be asked what they would like to do, then an if/else control flow statement will enable the correct step to be taken from there. *maybe

The first feature, which enables the user to consider data for a specific book, will allow the user to make an action based on the data. Either to add the book to a month, or to continue looking through books. They can find the book by either searching for a book's title or author, or select the choose for me feature that randomly generates a title. 

By opting to add an item to the calendar, the user will select a month, and if the month is free, a confirmation message will show the customer this has been successful. However, should a title already be allocated to a month, a warning prompt will appear asking the user to confirm they wish to ovewrite the month and that this can't be undone. If they go ahead, the month will be overwritten with the new title. The user can now opt to see an updated calender, which will be accessible accross all parts of the app as it is a sharable file. 

Pushing a book to a month will also push the associated data? about a book to the Bookreads API or for the calnendar - which do I want to do? - 

Because user input will feature heavily in this app, there will be a variety of safeguards against collecting this data, for example correct error handling so the user has specific feedback about any issues, and transforming data where necessary to ensure there are no case sensitivites.

## Diagram of Control Flow

Control flow diagram goes here

## Implementation Plan

- outline how each feature will be implemented with a checklist of tasks (min 5 per feature)
- make sure to prioritise features
- provide a deadline for each feature/checklist

This should be done with Trello or similar software

The book finding feature will be implemented by:
1. Write pseudocode to guide implementation of feature
1. Create a class and assign variables for finding a book as this code will need to be repeated.
1. Connecting the app to the Goodreads API
1. Retrieve user input and necessary error handling for next steps, assign this input to a variable
1. Search the API for variable to find matching data, or output a random selection, depending on user input.
1. Output the data in an easily readable way, followed by a prompt for next action from the user. 
1. Either loop back to step 2, or prepare the data to deploy to an additional file. 

The calendar feature will be implemented by:
1. Write pseudocode to guide implementation of feature
1. Create a blank CSV file 
1. Add column titles for month, book title, author, discussion points and reviews.
1. Create a class for pushing data to the calendar file as this code will need to be repeatable. Subclass of bookclub? Idk yet
1. Make this file is accessible to all users.

Implementing book reviews will be done by:
1. Write pseudocode to guide implementation of feature
1. Ask the user if they would like to review a book.
1. If yes, retrieve input for which book/month to review.
1. Show month, then capture input of review in a variable.
1. Push this review variable to the CSV of monthly reads. Or push this to goodreads? Not sure that would work because I think you need an account to do that.


## Help Documentation

- steps to install the app
- any dependencies
- system/hardware requirements

