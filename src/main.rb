require 'httparty'
require 'colorize'
require 'csv'
require 'smarter_csv'

# if empty write headers
# add feature to check for file first? Idk HOW lol
# CSV.open("bookclub.csv", "a") do |csv| 
#     csv << [:month, :title, :author, :rating, :review]
# end

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
    "science fiction"
]

# google book search results, outputs the top 5 results into an array, then highlights the title with the highest star rating
def search(keyword)
    url = "https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=5&key=AIzaSyAPth8B14lVUFScccXBmq8nu4X6H9aCSOw"
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
    puts "The result with the highest rating is: #{best_rated[:title].colorize(background: :blue)} by #{best_rated[:author][0]}."
    return top_results
end

def calendar(top_results)
    puts "Which number would you like to add?"
    book_to_add = gets.chomp.to_i - 1
    puts "Which month would you like to add this book to?"
    month_action = gets.chomp.downcase 
    data = SmarterCSV.process("bookclub.csv")
    data.each_with_index do |row, index|
        if month_action == row[:month]
            puts "This will override the book already allocated to #{month_action.capitalize}, do you want to continue? (y or n)"
            override_action = gets.chomp.downcase
            if override_action == "y"
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
            CSV.open("bookclub.csv", "w") do |csv| 
                csv << [:month, :title, :author, :rating, :review]
            end
            data.each do |row|
                CSV.open("bookclub.csv", "a") { |csv| csv << row.values }
            end
            puts "Great, #{top_results[book_to_add][:title]} has been added to #{month_action.capitalize}."
        end 
    end
end
    # CSV.open("bookclub.csv", "a") do |csv| 
    #     csv << [month_action, top_results[book_to_add][:title], top_results[book_to_add][:author], top_results[book_to_add][:rating]]
    # end


puts "Welcome to the Book Bosomed app! What would you like to do? (Options: find book, view calendar, write review, get help)"
options_action = gets.chomp.downcase
if options_action == "find book"
    puts "Let's find you a book to read! Type the title of the book you're looking for, or 'random' to get one generated for you."
    search_method = gets.chomp.downcase
    if search_method == "random"
        random_book = genres.sample
        search_results = search(random_book)
    else
        search_results = search(search_method)
    end
    puts "Would you like to add one of these titles to your calendar? (y or n)"
    calendar_action = gets.chomp.downcase
    if calendar_action == "y" 
        calendar(search_results)
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
    # write review
else 
    # display help menu
end
