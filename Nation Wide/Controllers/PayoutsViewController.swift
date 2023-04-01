//
//  PayoutsViewController.swift
//  Nationwide
//
//  Created by Solution Surface on 17/06/2022.
//

import UIKit
import SideMenu
import KRProgressHUD


class PayoutsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sideMenu: SideMenuNavigationController?
    
    var payoutDetailsList = [PayoutDetail]()
    
    var leftLabels = [ "", "Site Address:", "Month:", "Hourly Rate:", "Break Hours:", "No of Hours:", "Salary", "Status:"]
    var rightLabels = [String]()
    
    @IBOutlet weak var payoutsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.payoutsTableView.delegate = self
        self.payoutsTableView.dataSource = self

        
        self.payoutDetailApiCall()
        self.setupUI()
    }
    
    func setupUI() {
        
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
            
//            let notificationBarButton = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .done, target: self, action: #selector(self.notificationButtonPressed))
//            self.navigationItem.rightBarButtonItem  = notificationBarButton
            
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
            let alert = UIAlertController(title: "Nationwide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    @objc func sideMenuButtonPressed(){
        present(sideMenu!, animated: true)
    }
    
    @objc func notificationButtonPressed(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.payoutDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if payoutDetailsList[section].cellOpened == true {
            return 8
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as? SectionHeaderTableViewCell else {return UITableViewCell()}
            
            cell.date.text = payoutDetailsList[indexPath.section].payment_date
            
            if payoutDetailsList[indexPath.section].cellOpened {
                cell.arrow.image = UIImage(named: "collapseArrowDown")
                cell.bgView.backgroundColor = UIColor(hexFromString: "#0067B2")
                cell.date.textColor = UIColor.white
                cell.amount.textColor = UIColor.white
            } else {
                cell.arrow.image = UIImage(named: "collapseArrow")
                cell.bgView.backgroundColor = UIColor.white
                cell.date.textColor = UIColor.black
                cell.amount.textColor = UIColor.black
            }
            
            var status: String?
            if self.payoutDetailsList[indexPath.section].is_confirmed == "1" {
                status = "Paid"
            } else {
                status = "Pending"
            }
            cell.amount.text = "$\(payoutDetailsList[indexPath.section].total_rate ?? "")-\(status ?? "")"

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") as? SectionRowTableViewCell else {return UITableViewCell()}
            cell.leftLabel.text = self.leftLabels[indexPath.row]
            
            if cell.leftLabel.text == "" {
                cell.rightLabel.text = ""
            } else if cell.leftLabel.text == "Site Address:" {
                cell.rightLabel.text = self.payoutDetailsList[indexPath.section].job?.poc_address
            } else if cell.leftLabel.text == "Month:" {
                cell.rightLabel.text = self.payoutDetailsList[indexPath.section].payment_date
            } else if cell.leftLabel.text == "Hourly Rate:" {
                cell.rightLabel.text = self.payoutDetailsList[indexPath.section].hourly_rate
            } else if cell.leftLabel.text == "Break Hours:" {
                cell.rightLabel.text = self.payoutDetailsList[indexPath.section].break_hours
            } else if cell.leftLabel.text == "No of Hours:" {
                cell.rightLabel.text = self.payoutDetailsList[indexPath.section].total_hours
            } else if cell.leftLabel.text == "Salary" {
                cell.rightLabel.text = "$\(self.payoutDetailsList[indexPath.section].total_rate ?? "")"
            } else if cell.leftLabel.text == "Status:" {
                
                if self.payoutDetailsList[indexPath.section].is_confirmed == "1" {
                    cell.rightLabel.text = "Paid"
                } else {
                    cell.rightLabel.text = "Pending"
                }
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if payoutDetailsList[indexPath.section].cellOpened == true {
            payoutDetailsList[indexPath.section].cellOpened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        } else {
            payoutDetailsList[indexPath.section].cellOpened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
}

extension PayoutsViewController {
    
    func payoutDetailApiCall() {
        var token = ""
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
            }
        }
        
        KRProgressHUD.show()
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/getPayroll")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            KRProgressHUD.dismiss()


            do {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(PayrollApiResponse.self, from: data!)

                print("The Response is : ",apiResponse)

                if apiResponse.status == "Error" {
                    self.showErrorAlert(errorMessage: apiResponse.message)
                } else {
                    self.payoutDetailsList = apiResponse.payoutDetailsList ?? []
                    
                    DispatchQueue.main.async {
                        self.payoutsTableView.reloadData()
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
