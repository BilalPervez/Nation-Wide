//
//  NotificationsViewController.swift
//  Nation Wide
//
//  Created by Solution Surface on 17/06/2022.
//

import UIKit
import SideMenu
import KRProgressHUD
import CoreMedia

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var sideMenu: SideMenuNavigationController?
    @IBOutlet weak var notificationsTableView: UITableView!
    
    
    var dates:[Date]?
    var token = ""
    var shiftId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationsTableView.delegate = self
        self.notificationsTableView.dataSource = self
        
        self.setupUI()
        
        self.fetchSiteDetailsFromDefaults()
        self.fetchUserFromDefaults()
        
        
    }
    
    
    func fetchUserFromDefaults() {
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                self.token = loadedPerson.token ?? ""
            }
        }
    }
    
    func fetchSiteDetailsFromDefaults() {
        if let siteDetail = UserDefaults.standard.object(forKey: "siteDetail") as? Data {
            let decoder = JSONDecoder()
            if let siteDetail = try? decoder.decode(SiteDetail.self, from: siteDetail) {
                self.shiftId = siteDetail.shift_id ?? 0
            }
        }
    }
    
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
//        let notificationBarButton = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .done, target: self, action: #selector(notificationButtonPressed))
//        self.navigationItem.rightBarButtonItem  = notificationBarButton
        
        let sideMenuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(sideMenuButtonPressed))
        self.navigationItem.leftBarButtonItem = sideMenuBarButton
        
        
        sideMenu = SideMenuNavigationController(rootViewController: SideMenuController())
        sideMenu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    
    @objc func sideMenuButtonPressed(){
        present(sideMenu!, animated: true)
    }
    
    @objc func notificationButtonPressed(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

extension NotificationsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        
        let date: Date = dates?[indexPath.row] ?? Date()
        let time = date.toString(dateFormat: "HH:mm")
        let hour = Int(time.split(separator: ":").first ?? "0")
        cell.timeLabel.text = time
        
        let CurrentHour: Int   = (Calendar.current.component(.hour, from: Date()))
        if CurrentHour == hour {
            cell.userImage.tintColor = UIColor(hexString: "#007AFF")
        }else{
            
            cell.userImage.tintColor = UIColor(hexString: "#8E8E93")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let date: Date = dates?[indexPath.row] ?? Date()
        let time = date.toString(dateFormat: "HH:mm")
        let hour = Int(time.split(separator: ":").first ?? "0")
        
        let CurrentHour: Int   = (Calendar.current.component(.hour, from: Date()))
        if CurrentHour == hour {
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
            
        }
        
    }
}


extension NotificationsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nation Wide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
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
    
    
    
    func emergencyImageUploadRequest(imageToUpload: UIImage, imgKey: String) {

        KRProgressHUD.show()
        
        let myUrl = NSURL(string: "https://setrank.work/public/api/save_image");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let param = [
            "shift_id"  : "\(self.shiftId ?? 0)",
            "reason"    : "notification"
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
    
    
}




