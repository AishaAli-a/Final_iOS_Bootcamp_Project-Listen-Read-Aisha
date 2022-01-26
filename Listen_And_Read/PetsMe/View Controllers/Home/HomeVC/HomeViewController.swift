//
//  Home Screen.swift
//  SignIn_ProtoType
//
//  Created by Aisha Ali on 11/27/21.
//

import Firebase
import UIKit

var RecoBooks: [ReadingList] = []

class Home: UIViewController{
  
  let reuseIdentifier2 = String(describing: LabelCell.self)
  
  let db = Firestore.firestore()
  let id = Auth.auth().currentUser!.uid
  var books:[ReadingList] = []
  
  
  var currentBook: String = ""
  var currentGenre: String = ""
  var currentAuthor: String = ""
  var currentSummary: String = ""
  var currentImage: String = ""
  
  var categoryIndex = [0,1,2,3,4,5,6,7,8,9]
  var category : String?
  var randomimage: String?
  var randomBook: String?
  var a: String?
  var b: String?
  var c: String?
  var d: String?
  var e: String?
  var f: String?


  
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var continuousReading: UIStackView!
  @IBOutlet weak var bookImage: UIImageView!
  @IBOutlet weak var numberOFBooks: UILabel!
  @IBOutlet weak var categoriesCollection: UICollectionView!
  @IBOutlet weak var bookOfTheDayCollection: UICollectionView!
  @IBOutlet weak var userName_Label: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib2 = UINib(nibName: reuseIdentifier2, bundle: nil)
    categoriesCollection.register(nib2, forCellWithReuseIdentifier: reuseIdentifier2)
    configureSize(numberOfHorizantalCells: 4, marginsBetweenCells: 20)
    print("--------viewDidLoad Random Book: \(RecoBooks.count) --------------\n\n")
    print("--------viewDidLoad Random Book: \(books.count) --------------\n\n")
    
    
    
  }
  
  
  @IBAction func continueReading_Pressed(_ sender: UIButton) {
    let vc = storyboard?.instantiateViewController(withIdentifier: "UserReadingListVC") as! UserReadingListVC
    self.navigationController!.pushViewController(vc, animated: true)
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    readUserInfo()
    readUserReadingList()
    readBookOfTheDay()
    
    self.bookImage.frame.origin.y += 25
  }
  
  
  func bookAnimation(){
    
    if books.count != 0 {
      continuousReading.isHidden = false
      numberOFBooks.text = "\(books.count) Books in your reading list "
      randomimage = books.randomElement()?.coverBook
      
      
 
      //THREADING
      DispatchQueue.main.async{
        let data = try? Data(contentsOf: URL(string: self.randomimage!)!)
        if let data = data, let image = UIImage(data: data) {
          
          UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
            
            self.bookImage.image = image
            self.bookImage.frame.origin.y -= 25
          })
        }
      }
    } else{
      continuousReading.isHidden = true
    }
  }
  
  
  func readUserInfo(){
    
    let user = Auth.auth().currentUser
    if let currentUser = user {
      db.collection("users").document(currentUser.uid).getDocument { doc , err in
        if err != nil {
          print(err!)
        }
        else{
          let data = doc!.data()!
          print("\n\n* * * DATA : \(data) * * * * * * * *\n\n")
          self.userName_Label.text = data["name"] as? String
        }
      }
    }
  }
  
  
  func readUserReadingList(){
    
    let db = Firestore.firestore()
    db.collection("users").document(id).collection("ReadingList").getDocuments{ [self] Snapshot, error in
      if error == nil {
        books.removeAll()
        guard let data = Snapshot?.documents else {return}
        for bookInfo in data {
          
          books.append(ReadingList(coverBook: bookInfo.get("coverBook") as! String,
                                   authorName: bookInfo.get("authorName") as! String,
                                   bookTitle: bookInfo.get("bookTitle") as! String,
                                   bookGenere: bookInfo.get("bookGenere") as! String,
                                   bookContent: bookInfo.get("bookContent") as! String,
                                   bookId: bookInfo.get("bookId") as! String
                                  ))
          print(bookInfo.get("authorName")!)
        }
      }
      self.bookAnimation()
    }
  }
  
  func readBookOfTheDay(){
    
    let db = Firestore.firestore()
    db.collection("ReadingList").getDocuments{ Snapshot, error in
      if error == nil {
        RecoBooks.removeAll()
        guard let data = Snapshot?.documents else {return}
        for bookInfo in data {
          
          RecoBooks.append(ReadingList(coverBook: bookInfo.get("coverBook") as! String,
                                       authorName: bookInfo.get("authorName") as! String,
                                       bookTitle: bookInfo.get("bookTitle") as! String,
                                       bookGenere: bookInfo.get("bookGenere") as! String,
                                       bookContent: bookInfo.get("bookContent") as! String,
                                       bookId: bookInfo.get("bookId") as! String
                                      ))
          print("--------Random Book \(RecoBooks.count) --------------")
        }
        self.bookOfTheDayCollection.reloadData()
      }
    }
  }
}

