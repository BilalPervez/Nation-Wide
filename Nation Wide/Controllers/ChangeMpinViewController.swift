//
//  ChangeMpinViewController.swift
//  Nation Wide
//
//  Created by Muhammad Bilal on 11/01/2023.
//

import UIKit
import SideMenu
import KRProgressHUD

class ChangeMpinViewController: UIViewController {

    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var sideMenu: SideMenuNavigationController?
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
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
    
    @objc func sideMenuButtonPressed(){
        present(sideMenu!, animated: true)
    }
    
    @objc func notificationButtonPressed(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
    

    @IBAction func didTapChangeMPIN(_ sender: UIButton) {
        
        if self.newPasswordTextField.text == self.oldPasswordTextField.text {
            
            self.showErrorAlert(errorMessage: "New and Old Password shouldn't be same.")
            
        }else if self.newPasswordTextField.text == self.confirmPasswordTextField.text {
            
            changeMpin()
            
        }else{
            
            self.showErrorAlert(errorMessage: "Password doesn't Matched.")
            
        }
        
        
    }
    
    
    
    
    func changeMpin() {
        
        KRProgressHUD.show()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)

        let url = URL(string: "https://setrank.work/public/api/update_password")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let parameters = ["phone": self.phoneNumber ?? "",
                          "new_password": self.newPasswordTextField.text ?? "",
                          "old_password":self.oldPasswordTextField.text ?? ""
        ] as [String : Any]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            KRProgressHUD.dismiss()

            if error != nil || data == nil {
                print("Client error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Oops!! there is server error!")
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                print("response is not json")
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            guard let apiResponse = try? decoder.decode(SignInWithCellPhoneResponse.self, from: data!) else {
                        return
            }
            
            print("The Response is : ",apiResponse)
            
            if apiResponse.status == "Error" {
                self.showErrorAlert(errorMessage: apiResponse.message)
            } else {
                
                self.showErrorAlert(errorMessage: apiResponse.message)
                
//                if self.storeUerObjectInStorage(userData: apiResponse.userData!) {
////                    self.navigationToNextScreen()
//                } else {
//                    self.showErrorAlert(errorMessage: "Something Went Wrong. Please try again later")
//                }
                
                
                
                
            }

        })

        task.resume()
    }
    
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nationwide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
