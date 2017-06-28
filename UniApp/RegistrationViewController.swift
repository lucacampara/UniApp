//
//  RegistrationViewController.swift
//  UniApp
//
//  Created by Luca Campara on 26/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailRegistrationTextField: UITextField!
    @IBOutlet weak var repeatPasswordRegistrationTextField: UITextField!
    @IBOutlet weak var passwordRegistrationTextField: UITextField!
    
    @IBOutlet weak var registrationButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationButton.layer.cornerRadius = 5

        emailRegistrationTextField.layer.borderWidth = 1
        emailRegistrationTextField.layer.cornerRadius = 5
        emailRegistrationTextField.layer.borderColor = UIColor.white.cgColor
        emailRegistrationTextField.attributedPlaceholder = NSAttributedString(string: "email",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        passwordRegistrationTextField.layer.borderWidth = 1
        passwordRegistrationTextField.layer.cornerRadius = 5
        passwordRegistrationTextField.layer.borderColor = UIColor.white.cgColor
        passwordRegistrationTextField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                              attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        repeatPasswordRegistrationTextField.layer.borderWidth = 1
        repeatPasswordRegistrationTextField.layer.cornerRadius = 5
        repeatPasswordRegistrationTextField.layer.borderColor = UIColor.white.cgColor
        repeatPasswordRegistrationTextField.attributedPlaceholder = NSAttributedString(string: "ripeti password",
                                                                                 attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ACTIONS
    
    @IBAction func registrationButton(_ sender: Any) {
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

}
