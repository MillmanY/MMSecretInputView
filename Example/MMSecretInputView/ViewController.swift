//
//  ViewController.swift
//  SecretDemo
//
//  Created by MILLMAN on 2016/7/23.
//  Copyright © 2016年 MILLMAN. All rights reserved.
//

import UIKit
import MMSecretInputView
class ViewController: UIViewController {
    @IBOutlet weak var secretView:MMSecretInputView!
    @IBOutlet weak var checkTxtFiled:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkTxtFiled.text = "55555"
        secretView.completedBlock = { (value) in
            
            if(!self.checkEqual(value)) {
                self.secretView.setSecretLabelError({ 
                    self.showAlert("Actual Value is :\(self.checkTxtFiled.text!)")
                })
            } else {
                self.showAlert("Value Equal")
                self.secretView.clearAllText()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showAlert(title:String) {
        let alert = UIAlertView.init(title: title, message: nil, delegate: nil, cancelButtonTitle: "Confirm")
        alert.show()

    }
    
    func checkEqual(value:String) -> Bool {
        return value == checkTxtFiled.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

