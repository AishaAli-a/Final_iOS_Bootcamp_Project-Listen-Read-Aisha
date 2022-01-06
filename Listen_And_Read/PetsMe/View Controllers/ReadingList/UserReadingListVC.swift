//
//  UserReadingListVC.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/2/22.
//

import UIKit




private let reuseIdentifier4 = String(describing: BookListCell.self)
var count = 0 

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return readingList.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier4 , for: indexPath) as! BookListCell

      cell.bookAuthorName.text = readingList[indexPath.row].authorName
      cell.bookTitleLabel.text = readingList[indexPath.row].bookTitle

    DispatchQueue.global().async{
      let data = try? Data(contentsOf: URL(string: readingList[indexPath.row].coverBook)!)

      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          cell.bookCoverImage?.image = image
          cell.bookCoverImage?.contentMode = .scaleToFill

        }
      }
    }
    cell.bookGenreLabel.text = readingList[indexPath.row].bookGenere
      return cell
    }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


//    currentSummary = booksData[indexPath.row].txtLink

    currentBook = readingList[indexPath.row].bookTitle
    currentSummary = readingList[indexPath.row].bookContent
    currentImage = readingList[indexPath.row].coverBook
    currentAuthor = readingList[indexPath.row].authorName
    currentGenre = readingList[indexPath.row].bookGenere
    performSegue(withIdentifier: "showContent", sender: nil)
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationVC = segue.destination as? BookDetailsVC {
      destinationVC.bookTitle = currentBook
      destinationVC.genre = currentGenre
      destinationVC.cover = currentImage
      destinationVC.author = currentAuthor
      destinationVC.summary = currentSummary
      


    }
  }
  
}
    

    

