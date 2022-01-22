//
//  model.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/2/22.
//

import Foundation



struct ReadingList:Hashable {
  
  let coverBook : String
  let authorName : String
  let bookTitle : String
  let bookGenere : String
  let bookContent : String
  let bookId :String
  
  
  func getBookDetails() -> [String:Any]{
    return
    ["coverBook":coverBook,
     "authorName":authorName,
     "bookTitle":bookTitle,
     "bookGenere":bookGenere,
     "bookContent":bookContent,
     "bookId": bookId] as! [String:Any]
  }
}

