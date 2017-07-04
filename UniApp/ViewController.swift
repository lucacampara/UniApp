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

class ViewController: UIViewController, chiamateAPIDelegate{
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    var gestoreChiamate = ChiamateAPI()
    var activityIndicator = MDCActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestoreChiamate.delegate = self
        /*prova.delegateCaricamento = self
        prova.richiestaAutenticazionePOST(email: "prova", password: "", scelta: .SIGNUP)
        prova.richiesteDatiGET(access_token: "3252261a-215c-4078-a74d-2e1c5c63f0a1", scelta: .POSTS, pagina: 1)
        
        prova.richiesteDatiGET(access_token: "3252261a-215c-4078-a74d-2e1c5c63f0a1", scelta: .TIMETABLE, pagina: 0)*/
        
        //print("Access token \(AccessToken.current?.authenticationToken)")
        
        
        /*let facebookButton = LoginButton(readPermissions: [ .publicProfile ])
        facebookButton.center = view.center
        
        view.addSubview(facebookButton)*/
        
        let w = self.view.frame.size.width/2 - 60
        let h = self.view.frame.size.height/2 - 60
        activityIndicator = MDCActivityIndicator(frame: CGRect(x: w, y: h, width: 120, height: 120))
        activityIndicator.cycleColors = [UIColor.white]
        view.addSubview(activityIndicator)

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - ACTIONS
    
    @IBAction func facebookLoginButton(_ sender: Any) {
        
        var loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! \(accessToken.authenticationToken)")
            }
        }
    }
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if (emailTextField.text?.characters.count)! > 0 && (passwordTextField.text?.characters.count)! > 0 {
            // Start animation
            activityIndicator.startAnimating()
            
            gestoreChiamate.richiestaAutenticazionePOST(email: emailTextField.text!, password: passwordTextField.text!, scelta: .LOGIN)
        } else {
            messageLabel.text = "Inserisci tutti i campi"
        }
        
       /* var detailVC = NewsDetailViewController()
        detailVC.productTitle = "Titolo 1"
        detailVC.desc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec luctus, orci ut fermentum ultrices, nunc nisl iaculis erat, ornare ullamcorper dui nisi sed mi. Mauris non fringilla nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque eu orci et ante vestibulum tristique. Donec dapibus mi a quam blandit, at consectetur lectus elementum. Morbi aliquam rutrum nulla vel vulputate. Ut et tristique ipsum, sed ullamcorper risus. Mauris aliquet feugiat urna. Cras et laoreet tellus. Fusce consequat volutpat justo quis ornare. Sed augue orci, euismod nec augue vitae, condimentum malesuada nulla. Aenean hendrerit bibendum augue, in pharetra sem condimentum a. In hac habitasse platea dictumst. Donec auctor rutrum finibus. Vivamus eget tellus efficitur, vulputate ligula et, aliquet metus. Nunc et varius neque, at porttitor nunc. Suspendisse malesuada, risus et elementum faucibus, nisl lorem sollicitudin ipsum, quis gravida mi diam nec libero. Cras pharetra enim mi, ut posuere nisi tristique non. Sed rutrum magna vitae urna malesuada, at laoreet tortor fringilla. Donec molestie, sem vitae euismod volutpat, velit dui efficitur purus, et tempus enim ligula eget elit. Pellentesque consectetur, orci a interdum ultricies, neque leo tincidunt lectus, eu luctus dolor libero nec sapien. Nulla nec varius sem. Duis feugiat imperdiet felis, fringilla blandit velit sodales in. Maecenas suscipit felis ut sapien sodales maximus sit amet finibus leo. Nunc bibendum sed urna porttitor viverra. Mauris ut augue sit amet felis auctor dignissim id quis nunc. Proin placerat, leo in eleifend sodales, ante felis consectetur enim, non rutrum metus purus at lectus. Nam iaculis urna malesuada, molestie nibh iaculis, auctor nisl. Etiam sodales tempus neque in volutpat. Duis et laoreet sem, id convallis odio. Ut posuere cursus magna, a porttitor massa consequat eget. Fusce dapibus elit eget vestibulum porttitor."
        detailVC.imageName = "https://www.placehold.it/800x600"
        
        self.present(detailVC, animated: true, completion: nil)*/
    }
    
    func registra(access_token: String, id: String, errore: Bool, tipoErrore: String) {
        activityIndicator.stopAnimating()
        print("risp ",access_token,id,errore,tipoErrore)
        
        if errore == true {
            messageLabel.text = tipoErrore
        }
    }
    func finitoDiCaricare() {
        print("finito di caricare")
    }

}

