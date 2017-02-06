//
//  UserViewController.swift
//  Style Fix
//
//  Created by Vidamo on 9/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var phoneTextField: UITextField!
  @IBOutlet var btnSave: UIBarButtonItem!
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    imageView.layer.cornerRadius = imageView.frame.width / 2
    imageView.layer.masksToBounds = true
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
  // MARK: - UITextField
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let r = textField.text?.rangeFromNSRange(nsRange: range) {
      let currentString = textField.text!.replacingCharacters(in: r, with: string)
      let length = currentString.characters.count
      if (length > 12) {
        return false
      }
    }
    
    if let _ = string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) {
      return false
    }
    
    return true
  }
  
  @IBAction func didPressSave(_ sender: Any) {
    performSegue(withIdentifier: "segueMain", sender: self)
  }
  
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
