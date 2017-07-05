//
//  SettingsTableViewController.swift
//  UniApp
//
//  Created by Luca Campara on 26/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var minutes: UIButton!
    
    static let NOTIFICATION_MINUTES = "NOTIFICATION_MINUTES"
    
    var minutesArray: Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        
        
        let min = UserDefaults.standard.integer(forKey: SettingsTableViewController.NOTIFICATION_MINUTES)
        
        if min != 0 {
            minutes.setTitle("\(min) min", for: .normal)
        } else {
            minutes.setTitle("10 min", for: .normal)
        }
        
        // nasconde le righe vuote della tableview
        self.tableView.tableFooterView = UIView()
        
        initArray()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func initArray() {
        minutesArray.append(1)
        minutesArray.append(2)
        minutesArray.append(3)
        minutesArray.append(4)
        minutesArray.append(5)
        minutesArray.append(10)
        minutesArray.append(15)
        minutesArray.append(20)
        minutesArray.append(30)
        minutesArray.append(60)
        minutesArray.append(120)
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
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select \(indexPath.row)")
        if  indexPath.row == 1 {
            let action = ActionSheetStringPicker(title: "Seleziona i minuti", rows: [minutesArray], initialSelection: 5, doneBlock: {
                picker, index, values in
                
                return
            }, cancel:{
                ActionSheetStringPicker in return
            }, origin: nil)
                
            action?.tapDismissAction = TapAction.cancel
            action?.show()
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    @IBAction func notificationMinutes(_ sender: Any) {
        let action = ActionSheetStringPicker(title: "Seleziona i minuti", rows: minutesArray, initialSelection: 0, doneBlock: {
            picker, index, values in
            print(values as! Int)
            
            self.minutes.setTitle("\(values as! Int) min", for: .normal)
            UserDefaults.standard.set(values as! Int, forKey: SettingsTableViewController.NOTIFICATION_MINUTES)
            return
        }, cancel:{
            ActionSheetStringPicker in return
        }, origin: sender)
        
        action?.tapDismissAction = TapAction.cancel
        action?.show()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
