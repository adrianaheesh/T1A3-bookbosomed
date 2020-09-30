require_relative 'apikey.rb'
require 'tty-table'

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
def calendar(top_results)
    puts "Which month would you like to add this book to?"
    month_action = gets.chomp.downcase 
    data = SmarterCSV.process("bookclub.csv")
    # this will need to be a method because it is repeated for the review section
    data.each_with_index do |row, index|
        if month_action == row[:month]
            puts "You already have a book for #{month_action.capitalize}."
            override_action = prompt.yes?("Would you like to search again?")
            if override_action == true
                data[index] = {
                    month: month_action,
                    title: top_results[book_to_add][:title],
                    author: top_results[book_to_add][:author],
                    rating: top_results[book_to_add][:rating],
                    review: nil
                }
                puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
            else override_action == "n"
                puts "Which month would you like to add this book to instead?"
                month_action = gets.chomp.downcase
            end
        else 
            # override the existing csv and push titles
            CSV.open("bookclub.csv", "w") do |csv| 
                csv << [:month, :title, :author, :rating, :review]
            end
            # iterate through the variable 'data' and push the existing row values into the file
            data.each do |row|
                CSV.open("bookclub.csv", "a") { |csv| csv << row.values }
            end
            add the new book to the csv file
        end 
    end
    CSV.open("bookclub.csv", "a") do |csv| 
        csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], top_results[book_to_add][:rating]]
    end
    options_action = prompt.yes?("Would you like to see your club calendar?")
    if options_action == true
        view_calendar
    end
end

def view_calendar
    CSV.foreach("bookclub.csv", headers: true) do |row|
        puts "In #{row['month'].capitalize.colorize(:red)}, you're reading #{row['title'].colorize(:blue)} by #{row['author'].colorize(:yellow)}."
    end
end

def find_a_book_title
    puts "Let's find you a book to read! Type the title of the book or author you're looking for, or 'random' to get one generated for you."
    search_method = gets.chomp.downcase
    return search_method
end

