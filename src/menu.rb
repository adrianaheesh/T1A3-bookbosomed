require 'tty-prompt'
require_relative 'main.rb'

prompt = TTY::Prompt.new

main_menu = {
    "Find a book" => 1, 
    "View your club calendar" => 2, 
    "Write a review" => 3, 
    "Get help" => 4
}

# method? 
menu_action = prompt.select("What what you like to do?", main_menu, help: "(Use the up and down keys & then key enter to choose)", show_help: :always )

if menu_action == 1
    puts "Let's find you a book to read! Type the title of the book or author you're looking for, or 'random' to get one generated for you."
    search_method = gets.chomp.downcase
    if search_method == "random"
        random_book = genres.sample
        search_results = search(random_book)
    else
        search_results = search(search_method)
    end
    add_to_calendar = prompt.yes?("Do you want to add one of these titles to your club calendar?")
    if add_to_calendar == true
        calendar(search_results)
    else
        puts "Okay let's search again."
    end
elsif menu_action == 3
    # call review method
else menu_action == 4
    # help menu
end

