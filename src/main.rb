require 'httparty'
require 'pp'
require 'colorize'
require 'csv'

CSV.open("bookclub.csv", "w") do |csv| 
    csv << [:month, :title, :author, :rating, :review]
end

# list of book genres for randomize funtion - one of these is sampled and searched in order to enable random search function
genres = [
    "fantasy",
    "biography",
    "autobiography",
    "fiction",
    "non-fiction",
    "young adult",
    "romance",
    "thriller",
    "history",
    "childrens",
    "science fiction"
]

top_results = []

# google book search results, outputs the top 5 results into an array, then highlights the title with the highest star rating
def search(keyword)
    url = "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=5&key=AIzaSyAPth8B14lVUFScccXBmq8nu4X6H9aCSOw"
    response = HTTParty.get(url)
    result = response.parsed_response
    File.write("searchresults.json", result.to_json)
    
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

def calendar
    puts "Which number would you like to add?"
    book_to_add = gets.chomp.to_i - 1
    puts "Which month would you like to add this book to?"
    month_action = gets.chomp.downcase 
    CSV.open("bookclub.csv", "a") do |csv| 
        csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], top_results[book_to_add][:rating]]
    end
    # puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
end

puts "Welcome to the Book Bosomed app! What would you like to do? (Options: find book, view calendar, write review, get help)"
options_action = gets.chomp.downcase
if options_action == "find book"
    puts "Let's find you a book to read! Type the title of the book you're looking for, or 'random' to get one generated for you."
    search_method = gets.chomp.downcase
    if search_method == "random"
        random_book = genres.sample
        search(random_book)
    else
        search(search_method)
    end
    puts "Would you like to add one of these titles to your calendar? (y or n)"
    calendar_action = gets.chomp.downcase
    if calendar_action == "y" 
        calendar
    elsif calendar_action == "n"
        puts "No worries, let's do a new search."
    else
        puts "Sorry, that's not an option."
    end
elsif options_action == "view calendar"
    CSV.foreach("bookclub.csv", headers: true) do |row|
        puts "For the month of #{row['month'].capitalize}, you are reading #{row['title']}."
    end
elsif options_action == "write review"
    
else 
    # display help menu
end