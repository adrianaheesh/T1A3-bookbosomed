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
            calendar(search_results)
        else
            menu_action = prompt.select
            search_method = find_a_book_title
        end
elsif menu_action == 2
    view_calendar
elsif menu_action == 3
else menu_action == 4
    # help menu
end


# method for getting search parameters
# method for outputting the csv
# method for pushing new data to csv
# method for overriding data to csv
