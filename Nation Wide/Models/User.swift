/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User : Codable {
	let id : Int?
	let first_name : String?
	let last_name : String?
	let email : String?
	let phone : String?
	let otp_verified : Bool?
	let dob : String?
	let address : String?
	let city : String?
	let state : String?
	let zip : String?
	let avatar : String?
	let role : String?
	let email_verified_at : String?
	let job_info : String?
	let assigned : Int?
	let deleted_at : String?
	let created_at : String?
	let updated_at : String?
	let device_token : String?
	var avatar_url : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case first_name = "first_name"
		case last_name = "last_name"
		case email = "email"
		case phone = "phone"
		case otp_verified = "otp_verified"
		case dob = "dob"
		case address = "address"
		case city = "city"
		case state = "state"
		case zip = "zip"
		case avatar = "avatar"
		case role = "role"
		case email_verified_at = "email_verified_at"
		case job_info = "job_info"
		case assigned = "assigned"
		case deleted_at = "deleted_at"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case device_token = "device_token"
		case avatar_url = "avatar_url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		otp_verified = try values.decodeIfPresent(Bool.self, forKey: .otp_verified)
		dob = try values.decodeIfPresent(String.self, forKey: .dob)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		zip = try values.decodeIfPresent(String.self, forKey: .zip)
		avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
		role = try values.decodeIfPresent(String.self, forKey: .role)
		email_verified_at = try values.decodeIfPresent(String.self, forKey: .email_verified_at)
		job_info = try values.decodeIfPresent(String.self, forKey: .job_info)
		assigned = try values.decodeIfPresent(Int.self, forKey: .assigned)
		deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
		avatar_url = try values.decodeIfPresent(String.self, forKey: .avatar_url)
	}

}
