//
//  BookInfoViewController.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/27/21.
//

import UIKit
import Firebase

var readingList = [ReadingList] ()

class BookDetailsVC: UIViewController {
  
  var arrayBooks: [ReadingList] = []
  
  @IBOutlet weak var bookCover_ImageView: UIImageView!
  @IBOutlet weak var bookTitle_Label: UILabel!
  @IBOutlet weak var bookAuthor_Label: UILabel!
  @IBOutlet weak var bookGenre_Label: UILabel!
  
  

  
  
  
  var bookTitle:String = ""
  var cover:String = ""
  var author:String = ""
  var genre:String = ""
  var bookContent:String = ""
  let db = Firestore.firestore()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    bookTitle_Label.text = bookTitle
    bookGenre_Label.text = genre
    bookAuthor_Label.text = author
    
    print("~~ \(self.bookContent)")
    
    //  MARK:  - Edit File get text and image from url

    if self.cover != "NA"{
      DispatchQueue.global().async{
        let data = try? Data(contentsOf: URL(string: self.cover)!)
        if let data = data, let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self.bookCover_ImageView?.image = image
            self.bookCover_ImageView.layer.cornerRadius = 20
            self.bookCover_ImageView?.contentMode = .scaleToFill

          }
        }
      }
    } else {
      print("* * * PHOTO NOT FOUND * * * ")
    }
  }
  
  
  @IBAction func button_Pressed(_ sender: UIButton) {
    
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisplayBookContentVC") as! DisplayBookContentVC
    
    if self.bookContent != "NA"{
      addBookToUserReadingList()
      
      DispatchQueue.main.async {
        let textURL=URL(string: self.bookContent)!
        let textData=try? Data(contentsOf: textURL)
        let textFromURL = String(data: textData!, encoding: .utf8)
        vc.bookContent?.text = textFromURL
      }
      
    } else {
      
      resultAlert()
      
    }
    
    vc.hidesBottomBarWhenPushed = true
    vc.modalPresentationStyle = .fullScreen
    self.navigationController?.pushViewController(vc, animated: true)
    
  }
  
  //  MARK:  - Store current book to RedingList collection in firebase
  
  func addBookToUserReadingList(){
    
    let db = Firestore.firestore()
    let idUsers = Auth.auth().currentUser?.uid
    let idBook = Int.random(in: 1000000000...9999999999)
    db.collection("users").document(idUsers!).collection("ReadingList").getDocuments { [self] Snapshot, error in
      
      let myBooks = ReadingList(coverBook: cover,
                                authorName: author,
                                bookTitle: bookTitle,
                                bookGenere: genre,
                                bookContent: bookContent,
                                bookId: "\(idBook)")
      
      db.collection("users").document(idUsers!).collection("ReadingList").document(myBooks.bookTitle).setData(myBooks.getBookDetails())
    }
  }
}




