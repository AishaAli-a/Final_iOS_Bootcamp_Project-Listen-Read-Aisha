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

class Home: UIViewController{
  
  
  let searchBarController = UISearchController(searchResultsController: nil)
  var timer: Timer?
  
  var categoryIndex = [0,1,2,3,4,5,6,7,8,9]
  var category : String?
  
  
  
  @IBOutlet weak var categoriesCollection: UICollectionView!
  @IBOutlet weak var bookOfTheDayCollection: UICollectionView!
  
  let bookOfTheDay = [
    ImageDetails(myImages: "Alice’s Adventures in Wonderland", name: "Alice’s Adventures in Wonderland"),
    ImageDetails(myImages: "The Romance of a Pirate's Daughter", name: "The Romance of a Pirate's Daughter"),
    ImageDetails(myImages: "Peter and Wendy", name: "Peter and Wendy"),
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let nib2 = UINib(nibName: reuseIdentifier2, bundle: nil)
    categoriesCollection.register(nib2, forCellWithReuseIdentifier: reuseIdentifier2)
    configureSize(numberOfHorizantalCells: 4, marginsBetweenCells: 20)
    
    configureSearchBar()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = false
    searchBarController.searchBar.text = ""
    
  }
  
  //MARK: - SearchBar
  
  func configureSearchBar()  {
    
    navigationItem.searchController = searchBarController
    searchBarController.searchBar.placeholder = "Search Books"
    searchBarController.searchBar.enablesReturnKeyAutomatically = true
    navigationController?.navigationBar.tintColor = .cmOrange3
    
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
      
      cellA.bookOfTheDayImage.image = UIImage(named: bookOfTheDay[indexPath.row].myImages)
      cellA.bookOfTheDayLabel.text = "\(bookOfTheDay[indexPath.row].name)"
      cellA.bookOfTheDay_View.layer.cornerRadius = 20
      
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
      //  backItem.tintColor = .red
      
//      UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 20) ?? "Helvetica Neue "], for: .normal) // your textattributes here
      navigationItem.backBarButtonItem = backItem
      let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "BooksListTableViewController") as! BooksListTableViewController
      secondViewController.category =  category
      
      self.navigationController?.pushViewController(secondViewController, animated: true)
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
