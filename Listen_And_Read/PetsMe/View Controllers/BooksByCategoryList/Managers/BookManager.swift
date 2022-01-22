//
//  BookManager.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/25/21.
//

import Foundation

struct BookManager {
  
  
  
  var delegate : BookMangerDelegate?
  
  
  func fetchBookByCategory(category : String){
    let urlString = "\(EndPoints.guttenbergUrl)&topic=\(category)"
    print(urlString)
    performRequest(with: urlString)
  }
  
  
  func nextBooks(urlString : String){
    
    performRequest(with: urlString)
  }
  
  
  func SearchBookByCategory(category : String, search : String){
    
    let UrlString = "\(EndPoints.guttenbergUrl)&topic=\(category)&search=\(search)"
    let urlNew:String = UrlString.replacingOccurrences(of: " ", with: "%20")
    //        var urlString:String = UrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print(urlNew)
    
    performRequest(with: urlNew)
  }
  
  
  func performRequest(with urlString : String) {
    if let url  = URL(string: urlString){
      let session = URLSession(configuration: .default)
      
      let task = session.dataTask(with: url) { (data, response, error) in
        
        
        if error != nil {
          return
        }
        
        if let safeData = data
        {
          if let json = try? JSONSerialization.jsonObject(with: safeData, options: []) as? Dictionary<String,Any> {
            
            var nextItem : BookModel?
            if let next = json["next"] as? String {
              
              nextItem = self.ParseNextJSON(next)
            }
            
            if let articles = json["results"] as? Array<Dictionary<String,Any>> {
              
              let booksArray =   self.parseJSON(articles)
              if let nextValue = nextItem{
                self.delegate?.didUpdateBook(self, booksArray, nextValue)
              }
              else
              {
                self.delegate?.didUpdateBook(self, booksArray, BookModel.init(nextValue: "NA"))
              }
            }
            
          } else {
            print("Error");
          }
        }
      }
      task.resume()
    }
  }
  
  
  func parseJSON( _ booksData : Array<Dictionary<String,Any>>) -> [Books]{
    
    var booksarray = [Books]()
    for books in booksData {
      booksarray.append(Books(books))
    }
    return booksarray
  }
  
  
  func ParseNextJSON( _ nextUrl : String) -> BookModel
  {
    let booksNext = BookModel(nextValue: nextUrl)
    return booksNext
  }
  
}
