//
//  CreateMpinViewController.swift
//  Nation Wide
//
//  Created by Solution Surface on 13/06/2022.
//

import UIKit
import KRProgressHUD

class CreateMpinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var isUpdateMPIN: Bool?
    
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.setTitleColor(.white, for: .normal)
        self.loginButton.setTitle((isUpdateMPIN ?? false) ? "Create": "Login", for: UIControl.State.normal)
        self.loginTextField.delegate = self
        
//        self.loginTextField.text = "4321"
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func navigationToNextScreen() {
        
        DispatchQueue.main.async {
            
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SiteDetailViewController") as? SiteDetailViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
            
        }
        
        
    }
    
    func storeUerObjectInStorage(userData: UserData) -> Bool {
        do {
            let encoder = JSONEncoder()
            let user = try encoder.encode(userData)
            
            UserDefaults.standard.set(user, forKey: "user")
            
            DispatchQueue.main.async {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SiteDetailViewController")
                let window = UIWindow(frame: UIScreen.main.bounds)
                let navViewController = UINavigationController(rootViewController: initialViewController)
                window.rootViewController = navViewController
                window.makeKeyAndVisible()

            }
            
            return true

        } catch {
            print("Unable to Encode Note (\(error))")
            return false
        }
    }
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nationwide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        loginWithMpin()
    }
    
    @IBAction func forgotMpinPressed(_ sender: UIButton) {
        
        
        verifyPhoneAPICall();
       
        
        
    }
    
    
}

extension CreateMpinViewController {
    
    
    func verifyPhoneAPICall() {
        
        KRProgressHUD.show()

        let session = URLSession.shared
        let url = URL(string: "https://setrank.work/public/api/verify_phone?phone=\(self.phoneNumber ?? "")&status=false")!
        
        let task = session.dataTask(with: url) { data, response, error in
            KRProgressHUD.dismiss()
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
                
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            guard let apiResponse = try? decoder.decode(SignInWithCellPhoneResponse.self, from: data!) else {
                        return
            }

            if apiResponse.status == "Error" {
                
                self.showErrorAlert(errorMessage: apiResponse.message)
                
            } else {
                
                
                DispatchQueue.main.async {
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let sceneDelegate = windowScene.delegate as? SceneDelegate
                      else {
                        return
                      }
                    UserDefaults.standard.set(nil, forKey: "user")
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    let navigationHomeVC = UINavigationController(rootViewController: loginVC)
                    sceneDelegate.window?.rootViewController = navigationHomeVC
                }
                
               
                
            }
        }
        task.resume()
        
        
    }
    
    
    func loginWithMpin() {
        
        KRProgressHUD.show()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)

        let url = URL(string: "https://setrank.work/public/api/login")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let parameters = ["phone": self.phoneNumber ?? "",
                          "password": self.loginTextField.text ?? ""
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
            guard let apiResponse = try? decoder.decode(Json4Swift_Base.self, from: data!) else {
                        return
            }
            
            print("The Response is : ",apiResponse)
            
            if apiResponse.status == "Error" {
                self.showErrorAlert(errorMessage: apiResponse.message)
            } else {
                
                if self.storeUerObjectInStorage(userData: apiResponse.data!) {
                    self.navigationToNextScreen()
                } else {
                    self.showErrorAlert(errorMessage: "Something Went Wrong. Please try again later")
                }
                
                
                
                
            }

        })

        task.resume()
    }
    
}
