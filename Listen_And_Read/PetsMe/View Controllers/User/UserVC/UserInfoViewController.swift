//
//  UserInfoViewController.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/18/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseCore
import FirebaseStorage


class UserInfoViewController: UIViewController, UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate{
  
  
  
  var username: String = ""
  let db = Firestore.firestore()
  private let storage = Storage.storage().reference()

  let user = Auth.auth().currentUser
  
  let storge = Storage.storage()
  
  
  lazy var profileImage: UIImageView = {
    
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.cmOrange3
    view.layer.cornerRadius = 25
    view.isUserInteractionEnabled = true
//    view.contentMode = .scaleAspectFill
    
    return view
  }()
  
  
  lazy var imagePicker : UIImagePickerController = {
    $0.delegate = self
    $0.sourceType = .photoLibrary
    $0.allowsEditing = true
    
    return $0
  }(UIImagePickerController())
  
  
  let name : UILabel = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = NSLocalizedString("Name", comment: "")
    $0.layer.cornerRadius = 15
    $0.textAlignment = .center
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 23)
    
    return $0
  }(UILabel())
  
  
//  let changeLanguage : UIButton = {
//
//    $0.translatesAutoresizingMaskIntoConstraints = false
//    $0.layer.cornerRadius = 15
//    $0.setTitle(NSLocalizedString("change", comment: ""), for: .normal)
//    $0.setTitleColor( .black, for: .normal)
//    $0.addTarget(self, action: #selector(btnChangeLangauge), for: .touchUpInside)
//    return $0
//  }(UIButton())
  
  
  let shareApp : UIButton = {
    let shareApp = UIButton()
    //          shareApp.backgroundColor = UIColor(red: 216/255, green: 198/255, blue: 174/255, alpha: 1)
    shareApp.translatesAutoresizingMaskIntoConstraints = false
    shareApp.layer.cornerRadius = 15
    shareApp.setTitle(NSLocalizedString("share", comment: ""), for: .normal)
    shareApp.setTitleColor(.black, for: .normal)
    shareApp.addTarget(self, action: #selector(shareTheApp), for: .touchUpInside)
    
    return shareApp
  }()
  
  
  var signOutButton : UIButton = {
    let signOutButton = UIButton()
    //    signOutButton.backgroundColor = UIColor(red: 216/255, green: 198/255, blue: 174/255, alpha: 1)
    signOutButton.translatesAutoresizingMaskIntoConstraints = false
    signOutButton.layer.cornerRadius = 15
    signOutButton.tintColor = .white
    signOutButton.setTitleColor(.white, for: .normal)
    signOutButton.backgroundColor = .cmOrange3
    
    signOutButton.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)
    //    signOutButton.addTarget(self, action: #selector(shareTheApp), for: .touchUpInside)
    
    return signOutButton
  }()
  
  
  
  @objc func shareTheApp(sender:UIView){
    
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let textToShare = "Check out my app"
    //Enter the link app here
    if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {
      let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
      //Excluded Activities
      activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
      
      activityVC.popoverPresentationController?.sourceView = sender
      self.present(activityVC, animated: true, completion: nil)
    }
    
  }
  
  
  @objc func btnChangeLangauge() {
    
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
        print("Settings opened: \(success)")
      })
    }
  }
  
  
  
  @objc func OpenImage(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.editedImage] ?? info [.originalImage] as? UIImage ?? ""

    
    dismiss(animated: true)
    
    picker.dismiss(animated: true, completion: nil)
    profileImage.image = image as? UIImage
    

    guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
        return
    }//get byte from the data out of it
    //we are not uploading the image we are uploading the bytes for that image
      guard let imagData = image.pngData() else {
       return
      }
      guard let currentUser = user else {return}
      let imageName = currentUser.uid
      storage.child("images/\(imageName).png").putData(imagData,
                           metadata: nil,
                           completion: { _, error in
       guard error == nil else {
        print ("Fieled")
        return
       }
       self.dismiss(animated: true, completion: nil)
      })
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    name.resignFirstResponder()
    
    return true
  }
  
  
  //MARK: - VIEWDIDLOAD
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.profileImage.contentMode = .scaleToFill

    loadImage()
    loadUserInfo()

  
    
    Utilities.styleUILabel(name)
    //          setupGradientView3()
    //    self.title = NSLocalizedString("profile", comment: "")
    view.backgroundColor = UIColor.cmWhite
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    profileImage.addGestureRecognizer(tapRecognizer)
    
    
    profileImage.addGestureRecognizer(tapRecognizer)
    profileImage.image = .init(systemName: "455")
    profileImage.tintColor = UIColor(ciColor: .black)
    profileImage.layer.masksToBounds = true
    profileImage.layer.cornerRadius = 100
    profileImage.contentMode = .scaleAspectFit
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(profileImage)
    NSLayoutConstraint.activate([
      profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      profileImage.heightAnchor.constraint(equalToConstant: 200),
      profileImage.widthAnchor.constraint(equalToConstant: 200)
    ])
    
    view.addSubview(name)
    NSLayoutConstraint.activate([
      name.topAnchor.constraint(equalTo: view.topAnchor,constant: 470),
      name.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 80),
      name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
      name.heightAnchor.constraint(equalToConstant: 40),
      name.widthAnchor.constraint(equalToConstant: 290),
      
    ])
    
//    view.addSubview(changeLanguage)
//    NSLayoutConstraint.activate([
//      changeLanguage.topAnchor.constraint(equalTo: view.topAnchor, constant: 540),
//      changeLanguage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
//      changeLanguage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
//      changeLanguage.heightAnchor.constraint(equalToConstant: 40),
//
//    ])
    
    view.addSubview(shareApp)
    NSLayoutConstraint.activate([
      shareApp.topAnchor.constraint(equalTo: view.topAnchor, constant: 610),
      shareApp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
      shareApp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
      shareApp.heightAnchor.constraint(equalToConstant: 40),
    ])
    
    view.addSubview(signOutButton)
    NSLayoutConstraint.activate([
      signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 680),
      signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
      signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
      signOutButton.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    //    profileImage.addSubview(tapHere)
    //    NSLayoutConstraint.activate([
    //      tapHere.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 90),
    //      // tapHere.rightAnchor.constraint(equalTo: profileImage.rightAnchor, constant: -40),
    //      tapHere.leftAnchor.constraint(equalTo: profileImage.leftAnchor, constant: 60),
    //      tapHere.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor)
    //    ])
  }
  func loadImage() {
    let user = Auth.auth().currentUser
    print(user?.uid)
    guard let currentUser = user else{return}
    let pathReference = storge.reference(withPath: "images/\(currentUser.uid).png")
    pathReference.getData(maxSize: 1000 * 1024 * 1024) { data, error in
     if let error = error {
      // Uh-oh, an error occurred!
      print(error)
     } else {
      // Data for “images/island.jpg” is returned
      let image = UIImage(data: data!)
      self.profileImage.image = image
     }
    }
   }
  
  func loadUserInfo(){
    
    
    let user = Auth.auth().currentUser
    print(user?.uid as Any)
      if let currentUser = user {
       db.collection("users").document(currentUser.uid).getDocument { doc , err in
        if err != nil {
         print(err!)
        }
        else{
         let data = doc!.data()!
         self.username = data["name"] as! String
         print("\n\n* * * DATA : \(data)")
         self.name.text = self.username
        }
       }
      }
  }
  
  @objc func imageTapped() {
    print("Image Tapped")
    present(imagePicker, animated: true)
  }
}



