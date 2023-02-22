/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Job : Codable {
    let id : Int?
    let site_name : String?
    let person : String?
    let poc_cell_no : String?
    let poc_address : String?
    let poc_city : String?
    let poc_state : String?
    let poc_zip : String?
    let lat : Double?
    let lng : Double?
    let ref_no : String?
    let shift : String?
    let supervisor_name : String?
    let supervisor_cell_number : String?
    let supervisor_email : String?
    let active : Int?
    let terminated_reason : String?
    let pdf : String?
    let deleted_at : String?
    let created_at : String?
    let updated_at : String?
    let work_order_url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case site_name = "site_name"
        case person = "person"
        case poc_cell_no = "poc_cell_no"
        case poc_address = "poc_address"
        case poc_city = "poc_city"
        case poc_state = "poc_state"
        case poc_zip = "poc_zip"
        case lat = "lat"
        case lng = "lng"
        case ref_no = "ref_no"
        case shift = "shift"
        case supervisor_name = "supervisor_name"
        case supervisor_cell_number = "supervisor_cell_number"
        case supervisor_email = "supervisor_email"
        case active = "active"
        case terminated_reason = "terminated_reason"
        case pdf = "pdf"
        case deleted_at = "deleted_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case work_order_url = "work_order_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        site_name = try values.decodeIfPresent(String.self, forKey: .site_name)
        person = try values.decodeIfPresent(String.self, forKey: .person)
        poc_cell_no = try values.decodeIfPresent(String.self, forKey: .poc_cell_no)
        poc_address = try values.decodeIfPresent(String.self, forKey: .poc_address)
        poc_city = try values.decodeIfPresent(String.self, forKey: .poc_city)
        poc_state = try values.decodeIfPresent(String.self, forKey: .poc_state)
        poc_zip = try values.decodeIfPresent(String.self, forKey: .poc_zip)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
        ref_no = try values.decodeIfPresent(String.self, forKey: .ref_no)
        shift = try values.decodeIfPresent(String.self, forKey: .shift)
        supervisor_name = try values.decodeIfPresent(String.self, forKey: .supervisor_name)
        supervisor_cell_number = try values.decodeIfPresent(String.self, forKey: .supervisor_cell_number)
        supervisor_email = try values.decodeIfPresent(String.self, forKey: .supervisor_email)
        active = try values.decodeIfPresent(Int.self, forKey: .active)
        terminated_reason = try values.decodeIfPresent(String.self, forKey: .terminated_reason)
        pdf = try values.decodeIfPresent(String.self, forKey: .pdf)
        deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        work_order_url = try values.decodeIfPresent(String.self, forKey: .work_order_url)
    }

}
