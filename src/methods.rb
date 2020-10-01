require_relative 'apikey.rb'
require_relative 'main.rb'
require_relative 'data-sets.rb'
require 'tty-table'
require 'csv'

def search(keyword)
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
        
    puts "You're top search results are:"
    top_results.each do |book| 
        puts "#{top_results.index(book) + 1}. #{book[:title]} by #{book[:author][0]}."
    end

    best_rated = top_results.max_by{ |rating| }
    puts "The result with the highest rating is: #{best_rated[:title].colorize(:purple)} by #{best_rated[:author][0].colorize(:purple)}."
    return top_results
end

# method for adding a book to the calendar
def add_to_calendar(top_results, book_to_add)
    loop do
        month_action = $prompt.select("Which month would you like to add this book to?", $months, active_color: :bright_blue)    
        data = SmarterCSV.process("bookclub.csv")

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
                data[$new_month_allocation_index] = {
                    month: month_action,
                    title: top_results[book_to_add][:title],
                    author: top_results[book_to_add][:author],
                    rating: top_results[book_to_add][:rating],
                    review: nil
                }
                # updated data variable, now need to push new version to csv
                CSV.open("bookclub.csv", "w") do |csv| 
                    csv << [:month, :title, :author, :rating, :review]
                end
                data.each do |row|
                    CSV.open("bookclub.csv", "a") do |csv| 
                        csv << row.values 
                    end
                end
                puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
                break
            else 
                puts "No worries, pick a new month to allocate your book to." 
            end
        else $month_taken == !true
            CSV.open("bookclub.csv", "a") do |csv| 
                csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], top_results[book_to_add][:rating]]
            end
            puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
        break 
        end
    end
end

def view_calendar
    CSV.foreach("bookclub.csv", headers: true) do |row|
        if row == nil
            puts "You don't have any books allocated yet."
        else
        puts "In #{row['month'].capitalize}, you're reading #{row['title']} by #{row['author']}."
        end
    end
end

def find_a_book_title
    puts "Let's find you a book to read! Type the title of the book or author you're looking for, or 'random' to get one generated for you."
    search_method = gets.chomp.downcase
    return search_method
end

def review_a_book
    #ask for month
    month_action = $prompt.select("Which month's book would you like to review?", $months, active_color: :bright_blue)    
    # parse CSV into hashes and into variable
    books_data = SmarterCSV.process("bookclub.csv")
    # iterate through the calendar to find the month's index
    books_data.each_with_index do |row, index|
        if month_action == row[:month]
            $month_index = index
            break
        end
    end
    book_review = $prompt.ask("Please type your review", active_color: :bright_blue)
    books_data[$month_index][:review] = book_review
    # re-write the file with updated value
    CSV.open("bookclub.csv", "w") do |csv| 
        csv << [:month, :title, :author, :rating, :review]
    end
    books_data.each do |row|
        CSV.open("bookclub.csv", "a") do |csv| 
            csv << row.values 
        end
    end
end