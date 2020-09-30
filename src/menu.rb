require 'tty-prompt'
require_relative 'main.rb'
require_relative 'methods.rb'

prompt = TTY::Prompt.new

main_menu = {
    "Find a book" => 1, 
    "View your club calendar" => 2, 
    "Write a review" => 3, 
    "Get help" => 4
}

loop do
menu_action = prompt.select("What what you like to do?", main_menu, show_help: :always)

if menu_action == 1
    search_method = find_a_book_title
    if search_method == "random"
        random_book = genres.sample
        search_results = search(random_book)
    else
        search_results = search(search_method)
    end
    add_to_calendar = prompt.yes?("Do you want to add one of these titles to your club calendar?")
    if add_to_calendar == true
        book_data = []
        search_results.each do |headings, book_info| 
            book_data.push(book_info)
        end
        p book_data
        # book_to_add = prompt.select("Which book would you like to add to the calendar?", search_results[:title], show_help: :always)
    else
        loop until search_again == false
        search_again = prompt.yes?("Would you like to search again?")
        search_method = find_a_book_title
    end
elsif menu_action == 2
    view_calendar
elsif menu_action == 3
    # call rewrite method
else menu_action == 4
    # help menu
end
end

# method for getting search parameters
# method for outputting the csv
# method for pushing new data to csv
# method for overriding data to csv
