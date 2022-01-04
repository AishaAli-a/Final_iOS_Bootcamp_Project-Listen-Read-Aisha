//
//  BookInfoViewController.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/27/21.
//

import UIKit
var readingList = [AddToReadingList] ()

class BookDetailsVC: UIViewController {
  
  @IBOutlet weak var bookCover_ImageView: UIImageView!
  @IBOutlet weak var bookTitle_Label: UILabel!
  @IBOutlet weak var bookAuthor_Label: UILabel!
  @IBOutlet weak var bookGenre_Label: UILabel!
  
  @IBOutlet weak var textField: UITextView!
  

  var bookTitle:String = ""
  var image:String = ""
  var author:String = ""
  var genre:String = ""
  var summary:String = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    textField.text = ""
    bookCover_ImageView.layer.cornerRadius = 20
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)    
    bookTitle_Label.text = bookTitle
    bookGenre_Label.text = genre
    bookAuthor_Label.text = author
    
    print("~~ \(self.summary)")
    
    //  MARK:  - Edit File get text and image from url
    

    
    DispatchQueue.global().async{
      let data = try? Data(contentsOf: URL(string: self.image)!)
      
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.bookCover_ImageView?.image = image
          self.bookCover_ImageView?.contentMode = .scaleToFill
          
        }
      }
    }
  }

  
  
  
  @IBAction func button_Pressed(_ sender: UIButton) {
    
    let new = AddToReadingList(coverBook: image, authorName: author, bookTitle: bookTitle, bookGenere: genre)
    readingList.append(new)

//    for a in readingList {
//      if new.coverBook == a.coverBook{
//        print("++++++++ can not add items\n\n\n\n\\n")
//
//      } else {
//
//      }
//
//    }

    
    print("*****_____\(new)\n\n\n\n\n\n\n\n\n\n\n**********************\n\n\n\n")
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisplayBookContentVC") as! DisplayBookContentVC
    
    
    if self.summary != "NA"{
  
        DispatchQueue.main.async {
          let textURL=URL(string: self.summary)!
          let textData=try? Data(contentsOf: textURL)
          let textFromURL = String(data: textData!, encoding: .utf8)!
          vc.bookContent.text = ""
          vc.bookContent.text = textFromURL
        }
      }
    vc.hidesBottomBarWhenPushed = true
    vc.modalPresentationStyle = .fullScreen
    
    self.navigationController?.pushViewController(vc, animated: true)

//    present(vc,animated: false, completion: nil)
    
    
  }
}


