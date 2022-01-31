//
//  UserInfoViewController.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/18/21.
//

import UIKit
import Firebase
import FirebaseStorage


class UserInfoViewController: UIViewController, UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate{
  
  
  
  var username: String = ""
  let db = Firestore.firestore()
  let user = Auth.auth().currentUser
  
  let storge = Storage.storage()
  
  
   var profileImage: UIImageView = {
    
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.cmOrange3
    $0.layer.cornerRadius = 100
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
    
    return $0
  }(UIImageView())
  
  
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
    $0.textColor = UIColor(named: "TextColor")
    $0.font = .boldSystemFont(ofSize: 30)
    
    return $0
  }(UILabel())
  
  
  let shareApp : UIButton = {
    let shareApp = UIButton()
    shareApp.translatesAutoresizingMaskIntoConstraints = false
    shareApp.layer.cornerRadius = 15
    shareApp.setTitle(NSLocalizedString("share", comment: ""), for: .normal)
    shareApp.setTitleColor(UIColor(named: "TextColor"), for: .normal)

    
    shareApp.titleLabel?.font = .boldSystemFont(ofSize: 30)

    shareApp.addTarget(self, action: #selector(shareTheApp), for: .touchUpInside)
    
    return shareApp
  }()
  
  
  var signOutButton : UIButton = {
    
    let signOutButton = UIButton()
    signOutButton.translatesAutoresizingMaskIntoConstraints = false
    signOutButton.layer.cornerRadius = 30
    signOutButton.tintColor = .white
    signOutButton.setTitleColor(.white, for: .normal)
    signOutButton.backgroundColor = UIColor(named: "Button")
    signOutButton.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)
    signOutButton.titleLabel?.font = .boldSystemFont(ofSize: 25)


    signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    
    return signOutButton
  }()
  

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    name.resignFirstResponder()
    
    return true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadImage()
    loadUserInfo()
  }
  
  
  //MARK: - VIEWDIDLOAD
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(named: "Dark Mode Color")
    layout()
  }
  
  
  //MARK: - LayOut
  func layout(){
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    profileImage.addGestureRecognizer(tapRecognizer)
    profileImage.addGestureRecognizer(tapRecognizer)
    profileImage.layer.cornerRadius = 100
    profileImage.layer.masksToBounds = true
    profileImage.contentMode = .scaleAspectFill
    
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
    
    
    view.addSubview(shareApp)
    NSLayoutConstraint.activate([
      shareApp.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30),
      shareApp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
      shareApp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
      shareApp.heightAnchor.constraint(equalToConstant: 40),
    ])
    
    view.addSubview(signOutButton)
    NSLayoutConstraint.activate([
      signOutButton.topAnchor.constraint(equalTo: shareApp.bottomAnchor, constant: 40),
      signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 304),
      signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -304),
      signOutButton.heightAnchor.constraint(equalToConstant: 68),
      signOutButton.widthAnchor.constraint(equalToConstant: 334)

    ])
    
  }
  
  func loadImage() {
    
    let user = Auth.auth().currentUser
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
    if let currentUser = user {
      db.collection("users").document(currentUser.uid).getDocument { doc , err in
        if err != nil {
          print(err!)
        }
        else{
          let data = doc!.data()!
          self.username = data["name"] as! String
          self.name.text = self.username
        }
      }
    }
  }
  
  //MARK: - upload image to storage

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    let image = info[.editedImage] ?? info [.originalImage] as? UIImage ?? ""
    dismiss(animated: true)
    
    picker.dismiss(animated: true, completion: nil)
    profileImage.image = image as? UIImage
    
    guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
      return
    }
    
    guard let imagData = image.pngData() else {return}
    guard let currentUser = user else {return}
    
    let imageName = currentUser.uid
    storge.reference().child("images/\(imageName).png").putData(imagData,
                                                     metadata: nil,
                                                     completion: { _, error in
      guard error == nil else {
        print ("Fieled")
        return
      }
      self.dismiss(animated: true, completion: nil)
    })
  }
  
  
  @objc func imageTapped() {
    present(imagePicker, animated: true)
  }
  
  //MARK: - SignOut
  @objc func signOut(){
    do{
      try Auth.auth().signOut()
    } catch let logouterror {
      print(logouterror)
    }
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "CheckIfLoggedInVC") as! CheckIfLoggedInVC
    vc.modalPresentationStyle = .fullScreen
    present(vc,animated:false,completion: nil)
  }
  
  //MARK: -  Share App
  @objc func shareTheApp(sender:UIView){
    
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let textToShare = "Check out my app"
    if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {
      let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
      activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
      
      activityVC.popoverPresentationController?.sourceView = sender
      self.present(activityVC, animated: true, completion: nil)
    }
  }
  
  //MARK: - OpenImage

  @objc func OpenImage(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
}

