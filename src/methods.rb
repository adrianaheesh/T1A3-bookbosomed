require_relative 'apikey.rb'
require_relative 'main.rb'
require_relative 'data-sets.rb'
require 'pastel'
require 'tty-table'
require 'csv'

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
                rating: item["volumeInfo"]["averageRating"]
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
                    rating: top_results[book_to_add][:rating],
                    review: nil
                }

                # rewrite the calendar csv
                CSV.open("bookclub.csv", "w") do |csv| 
                    csv << [:month, :title, :author, :rating, :review]
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
                csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], top_results[book_to_add][:rating]]
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

# method to review a book
def review_a_book
    loop do
        month_action = $prompt.select("Which month's book would you like to review?", $months, active_color: :bright_blue)    
        # books_data is an array of hashes
        books_data = SmarterCSV.process("bookclub.csv")
        
        # iterate through the array, and if the month for that row matches the users selection, output this row's index into a variable
        books_data.each_with_index do |row, index|
            if month_action == row[:month]
                $month_index = index
                break
            end
        end
        
        if $month_index == nil
            puts "Sorry, that month doesn't have any books allocated to it yet."
        else 
            # $month_index.nil? 
            book_review = $prompt.ask("Please type your review", active_color: :bright_blue)
            # assign this review to the correct index
            books_data[$month_index][:review] = book_review
            
            CSV.open("bookclub.csv", "w") do |csv| 
                csv << [:month, :title, :author, :rating, :review]
            end
            
            books_data.each do |row|
                CSV.open("bookclub.csv", "a") do |csv| 
                    csv << row.values 
                end
            end
            break
        end
    end
end