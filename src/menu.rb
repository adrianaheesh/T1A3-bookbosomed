require 'tty-prompt'
require 'tty-font'
require_relative 'main.rb'
require_relative 'methods.rb'

font = TTY::Font.new(:block)
$prompt = TTY::Prompt.new
pastel = Pastel.new
error = pastel.red.bold.detach # defining how each error will look

puts font.write("Book-Bosomed")
puts pastel.bright_blue.inverse("                                             Welcome to Book-Bosomed!                                             \n")

main_menu = {
    "Find a book" => 1, 
    "View your club calendar" => 2, 
    "Write a review" => 3, 
    "Get help" => 4
}

loop do
menu_action = $prompt.select("What what you like to do?", main_menu, show_help: :always, active_color: :bright_blue)

if menu_action == 1
    loop do
        search_method = find_a_book_title
        if search_method == "random"
            random_book = genres.sample
            search_results = search(random_book)
        else
            search_results = search(search_method)
        end
        add_to_calendar = $prompt.yes?("Do you want to add one of these titles to your club calendar?", active_color: :bright_blue)
        if add_to_calendar == true
            book_data = []
            search_results.each do |headings, book_info| 
                book_data.push(book_info)
            end
            p book_data
            # book_to_add = prompt.select("Which book would you like to add to the calendar?", search_results[:title], show_help: :always)
        else
            loop until add_to_calendar == false
        end
        search_again = $prompt.yes?("Would you like to search again?", active_color: :bright_blue)
    break if search_again == false
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
