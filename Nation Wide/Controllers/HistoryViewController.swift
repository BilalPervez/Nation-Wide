//
//  HistoryViewController.swift
//  Nation Wide
//
//  Created by Solution Surface on 15/06/2022.
//

import UIKit
import SideMenu
import KRProgressHUD

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var siteDetailButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var totalHours: UILabel!
    @IBOutlet weak var totalEarnings: UILabel!
    
    var sideMenu: SideMenuNavigationController?
    var checkInCheckOutHistoryList : [CheckInCheckOutHistoryObject]?
    var historyDetails : HistoryDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTimeLogAPICall()
        returnUserApiCall()

    }
    
    func setupUI() {
        
        DispatchQueue.main.async {
            
            self.totalHours.text = "\(self.historyDetails?.total_hours ?? 0)"
            self.totalEarnings.text = "\(self.historyDetails?.total_earnings ?? 0)"
            
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
            
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
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nation Wide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    @objc func sideMenuButtonPressed() {
        present(sideMenu!, animated: true)
    }
    
    @objc func notificationButtonPressed() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func siteDetailButtonPressed(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SiteDetailViewController") as? SiteDetailViewController
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
//        self.navigationController?.pushViewController(vc!, animated: false)
        let vc  = ChatViewController()
        vc.title = "Chat"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HistoryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkInCheckOutHistoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.date.text = "16-June-2022"
        cell.day.text = "Thursday"
        cell.checkInTime.text = self.checkInCheckOutHistoryList?[indexPath.row].check_in_time
        cell.checkOutTime.text = self.checkInCheckOutHistoryList?[indexPath.row].check_out_time
        return cell
    }
}

extension HistoryViewController {
    func historyTimeLogAPICall() {
        var token = ""
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
            }
        }
        
        KRProgressHUD.show()
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/timeLog")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            KRProgressHUD.dismiss()


            do {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(TimeLogHistoryApiResponse.self, from: data!)

                print("The Response is : ",apiResponse)

                if apiResponse.status == "Error" {
                    self.showErrorAlert(errorMessage: apiResponse.message)
                } else {
                    self.checkInCheckOutHistoryList = apiResponse.checkInCheckOutHistoryList
                    DispatchQueue.main.async {
                        self.historyTableView.reloadData()
                    }
                    
                }
            }
            catch {
                
                self.showErrorAlert(errorMessage: "Something went wrong. Please try again later.")
                print("JSON Serialization error")
            }

        }).resume()
    }
    
    func returnUserApiCall() {
        var token = ""
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
            }
        }
        
        KRProgressHUD.show()
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/user")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            KRProgressHUD.dismiss()


            do {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(ApiReturnUserResponse.self, from: data!)

                print("The Response is : ",apiResponse)

                if apiResponse.status == "Error" {
                    self.showErrorAlert(errorMessage: apiResponse.message)
                } else {
                    self.historyDetails = apiResponse.historyDetails
                    self.setupUI()
                    
                    
                }
            }
            catch {
                
                self.showErrorAlert(errorMessage: "Something went wrong. Please try again later.")
                print("JSON Serialization error")
            }

        }).resume()
    }
    
}
