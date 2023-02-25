//
//  SiteDetailViewController.swift
//  Nation Wide
//
//  Created by Solution Surface on 14/06/2022.
//

import UIKit
import SideMenu
import KRProgressHUD
import CoreLocation

class SiteDetailViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    
    /// Creating UIDocumentInteractionController instance.
    let documentInteractionController = UIDocumentInteractionController()
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var workOrderRefrence: UILabel!
    @IBOutlet weak var guardName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var lblShiftTiming: UILabel!
    @IBOutlet weak var pocName: UILabel!
    @IBOutlet weak var pocCellNumber: UILabel!

    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var noOfDays: UILabel!
    @IBOutlet weak var btnCheckIn: UIButton!
    
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var guardType: UILabel!
    @IBOutlet weak var btnBreak: UIButton!
    var sideMenu: SideMenuNavigationController?
    
    var siteDetail: SiteDetail?
    var checkInOutdata: CheckInCheckOutData?
    
    var guardNameFromUserDefaults: String?
    
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    
    var locationManager : CLLocationManager = CLLocationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var startTime: Date?
    var endTime: Date?
    var isDeviceWithinRegion: Bool?
    

    override func viewDidLoad() {
        
    
        
        super.viewDidLoad()
        
        self.userNotificationCenter.delegate = self
        self.requestNotificationAuthorization()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                self.guardNameFromUserDefaults = "\(loadedPerson.user?.first_name ?? "") \(loadedPerson.user?.last_name ?? "")"
                
            }
        }
        
        if let checkInData = UserDefaults.standard.object(forKey: "CheckIN") as? Data {
            let decoder = JSONDecoder()
            if let loadCheckInOutData = try? decoder.decode(CheckInCheckOutData.self, from: checkInData) {
                
                if let choutTime = loadCheckInOutData.check_out_time {
                    self.checkInOutdata = loadCheckInOutData;
                    self.btnCheckIn.isEnabled = true
                    self.btnCheckOut.isEnabled = false
                    self.btnBreak.isEnabled = false
                }else {
                    
                    self.checkInOutdata = loadCheckInOutData;
                    self.btnCheckIn.isEnabled = false
                    self.btnCheckOut.isEnabled = true
                    self.btnBreak.isEnabled = true
                }
                
                
            }
        }else{
            
            self.btnCheckIn.isEnabled = true
            self.btnCheckOut.isEnabled = false
            self.btnBreak.isEnabled = false
        }
        
//        let currentDate = Date()
//        let calendar = Calendar.current
//        let day = calendar.component(.day, from: currentDate)
//        print(day)

        
        
        
        
        
//        if let siteDetailData = UserDefaults.standard.object(forKey: "SiteDetail") as? Data {
//
//            let decoder = JSONDecoder()
//            if let siteDetail = try? decoder.decode(SiteDetail.self, from: siteDetailData) {
//
//                self.siteDetail = siteDetail
//
//                if let st = self.siteDetail {
//                    self.storeSiteDetailsInStorage(siteDetail: st)
//                }else{
//                    self.showErrorAlert(errorMessage: "This User has no job Assigned.")
//                }
//                self.setupUI()
//
//
//            }
//
//        }else{
            
            siteDetailsAPICall()
