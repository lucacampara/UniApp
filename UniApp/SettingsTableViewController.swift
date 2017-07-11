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
    @IBOutlet weak var `switch`: UISwitch!
    
    static let NOTIFICATION_MINUTES = "NOTIFICATION_MINUTES"
    static let NOTIFICATION_SWITCH_STATUS = "NOTIFICATION_SWITCH_STATUS"
    
    var minutesArray: Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        let switchStatusInteger = UserDefaults.standard.integer(forKey: SettingsTableViewController.NOTIFICATION_SWITCH_STATUS)
        if switchStatusInteger == -1 {
            self.switch.setOn(false, animated: false)
        }
        
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
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select \(indexPath.row)")
        if indexPath.row == 0 {
            
            if self.switch.isOn {
                print("IS OFF")
                self.showAlert(title: "Disattiva Notifiche", message: "Vuoi disattivare tutte le notifiche impostate?", number: 0)
            } else {
                self.switch.setOn(true, animated: true)
                UserDefaults.standard.set(0, forKey: SettingsTableViewController.NOTIFICATION_SWITCH_STATUS)
            }
            
            self.tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
            
            
        } else if indexPath.row == 1 {
            
            let action = ActionSheetStringPicker(title: "Seleziona i minuti", rows: minutesArray, initialSelection: 0, doneBlock: {
                picker, index, values in
                print(values as! Int)
                
                self.minutes.setTitle("\(values as! Int) min", for: .normal)
                UserDefaults.standard.set(values as! Int, forKey: SettingsTableViewController.NOTIFICATION_MINUTES)
                return
            }, cancel: {
                ActionSheetStringPicker in return
            }, origin: tableView)
            
            action?.tapDismissAction = TapAction.cancel
            action?.show()
            
            self.tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
            
        } else if indexPath.row == 2 {
            showAlert(title: "Logout", message: "Sei sicuro di voler eseguire il logout?", number: 2)
        }
    }
    
    
    func showAlert(title: String, message: String, number: Int) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) -> Void in
            switch number {
                case 0:
                    // disattiva notifiche
                    self.switch.setOn(false, animated: true)
                    self.cancelAllNotifications()
                    UserDefaults.standard.set(-1, forKey: SettingsTableViewController.NOTIFICATION_SWITCH_STATUS)
                    break
                case 2:
                    // logout
                    UserDefaults.standard.set(nil, forKey: ViewController.USER_TOKEN)
                    self.performSegue(withIdentifier: "logout", sender: self)
                    break
                default:
                    break
                
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) -> Void in
            switch number {
            case 0:
                self.switch.setOn(true, animated: true)
                break
            default:
                break
                
            }
        }))

        self.present(alertView, animated: true, completion: nil)
    }
    
    
    func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
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
    
    
    @IBAction func SwitchAction(_ sender: Any) {
        if self.switch.isOn {
            print("IS ON")
            UserDefaults.standard.set(0, forKey: SettingsTableViewController.NOTIFICATION_SWITCH_STATUS)
        } else {
            print("IS OFF")
            self.showAlert(title: "Disattiva Notifiche", message: "Vuoi disattivare tutte le notifiche impostate?", number: 0)
        }
    }
    
    @IBAction func notificationMinutes(_ sender: Any) {
        let action = ActionSheetStringPicker(title: "Seleziona i minuti", rows: minutesArray, initialSelection: 0, doneBlock: {
            picker, index, values in
            print(values as! Int)
            
            self.minutes.setTitle("\(values as! Int) min", for: .normal)
            UserDefaults.standard.set(values as! Int, forKey: SettingsTableViewController.NOTIFICATION_MINUTES)
            return
        }, cancel: {
            ActionSheetStringPicker in return
        }, origin: sender)
        
        action?.tapDismissAction = TapAction.cancel
        action?.show()
        
        self.tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
