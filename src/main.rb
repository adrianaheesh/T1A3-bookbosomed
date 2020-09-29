# pseduocode
# ask user if they would prefer to search for a book or randomly generate a book
# if search, trawl through the bookreads API for matching data
# if random, generate a random output from the API
# ask if user would like to add this to their calendar
# if yes, ask which month
# if no, loop back to line 2

require 'httparty'
require 'pp'
require 'colorize'
require 'csv'

# accessing Google Books API
puts "Let's find you a book to read! Type the title of the book you're looking for, or 'random' to get one generated for you."
search_method = gets.chomp.downcase
if search_method == "random"
    # iterate through API and randomly output a book title
else
    url = "https://www.googleapis.com/books/v1/volumes?q=#{search_method}&maxResults=5&key=AIzaSyAPth8B14lVUFScccXBmq8nu4X6H9aCSOw"
    response = HTTParty.get(url)
    result = response.parsed_response
    File.write("searchresults.json", result.to_json)
    
    top_results = []
    top_results[0] = { 
        title: result["items"][0]["volumeInfo"]["title"], 
        author: result["items"][0]["volumeInfo"]["authors"],
        rating: result["items"][0]["volumeInfo"]["averageRating"]
    }
    top_results[1] = { 
        title: result["items"][1]["volumeInfo"]["title"], 
        author: result["items"][1]["volumeInfo"]["authors"],
        rating: result["items"][1]["volumeInfo"]["averageRating"]
    }
    top_results[2] = { 
        title: result["items"][2]["volumeInfo"]["title"], 
        author: result["items"][2]["volumeInfo"]["authors"],
        rating: result["items"][2]["volumeInfo"]["averageRating"]
    }
    top_results[3] = { 
        title: result["items"][3]["volumeInfo"]["title"], 
        author: result["items"][3]["volumeInfo"]["authors"],
        rating: result["items"][3]["volumeInfo"]["averageRating"]
    }
    top_results[4] = { 
        title: result["items"][4]["volumeInfo"]["title"], 
        author: result["items"][4]["volumeInfo"]["authors"],
        rating: result["items"][4]["volumeInfo"]["averageRating"]
    }
    
    puts "You're top search results are:"
    top_results.each do |book| 
        puts "#{top_results.index(book) + 1}. #{book[:title]} by #{book[:author][0]}."
    end

    best_rated = top_results.max_by{ |rating| }
    puts "The result with the highest rating is: #{best_rated[:title].colorize(background: :blue)} by #{best_rated[:author][0]}."

end

puts "Would you like to add one of these titles to your calendar? (y or n)"
calendar_action = gets.chomp.downcase
if calendar_action == "y" 
    puts "Which number would you like to add?"
    book_to_add = gets.chomp.to_i - 1
    puts "Which month would you like to add this book to?"
    month_action = gets.chomp.downcase 
    # push top_results.index(title_action) to a File.write CSV 
        # if/else for existing month data
        File.write("calendar.csv", data.join("\n"), mode: "a") # serialisation 
    puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
elsif calendar_action == "n"
    puts "No worries, we can do a new search."
else
    puts "Sorry, that's not an option."
end