//            self.getCurrentDay()
//        }
        
    }
    
    
 
    func  getCurrentStartAndEndDate(staringTime: [String?], endingTime: [String?]) -> [Date?] {
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayOfWeek = formatter.string(from: date)
        print(dayOfWeek)

        
        if dayOfWeek == "Monday" {
            
            let startTime: String? = staringTime[0] ?? nil
            let endTime: String? = endingTime[0] ?? nil
            if let sDate = startTime, let eDate = endTime {
                let startDate = sDate.dateValue
                let endDate = eDate.dateValue
                return [startDate ?? Date(), endDate ?? Date()]
            }else{
                return [nil, nil];
            }
            
            
        } else if dayOfWeek == "Tuseday" {
            
            let startTime: String? = staringTime[1] ?? nil
            let endTime: String? = endingTime[1] ?? nil
            if let sDate = startTime, let eDate = endTime {
                let startDate = sDate.dateValue
                let endDate = eDate.dateValue
                return [startDate ?? Date(), endDate ?? Date()]
            }else{
                return [nil, nil];
            }
            
        }else if dayOfWeek == "Wednesday" {
            
            let startTime: String? = staringTime[2] ?? nil
            let endTime: String? = endingTime[2] ?? nil
            if let sDate = startTime, let eDate = endTime {
                let startDate = sDate.dateValue
                let endDate = eDate.dateValue
                return [startDate ?? Date(), endDate ?? Date()]
            }else{
                return [nil, nil];
            }
            
        }else if dayOfWeek == "Thursday" {
            
            let startTime: String? = staringTime[3] ?? nil
            let endTime: String? = endingTime[3] ?? nil
            if let sDate = startTime, let eDate = endTime {
                let startDate = sDate.dateValue
                let endDate = eDate.dateValue
                return [startDate ?? Date(), endDate ?? Date()]
            }else{
                return [nil, nil];
            }
            
        }else if dayOfWeek == "Friday" {
            
            
            let startTime: String? = staringTime[4] ?? nil
            let endTime: String? = endingTime[4] ?? nil
            if let sDate = startTime, let eDate = endTime {
                let startDate = sDate.dateValue
                let endDate = eDate.dateValue
                return [startDate ?? Date(), endDate ?? Date()]
            }else{
                return [nil, nil];
            }
            
        }else if dayOfWeek == "Saturday" {
            
            
            let startTime: String? = staringTime[5] ?? nil
            let endTime: String? = endingTime[5] ?? nil
            if let sDate = startTime, let eDate = endTime {
                let startDate = sDate.dateValue
                let endDate = eDate.dateValue
                return [startDate ?? Date(), endDate ?? Date()]
            }else{
                return [nil, nil];
            }
            
            
        }
        
        let startTime: String? = staringTime[6] ?? nil
        let endTime: String? = endingTime[6] ?? nil
        if let sDate = startTime, let eDate = endTime {
            let startDate = sDate.dateValue
            let endDate = eDate.dateValue
            return [startDate ?? Date(), endDate ?? Date()]
        }else{
            return [nil, nil];
        }
        

        
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification(message: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Nation Wide"
        notificationContent.body = message
        notificationContent.badge = NSNumber(value: 3)
        
        if let url = Bundle.main.url(forResource: "dune",
                                    withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                            url: url,
                                                            options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for cL in locations {
            print(cL)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        sendNotification(message: "You are out of your region")
        isDeviceWithinRegion = false
        checkOutAPICall(id: self.checkInOutdata?.id ?? 1, type: "check_out", timezone: localTimeZoneIdentifier, clicked: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        isDeviceWithinRegion = true
        sendNotification(message: "You are inside of your region")
    }
    
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        
        let userCalendar = Calendar.current
        
        let numberOfDays = userCalendar.dateComponents([.day], from: from, to: to)
        
        return numberOfDays.day!
    }
    
    func setupUI() {

        DispatchQueue.main.async {
            
            
            let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: self.siteDetail?.job?.lat ?? 0.0, longitude: self.siteDetail?.job?.lng ?? 0.0), radius: 1000, identifier: "GEO")
            self.locationManager.startMonitoring(for: geoFenceRegion)
            
            
            if let st = self.siteDetail {
                
                
                
                let startDateType = ((st.start_date ?? "") as NSString).doubleValue
                let startdate = Date(timeIntervalSince1970: startDateType)
                
                let endDateType = ((st.end_date ?? "") as NSString).doubleValue
                let enddate = Date(timeIntervalSince1970: endDateType)
                
                

                self.guardType.text = st.gaurd_type ?? ""
                self.startDate.text = startdate.toString(dateFormat: "dd/MM/yyyy")
                self.endDate.text = enddate.toString(dateFormat: "dd/MM/yyyy")
                self.noOfDays.text = "\(self.numberOfDaysBetween(startdate, and: enddate))"
                self.lblCompanyName.text = st.job?.company_name ?? ""
                self.workOrderRefrence.text = st.job?.ref_no
                self.guardName.text = self.guardNameFromUserDefaults
                self.address.text = st.job?.poc_address ?? ""
                self.city.text = st.job?.poc_city ?? ""
                self.state.text = st.job?.poc_state
                self.zipCode.text = st.job?.poc_zip
                self.siteName.text = st.job?.site_name
                self.lblShiftTiming.text = st.job?.shift
                self.pocName.text = st.job?.person
                self.pocCellNumber.text = st.job?.poc_cell_no
            } else {
                self.workOrderRefrence.text = ""
                self.guardName.text = ""
                self.address.text = ""
                self.city.text = ""
                self.state.text = ""
                self.zipCode.text = ""
                self.siteName.text = ""
                self.pocName.text = ""
                self.pocCellNumber.text = ""
            }
            
            
            
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
            
            self.navigationItem.title = self.siteDetail?.job?.company_name ?? ""
            let notificationBarButton = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .done, target: self, action: #selector(self.notificationButtonPressed))
            self.navigationItem.rightBarButtonItem  = notificationBarButton
            
            let sideMenuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(self.sideMenuButtonPressed))
            self.navigationItem.leftBarButtonItem = sideMenuBarButton
            
            
            self.sideMenu = SideMenuNavigationController(rootViewController: SideMenuController())
            self.sideMenu?.leftSide = true
            
            SideMenuManager.default.leftMenuNavigationController = self.sideMenu
            SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        }
        
        
        
    }

    
    
    func downloadPDF(url: URL) {
//      let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        guard let data = data, error == nil else { return }
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURL = documentsPath.appendingPathComponent("WorkOrder.pdf")
//        do {
//          try data.write(to: fileURL)
//        } catch {
//          print("Error while saving the PDF to local storage: \(error)")
//        }
//      }
//      task.resume()
        
        
        
        // Create destination URL
          let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
          let destinationFileUrl = documentsUrl.appendingPathComponent("downloadedFile.jpg")
          
          //Create URL to the source file you want to download
          let fileURL = url
          
          let sessionConfig = URLSessionConfiguration.default
          let session = URLSession(configuration: sessionConfig)
       
          let request = URLRequest(url:fileURL)
          
          let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
              if let tempLocalUrl = tempLocalUrl, error == nil {
                  // Success
                  if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                      print("Successfully downloaded. Status code: \(statusCode)")
                  }
                  
                  do {
                      try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                  } catch (let writeError) {
                      print("Error creating a file \(destinationFileUrl) : \(writeError)")
                  }
                  
              } else {
                  print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
              }
          }
          task.resume()
        
        
        
    }
    
    
    

    
    
    @objc func sideMenuButtonPressed(){
        present(sideMenu!, animated: true)
    }
    
    @objc func notificationButtonPressed(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
        
        
        let startEndDates: [Date?] = self.getCurrentStartAndEndDate(staringTime: self.siteDetail?.starting_time ?? [], endingTime: self.siteDetail?.ending_time ?? [])
        
        let startDateTime: Date? = startEndDates.first ?? nil
        let endDateTime: Date? = startEndDates.last ?? nil

        
        if let startTime = startDateTime, let endTime = endDateTime {
            
            let hours: Int   = Calendar.current.dateComponents([.hour], from: startTime, to: endTime).hour ?? 0
            print(hours)
            
            var dates = [Date]()
            for index in 0...hours {

                let calendar = Calendar.current
                let date = calendar.date(byAdding: .hour, value: index, to: startTime) ?? Date()
                dates.append(date)

            }
            
            vc?.dates = dates

            
        }else {
         
            
            
        }

        
        
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nationwide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func storeSiteDetailsInStorage(siteDetail: SiteDetail) {
        do {
            let encoder = JSONEncoder()
            let siteDetail = try encoder.encode(siteDetail)
            
            UserDefaults.standard.set(siteDetail, forKey: "siteDetail")

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
//        self.navigationController?.pushViewController(vc!, animated: false)
        let vc  = ChatViewController()
        vc.title = "Chat"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func historyButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @IBAction func checkInPressed(_ sender: UIButton) {
        
        let startEndDates: [Date?] = self.getCurrentStartAndEndDate(staringTime: self.siteDetail?.starting_time ?? [], endingTime: self.siteDetail?.ending_time ?? [])
        
        let startDateTime: Date? = startEndDates.first ?? nil
        let endDateTime: Date? = startEndDates.last ?? nil
        let currentDate: Date = Date()
        
        if let startTime = startDateTime, let endTime = endDateTime, let withinRegion = isDeviceWithinRegion{
            if currentDate > startTime && currentDate < endTime && withinRegion {   // current time is between start and end time
                
                checkInAPICall(job_id: self.siteDetail?.shift_id ?? 1, break_hours: 0, timezone: localTimeZoneIdentifier)
                
            }else{
                self.showErrorAlert(errorMessage: "This User has no duty time or not within region.")
            }
        }else{
         
            self.showErrorAlert(errorMessage: "This User has no duty time or not within region.")
        }

        

        
    }
    
    @IBAction func checkOutPressed(_ sender: Any) {
        checkOutAPICall(id: self.checkInOutdata?.id ?? 1, type: "check_out", timezone: localTimeZoneIdentifier, clicked: true)
    }
    @IBAction func breakInPressed(_ sender: Any) {
        checkOutAPICall(id: self.checkInOutdata?.id ?? 1, type: "break", timezone: localTimeZoneIdentifier, clicked: true)
    }
    
    @IBAction func downLoadWorkOrderPressed(_ sender: UIButton) {
        
        
        if let workOrderURL = self.siteDetail?.job?.work_order_url {
            
            let url: URL = URL(string: workOrderURL)!
//            self.storeAndShare(withURLString: workOrderURL)
            self.downloadPDF(url: url)

        }
        
        
    }
    
    
}

extension SiteDetailViewController {
    
    func siteDetailsAPICall() {
        
        var token = ""
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
            }
        }
        
        KRProgressHUD.show()
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/get_site_details")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            KRProgressHUD.dismiss()


            do {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(SiteDetailApiResponse.self, from: data!)

                print("The Response is : ",apiResponse)

                
              
                
                if apiResponse.status == "Error" {
                    self.showErrorAlert(errorMessage: apiResponse.message)
                } else {
                    
                    self.siteDetail = apiResponse.siteDetail
                    
                    
                    if let st = self.siteDetail {
                        //Save CheckInData in Prefernces
                        let encoder = JSONEncoder()
                        let siteDetail = try encoder.encode(apiResponse.siteDetail)
                        UserDefaults.standard.set(siteDetail, forKey: "SiteDetail")
                        
                        self.storeSiteDetailsInStorage(siteDetail: st)
                    }else{
                        UserDefaults.standard.set(nil, forKey: "SiteDetail")
                        self.showErrorAlert(errorMessage: "This User has no job Assigned.")
                    }
                    self.setupUI()
                }
            }
            catch {
                self.showErrorAlert(errorMessage: "Something went wrong. Please try again later.")
                print("JSON Serialization error")
            }

        }).resume()
        
        
    }
    
    func checkInAPICall(job_id: Int, break_hours: Int, timezone: String)  {
        var token = ""
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
            }
        }
        
        KRProgressHUD.show()
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/check_in?shift_id=\(job_id)&break_hours=\(break_hours)&timezone=\(timezone)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            KRProgressHUD.dismiss()


            do {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(CheckInCheckOutApiResponse.self, from: data!)

                if apiResponse.status == "Error" {
                    self.showErrorAlert(errorMessage: apiResponse.message)
                } else {
                    
                    //Save CheckInData in Prefernces
                    let encoder = JSONEncoder()
                    let checkInOUt = try encoder.encode(apiResponse.checkInCheckOutData)
                    UserDefaults.standard.set(checkInOUt, forKey: "CheckIN")
                    
                    DispatchQueue.main.async {
                        

                        self.btnCheckIn.isEnabled = false
                        self.btnCheckOut.isEnabled = true
                        self.btnBreak.isEnabled = true
                    }
                }
            }
            catch {
                self.showErrorAlert(errorMessage: "Something went wrong. Please try again later.")
                print("JSON Serialization error")
            }

        }).resume()
    }
    
    
    func checkOutAPICall(id: Int,type: String, timezone: String, clicked: Bool)  {
        var token = ""
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
            }
        }
        
        KRProgressHUD.show()
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/check_out?id=\(id)&type=\(type)&timezone=\(timezone)&clicked=\(clicked)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            KRProgressHUD.dismiss()


            do {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(CheckInCheckOutApiResponse.self, from: data!)

                print("The Response is : ",apiResponse)

                if apiResponse.status == "Error" {
                    self.showErrorAlert(errorMessage: apiResponse.message)
                } else {
                    
                    //Save CheckInData in Prefernces
                    let encoder = JSONEncoder()
                    let checkInOUt = try encoder.encode(apiResponse.checkInCheckOutData)
                    UserDefaults.standard.set(checkInOUt, forKey: "CheckIN")
                    
                    DispatchQueue.main.async {
                        
                        self.btnCheckIn.isEnabled = true
                        self.btnCheckOut.isEnabled = false
                        self.btnBreak.isEnabled = false
                        
//                        if type == "check_out" {
//                            self.checkOutTime.text = apiResponse.checkInCheckOutData?.check_out_time
//                        } else {
//                            self.breakInTime.text = apiResponse.checkInCheckOutData?.check_out_time
//                        }
                        
                        
                        
                    }
                }
            }
            catch {
                self.showErrorAlert(errorMessage: "Something went wrong. Please try again later.")
                print("JSON Serialization error")
            }

        }).resume()
    }

    
}




extension SiteDetailViewController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
//        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.lastPathComponent
//        documentInteractionController.presentPreview(animated: <#T##Bool#>)
    }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        KRProgressHUD.show()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                KRProgressHUD.dismiss()
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
        }.resume()
    }
}
