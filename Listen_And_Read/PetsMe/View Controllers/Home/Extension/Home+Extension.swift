//
//  Home+Extension.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/21/22.
//

import UIKit



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
      

      
      cellA.bookOfTheDayLabel.text = RecoBooks.randomElement()?.bookTitle
      randomimage = RecoBooks.randomElement()?.coverBook
      print("\n\n* * * I AM HERE AISHA : \(String(describing: randomimage)) * * * * * * * *\n\n")


      
      
      cellA.bookOfTheDay_View.layer.cornerRadius = 20
      DispatchQueue.global().async{
//        let data = try? Data(contentsOf: URL(string: RecoBooks.randomElement()!.coverBook)!)
//        
//        if let data = data, let image = UIImage(data: data) {
//          DispatchQueue.main.async {
//            cellA.bookOfTheDayImage?.image = image
//            cellA.bookOfTheDayImage?.contentMode = .scaleToFill
//            
//          }
//        }
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
      
      let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "BookInfoViewController") as! BookDetailsVC
      
      
      destinationVC.bookTitle = bookOfTheDay[indexPath.row].bookTitle
      destinationVC.bookContent = bookOfTheDay[indexPath.row].bookContent
      destinationVC.cover  = bookOfTheDay[indexPath.row].coverBook
      destinationVC.author = bookOfTheDay[indexPath.row].authorName
      destinationVC.genre = bookOfTheDay[indexPath.row].bookGenere
      print("# # # # # # # # # # ## # \(destinationVC.genre)# # #")
      
      performSegue(withIdentifier: "show_detail", sender: nil)
    }
  }
  
  // MARK: - Cell LayOut
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
    
    let totalMarginBetweenCells:CGFloat = marginsBetweenCells * (numberOfHorizantalCells - 1)
    
    let marginPerCell:CGFloat = totalMarginBetweenCells / numberOfHorizantalCells
    
    let frameWidth:CGFloat = 1400
    let cellWidth = (frameWidth/numberOfHorizantalCells) - marginsBetweenCells
    
    let cellHeight = cellWidth
    
    layout.minimumLineSpacing = marginPerCell
    layout.minimumInteritemSpacing = 0
    layout.estimatedItemSize = .zero
    layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
  }
}

