//
//  ViewController.swift
//  UniApp
//
//  Created by Luca Campara on 21/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import MaterialComponents.MDCActivityIndicator

class ViewController: UIViewController, chiamateAPIDelegate, UITextFieldDelegate {
    
    static let USER_TOKEN = "USER_TOKEN"
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    var activityIndicator = MDCActivityIndicator()
    let gestoreChiamate = ChiamateAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        /*
        let prova = DatabaseRealm()
        var test = prova.ritornaArrayNews()
        var test1 = prova.ritornaArrayOrari()
        print(test,test1)
        */
        view.addSubview(activityIndicator)
        
        gestoreChiamate.delegate = self
        
        let w = self.view.frame.size.width/2 - 60
        let h = self.view.frame.size.height/2 - 60
        activityIndicator = MDCActivityIndicator(frame: CGRect(x: w, y: h, width: 120, height: 120))
        activityIndicator.cycleColors = [UIColor.white]
        view.addSubview(activityIndicator)
        
        /*let prova = ChiamateAPI()
        prova.delegate = self
        prova.delegateCaricamento = self
        prova.richiestaAutenticazionePOST(email: "jdfdsfds@sdfaf.it", password: "password", scelta: .SIGNUP)
        prova.richiesteDatiGET(access_token: "3252261a-215c-4078-a74d-2e1c5c63f0a1", scelta: .POSTS, pagina: 1)
        
        prova.richiesteDatiGET(access_token: "3252261a-215c-4078-a74d-2e1c5c63f0a1", scelta: .TIMETABLE, pagina: 0)*/
        
        //print("Access token \(AccessToken.current?.authenticationToken)")
        

        loginButton.layer.cornerRadius = 5
        facebookButton.layer.cornerRadius = 5
        
        let imageFacebook = UIImageView(image: UIImage(named: "FacebookLogo"))
        imageFacebook.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        imageFacebook.contentMode = .scaleAspectFill
        facebookButton.addSubview(imageFacebook)

        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                                 attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
    }
    
/*    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }*/
    
    
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
    
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
        print("BEGIN")
        if textField.isEqual(emailTextField) {
            //move the main view, so that the keyboard does not hide it.
            if  (self.view.frame.origin.y >= 0)
            {
                self.setViewMovedUp(movedUp: true)
            }
        }
    }
    
    func keyboardWillShow() {
        print("1")
        if self.view.frame.origin.y >= 0{
            self.setViewMovedUp(movedUp: true)
        }
        else if (self.view.frame.origin.y < 0)
        {
            self.setViewMovedUp(movedUp: false)
        }
    }
    
    func keyboardWillHide() {
        print("2")
        if self.view.frame.origin.y >= 0 {
            self.setViewMovedUp(movedUp: true)
        }
        else if (self.view.frame.origin.y < 0)
        {
            self.setViewMovedUp(movedUp: false)
        }
    }
    
    let kOFFSET_FOR_KEYBOARD: CGFloat = 200.0
    
    func setViewMovedUp(movedUp: Bool) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(3)
        
        var rect = self.view.frame
    
        if movedUp{
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            rect.size.height += kOFFSET_FOR_KEYBOARD;
        }
        else {
            // revert back to the normal state.
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
            rect.size.height -= kOFFSET_FOR_KEYBOARD;
        }
        self.view.frame = rect;
        
        UIView.commitAnimations()

    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("RETURN")
        
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
        
        if nextTag == 3 {
            self.view.endEditing(true)
        }
        
        return false // We do not want UITextField to insert line-breaks.
    }
    
    // MARK: - ACTIONS
    
    @IBAction func facebookLoginButton(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        var loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! \(accessToken.authenticationToken)")
                
                // facebook chiamata
                self.gestoreChiamate.richiestaTokenAFacebook(tokenDiFacebook: accessToken.authenticationToken)
            }
        }
    }
    
    func resetMessage() {
        DispatchQueue.main.async {
            self.messageLabel.text = "Accedi o registrati"
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {

        if (emailTextField.text?.characters.count)! > 0 && (passwordTextField.text?.characters.count)! > 0 {
            // Start animation
            activityIndicator.startAnimating()
            
            gestoreChiamate.richiestaAutenticazionePOST(email: emailTextField.text!, password: passwordTextField.text!, scelta: .LOGIN)
        } else {
            self.setMessage(message: "Inserisci tutti i campi")
        }
        
       /* var detailVC = NewsDetailViewController()
        detailVC.productTitle = "Titolo 1"
        detailVC.desc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec luctus, orci ut fermentum ultrices, nunc nisl iaculis erat, ornare ullamcorper dui nisi sed mi. Mauris non fringilla nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque eu orci et ante vestibulum tristique. Donec dapibus mi a quam blandit, at consectetur lectus elementum. Morbi aliquam rutrum nulla vel vulputate. Ut et tristique ipsum, sed ullamcorper risus. Mauris aliquet feugiat urna. Cras et laoreet tellus. Fusce consequat volutpat justo quis ornare. Sed augue orci, euismod nec augue vitae, condimentum malesuada nulla. Aenean hendrerit bibendum augue, in pharetra sem condimentum a. In hac habitasse platea dictumst. Donec auctor rutrum finibus. Vivamus eget tellus efficitur, vulputate ligula et, aliquet metus. Nunc et varius neque, at porttitor nunc. Suspendisse malesuada, risus et elementum faucibus, nisl lorem sollicitudin ipsum, quis gravida mi diam nec libero. Cras pharetra enim mi, ut posuere nisi tristique non. Sed rutrum magna vitae urna malesuada, at laoreet tortor fringilla. Donec molestie, sem vitae euismod volutpat, velit dui efficitur purus, et tempus enim ligula eget elit. Pellentesque consectetur, orci a interdum ultricies, neque leo tincidunt lectus, eu luctus dolor libero nec sapien. Nulla nec varius sem. Duis feugiat imperdiet felis, fringilla blandit velit sodales in. Maecenas suscipit felis ut sapien sodales maximus sit amet finibus leo. Nunc bibendum sed urna porttitor viverra. Mauris ut augue sit amet felis auctor dignissim id quis nunc. Proin placerat, leo in eleifend sodales, ante felis consectetur enim, non rutrum metus purus at lectus. Nam iaculis urna malesuada, molestie nibh iaculis, auctor nisl. Etiam sodales tempus neque in volutpat. Duis et laoreet sem, id convallis odio. Ut posuere cursus magna, a porttitor massa consequat eget. Fusce dapibus elit eget vestibulum porttitor."
        detailVC.imageName = "https://www.placehold.it/800x600"
        
        self.present(detailVC, animated: true, completion: nil)*/
    }
    
    func registra(access_token: String, id: String, errore: Bool, tipoErrore: String) {
        activityIndicator.stopAnimating()
        print("risp ",access_token,id,errore,tipoErrore, errore==true)
        
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

