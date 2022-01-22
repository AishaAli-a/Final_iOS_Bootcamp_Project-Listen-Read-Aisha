//
//  ViewController.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/18/21.
//

import UIKit
import Firebase



class CheckIfLoggedInVC: UIViewController {
  
  let idUsers = Auth.auth().currentUser?.uid
  
  override func viewDidLoad() {
    super.viewDidLoad()

    

  }
  
  //MARK: - Check if the user already logged in or not
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let storboard = UIStoryboard(name: "Main", bundle: nil)
    
    if idUsers == nil {
      let vc = storboard.instantiateViewController(withIdentifier: "SplashClass") as!  SplashClass
      vc.modalPresentationStyle = .fullScreen
      self.present(vc, animated: true, completion: nil)
      print("User is not logged In")
    }else{

      let vc = storboard.instantiateViewController(withIdentifier: "MainTabBar")  as! MainTabBar
      
      vc.modalPresentationStyle = .fullScreen
      self.present(vc, animated: true, completion: nil)
      print("User is  logged In")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    print("* * * * CheckIfLoggedInVC viewWillAppear * * *  ")
    print("Number of Books: \(books.count)")

  }
  
  
  override func loadView() {
    super.loadView()
//    readReadingList()
//    print("* * * * CheckIfLoggedInVC loadView * * *  ")
   let count = UserReadingListVC().myReadingList.count
    print("* * * * number of books in reading list: \(count) * * *  ")

   

  }

//  func readReadingList(){
//    let db = Firestore.firestore()
//    db.collection("users").document(idUsers!).collection("ReadingList").getDocuments{ Snapshot, error in
//      if error == nil {
//        books.removeAll()
//        guard let data = Snapshot?.documents else {return}
//        for bookInfo in data {
//
//          books.append(ReadingList(coverBook: bookInfo.get("coverBook") as! String,
//                                        authorName: bookInfo.get("authorName") as! String,
//                                        bookTitle: bookInfo.get("bookTitle") as! String,
//                                        bookGenere: bookInfo.get("bookGenere") as! String,
//                                        bookContent: bookInfo.get("bookContent") as! String,
//                                        bookId: bookInfo.get("bookId") as! String
//                                       ))
//          print("Number of Books: \(books.count)")
//        }
//      }
//    }
//  }
}



