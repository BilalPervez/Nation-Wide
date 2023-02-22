/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import UIKit
struct PayoutDetail : Codable {
    
	let id : Int?
	let user_id : Int?
	let job_id : Int?
	let total_hours : String?
	let hourly_rate : String?
	let total_rate : String?
	let break_hours : String?
	let payment_date : String?
	let is_confirmed : String?
	let confirmed : String?
	let created_at : String?
	let updated_at : String?
    var cellOpened = false
	let job : Job?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user_id = "user_id"
		case job_id = "job_id"
		case total_hours = "total_hours"
		case hourly_rate = "hourly_rate"
		case total_rate = "total_rate"
		case break_hours = "break_hours"
		case payment_date = "payment_date"
		case is_confirmed = "is_confirmed"
		case confirmed = "confirmed"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case job = "job"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		job_id = try values.decodeIfPresent(Int.self, forKey: .job_id)
		total_hours = try values.decodeIfPresent(String.self, forKey: .total_hours)
		hourly_rate = try values.decodeIfPresent(String.self, forKey: .hourly_rate)
		total_rate = try values.decodeIfPresent(String.self, forKey: .total_rate)
		break_hours = try values.decodeIfPresent(String.self, forKey: .break_hours)
		payment_date = try values.decodeIfPresent(String.self, forKey: .payment_date)
		is_confirmed = try values.decodeIfPresent(String.self, forKey: .is_confirmed)
		confirmed = try values.decodeIfPresent(String.self, forKey: .confirmed)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		job = try values.decodeIfPresent(Job.self, forKey: .job)
	}

}
