//
//  ProfileViewController.swift
//  Nation Wide
//
//  Created by Solution Surface on 16/06/2022.
//

import UIKit
import SideMenu
import KRProgressHUD
import Alamofire

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    @IBOutlet weak var totalJobs: UILabel!
    @IBOutlet weak var totalEarnings: UILabel!
    @IBOutlet weak var activeSite: UILabel!
    @IBOutlet weak var siteAddress: UILabel!
    @IBOutlet weak var cellNumber: UILabel!
    
    @IBOutlet weak var tempImage: UIImageView!
    var token = ""
    var name = ""
    var cellNumberFromUserDefaults = ""
    
    var jobId = 0
    var activeSiteFromDefaults = ""
    var siteAddressFromDefaults = ""
    
    var historyDetails : HistoryDetails?

    var sideMenu: SideMenuNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        returnUserApiCall()
        fetchSiteDetailsFromDefaults()
        
        
    }
    
    func fetchUserFromDefaults() {
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                self.token = loadedPerson.token ?? ""
                self.name = "\(loadedPerson.user?.first_name ?? "")\(loadedPerson.user?.last_name ?? "")"
                self.cellNumberFromUserDefaults = loadedPerson.user?.phone ?? ""
            }
        }
    }
    
    func fetchSiteDetailsFromDefaults() {
        if let siteDetail = UserDefaults.standard.object(forKey: "siteDetail") as? Data {
            let decoder = JSONDecoder()
            if let siteDetail = try? decoder.decode(SiteDetail.self, from: siteDetail) {
                self.jobId = siteDetail.job_id ?? 0
                self.siteAddressFromDefaults = siteDetail.job?.poc_address ?? ""
                self.activeSiteFromDefaults = siteDetail.job?.site_name ?? ""
            }
        }
    }
    
    func setupUI() {
        
        DispatchQueue.main.async {
            self.userName.text = self.name
            self.cellNumber.text = self.cellNumberFromUserDefaults
            
            self.totalEarnings.text = "\(self.historyDetails?.total_earnings ?? 0)"
            self.totalHours.text = "\(self.historyDetails?.total_hours ?? 0)"
            self.totalJobs.text = "\(self.historyDetails?.total_jobs ?? 0)"
            
            self.siteAddress.text = self.siteAddressFromDefaults
            self.activeSite.text = self.activeSiteFromDefaults
            
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

    @objc func sideMenuButtonPressed(){
        present(sideMenu!, animated: true)
    }
    
    @objc func notificationButtonPressed(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func EmergencyButtonPressed(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        emergencyImageUploadRequest(imageToUpload: image, imgKey: "emergencyImage")
        
        
        
        
    }
    
}







extension ProfileViewController {
    
    
    
    func emergencyImageUploadRequest(imageToUpload: UIImage, imgKey: String) {

        KRProgressHUD.show()
        
        let myUrl = NSURL(string: "https://setrank.work/public/api/save_image");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let param = [
            "job_id"  : "\(self.jobId ?? 0)",
            "reason"    : "emergency"
        ]

        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = imageToUpload.jpegData(compressionQuality: 1)
        if imageData == nil  {
            return
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "image", imageDataKey: imageData! as NSData, boundary: boundary, imgKey: imgKey) as Data

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            KRProgressHUD.dismiss()
            
                if error != nil {
                    print("error=\(error!)")
                    
                    self.showErrorAlert(errorMessage: "An issue occured. Please try again later")
                    
                    return
                }
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response data = \(responseString!)")
            self.showErrorAlert(errorMessage: "Image uploaded successfully.")
            }

            task.resume()
        }




    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imgKey: String) -> NSData {
            let body = NSMutableData();

            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }

            let filename = "\(imgKey).jpg"
            let mimetype = "image/jpg"

            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")

            return body
        }

        func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }
    
    
    
    func returnUserApiCall() {
        
        self.fetchUserFromDefaults()
        
        KRProgressHUD.show()
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/user")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(self.token)", forHTTPHeaderField: "Authorization")

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


