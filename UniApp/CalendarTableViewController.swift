//
//  CalendarTableViewController.swift
//  UniApp
//
//  Created by Agostino Romanelli on 28/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialAppBar

class cellOfCalendar: UITableViewCell{
    @IBOutlet weak var labelCourse: UILabel!
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelTeacher: UILabel!
    @IBOutlet weak var labelLesson: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    
    @IBOutlet weak var viewColor: UIView!
}

class CalendarTableViewController: UITableViewController {
    
    let appBar = MDCAppBar()
    
    var arrayCourseLabel: [String] = ["ISIA", "UniUD", "UniUD"];
    var arrayTeacherLabel: [String] = ["Damiano Buscemi", "Prof. Calabretto", "Prof. M. Ripiccini"];
    var arrayClassLabel: [String] = ["Aula S8", "Lab. ITS (L3)", "Aula S1"];
    var arrayHourLabel: [String] = ["09:00 - 13:00", "14:00 - 18:00", "09:00 - 13:00"];
    var arrayLessonLabel: [String] = ["Tecnologie Multimediali e Laboratorio + Test d'ingresso", "ergonomia 2AB", "ergonomia 3AB"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = UIColor(red: 0.6784313725490196, green: 0.1333333333333333333333, blue: 0.1333333333333333333333, alpha: 1.0)
        appBar.navigationBar.tintColor = UIColor.black
        appBar.headerViewController.headerView.trackingScrollView = self.tableView
        appBar.addSubviewsToParent()
        
        let icon = UIImage(named: "Settings")
        let menuButton = UIBarButtonItem(image: icon, style: .done, target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = menuButton;
        
        title = "Calendario"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50;
    }

    func openSettings() {
        self.performSegue(withIdentifier: "openSettings", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellCalendar", for: indexPath) as! cellOfCalendar
        
        cell.labelCourse.text = arrayCourseLabel[indexPath.row]
        cell.labelLesson.text = arrayLessonLabel[indexPath.row]
        cell.labelTeacher.text = arrayTeacherLabel[indexPath.row]
        cell.labelHour.text = arrayHourLabel[indexPath.row]
        cell.labelClass.text = arrayClassLabel[indexPath.row]
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
    

}
