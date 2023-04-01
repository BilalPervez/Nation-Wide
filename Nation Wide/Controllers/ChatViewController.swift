//
//  ChatViewController.swift
//  Nationwide
//
//  Created by Solution Surface on 15/06/2022.
//

import UIKit
import SideMenu
import MessageKit
import InputBarAccessoryView
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase
import KRProgressHUD
import SDWebImage


struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind


}

struct Media: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    
}


class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    



    let image = UIImage(named: "my_image")




    
    
    let currentUser = Sender(senderId: "self", displayName: "Jhon Smith")
    let otherUser = Sender(senderId: "Admin", displayName: "NTW Admin")
    var messages = [MessageType]()
    var firebaseMessagesList = [FirebaseMessage]()
    private let keyboardManager = KeyboardManager()
    private let subviewInputBar = InputBarAccessoryView()

    var ref = Database.database().reference(withPath: "messages")
    var usersRefObservers: [DatabaseHandle] = []
    
    var token = ""
    var chatId = 0
    var selfUserId = 0
    var selfUserAvatar = ""
    var shiftId = 0
    
    
    
    /// The object that manages attachments
       lazy var attachmentManager: AttachmentManager = { [unowned self] in
           let manager = AttachmentManager()
           manager.delegate = self
           return manager
       }()
       
       /// The object that manages autocomplete
//       lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
//           let manager = AutocompleteManager(for: self.messageInputBar.inputTextView)
//           manager.delegate = self
//           manager.dataSource = self
//           return manager
//       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


//        tableView.keyboardDismissMode = .interactive
        messageInputBar.delegate = self
        
//        messageInputBar.plugins = [attachmentManager]
        
        
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
                chatId = loadedPerson.chat_id ?? 0
                selfUserId = loadedPerson.user?.id ?? 0
                selfUserAvatar = loadedPerson.user?.avatar_url ?? ""
                
            }
        }
        
        fetchSiteDetailsFromDefaults()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
