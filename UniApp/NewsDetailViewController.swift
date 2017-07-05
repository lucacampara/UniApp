//
//  NewsDetailViewController.swift
//  UniApp
//
//  Created by Luca Campara on 28/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import SDWebImage
import MaterialComponents.MaterialAppBar
import MaterialComponents.MaterialActivityIndicator

class NewsDetailViewController: UIViewController {
    

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsGoToSite: UIButton!
    @IBOutlet weak var newsDetail: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    var news = NewsRealm()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = UIColor(red: 0.6784313725490196, green: 0.1333333333333333333333, blue: 0.1333333333333333333333, alpha: 1.0)
        appBar.navigationBar.tintColor = .clear
        appBar.navigationBar.tintColor = .white
        
        appBar.addSubviewsToParent()
        
        title = "Dettaglio"*/
        
        let backButton = UIBarButtonItem(title:"",
                                         style:.done,
                                         target:self,
                                         action:#selector(dismissDetail))
        let backImage = UIImage(named:MDCIcons.pathFor_ic_arrow_back())
        backButton.image = backImage
        self.navigationItem.leftBarButtonItem = backButton
        
        //appBar.navigationBar.leftBarButtonItem = backButton
        
        newsImage.sd_setImage(with: URL(string: news.media), placeholderImage: UIImage(named: "LogoConsorzio"))
        newsDate.text = news.createdAt
        newsTitle.text = news.title
        newsDetail.text = news.content
        
        /*newsImage.sd_setImage(with: URL(string: "https://www.placehold.it/800x600"), placeholderImage: UIImage(named: "LogoConsorzio"))
        newsDate.text = "28 giugno 2017"
        newsTitle.text = "Corso Biometria 2017 – tecniche, normativa e applicazioni"
        newsDetail.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec luctus, orci ut fermentum ultrices, nunc nisl iaculis erat, ornare ullamcorper dui nisi sed mi. Mauris non fringilla nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque eu orci et ante vestibulum tristique. Donec dapibus mi a quam blandit, at consectetur lectus elementum. Morbi aliquam rutrum nulla vel vulputate. Ut et tristique ipsum, sed ullamcorper risus. Mauris aliquet feugiat urna. Cras et laoreet tellus. Fusce consequat volutpat justo quis ornare. Sed augue orci, euismod nec augue vitae, condimentum malesuada nulla. Aenean hendrerit bibendum augue, in pharetra sem condimentum a. In hac habitasse platea dictumst. Donec auctor rutrum finibus. Vivamus eget tellus efficitur, vulputate ligula et, aliquet metus. Nunc et varius neque, at porttitor nunc. Suspendisse malesuada, risus et elementum faucibus, nisl lorem sollicitudin ipsum, quis gravida mi diam nec libero. Cras pharetra enim mi, ut posuere nisi tristique non. Sed rutrum magna vitae urna malesuada, at laoreet tortor fringilla. Donec molestie, sem vitae euismod volutpat, velit dui efficitur purus, et tempus enim ligula eget elit. Pellentesque consectetur, orci a interdum ultricies, neque leo tincidunt lectus, eu luctus dolor libero nec sapien. Nulla nec varius sem. Duis feugiat imperdiet felis, fringilla blandit velit sodales in. Maecenas suscipit felis ut sapien sodales maximus sit amet finibus leo. Nunc bibendum sed urna porttitor viverra. Mauris ut augue sit amet felis auctor dignissim id quis nunc. Proin placerat, leo in eleifend sodales, ante felis consectetur enim, non rutrum metus purus at lectus. Nam iaculis urna malesuada, molestie nibh iaculis, auctor nisl. Etiam sodales tempus neque in volutpat. Duis et laoreet sem, id convallis odio. Ut posuere cursus magna, a porttitor massa consequat eget. Fusce dapibus elit eget vestibulum porttitor."*/

        // Do any additional setup after loading the view.
    }
    
    func dismissDetail() {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func newsGoToSite(_ sender: Any) {
    }

}
