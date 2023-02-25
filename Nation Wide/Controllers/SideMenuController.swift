//
//  SideMenuController.swift
//  Nation Wide
//
//  Created by Solution Surface on 15/06/2022.
//

import Foundation
import UIKit
import KRProgressHUD

class SideMenuController: UITableViewController {
    
//    let items = ["Dashboard","Profile","Payout","Emergency","Change MPin"]
    let items = ["Dashboard","Profile","Emergency","Change MPin"]
    let logoutbutton = UIButton()
    var token = ""
    var phoneNumber: String?
    var siftId = 0
    var user: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchSiteDetailsFromDefaults()
        self.fetchUserFromDefaults()
        
        logoutbutton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.separatorColor = UIColor(hexFromString: "#0067B2")
        
        
    }
    
    
    func fetchUserFromDefaults() {
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                user = loadedPerson
                self.token = loadedPerson.token ?? ""
                self.phoneNumber = loadedPerson.user?.phone ?? ""
                tableView.reloadData()
                
            }
        }
    }
    
    func fetchSiteDetailsFromDefaults() {
        if let siteDetail = UserDefaults.standard.object(forKey: "siteDetail") as? Data {
            let decoder = JSONDecoder()
            if let siteDetail = try? decoder.decode(SiteDetail.self, from: siteDetail) {
                self.siftId = siteDetail.shift_id ?? 0
            }
        }
    }
    
    
    @objc func logOutPressed(){
        
        let alert = UIAlertController(title: "Nation Wide", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            UserDefaults.standard.set(nil, forKey: "user")
            UserDefaults.standard.set(nil, forKey: "CheckIN")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            let navViewController = UINavigationController(rootViewController: initialViewController)
            sceneDelegate.window?.rootViewController = navViewController
            sceneDelegate.window?.makeKeyAndVisible()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 150))

        
        let image = CircularImageView()
        image.frame = CGRect.init(x: 70, y: -10, width: 100, height: 100)
        if let avatar = self.user?.user?.avatar_url {
                
            let url = URL(string: avatar)
            getData(from: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() { [weak self] in
                        image.image = UIImage(data: data)
                    }
                }
            
        }else{
            image.image = UIImage(systemName: "camera.circle")
        }
        

        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: headerView.frame.height / 3, width: headerView.frame.width-20, height: headerView.frame.height-20)
        label.text = "\(self.user?.user?.first_name ?? "") \(self.user?.user?.last_name ?? "")"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(hexFromString: "#0067B2")
        
        headerView.addSubview(label)
        headerView.addSubview(image)

        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 150
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
        
        self.logoutbutton.frame = CGRect.init(x: 20, y: footerView.frame.height / 3, width: 100, height: 40)
        logoutbutton.setTitle("Logout", for: .normal)
        logoutbutton.setTitleColor(UIColor(hexFromString: "#DF4343"), for: .normal)
        logoutbutton.backgroundColor = UIColor(hexFromString: "#E6F0F8")
        logoutbutton.layer.cornerRadius = 10
        footerView.addSubview(logoutbutton)

        return footerView
    }
    

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 80
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SiteDetailViewController") as? SiteDetailViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        } else if indexPath.row == 2 {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }else if indexPath.row == 3 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangeMpinViewController") as? ChangeMpinViewController
            vc?.phoneNumber = phoneNumber
            self.navigationController?.pushViewController(vc!, animated: false)
            
        }
        
    }
    
}

extension SideMenuController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            "shift_id"  : "\(self.siftId ?? 0)",
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
    
    
}

