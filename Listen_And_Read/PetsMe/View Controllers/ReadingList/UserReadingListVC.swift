//
//  UserReadingListVC.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/2/22.
//

import UIKit
import Firebase


var myReadingList: [ReadingList] = []


private let reuseIdentifier4 = String(describing: BookListCell.self)

class UserReadingListVC: UITableViewController {
  
  
  
  var currentBook: String = ""
  var currentGenre: String = ""
  var currentAuthor: String = ""
  var currentSummary: String = ""
  var currentImage: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .cmWhite
    
    let nib2 = UINib(nibName: reuseIdentifier4, bundle: nil)
    
    tableView.register(nib2, forCellReuseIdentifier: reuseIdentifier4)
    
  }

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    readReadingList()

  }
  
  override func viewDidAppear(_ animated: Bool) {
//    readReadingList()
  }
  
  
  // MARK: - Table view data source
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myReadingList.count
    
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier4 , for: indexPath) as! BookListCell
    
    cell.bookAuthorName.text = myReadingList[indexPath.row].authorName
    cell.bookTitleLabel.text = myReadingList[indexPath.row].bookTitle
    
    DispatchQueue.global().async{
      let data = try? Data(contentsOf: URL(string: myReadingList[indexPath.row].coverBook)!)
      
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          cell.bookCoverImage?.image = image
          cell.bookCoverImage?.contentMode = .scaleToFill
          
        }
      }
    }
    cell.bookGenreLabel.text = myReadingList[indexPath.row].bookGenere
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    currentBook = myReadingList[indexPath.row].bookTitle
    currentSummary = myReadingList[indexPath.row].bookContent
    currentImage = myReadingList[indexPath.row].coverBook
    currentAuthor = myReadingList[indexPath.row].authorName
    currentGenre = myReadingList[indexPath.row].bookGenere
    performSegue(withIdentifier: "myBooks", sender: nil)
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationVC = segue.destination as? BookDetailsVC {
      destinationVC.bookTitle = currentBook
      //      destinationVC.genre = category!
      destinationVC.cover = currentImage
      destinationVC.author = currentAuthor
      destinationVC.bookContent = currentSummary
    }
  }
  
  
  func readReadingList(){
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    db.collection("users").document(userID!).collection("ReadingList").getDocuments { Snapshot, error in
      if error == nil {
        myReadingList.removeAll()
        guard let data = Snapshot?.documents else {return}
        for bookInfo in data {
          myReadingList.append(ReadingList(coverBook: bookInfo.get("coverBook") as! String,
                                                authorName: bookInfo.get("authorName") as! String,
                                                bookTitle: bookInfo.get("bookTitle") as! String,
                                                bookGenere: bookInfo.get("bookGenere") as! String,
                                                bookContent: bookInfo.get("bookContent") as! String,
                                                bookId: bookInfo.get("bookId") as! String
                                               ))
          print("\n\n* * * \(bookInfo.get("authorName")!) * * *")
        }
        self.tableView.reloadData()
      }
    }
  }
}




