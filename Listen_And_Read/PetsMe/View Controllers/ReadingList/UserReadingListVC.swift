//
//  UserReadingListVC.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/2/22.
//

import UIKit




private let reuseIdentifier3 = String(describing: BookListCell.self)

class UserReadingListVC: UITableViewController {



    override func viewDidLoad() {
        super.viewDidLoad()

      self.view.backgroundColor = .cmWhite
      
      let nib2 = UINib(nibName: reuseIdentifier3, bundle: nil)
      
      tableView.register(nib2, forCellReuseIdentifier: reuseIdentifier3)
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

      let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier3 , for: indexPath) as! BookListCell

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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
