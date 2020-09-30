require 'httparty'
require 'colorize'
require 'csv'
require 'smarter_csv'
require 'tty-prompt'
require 'dotenv'
require 'tty-font'
require_relative 'methods.rb'

Dotenv.load
font = TTY::Font.new(:block)

puts font.write("Book-Bosomed")
puts "Welcome to Book-Bosomed!"

#login menu goes here




# list of book genres for randomize funtion - one of these is sampled and searched in order to enable random search function
genres = [
    "fantasy",
    "biography",
    "autobiography",
    "fiction",
    "non-fiction",
    "young adult",
    "romance",
    "thriller",
    "history",
    "science fiction"
]

# google book search results, outputs the top 5 results into an array, then highlights the title with the highest star rating



# puts "Welcome to the Book Bosomed app! What would you like to do? (Options: find book, view calendar, write review, get help)"
# options_action = gets.chomp.downcase
# if options_action == "find book"
#     puts "Let's find you a book to read! Type the title of the book you're looking for, or 'random' to get one generated for you."
#     search_method = gets.chomp.downcase
#     if search_method == "random"
#         random_book = genres.sample
#         search_results = search(random_book)
#     else
#         search_results = search(search_method)
#     end
#     puts "Would you like to add one of these titles to your calendar? (y or n)"
#     calendar_action = gets.chomp.downcase
#     if calendar_action == "y" 
#         calendar(search_results)
#     elsif calendar_action == "n"
#         puts "No worries, let's do a new search."
#     else
#         puts "Sorry, that's not an option."
#     end
# elsif options_action == "view calendar"
#     view_calendar
# elsif options_action == "write review"
#     # write review
#     # going to have to repeat the steps of overriding the existing csv 
# else 
#     # display help menu - command line arguments? 
# end
