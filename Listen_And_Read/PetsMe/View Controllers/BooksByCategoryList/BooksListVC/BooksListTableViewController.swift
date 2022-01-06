//
//  BooksListTableViewController.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/25/21.
//

import UIKit

private let reuseIdentifier2 = String(describing: BookListCell.self)

class BooksListTableViewController: UITableViewController, BookMangerDelegate {
  
  var vSpinner : UIView?
  var category: String?
  var apiUrl : URL?
  var articles: Array<Dictionary<String,Any>> = [];
  var pageNumber = 1
  var isDataLoading = false
  var booksManager = BookManager()
  var booksData = [Books]()
  var nextLink : String?
  var fetchMore = false
  
  var currentBook: String = ""
  var currentGenre: String = ""
  var currentAuthor: String = ""
  var currentSummary: String = ""
  var currentImage: String = ""
  
  
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .cmWhite
    searchBar.delegate = self
    searchBar.placeholder = "Search Books"
    
    let nib2 = UINib(nibName: reuseIdentifier2, bundle: nil)
    
    tableView.register(nib2, forCellReuseIdentifier: reuseIdentifier2)
    booksManager.delegate = self
    self.showSpinner(onView: self.view)
    booksManager.fetchBookByCategory(category: category!)
  }
  
  
  //MARK: - Load More books
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    
    if offsetY > contentHeight - scrollView.frame.height {
      if !fetchMore
      {
        beginBatchFetch()
      }
    }
  }
  
  
  func beginBatchFetch ()
  {
    fetchMore = true
    print("beginfetch")
    self.showSpinner(onView: self.view)
    booksManager.nextBooks(urlString: nextLink!)
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return booksData.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath)as!BookListCell
    cell.bookAuthorName.text = booksData[indexPath.row].authorname
    cell.bookTitleLabel.text = booksData[indexPath.row].title
    
    DispatchQueue.global().async{
      let data = try? Data(contentsOf: URL(string: self.booksData[indexPath.row].imageLink)!)
      
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          cell.bookCoverImage?.image = image
          cell.bookCoverImage?.contentMode = .scaleToFill
          
        }
      }
    }
    
    
    cell.bookGenreLabel.text = category
    

    
    print("~~ Formats Image: \(String(describing: booksData[indexPath.row].format))\n\n\n\n")

    return cell
  }
  
  
  // MARK: - Books Delegte - show books depend on the category or search
  
  func didUpdateBook(_ bookManager: BookManager, _ books: [Books], _ nextUrl: BookModel) {
    
    fetchMore = false
    booksData.append(contentsOf: books)
    nextLink = nextUrl.next
    removeSpinner()
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
}

extension BooksListTableViewController{
  
  func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style:.large )
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
  }
  func removeSpinner() {
    DispatchQueue.main.async {
      self.vSpinner?.removeFromSuperview()
      self.vSpinner = nil
    }
  }
}


extension BooksListTableViewController : UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text
    {
      booksManager.SearchBookByCategory(category: category!, search: searchText)
    }
    
    searchBar.text = ""
    fetchMore = true
    booksData.removeAll()
    self.searchBar.endEditing(true)
    self.searchBar.layer.borderColor = UIColor.clear.cgColor
    self.showSpinner(onView: self.view)
    
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.layer.borderColor = UIColor.cmWhite.cgColor
    self.searchBar.layer.borderWidth = 6
    
  }
  
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


//    currentSummary = booksData[indexPath.row].txtLink

    currentBook = booksData[indexPath.row].title
    currentSummary = booksData[indexPath.row].format
    currentImage = booksData[indexPath.row].imageLink
    currentAuthor = booksData[indexPath.row].authorname
    performSegue(withIdentifier: "show", sender: nil)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationVC = segue.destination as? BookDetailsVC {
      destinationVC.bookTitle = currentBook
      destinationVC.genre = category!
      destinationVC.cover = currentImage
      destinationVC.author = currentAuthor
      destinationVC.summary = currentSummary
      
    }
  }
}

