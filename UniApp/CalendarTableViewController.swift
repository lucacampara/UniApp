//
//  CalendarTableViewController.swift
//  UniApp
//
//  Created by Agostino Romanelli on 28/06/17.
//  Copyright © 2017 tsam_its. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialAppBar
import SwipeCellKit
import UserNotifications

class cellOfCalendar: SwipeTableViewCell{
    @IBOutlet weak var labelCourse: UILabel!
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelTeacher: UILabel!
    @IBOutlet weak var labelLesson: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    
    @IBOutlet weak var viewColor: UIView!
}

class CalendarTableViewController: UITableViewController, SwipeTableViewCellDelegate, controllaCaricamento {
    
    var colorsDictionary = [String: UIColor]()
    
    var databaseRealm = DatabaseRealm()
    var calendarList = [OrarioRealm]()
    let chiamate = ChiamateAPI()
    
    let appBar = MDCAppBar()
    
    var arrayCourseLabel: [String] = ["ISIA", "UniUD", "UniUD"];
    var arrayTeacherLabel: [String] = ["Damiano Buscemi", "Prof. Calabretto", "Prof. M. Ripiccini"];
    var arrayClassLabel: [String] = ["Aula S8", "Lab. ITS (L3)", "Aula S1"];
    var arrayHourLabel: [String] = ["09:00 - 13:00", "14:00 - 18:00", "09:00 - 13:00"];
    var arrayLessonLabel: [String] = ["Tecnologie Multimediali e Laboratorio + Test d'ingresso", "ergonomia 2AB", "ergonomia 3AB"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionNotification();
        
        initColors()
        
        calendarList = databaseRealm.ritornaArrayOrari() as! [OrarioRealm]
        print(calendarList.count)
        
        let token = UserDefaults.standard.string(forKey: ViewController.USER_TOKEN)
        
        chiamate.delegateCaricamento = self
        
        if calendarList.count == 0 {
            chiamate.richiesteDatiGET(access_token: token!, scelta: .TIMETABLE, pagina: 0)
        }

        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xAD2222)
        appBar.navigationBar.tintColor = UIColor.black
        appBar.headerViewController.headerView.trackingScrollView = self.tableView
        appBar.addSubviewsToParent()
        
        let icon = UIImage(named: "Settings")
        let menuButton = UIBarButtonItem(image: icon, style: .done, target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = menuButton;
        
        //title = "Lezioni"
        
        let view1 = UIView(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect.init(x: 0, y: 20, width: view.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Lezioni"
        label.textColor = UIColor.white
        label.textAlignment = .center
        view1.addSubview(label)
        //view1.backgroundColor = UIColor.gray // Set your background color
        appBar.navigationBar.addSubview(view1)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50;
    }
    
    func finitoDiCaricare() {
        DispatchQueue.main.async {
            self.calendarList = self.databaseRealm.ritornaArrayOrari() as! [OrarioRealm]
            print("finito ", self.calendarList.count)
            self.tableView.reloadData()
        }
    }
    
    func initColors() {
        colorsDictionary["I.T.S."] = Utils.UIColorFromRGB(rgbValue: 0xe53935)
        colorsDictionary["UniUD"] = Utils.UIColorFromRGB(rgbValue: 0x1e88e5)
        colorsDictionary["UniTS"] = Utils.UIColorFromRGB(rgbValue: 0x43a047)
        colorsDictionary["ISIA"] = Utils.UIColorFromRGB(rgbValue: 0xfdd835)
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
        return self.calendarList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellCalendar", for: indexPath) as! cellOfCalendar
        
        cell.labelCourse.text = calendarList[indexPath.row].course
        cell.labelLesson.text = calendarList[indexPath.row].name
        cell.labelTeacher.text = calendarList[indexPath.row].prof
        cell.labelHour.text = "\(calendarList[indexPath.row].oraInizioLezione) - \(calendarList[indexPath.row].oraFineLezione)"
        cell.labelClass.text = calendarList[indexPath.row].classe
        cell.viewColor.backgroundColor = colorsDictionary[calendarList[indexPath.row].course]

        /*cell.labelCourse.text = arrayCourseLabel[indexPath.row]
        cell.labelLesson.text = arrayLessonLabel[indexPath.row]
        cell.labelTeacher.text = arrayTeacherLabel[indexPath.row]
        cell.labelHour.text = arrayHourLabel[indexPath.row]
        cell.labelClass.text = arrayClassLabel[indexPath.row]*/


        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect.init(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "4 giugno 2017"
        view.addSubview(label)
        view.backgroundColor = UIColor.gray // Set your background color
        
        return view
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
    
        // #### NOTIFICATION ACTION ### \\
        
        let notificationAction = SwipeAction(style: .default, title: "Abilita\nnotifica") { action, indexPath in
            
            let alertController = UIAlertController(title: "Notifica", message:
                "Sicuro di voler attivare la notifica per questa lezione?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Annulla", style: UIAlertActionStyle.default,handler: nil))
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: { action in
                self.scheduleNotification(title: "Lezione di Gino Parigino", contents: "La lezione sta per iniziare! Muovi il culo!", hour: 16, minute: 6)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        notificationAction.textColor = UIColor.orange
        notificationAction.image = UIImage(named: "Notification")
        notificationAction.transitionDelegate = ScaleTransition.default
        notificationAction.backgroundColor = UIColor(white: 1, alpha: 0.5)

        
        // #### CALENDAR ACTION ### \\
        
        let calendarAction = SwipeAction(style: .default, title: "Aggiungi al\ncalendario") { action, indexPath in
            print("PULSANTE CALENDARIO PREMUTO")
        }
        
        calendarAction.transitionDelegate = ScaleTransition.default
        calendarAction.textColor = UIColor.orange
        calendarAction.image = UIImage(named: "CalendarPlus")
        calendarAction.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        return [calendarAction, notificationAction]
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

    func permissionNotification(){
        UNUserNotificationCenter.current().getNotificationSettings{(settings) in
            if(settings.authorizationStatus == .authorized){
                //User give authorized
                self.scheduleNotification(title: "Notifica insulatativa", contents: "vai a farti fottere", hour: 11, minute: 48)
            }else{
                //User not give authorized
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler:{ (granted, error) in
                    if let error = error{
                        print(error)
                        
                    }else{
                        if(granted){
                            self.scheduleNotification(title: "Notifica insulatativa", contents: "vai a farti fottere", hour: 12, minute: 02)
                        }
                    }
                })
            }
        }
    }
    
    func scheduleNotification(title: String, contents: String, hour: Int, minute: Int){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = contents
        
        var dateInfo = DateComponents()
        dateInfo.hour = hour
        dateInfo.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        let NotificationRequest = UNNotificationRequest(identifier: "timedNotificationIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(NotificationRequest) { (error) in
            if let error = error {
                print(error)
            }else{
                print("Notification sheduled!")
            }
            
        }
    }
    

}
