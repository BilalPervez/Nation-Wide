/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

//import Foundation
//struct FirebaseMessage : Codable {
//	let body : String?
//	let chat_id : Int?
//	let created_at : String?
//	let id : Int?
//	let sender_id : Int?
//	let updated_at : String?
//
//	enum CodingKeys: String, CodingKey {
//
//		case body = "body"
//		case chat_id = "chat_id"
//		case created_at = "created_at"
//		case id = "id"
//		case sender_id = "sender_id"
//		case updated_at = "updated_at"
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		body = try values.decodeIfPresent(String.self, forKey: .body)
//		chat_id = try values.decodeIfPresent(Int.self, forKey: .chat_id)
//		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//		id = try values.decodeIfPresent(Int.self, forKey: .id)
//		sender_id = try values.decodeIfPresent(Int.self, forKey: .sender_id)
//		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//	}
//
//}


import Firebase
import FirebaseDatabase

struct FirebaseMessage {
    let ref: DatabaseReference?
    let key: String
    let body : String?
    let chat_id : Int?
    let created_at : String?
    let id : Int?
    let sender_id : Int?
    let updated_at : String?
    
    // MARK: Initialize with Raw Data
    init(body: String, chat_id: Int, created_at: String, id: Int, sender_id: Int, updated_at: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.body = body
        self.chat_id = chat_id
        self.created_at = created_at
        self.id = id
        self.sender_id = sender_id
        self.updated_at = updated_at
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let body = value["body"] as? String,
            let chat_id = value["chat_id"] as? Int,
            let created_at = value["created_at"] as? String,
            let id = value["id"] as? Int,
            let sender_id = value["sender_id"] as? Int,
            let updated_at = value["updated_at"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.body = body
        self.chat_id = chat_id
        self.created_at = created_at
        self.id = id
        self.sender_id = sender_id
        self.updated_at = updated_at
    }
    
    // MARK: Convert GroceryItem to AnyObject
    func toAnyObject() -> Any {
        return [
            "body": body ?? "",
            "chat_id": chat_id ?? 0,
            "created_at": created_at ?? "",
            "id": id ?? 0,
            "sender_id": sender_id ?? 0,
            "updated_at": updated_at ?? ""
            
        ]
    }
}
