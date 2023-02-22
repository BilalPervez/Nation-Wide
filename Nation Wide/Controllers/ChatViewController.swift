//
//  ChatViewController.swift
//  Nation Wide
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


class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


//        messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-46400), kind: .text("Hello")))
//        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-46400), kind: .text("Hi")))
//        messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-46400), kind: .text("How r u?")))
//        messages.append(Message(sender: otherUser, messageId: "4", sentDate: Date().addingTimeInterval(-46400), kind: .text("I am fine")))
//        messages.append(Message(sender: currentUser, messageId: "5", sentDate: Date().addingTimeInterval(-46400), kind: .text("Messages working fine now")))
//        messages.append(Message(sender: otherUser, messageId: "7", sentDate: Date().addingTimeInterval(-46400), kind: .text("Cool!!!")))
//        messages.append(Message(sender: currentUser, messageId: "8", sentDate: Date().addingTimeInterval(-46400), kind: .text("sdsff")))
//        messages.append(Message(sender: otherUser, messageId: "9", sentDate: Date().addingTimeInterval(-46400), kind: .text("sdfdsfdsf!!!")))
//        messages.append(Message(sender: currentUser, messageId: "10", sentDate: Date().addingTimeInterval(-46400), kind: .text("Cosdfsdfdsfol!!!")))
//        messages.append(Message(sender: otherUser, messageId: "11", sentDate: Date().addingTimeInterval(-46400), kind: .text("dgdfgdf!!!")))
//        messages.append(Message(sender: currentUser, messageId: "12", sentDate: Date().addingTimeInterval(-46400), kind: .text("gfdgfdgf!!!")))
//        messages.append(Message(sender: otherUser, messageId: "13", sentDate: Date().addingTimeInterval(-46400), kind: .text("dgfgffdg!!!")))
//        messages.append(Message(sender: currentUser, messageId: "14", sentDate: Date().addingTimeInterval(-46400), kind: .text("fdgfgdfg!!!")))
//        messages.append(Message(sender: otherUser, messageId: "15", sentDate: Date().addingTimeInterval(-46400), kind: .text("fdgfgdfg!!!")))
//        messages.append(Message(sender: currentUser, messageId: "16", sentDate: Date().addingTimeInterval(-46400), kind: .text("dfgdfgfdg!!!")))
//        messages.append(Message(sender: otherUser, messageId: "17", sentDate: Date().addingTimeInterval(-46400), kind: .text("dfgfgfdg!!!")))
//        messages.append(Message(sender: currentUser, messageId: "18", sentDate: Date().addingTimeInterval(-46400), kind: .text("fgfdgdfg!!!")))
//        messages.append(Message(sender: otherUser, messageId: "19", sentDate: Date().addingTimeInterval(-46400), kind: .text("dfgdfgfdg!!!")))
//        messages.append(Message(sender: currentUser, messageId: "20", sentDate: Date().addingTimeInterval(-46400), kind: .text("dfgfgdfg!!!")))
//        messages.append(Message(sender: otherUser, messageId: "21", sentDate: Date().addingTimeInterval(-46400), kind: .text("dfgfgdgfdgfdgfd!!!")))
        
        
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: userData) {
                token = loadedPerson.token ?? ""
                chatId = loadedPerson.chat_id ?? 0
                selfUserId = loadedPerson.user?.id ?? 0
                
            }
        }
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let completed = ref.observe(.value) { snapshot in
            var fbMessageList: [FirebaseMessage] = []
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
                    let msg = Message(sender: self.currentUser, messageId: "\(message.id ?? 0)", sentDate: messageDate ?? Date(), kind: .text(message.body ?? ""))
                    self.messages.append(msg)
                } else {
                    let msg = Message(sender: self.otherUser, messageId: "\(message.id ?? 0)", sentDate: messageDate ?? Date(), kind: .text(message.body ?? ""))
                    self.messages.append(msg)
                }
            }
            
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }
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
        
        
        
        var request = URLRequest(url: URL(string: "https://setrank.work/public/api/chats/1/sendMessage")!)
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
            let alert = UIAlertController(title: "Nation Wide", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
}
