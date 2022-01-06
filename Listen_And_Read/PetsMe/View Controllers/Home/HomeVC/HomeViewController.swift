//
//  Home Screen.swift
//  SignIn_ProtoType
//
//  Created by Aisha Ali on 11/27/21.
//

import Foundation
import UIKit
//LabelCell
private let reuseIdentifier2 = String(describing: LabelCell.self)
private let reuseIdentifier3 = String(describing: BookListCell.self)
class Home: UIViewController{
  
  
  var currentBook: String = ""
  var currentGenre: String = ""
  var currentAuthor: String = ""
  var currentSummary: String = ""
  var currentImage: String = ""
  
  
  let bookOfTheDay = [
    AddToReadingList(coverBook: "http://www.gutenberg.org/cache/epub/74/pg74.cover.medium.jpg", authorName: "Mark Twain", bookTitle: "The Adventures of Tom Sawyer", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/74/74-0.txt"),

    AddToReadingList(coverBook: "http://www.gutenberg.org/cache/epub/76/pg76.cover.medium.jpg", authorName: "Mark Twain", bookTitle: "Adventures of Huckleberry Finn", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/76/76-0.txt"),

    AddToReadingList(coverBook: "http://www.gutenberg.org/cache/epub/421/pg421.cover.medium.jpg", authorName: "Robert Louis Stevenson", bookTitle: "Kidnapped", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/421/421-0.txt"),

    AddToReadingList(coverBook: "http://www.gutenberg.org/cache/epub/1480/pg1480.cover.medium.jpg", authorName: "Thomas Hughes", bookTitle: "Tom Brown\'s School Days", bookGenere: "Fiction", bookContent: "http://www.gutenberg.org/files/1480/1480-0.txt")

  ]
  
  
  var categoryIndex = [0,1,2,3,4,5,6,7,8,9]
  var category : String?

  
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var continuousReading: UIStackView!
  
  @IBOutlet weak var bookImage: UIImageView!
  @IBOutlet weak var numberOFBooks: UILabel!
  @IBOutlet weak var categoriesCollection: UICollectionView!
  @IBOutlet weak var bookOfTheDayCollection: UICollectionView!
  

  
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let nib2 = UINib(nibName: reuseIdentifier2, bundle: nil)
    categoriesCollection.register(nib2, forCellWithReuseIdentifier: reuseIdentifier2)
    configureSize(numberOfHorizantalCells: 4, marginsBetweenCells: 20)
    continuousReading.isHidden = true
  
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = false
    print("\n\n***********\(count)\n\n")

    if readingList.count != 0{
      continuousReading.isHidden = false
      numberOFBooks.text = "\(readingList.count) Books in your list "
    }

    UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
         self.bookImage.image = UIImage(named: "History")
        self.bookImage.frame.origin.y -= 25

     })
    
  }
  
}
  


//MARK: - Home Extension

extension Home: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView == self.bookOfTheDayCollection {
      return bookOfTheDay.count
      
    } else {
      return bookByCtegory.count
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == self.bookOfTheDayCollection {
      
      let cellA = bookOfTheDayCollection.dequeueReusableCell(withReuseIdentifier: "BookOfTheDayCell", for: indexPath) as! BookOfTheDayCell

      cellA.bookOfTheDayLabel.text = "\(bookOfTheDay[indexPath.row].bookTitle)"
      
      cellA.bookOfTheDay_View.layer.cornerRadius = 20
      DispatchQueue.global().async{
        let data = try? Data(contentsOf: URL(string: self.bookOfTheDay[indexPath.row].coverBook)!)
        
        if let data = data, let image = UIImage(data: data) {
          DispatchQueue.main.async {
            cellA.bookOfTheDayImage?.image = image
            cellA.bookOfTheDayImage?.contentMode = .scaleToFill
            
          }
        }
      }
      return cellA
      
    } else {
      
      let cellB = categoriesCollection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! LabelCell
      cellB.categorize.image = UIImage(named:  bookByCtegory[indexPath.row].myImages)
      cellB.titlleLabel.text = "\(bookByCtegory[indexPath.row].name)"
      cellB.categorize.layer.cornerRadius = 20
      return cellB
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if collectionView == self.categoriesCollection {
      switch categoryIndex[indexPath.row] {
      case 0:
        category = "Fiction"
      case 1:
        category = "Drama"
      case 2:
        category = "Humor"
      case 3:
        category = "Politics"
      case 4:
        category = "Philosophy"
      case 5:
        category = "History"
      case 6:
        category = "Adventure"
      case 7:
        category = "Mystory"
      case 8:
        category = "Romance"
      case 9:
        category = "Novel"
        
      default:
        category = "Fiction"
      }
      
      let backItem = UIBarButtonItem()
      backItem.title = category
      navigationItem.backBarButtonItem = backItem
      let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "BooksListTableViewController") as! BooksListTableViewController
      secondViewController.category =  category
      
      self.navigationController?.pushViewController(secondViewController, animated: true)
    } else {
      currentBook = bookOfTheDay[indexPath.row].bookTitle
      currentSummary = bookOfTheDay[indexPath.row].bookContent
      currentImage = bookOfTheDay[indexPath.row].coverBook
      currentAuthor = bookOfTheDay[indexPath.row].authorName
      currentGenre = bookOfTheDay[indexPath.row].bookGenere
      
      
    }
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
    
    
  
  
  
  func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
      return layout.itemSize
      
    }else{
      
      return .zero
    }
  }
  
  
  
  func configureSize (numberOfHorizantalCells: CGFloat, marginsBetweenCells:CGFloat){
    
    guard let layout = categoriesCollection.collectionViewLayout as? UICollectionViewFlowLayout else {
      
      return
    }
    
    print("\n\n\(#file) - \(#function)\n\n")
    
    //*** Cell Spacing
    
    let totalMarginBetweenCells:CGFloat = marginsBetweenCells * (numberOfHorizantalCells - 1)
    print(" - totalMarginBetweenCells: \(totalMarginBetweenCells)")
    
    let marginPerCell:CGFloat = totalMarginBetweenCells / numberOfHorizantalCells
    print(" - marginPerCell: \(marginPerCell)")
    
    
    let frameWidth:CGFloat = 1400
    
    //    let frameWidth:CGFloat = 400
    print(" - frameWidth: \(frameWidth)")
    
    let cellWidth = (frameWidth/numberOfHorizantalCells) - marginsBetweenCells
    
    print(" - cellWidth: \(cellWidth)")
    
    let cellHeight = cellWidth
    
    layout.minimumLineSpacing = marginPerCell
    layout.minimumInteritemSpacing = 0
    
    
    layout.estimatedItemSize = .zero
    layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    print(" - layout.itemSize: \(layout.itemSize)")
    
    
  }
}
