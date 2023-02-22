/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

//import Foundation
//struct SiteDetail : Codable {
//	let job_id : Int?
//	let site_name : String?
//	let poc_name : String?
//	let poc_cell_number : String?
//	let zip : String?
//	let state : String?
//	let city : String?
//	let address : String?
//	let ref_no : String?
//	let sarting_date : String?
//	let ending_date : String?
//	let sarting_time : Int?
//	let ending_time : Int?
//	let lng : Double?
//	let lat : Double?
//	let work_order_url : String?
//
//	enum CodingKeys: String, CodingKey {
//
//		case job_id = "job_id"
//		case site_name = "site_name"
//		case poc_name = "poc_name"
//		case poc_cell_number = "poc_cell_number"
//		case zip = "zip"
//		case state = "state"
//		case city = "city"
//		case address = "address"
//		case ref_no = "ref_no"
//		case sarting_date = "sarting_date"
//		case ending_date = "ending_date"
//		case sarting_time = "sarting_time"
//		case ending_time = "ending_time"
//		case lng = "lng"
//		case lat = "lat"
//		case work_order_url = "work_order_url"
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		job_id = try values.decodeIfPresent(Int.self, forKey: .job_id)
//		site_name = try values.decodeIfPresent(String.self, forKey: .site_name)
//		poc_name = try values.decodeIfPresent(String.self, forKey: .poc_name)
//		poc_cell_number = try values.decodeIfPresent(String.self, forKey: .poc_cell_number)
//		zip = try values.decodeIfPresent(String.self, forKey: .zip)
//		state = try values.decodeIfPresent(String.self, forKey: .state)
//		city = try values.decodeIfPresent(String.self, forKey: .city)
//		address = try values.decodeIfPresent(String.self, forKey: .address)
//		ref_no = try values.decodeIfPresent(String.self, forKey: .ref_no)
//		sarting_date = try values.decodeIfPresent(String.self, forKey: .sarting_date)
//		ending_date = try values.decodeIfPresent(String.self, forKey: .ending_date)
//		sarting_time = try values.decodeIfPresent(Int.self, forKey: .sarting_time)
//		ending_time = try values.decodeIfPresent(Int.self, forKey: .ending_time)
//		lng = try values.decodeIfPresent(Double.self, forKey: .lng)
//		lat = try values.decodeIfPresent(Double.self, forKey: .lat)
//		work_order_url = try values.decodeIfPresent(String.self, forKey: .work_order_url)
//	}
//
//}



/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SiteDetail : Codable {
    let job_id : Int?
    let shift_id : Int?
    let start_date : String?
    let end_date : String?
    let gaurd_type : String?
    let starting_time : [String]?
    let ending_time : [String]?
    let job : Job?

    enum CodingKeys: String, CodingKey {

        case job_id = "job_id"
        case shift_id = "shift_id"
        case start_date = "start_date"
        case end_date = "end_date"
        case gaurd_type = "gaurd_type"
        case starting_time = "starting_time"
        case ending_time = "ending_time"
        case job = "job"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        job_id = try values.decodeIfPresent(Int.self, forKey: .job_id)
        shift_id = try values.decodeIfPresent(Int.self, forKey: .shift_id)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        gaurd_type = try values.decodeIfPresent(String.self, forKey: .gaurd_type)
        starting_time = try values.decodeIfPresent([String].self, forKey: .starting_time)
        ending_time = try values.decodeIfPresent([String].self, forKey: .ending_time)
        job = try values.decodeIfPresent(Job.self, forKey: .job)
    }

}
