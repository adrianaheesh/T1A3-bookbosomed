# pseduocode
# ask user if they would prefer to search for a book or randomly generate a book
# if search, trawl through the bookreads API for matching data
# if random, generate a random output from the API
# ask if user would like to add this to their calendar
# if yes, ask which month
# if no, loop back to line 2

require 'httparty'
require 'pp'

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
    top_results = {}
    top_results[result["items"][0]["volumeInfo"]["title"]] = result["items"][0]["volumeInfo"]["authors"]
    top_results[result["items"][1]["volumeInfo"]["title"]] = result["items"][1]["volumeInfo"]["authors"]
    top_results[result["items"][2]["volumeInfo"]["title"]] = result["items"][2]["volumeInfo"]["authors"]
    top_results[result["items"][3]["volumeInfo"]["title"]] = result["items"][3]["volumeInfo"]["authors"]
    top_results[result["items"][4]["volumeInfo"]["title"]] = result["items"][4]["volumeInfo"]["authors"]
    puts "You're top search results are:"
    top_results.each { |book, author| puts "#{book} by #{author[0]}" }
    # don't forget to add reviews? 
end
puts "Would you like to add one of these titles to your calendar? (y or n)"
calendar_action = gets.chomp.downcase
if calendar_action == "y" || calendar_action == "yes"
    # add this to the calendar CSV
elsif calendar_action == "n" || calendar_action == "no"
    puts "Not for you, eh? No worries, we can search for a different book."
else 
    puts "Invalid answer"
end

# "authors", "title" , "averageRating"
# title
result["items"][0]["volumeInfo"]["title"]
#author
result["items"][0]["volumeInfo"]["authors"]

