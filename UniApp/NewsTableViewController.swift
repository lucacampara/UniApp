//
//  NewsTableViewController.swift
//  UniApp
//
//  Created by Agostino Romanelli on 28/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialAppBar
import MaterialComponents.MaterialActivityIndicator

class cellOfNews: UITableViewCell{
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var newImage: UIImageView!
}

class NewsTableViewController: UITableViewController, controllaCaricamento {
    
    var databaseRealm = DatabaseRealm()
    var newsList = [NewsRealm]()
    let chiamate = ChiamateAPI()
    var activityIndicator = MDCActivityIndicator()
    
    let appBar = MDCAppBar()
    
    var arrayDataLabel: [String] = ["15 giugno 2017", "16 giugno 2017"]
    var arrayTitleLabel: [String] = ["Ateneo, cambio al vertice dell'amministrazione", "Dall’ERDISU all’ARDISS"];
    var arrayContentLabel: [String] = ["Con il 1° gennaio 2014 i due ERDISU regionali sono stati soppressi facendo nascere l&#8217;ARDISS, ovvero l&#8217;Agenzia regionale per il diritto agli studi superiori, assorbendo le finalità ed i servizi dei precedenti enti nell&#8217;ottica di riorganizzare il diritto allo studio superiore in Friuli Venezia Giulia", "Massimo Di Silverio, 55 anni, laureato in Scienze politiche, è il nuovo direttore generale dell&#8217;Ateneo friulano. L&#8217;incarico, di durata triennale e rinnovabile, è stato deliberato all&#8217;unanimità dal"];
    
    let token = UserDefaults.standard.string(forKey: ViewController.USER_TOKEN)
    var currentPage = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsList = databaseRealm.ritornaArrayNews()
        
        let w = self.view.frame.size.width/2 - 60
        let h = self.view.frame.size.height/2 - 60
        activityIndicator = MDCActivityIndicator(frame: CGRect(x: w, y: h, width: 120, height: 120))
        activityIndicator.cycleColors = [Utils.UIColorFromRGB(rgbValue: 0xAD2222)]
        view.addSubview(activityIndicator)
        
        chiamate.delegateCaricamento = self
        
        print("count", newsList.count)
        if newsList.count == 0 {
            activityIndicator.startAnimating()
            chiamate.richiesteDatiGET(access_token: token!, scelta: .POSTS, pagina: currentPage)
        }
        
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xAD2222)
        appBar.navigationBar.tintColor = UIColor.white
        appBar.headerViewController.headerView.trackingScrollView = self.tableView
        appBar.addSubviewsToParent()
        
        let icon = UIImage(named: "Settings")
        let menuButton = UIBarButtonItem(image: icon, style: .done, target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = menuButton;

        //title = "News"
        
        let view1 = UIView(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect.init(x: 0, y: 20, width: view.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "News"
        label.textColor = UIColor.white
        label.textAlignment = .center
        view1.addSubview(label)
        //view1.backgroundColor = UIColor.gray // Set your background color
        appBar.navigationBar.addSubview(view1)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50;
        
        self.tableView.reloadData()

    }
    
    func openSettings() {
        self.performSegue(withIdentifier: "openSettings", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 2
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellNews", for: indexPath) as! cellOfNews
        
        /*cell.labelData.text = arrayDataLabel[indexPath.row]
        cell.labelTitle.text = arrayTitleLabel[indexPath.row]
        cell.labelContent.text = arrayContentLabel[indexPath.row]*/
        
        cell.labelData.text = newsList[indexPath.row].dataNews
        cell.labelTitle.text = newsList[indexPath.row].title
        cell.labelContent.text = newsList[indexPath.row].content
        cell.imageNews.sd_setImage(with: URL(string: newsList[indexPath.row].media), placeholderImage: UIImage(named: "LogoConsorzio"))
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = cell.imageNews.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.imageNews.addSubview(blurView)
        
        cell.newImage.sd_setImage(with: URL(string: newsList[indexPath.row].media), placeholderImage: UIImage(named: "LogoConsorzio"))
        
        /*cell.viewCard.layer.shadowPath = UIBezierPath(rect: cell.viewCard.bounds).cgPath
        cell.viewCard.layer.shadowColor = UIColor.gray.cgColor
        cell.viewCard.layer.shadowOpacity = 0.25
        cell.viewCard.layer.shadowOffset = CGSize.zero
        cell.viewCard.layer.shadowRadius = 10
        cell.viewCard.layer.masksToBounds = true;
        cell.viewCard.clipsToBounds = false;*/

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row == (self.newsList.count - 5) {
            print("nuova chiamata")
            currentPage += 1
            chiamate.richiesteDatiGET(access_token: token!, scelta: .POSTS, pagina: currentPage)
        }
    }
    
    // Codice per fare in modo che l'AppBar si adatti allo scrolling
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidScroll()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    func finitoDiCaricare(page: Int) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        
            self.newsList = self.databaseRealm.ritornaArrayNews()
            print("finito ", self.newsList.count)
            self.tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetail" {
            let navigationController = segue.destination as! UINavigationController
            let detailController = navigationController.topViewController as! NewsDetailViewController
            
            if let selectedNewsCell = sender as? cellOfNews {
                let indexPath = self.tableView.indexPath(for: selectedNewsCell)!
                detailController.news = newsList[indexPath.row]
            }
            
        }
    }
    

}
