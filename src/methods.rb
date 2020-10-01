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
    month_action = $prompt.select("Which month would you like to add this book to?", $months, active_color: :bright_blue)    
    
    # use gem to turn csv into array of hashes
    data = SmarterCSV.process("bookclub.csv")

    # iterate through the array of hashes and determing if the month is taken or not
    data.each do |row|
        if month_action == row[:month]
            $month_taken = true
        else
            $month_taken = false
        end
    end

    if $month_taken == true
        puts "You've already allocated a book to #{month_action}."
        override_action = $prompt.yes?("Do you want to override this month?", active_color: :bright_blue)
        if override_action == true
            # figure out how to override data lol
                # data[index] = {
                #     month: month_action,
                #     title: top_results[book_to_add][:title],
                #     author: top_results[book_to_add][:author],
                #     rating: top_results[book_to_add][:rating],
                #     review: nil
                # }
            puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
        else 
            puts "No worries, pick a new month to allocate your book to." 
            month_action = $prompt.select("Which month would you like to add this book to?", $months, active_color: :bright_blue)
        end
    else $month_taken == false
        CSV.open("bookclub.csv", "a") do |csv| 
            csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], top_results[book_to_add][:rating]]
        end
    end
end

def view_calendar
    CSV.foreach("bookclub.csv", headers: true) do |row|
        puts "In #{row['month'].capitalize}, you're reading #{row['title']} by #{row['author']}."
    end
end

def find_a_book_title
    puts "Let's find you a book to read! Type the title of the book or author you're looking for, or 'random' to get one generated for you."
    search_method = gets.chomp.downcase
    return search_method
end




# else  
#     # override the existing csv and push titles
#     CSV.open("bookclub.csv", "w") do |csv| 
#         csv << [:month, :title, :author, :rating, :review]
#     end

#     # iterate through the variable 'data' and push the existing row values into the file
#     data.each do |row|
#         CSV.open("bookclub.csv", "a") do |csv| 
#             csv << row.values 
#         end
#     end

#     # add the new book to the bottom of the csv file
#     CSV.open("bookclub.csv", "a") do |csv| 
#         csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], top_results[book_to_add][:rating]]
#     end
# end 


# remove any duplicate months
# data = data.uniq! 
# data.each do |row|
#     csv << row.values
# end

