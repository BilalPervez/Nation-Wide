//
//  SignInViewController.swift
//  Nation Wide
//
//  Created by Solution Surface on 13/06/2022.
//

import UIKit
import Alamofire
import KRProgressHUD
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    var currentVerificationId = ""
    
    @IBOutlet weak var signInTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInTextField.delegate = self
        
        self.signInTextField.text = "315-503-1862"
        
        self.sendButton.setTitleColor(.white, for: .normal)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    func requestOtp(phoneNo: String) {
      // Step 3 (Optional) - Default language is English
      Auth.auth().languageCode = "en"
      let phoneNumber = "+1" + phoneNo

      // Step 4: Request SMS
      PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }

        // Either received APNs or user has passed the reCAPTCHA
        // Step 5: Verification ID is saved for later use for verifying OTP with phone number
        self.currentVerificationId = verificationID!
          
          DispatchQueue.main.async {
              
              let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnterOTPViewController") as? EnterOTPViewController
              vc?.currentVerificationId = self.currentVerificationId
              vc?.phoneNumber = self.signInTextField.text
              self.navigationController?.pushViewController(vc!, animated: true)
          }
          
      }
    }
    
    func navigationToNextScreen(screenCheck: Bool?) {
        if screenCheck ?? false {
            
            DispatchQueue.main.async {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateMpinViewController") as? CreateMpinViewController
                vc?.phoneNumber = self.signInTextField.text
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            
        } else {
            
            DispatchQueue.main.async {
                self.requestOtp(phoneNo: self.signInTextField.text ?? "")
            }
            
            
            
           
            
            
        }
    }
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nationwide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let count = text.count
    
        if string != "" {
            if count > 12
            {
                return false
            }
            if count % 4 == 0 && count < 9 {
                textField.text?.insert("-", at: String.Index.init(encodedOffset: count - 1))
            }
            return true
        }
        return true
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        self.signInAPICall()
    }
}

extension SignInViewController {
    
    func signInAPICall() {
        
        KRProgressHUD.show()
//    http://setrank.work/ntwzx
//        https://setrank.work/
//        http://192.168.100.216/nwt/
        let session = URLSession.shared
        let url = URL(string: "https://setrank.work/public/api/verify_status?phone=\(signInTextField.text ?? "")")!
        
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
                self.navigationToNextScreen(screenCheck: apiResponse.data)
            }
        }
        task.resume()
        
        
    }
    
}



