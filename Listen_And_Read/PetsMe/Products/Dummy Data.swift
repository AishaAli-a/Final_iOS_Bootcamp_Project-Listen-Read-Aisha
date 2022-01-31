

import UIKit
import Foundation


extension UIViewController{
  
  
  func resultAlert(){
    
    let resetAlert = UIAlertController(title: "Warning"
                                       , message: "Sorry this book is not available"
                                       , preferredStyle: .alert)
    
    resetAlert.addAction(UIAlertAction(title: "Okay",
                                       style: .default
                                       ,handler: nil ))
    present(resetAlert, animated: true)
  }
  
}

var gender = "en-IE"


let bookOfTheDay = [
  ReadingList(coverBook: "http://www.gutenberg.org/cache/epub/74/pg74.cover.medium.jpg", authorName: "Mark Twain", bookTitle: "The Adventures of Tom Sawyer", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/74/74-0.txt", bookId: ""),
  
  ReadingList(coverBook: "http://www.gutenberg.org/cache/epub/76/pg76.cover.medium.jpg", authorName: "Mark Twain", bookTitle: "Adventures of Huckleberry Finn", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/76/76-0.txt", bookId: ""),
  
  ReadingList(coverBook: "http://www.gutenberg.org/cache/epub/421/pg421.cover.medium.jpg", authorName: "Robert Louis Stevenson", bookTitle: "Kidnapped", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/421/421-0.txt", bookId: ""),
  
  ReadingList(coverBook: "http://www.gutenberg.org/cache/epub/1480/pg1480.cover.medium.jpg", authorName: "Thomas Hughes", bookTitle: "Tom Brown\'s School Days", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/1480/1480-0.txt", bookId: "")
]


let bookByCtegory = [
  ImageDetails(myImages: "Novel", name: "Fiction"),
  ImageDetails(myImages: "History", name: "Drama"),
  ImageDetails(myImages: "Mystery", name: "Humor"),
  ImageDetails(myImages: "Fiction", name: "Politics"),
  ImageDetails(myImages: "Starter", name: "Philosphy"),
  ImageDetails(myImages: "Romance", name: "History"),
  ImageDetails(myImages: "Fantasy", name: "Advanture"),
  ImageDetails(myImages: "Science", name: "Mystory"),
  ImageDetails(myImages: "Health", name: "Romance"),
  ImageDetails(myImages: "Children", name: "Novel"),
]





