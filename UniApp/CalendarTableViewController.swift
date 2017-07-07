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
import EventKit

class cellOfCalendar: SwipeTableViewCell{
    @IBOutlet weak var labelCourse: UILabel!
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelTeacher: UILabel!
    @IBOutlet weak var labelLesson: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    
    @IBOutlet weak var viewColor: UIView!
}

class calendarHeaderCell: UITableViewCell {
    @IBOutlet weak var labelDate: UILabel!
}

class CalendarTableViewController: UITableViewController, SwipeTableViewCellDelegate, controllaCaricamento {
    
    var colorsDictionary = [String: UIColor]()
    
    var databaseRealm = DatabaseRealm()
    var calendarList = [OrarioRealm]()
    var dictionary = [String: Array<OrarioRealm>]()
    let chiamate = ChiamateAPI()
    
    var allKeysDays = Array<String>()
    
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

//  calendarList = databaseRealm.ritornaArrayOrari() as! [OrarioRealm]
        
        dictionary = databaseRealm.ritornaDicionaryArrayRealmOrari()
        allKeysDays = Array(dictionary.keys).sorted(by: {$0<$1})
        
        print("ABC ", dictionary.count)
        print(allKeysDays)
        
        
        let token = UserDefaults.standard.string(forKey: ViewController.USER_TOKEN)
        
        chiamate.delegateCaricamento = self
        
        if dictionary.count == 0 {
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
    
    func finitoDiCaricare(page: Int) {
        DispatchQueue.main.async {
//            self.calendarList = self.databaseRealm.ritornaArrayOrari() as! [OrarioRealm]
            self.dictionary = self.databaseRealm.ritornaDicionaryArrayRealmOrari()
            self.allKeysDays = Array(self.dictionary.keys).sorted(by: {$0<$1})
            print("finito ", self.dictionary.count)
            self.tableView.reloadData()
        }
    }
    
    func initColors() {
        colorsDictionary["I.T.S."] = Utils.UIColorFromRGB(rgbValue: 0xe53935)
        colorsDictionary["UniUD"] = Utils.UIColorFromRGB(rgbValue: 0x1e88e5)
        colorsDictionary["UniTS"] = Utils.UIColorFromRGB(rgbValue: 0x43a047)
        colorsDictionary["ISIA"] = Utils.UIColorFromRGB(rgbValue: 0xfdd835)
        colorsDictionary["Consortium Service"] = Utils.UIColorFromRGB(rgbValue: 0x8e24aa)
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
        return dictionary.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (dictionary[self.allKeysDays[section]]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellCalendar", for: indexPath) as! cellOfCalendar
        
        
        cell.labelCourse.text = self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row].course
        cell.labelLesson.text = self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row].name
        cell.labelTeacher.text = self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row].prof
        cell.labelHour.text = "\(self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row].oraInizioLezione as! String) - \(self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row].oraFineLezione as! String)"
        cell.labelClass.text = self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row].classe
        cell.viewColor.backgroundColor = colorsDictionary[(self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row].course)!]

        /*cell.labelCourse.text = arrayCourseLabel[indexPath.row]
        cell.labelLesson.text = arrayLessonLabel[indexPath.row]
        cell.labelTeacher.text = arrayTeacherLabel[indexPath.row]
        cell.labelHour.text = arrayHourLabel[indexPath.row]
        cell.labelClass.text = arrayClassLabel[indexPath.row]*/


        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.allKeysDays[section]
    }
    
    /*override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("HEADER")
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeader") as! calendarHeaderCell
        
        headerCell.labelDate.text = self.allKeysDays[section]
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }*/
    
    /*override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect.init(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "4 giugno 2017"
        view.addSubview(label)
        view.backgroundColor = UIColor.gray // Set your background color
        
        return view
    }*/
    
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
        
        let gray = UIColor(white: 1, alpha: 0.5)
        
        notificationAction.textColor = UIColor.orange
        notificationAction.image = UIImage(named: "Notification")
        notificationAction.transitionDelegate = ScaleTransition.default
        notificationAction.backgroundColor = gray

        
        // #### CALENDAR ACTION ### \\
        
        let calendarAction = SwipeAction(style: .default, title: "Aggiungi al\ncalendario") { action, indexPath in
            print("PULSANTE CALENDARIO PREMUTO")
            var lezione = (self.dictionary[self.allKeysDays[indexPath.section]]?[indexPath.row])!
            print(lezione)
            
            
            let alertView = UIAlertController(title: "Aggiungi  al calendario", message: "Vuoi aggiungere questa lezione al tuo calendario?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) -> Void in
                self.addToCalendar(title: lezione.name, start: lezione.time_start, end: lezione.time_end)
            }))
            alertView.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
            self.present(alertView, animated: true, completion: nil)

            
        }
        
        calendarAction.transitionDelegate = ScaleTransition.default
        calendarAction.textColor = UIColor.orange
        calendarAction.image = UIImage(named: "CalendarPlus")
        calendarAction.backgroundColor = gray
        
        return [calendarAction, notificationAction]
    }
    
    
    func addToCalendar(title: String, start: String, end: String) {
        
        print("start ", start)
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        //let dateFormatterPrint = DateFormatter()
        //dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            //let dateStart = Date()
            //let dateEnd = dateFormatter.date(from: end) as Date
            
            let dateStart = dateFormatterGet.date(from: start)
            let dateEnd = dateFormatterGet.date(from: end)

            
            var event = EKEvent(eventStore: store)
            event.title = title
            event.startDate = dateStart!
            event.endDate = dateEnd!
            event.calendar = store.defaultCalendarForNewEvents
            
            do {
                try store.save(event, span: .thisEvent, commit: true)
                let savedEventId = event.eventIdentifier //save event id to access this particular event later
            } catch {
                // Display error to user
            }
            
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
