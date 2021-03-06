require 'tty-prompt'
require 'tty-font'
# require_relative 'main.rb'
require_relative 'methods.rb'

font = TTY::Font.new(:block)
$prompt = TTY::Prompt.new
pastel = Pastel.new

puts font.write("Book-Bosomed")
puts pastel.bright_blue.inverse("                                             Welcome to Book-Bosomed!                                             \n")

loop do
menu_action = $prompt.select("What what you like to do?", $main_menu, show_help: :always, active_color: :bright_blue)

if menu_action == 1 # search for a book
    loop do
        search_method = find_a_book_title
        if search_method == "random"
            random_book = $genres.sample
            search_results = search(random_book)
        else
            search_results = search(search_method)
        end
        add_to_calendar_action = $prompt.yes?("Do you want to add one of these titles to your club calendar?", active_color: :bright_blue)
        if add_to_calendar_action == true
            $book_to_add = $prompt.select("Which number book would you like to add?", %w(1 2 3 4 5), active_color: :bright_blue).to_i - 1
            add_to_calendar(search_results, $book_to_add)
        else
            loop until add_to_calendar_action == false
        end
        search_again = $prompt.yes?("Would you like to search again?", active_color: :bright_blue)
    break if search_again == false
    end
elsif menu_action == 2 # view the club calendar
    view_calendar
elsif menu_action == 3 # review a book
    review_a_book
elsif menu_action == 4 # read a review
    read_a_review
elsif menu_action == 5 # get help
    learn_more
else menu_action == 5 # quit the app
    exit_action = $prompt.yes?("Are you sure you want to exit Book-Bosomed?", active_color: :bright_blue)
    if exit_action == true
        exit
    end
end
end
