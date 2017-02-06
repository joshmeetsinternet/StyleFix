//
//  ViewController.swift
//  Style Fix
//
//  Created by Vidamo on 23/11/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var btnFb: UIButton!

  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.backgroundColor = UIColor.clear

  }
  
  override func viewDidLayoutSubviews() {
      
  }
  
  // MARK : - Actions
  
  @IBAction func didPressFb(_ sender: Any) {
      let loginManager = FBSDKLoginManager()
      loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
          
          if let e = error {
              print(e.localizedDescription)
          } else if let r = result, r.isCancelled {
              print(r)
          } else {
              if let r = result, r.grantedPermissions.contains("email") {
                  self.returnUserData()
              } else {
                  showAlert(inController: self, title: nil, message: "Email is required")
              }
          }
      }
  }
  
  func returnUserData() {
      let bgView = UIView(frame: self.view.bounds)
      bgView.backgroundColor = UIColor.flatBlack
      bgView.alpha = 0.5
      let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
      indicator.center = bgView.center
      bgView.addSubview(indicator)
      indicator.startAnimating()
      self.view.window?.addSubview(bgView)
      
      let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,email,name,picture.type(large),gender,locale,location"])
      graphRequest.start(completionHandler: { (connection, result, error) -> Void in
          
          bgView.removeFromSuperview()
          if ((error) != nil) {
              showAlert(inController: self, title: nil, message: error?.localizedDescription)
          } else if let r = result {
              self.register(withResult: r)
          }
      })
  }
  
  func register(withResult result: Any) {
    let bgView = UIView(frame: self.view.bounds)
    bgView.backgroundColor = UIColor.flatBlack
    bgView.alpha = 0.5
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    indicator.center = bgView.center
    bgView.addSubview(indicator)
    indicator.startAnimating()
    self.view.window?.addSubview(bgView)
    
    bgView.removeFromSuperview()
    
    performSegue(withIdentifier: "segueUser", sender: self)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? UserViewController {

    }
  }
}

