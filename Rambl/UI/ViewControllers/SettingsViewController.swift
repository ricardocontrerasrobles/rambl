//
//  SettingsViewController.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsViewController: BaseViewController
{
    @IBOutlet weak var statusInput: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    internal var viewModel: SettingsViewModel?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func getBaseViewModel() -> BaseViewModel?
    {
        return viewModel
    }
    
    @IBAction func dismiss(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changeImage(_ sender: Any)
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let status = textField.text
        {
            SettingsViewModel.save(status: status)
        }
        return true
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.userImage.image = pickedImage
            self.viewModel?.upload(image: pickedImage)
        }
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UINavigationControllerDelegate
{
}

private extension SettingsViewController
{
    func setup()
    {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        statusInput.delegate = self
        statusInput.placeholder = SettingsViewModel.getStatus()
        if let imageURLString = viewModel?.userImageURL(), let userImageURL = URL(string: imageURLString)
        {
            userImage.sd_setImage(with: userImageURL)
        }
    }
}
