//
//  EnterOTPViewController.swift
//  Nation Wide
//
//  Created by Solution Surface on 13/06/2022.
//

import UIKit
import FirebaseAuth

class EnterOTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterOtpTxtField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var currentVerificationId: String?
    var phoneNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterOtpTxtField.delegate = self
        self.nextButton.setTitleColor(.white, for: .normal)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func nextPressed(_ sender: UIButton) {
     
        
        let verificationCode = enterOtpTxtField.text
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId ?? "", verificationCode: enterOtpTxtField.text ?? "")

        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            print(authError.description)
              self.showErrorAlert(errorMessage: authError.description)
            return
          }

          // User has signed in successfully and currentUser object is valid
          let currentUserInstance = Auth.auth().currentUser
            
            DispatchQueue.main.async {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateMpinViewController") as? CreateMpinViewController
                vc?.phoneNumber = self.phoneNumber
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
        
    }
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nation Wide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
}
