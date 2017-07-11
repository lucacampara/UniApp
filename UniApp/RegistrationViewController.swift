//
//  RegistrationViewController.swift
//  UniApp
//
//  Created by Luca Campara on 26/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import MaterialComponents.MDCActivityIndicator

class RegistrationViewController: UIViewController, chiamateAPIDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailRegistrationTextField: UITextField!
    @IBOutlet weak var repeatPasswordRegistrationTextField: UITextField!
    @IBOutlet weak var passwordRegistrationTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!

    var gestoreChiamate = ChiamateAPI()
    var activityIndicator = MDCActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailRegistrationTextField.delegate = self
        passwordRegistrationTextField.delegate = self
        repeatPasswordRegistrationTextField.delegate = self
        
        gestoreChiamate.delegate = self
        
        let w = self.view.frame.size.width/2 - 60
        let h = self.view.frame.size.height/2 - 60
        activityIndicator = MDCActivityIndicator(frame: CGRect(x: w, y: h, width: 120, height: 120))
        activityIndicator.cycleColors = [UIColor.white]
        view.addSubview(activityIndicator)
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        if nextTag == 4 {
            self.view.endEditing(true)
        }
        
        return false // We do not want UITextField to insert line-breaks.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setMessage(message: String) {
        DispatchQueue.main.async {
            self.messageLabel.text = message
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.resetMessage), userInfo: nil, repeats: false)
        }
    }
    
    func resetMessage() {
        DispatchQueue.main.async {
            self.messageLabel.text = ""
        }
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
        
        if (emailRegistrationTextField.text?.characters.count)! > 0 && (passwordRegistrationTextField.text?.characters.count)! > 0 && (repeatPasswordRegistrationTextField.text?.characters.count)! > 0 {
            
            if  passwordRegistrationTextField.text == repeatPasswordRegistrationTextField.text {
                
                if Utils.internetAvailable() {
                    activityIndicator.startAnimating()
                    gestoreChiamate.richiestaAutenticazionePOST(email: emailRegistrationTextField.text!, password: passwordRegistrationTextField.text!, scelta: .SIGNUP)
                } else {
                    self.setMessage(message: "Nessuna connessione Internet")
                }
                print("ok password")
            } else {
                print("password failed")
                self.setMessage(message: "Le password inserite non corrispondono")
            }
        } else {
            self.setMessage(message: "Inserisci tutti i campi")
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func registra(access_token: String, id: String, errore: Bool, tipoErrore: String) {
        activityIndicator.stopAnimating()
        print("risposta",access_token,id,errore,tipoErrore)
        
        if errore {
            self.setMessage(message: tipoErrore)
        } else {
            loginOk(token: access_token)
        }
    }
    
    func loginOk(token: String) {
        // salvo il token nelle preferences
        UserDefaults.standard.set(token, forKey: ViewController.USER_TOKEN)
        
        DispatchQueue.main.async {
            // apro la home
            self.performSegue(withIdentifier: "showHome", sender: self)
        }
    }
    
    func validitaToken(validita: Bool) {
        print(validita)
    }

}
