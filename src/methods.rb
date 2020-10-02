require_relative 'apikey.rb'
require_relative 'data-sets.rb'
require 'pastel'
require 'tty-table'
require 'csv'
require 'httparty'
require 'smarter_csv'
require 'tty-prompt'

$pastel = Pastel.new

# method for searching a keyword
def search(keyword)
    begin
        url = "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=5&key=#{$apikey}"
        response = HTTParty.get(url)
        result = response.parsed_response
        File.write("searchresults.json", result.to_json)
        
        top_results = []
        result["items"].each do |item|
            top_results.push({
                title: item["volumeInfo"]["title"], 
                author: item["volumeInfo"]["authors"], 
            })
        end
        
        puts "Here's your top 5 search results starting from highest rated to lowest:"
        top_results.each do |book| 
            if book[:author] == nil # nil class will throw error for one of these values
                puts ("#{top_results.index(book) + 1}. #{book[:title]} by an unknown author.")
            else
                puts ("#{top_results.index(book) + 1}. #{book[:title]} by #{book[:author][0]}.")
            end
        end
    rescue NoMethodError # in case it's not the author missing
        puts "Some of your search results have incomplete data."
    end
    return top_results
end

# method for adding a book to the calendar
def add_to_calendar(top_results, book_to_add)
    loop do
        month_action = $prompt.select("Which month would you like to add this book to?", $months, active_color: :bright_blue)    
        data = SmarterCSV.process("bookclub.csv")

        # iterate through the calendar to check if the chosen month is already on there, output a true variable and index, then break if month found
        data.each_with_index do |row, index|
            if month_action == row[:month]
                $month_taken = true
                $new_month_allocation_index = index
                break
            end
        end

        case
        when $month_taken == true
            puts "You've already allocated a book to #{month_action}."
            overwrite_action = $prompt.yes?("Do you want to overwrite this month?", active_color: :bright_blue)
            if overwrite_action == true
                # replace the index at this month within the data variable
                data[$new_month_allocation_index] = {
                    month: month_action,
                    title: top_results[book_to_add][:title],
                    author: top_results[book_to_add][:author],
                    review: nil
                }

                # rewrite the calendar csv
                CSV.open("bookclub.csv", "w") do |csv| 
                    csv << [:month, :title, :author, :review]
                end

                # iterate through the data variable and push those values to the csv
                data.each do |row|
                    CSV.open("bookclub.csv", "a") do |csv| 
                        csv << row.values 
                    end
                end
                puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
                break # break the loop once a new book has been pushed
            else 
                puts "No worries, pick a new month to allocate your book to." 
            end

        # if the month is free, append the calendar csv
        else $month_taken == !true
            CSV.open("bookclub.csv", "a") do |csv| 
                csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], nil]
            end
            puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
        break # break the loop once a new book has been pushed
        end
    end
end

# method to view the current calender
def view_calendar
    begin
        CSV.foreach("bookclub.csv", headers: true) do |row|
            if row == nil
                puts "You don't have any books allocated yet."
            elsif row['author'] == nil # incase the author is missing, to avoid error
                puts "In #{row['month'].capitalize}, you're reading #{row['title']} by an unknown author."
            else
                puts "In #{row['month'].capitalize}, you're reading #{row['title']} by #{row['author']}."
            end
        end
    rescue # backup in case other data is missing
        puts "Some of the data is missing for this book."
    end
end

# method to find a book
def find_a_book_title
    puts "Let's find you a book to read! Type the title of the book or author you're looking for, or 'random' to get one generated for you."
    search_method = gets.chomp.downcase
    return search_method
end

# method to find a month
def find_a_month
    $month_action = $prompt.select("Which month's book would you like to review?", $months, active_color: :bright_blue)    
    # books_data is an array of hashes thanks to SmarterCSV gem
    $books_data = SmarterCSV.process("bookclub.csv", { :remove_empty_options => false, :remove_values_matching => false, :remove_empty_hashes => false })
    
    # iterate through the array, and if the month for that row matches the users selection, output this row's index into a variable
    $month_index = nil
    $books_data.each_with_index do |row, index|
        if $month_action == row[:month]
            $month_index = index
            break
        end
    end
end

# method to review a book
def review_a_book
    loop do
        find_a_month
        
        case
        when $month_index == nil
            puts "Sorry, that month doesn't have any books allocated to it yet."
        else 
            puts "#{$month_action}'s book is #{$books_data[$month_index][:title]}."
            book_review = $prompt.ask("Please type your review", active_color: :bright_blue)
            # assign this review to the correct index within this variable
            $books_data[$month_index][:review] = book_review
            p $books_data
            
            # rewrite the csv with titles
            CSV.open("bookclub.csv", "w") do |csv| 
                csv << [:month, :title, :author, :review]
            end
            
            # iterate through the variable and push it to the csv
            $books_data.each do |row|
                CSV.open("bookclub.csv", "a") do |csv| 
                    csv << row.values 
                end
            end
        end
        another_review = $prompt.yes?("Would you like to write another review?", active_color: :bright_blue)
    break if another_review == false    
    end
end

def read_a_review
    puts "Let's see what you've written about your club books!"
    loop do
        find_a_month

        if $month_index == nil
            puts "Sorry, that month doesn't have any books allocated to it yet."
        elsif $books_data[$month_index][:review] == nil
            puts "#{$month_action}'s book #{$books_data[$month_index][:title]} hasn't got any reviews yet."
        else
            puts "#{$month_action}'s book #{$books_data[$month_index][:title]} has the following review:"
            puts $books_data[$month_index][:review]
        end

        another_review = $prompt.yes?("Would you like to read another review?", active_color: :bright_blue)
        break if another_review == false
    end
end

# Learn about the app and get help
def learn_more
    puts "Book-Bosomed is your all in one book-club manager. Easily find books based on the title or author, or even general key words like 'cats' or 'dogs'.\  
    This app will automatically provide you with the top 5 Google Books search results for that particular keyword. But hey, we know that sometimes you\ 
    don't know what you're looking for! You can search 'random' and we'll generate 5 books on a random topic for you to look over.\  
    Once you're happy with your book you can choose to add it to your club calendar. Easily track and see your upcoming book assignments \ 
    by selecting 'view calendar' from the main menu. Once you've read a book, you can easily write your own review through the main menu. Simply\ 
    select the month for that book, write out your review and viola - it's stored away for another time."
end
