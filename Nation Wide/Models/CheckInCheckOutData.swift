/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CheckInCheckOutData : Codable {
	let user_id : Int?
	let job_id : Int?
	let check_in : Int?
	let updated_at : String?
	let created_at : String?
	let id : Int?
	let check_in_time : String?
	let check_out_time : String?

	enum CodingKeys: String, CodingKey {

		case user_id = "user_id"
		case job_id = "job_id"
		case check_in = "check_in"
		case updated_at = "updated_at"
		case created_at = "created_at"
		case id = "id"
		case check_in_time = "check_in_time"
		case check_out_time = "check_out_time"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		job_id = try values.decodeIfPresent(Int.self, forKey: .job_id)
		check_in = try values.decodeIfPresent(Int.self, forKey: .check_in)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		check_in_time = try values.decodeIfPresent(String.self, forKey: .check_in_time)
		check_out_time = try values.decodeIfPresent(String.self, forKey: .check_out_time)
	}

}
