//
//  Settings.swift
//  DrawPad
//
//  Created by Betina Kreiman on 4/22/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

//import Foundation
import UIKit

class Settings: UIViewController {
  
  @IBOutlet weak var backButtonOutlet: UIButton!
  @IBOutlet weak var shareButtonOutlet: UIButton!
  
  @IBOutlet weak var mnistLabel: UILabel!
  @IBOutlet weak var mnistSwitch: UISwitch!
  
  
  @IBOutlet weak var fashionMnistLabel: UILabel!
  @IBOutlet weak var fashionMnistSwitch: UISwitch!
  
  @IBOutlet weak var googleDrawLabel: UILabel!
  @IBOutlet weak var googleDrawSwitch: UISwitch!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  

  
  var imageView = UIImageView()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if ViewController.modelIndex == 0 {
      mnistSwitch.isOn = true
      fashionMnistSwitch.isOn = false
    } else if ViewController.modelIndex == 2 {
      fashionMnistSwitch.isOn = false
      googleDrawSwitch.isOn = true
    }
    
    descriptionTextView.center.x = ViewController.screenWidth / 2
    descriptionTextView.center.y = ViewController.screenHeight * 0.33
    
    mnistLabel.center.x = ViewController.screenWidth * 0.35
    mnistLabel.center.y = ViewController.screenHeight * 0.6
    mnistSwitch.center.x = ViewController.screenWidth * 0.78
    mnistSwitch.center.y = mnistLabel.center.y
    
    fashionMnistLabel.center.x = mnistLabel.center.x
    fashionMnistLabel.center.y = ViewController.screenHeight * 0.68
    fashionMnistSwitch.center.x  = mnistSwitch.center.x
    fashionMnistSwitch.center.y = fashionMnistLabel.center.y
    
    googleDrawLabel.center.x = mnistLabel.center.x
    googleDrawLabel.center.y = ViewController.screenHeight * 0.76
    googleDrawSwitch.center.x  = mnistSwitch.center.x
    googleDrawSwitch.center.y = googleDrawLabel.center.y
  }
  
  
  @IBAction func sharePressed(_ sender: Any) {
    guard let image = imageView.image else {
      return
    }
    let activity = UIActivityViewController(activityItems: [image],
                                          applicationActivities: nil)
    present(activity, animated: true)
  }
  
  @IBAction func switchPressed(_ sender: UISwitch) {
    if sender.isOn == true {
      if sender.tag == 0 {
        fashionMnistSwitch.isOn = false
        googleDrawSwitch.isOn = false
        ViewController.modelIndex = 0
      } else if sender.tag == 1 {
        mnistSwitch.isOn = false
        googleDrawSwitch.isOn = false
        ViewController.modelIndex = 1
      } else {
        mnistSwitch.isOn = false
        fashionMnistSwitch.isOn = false
        ViewController.modelIndex = 2
      }
    } else {
      // making default fashion mnist
      fashionMnistSwitch.isOn = true
      ViewController.modelIndex = 1
    }
  }
  
}
