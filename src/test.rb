books = [
    {
    month: "January",
    title: "Book title 1",
    author: "Some person 1",
    rating: 4
    },
    {
    month: "February",
    title: "Book title 2",
    author: "Some person 2",
    rating: 4.6
    }
]

month = 1

books.delete_at(month)
books[0] = {
    month: "March",
    title: "Book title 3",
    author: "Some person 3",
    rating: 4.3
}

p books