//        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(onSearchButtonClicked))
//                self.navigationItem.rightBarButtonItem  = searchBarButtonItem

       

        
//        messageInputBar.leftStackView.addArrangedSubview(searchBarButtonItem)

        setupInputButton()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem()
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
    
    
    func setupInputButton()  {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        
        button.onTouchUpInside { _ in
            self.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    private func presentInputActionSheet(){
        let actionSheet = UIAlertController(title: "Media", message: "Please choose", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            
        }))
        present(actionSheet, animated: true)
        
    }
    @objc func onSearchButtonClicked(_ sender: Any){
        print("SearchButtonClicked")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        let completed = ref.observe(.value) { snapshot in
            var fbMessageList: [FirebaseMessage] = []
            self.messages.removeAll()
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let fbMessage = FirebaseMessage(snapshot: snapshot) {
                    fbMessageList.append(fbMessage)
                }
            }
            
            for (index, message) in fbMessageList.enumerated() {
                
                let date = NSDate(timeIntervalSince1970: TimeInterval(((Double(message.created_at ?? "0") ?? 0)/1000.0)))
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
                let messageDate = formatter.date(from: formatter.string(from: date as Date))
                
                if message.sender_id == self.selfUserId {
                    
                    if  (message.body?.contains("https://") ?? false) {
                     
                        let url: URL = URL(string: message.body ?? "")!
                        let messageKind: MessageKind = (message.body?.contains("https://") ?? false) ? .photo(Media(url: url, image: nil, placeholderImage: UIImage(named: "placehodlerImage")!, size: CGSize(width: 250, height: 200))) : .text(message.body ?? "")
                        
                        let msg = Message(sender: self.currentUser, messageId: "\(message.id ?? 0)", sentDate: messageDate ?? Date(), kind: messageKind)
                        self.messages.append(msg)
                        
                    }else{
                        
                        let messageKind: MessageKind = .text(message.body ?? "")
                        let msg = Message(sender: self.currentUser, messageId: "\(message.id ?? 0)", sentDate: messageDate ?? Date(), kind: messageKind)
                        self.messages.append(msg)
                        
                    }
                    
                } else {
                    if  (message.body?.contains("https://") ?? false) {
                        
                        let url: URL =  URL(string: message.body ?? "")!
                        let messageKind: MessageKind = (message.body?.contains("https://") ?? false) ? .photo(Media(url: url, image: nil, placeholderImage: UIImage(named: "placehodlerImage")!, size: CGSize(width: 250, height: 200))) : .text(message.body ?? "")
                        let msg = Message(sender: self.otherUser, messageId: "\(message.id ?? 0)", sentDate: messageDate ?? Date(), kind: messageKind)
                        self.messages.append(msg)
                        
                    }else{
                        
                        let messageKind: MessageKind = .text(message.body ?? "")
                        let msg = Message(sender: self.otherUser, messageId: "\(message.id ?? 0)", sentDate: messageDate ?? Date(), kind: messageKind)
                        self.messages.append(msg)
                        
                    }
                    
    
                    
                    
                    
                }
            }
            
            DispatchQueue.main.async {
                
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == "self" {
            
            
            let imageUrl = URL(string: selfUserAvatar)!
            let request = URLRequest(url: imageUrl)
            let session = URLSession.shared

        
            // Check if the image is already in the cache
            if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
                let image = UIImage(data: cachedResponse.data)
                let avatar = Avatar(image: image, initials: "AB")
                avatarView.set(avatar: avatar)
                // Use the cached image
            } else {
                // If the image is not in the cache, download it and store it in the cache
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let data = data, let response = response {
                        let cachedResponse = CachedURLResponse(response: response, data: data)
                        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                        let image = UIImage(data: data)
                        let avatar = Avatar(image: image, initials: "AB")
                        avatarView.set(avatar: avatar)
                        // Use the downloaded image
                    }
                }
                task.resume()
            }

           
        }else{
            let avatar = Avatar(image: UIImage(named: "AppIcon"), initials: "AB")
            avatarView.set(avatar: avatar)
        }
        
    }
    

    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        guard let message = message as? Message else {
            return
        }
        switch message.kind {
        case .photo(let media):
            guard let imageurl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageurl, completed: nil)
            
        default:
            break
        }
        
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        let text = inputBar.inputTextView.text!

        
        messages.append(Message(sender: currentUser, messageId: "", sentDate: Date().addingTimeInterval(-46400), kind: .text(text)))
        messagesCollectionView.reloadData()
        sendMessage(message: text)
        DispatchQueue.main.async {
            
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
        inputBar.inputTextView.text = ""
    }
    
    
    func sendMessage(message: String?) {
        
        
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/chats/\(chatId)/sendMessage")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        let parameters = ["message": message,
                          "type": "api"
        ] as [String : Any]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in


            do {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(SendMessagesResponse.self, from: data!)

                print("The Response is : ",apiResponse)

                if apiResponse.status == "Error" {
                    self.showErrorAlert(errorMessage: apiResponse.message)
                }
            }
            catch {
                self.showErrorAlert(errorMessage: "Something went wrong. Please try again later.")
                print("JSON Serialization error")
            }

        }).resume()
    }
    
    
    func showErrorAlert(errorMessage: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Nationwide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
}



extension ChatViewController: AttachmentManagerDelegate {
    
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = messageInputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let imageData = image.pngData() else{
            return
        }
        //upload image
        // send message
        messageImageUploadRequest(imageToUpload: image, imgKey: "chat")
        
        
        
        
        
    }
    
    
    func messageImageUploadRequest(imageToUpload: UIImage, imgKey: String) {

        KRProgressHUD.show()
        
        let myUrl = NSURL(string: "https://setrank.work/public/api/save_image");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let param = [
            "shift_id"  : "\(self.shiftId ?? 0)",
            "reason"    : "chat"
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
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                
                let mesageURL = json?["data"] as? String
                self.sendMessage(message: mesageURL)
                
                
        
                
                
//                if let avatar = self.currentUser?.user?.avatar_url {
//
//                    let url = URL(string: avatar)
//                    self.getData(from: url!) { data, response, error in
//                            guard let data = data, error == nil else { return }
//                            print("Download Finished")
//                            // always update the UI from the main thread
//                            DispatchQueue.main.async() { [weak self] in
//                                self?.userImage.image = UIImage(data: data)
//                            }
//                        }
//
//                }else{
//                    self.userImage.image = UIImage(systemName: "camera.fill")
//                }
                
//                self.showErrorAlert(errorMessage: "Image uploaded successfully.")
                
            } catch {
                print("errorMsg")
            }
            
//                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("response data = \(responseString!)")
            
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
