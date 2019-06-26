//
//  AddUserViewController.swift
//  UserProject
//
//  Created by Igor Baric on 4/17/19.
//  Copyright © 2019 ItFusion. All rights reserved.
//

import UIKit

protocol AddUserViewControllerDelegate : AnyObject {
    func addUserViewControllerDidSaveUser(user: User!)
    func addUserViewControllerDidSaveAccount(account: Account!)
}

class AddUserViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldAdress: UITextField!
    @IBOutlet weak var textFieldAge: UITextField!
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    @IBOutlet weak var textImageView: UIImageView!
    
    weak var delegate: AddUserViewControllerDelegate?
    var savedUser : User?
    var userToEdit : User?
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldFirstName.delegate = self
        textFieldLastName.delegate = self
        textFieldAge.delegate = self
        textFieldAdress.delegate = self
        textFieldEmail.delegate = self
        
        if let userEdit = userToEdit {
            textFieldFirstName.text = userEdit.firstName
            textFieldLastName.text = userEdit.lastName
            textFieldEmail.text = userEdit.email
            textFieldAdress.text = userEdit.adress
            textFieldAge.text = userEdit.age
        }
    }
    
    
    @IBAction func onButtonClickImage(_ sender: Any) {
        let myActionSheet =  UIAlertController(title: "Izaberite opciju", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        myActionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (ACTION :UIAlertAction!)in
            //      ACTION
            
            self.showNotSupportedAlert(message: "Sorry,can't access camera")
        }))
        myActionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (ACTION :UIAlertAction!)in
            //     ACTION
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
            
        }))
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

    func showNotSupportedAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
        
    @IBAction func onButtonClickSave(_ sender: Any) {
        let firstName = textFieldFirstName.text!.count > 0 ? textFieldFirstName.text : nil
        let lastName = textFieldLastName.text!.count > 0 ? textFieldLastName.text : nil
        let email = textFieldEmail.text!.count > 0 ? textFieldEmail.text : nil
        let adress = textFieldAdress.text!.count > 0 ? textFieldAdress.text : nil
        let age = textFieldAge.text!.count > 0 ? textFieldAge.text : nil
        
        
        savedUser = User.init(firstName: firstName, lastName: lastName, email: email, adress: adress, age: age)
        if (savedUser?.fullName() != nil){
            if let userEdit = userToEdit {
                userEdit.firstName = textFieldFirstName.text
                userEdit.lastName = textFieldLastName.text
                userEdit.adress = textFieldAdress.text
                userEdit.email = textFieldEmail.text
                userEdit.age = textFieldAge.text
                //  userEdit.profilImage = imageViewProfilePicture.image
                let account = Account.init(userEdit, nil)
                //                delegate?.addUserVCDidSaveUser(user: userEdit)
                delegate?.addUserViewControllerDidSaveAccount(account: account)
                userToEdit = nil
            } else {
                let account = Account.init(savedUser, nil)
                delegate?.addUserViewControllerDidSaveAccount(account: account)
                //                delegate?.addUserVCDidSaveUser(user: savedUser)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        textImageView.image = image
    }
    
    
}


