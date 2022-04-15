/**
*  Skima Framework
*  Copyright (C) 2022 Joaquin Bozzalla
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU Affero General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU Affero General Public License for more details.
*
*  You should have received a copy of the GNU Affero General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import Alamofire

protocol SkimaViewModelDelegate: AnyObject {
    func onSuccess()
}

class SkimaViewModel {
    weak var delegate: SkimaViewModelDelegate?
    var model: Screen?
    
    let endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func loadData() {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
        let osVersion = UIDevice.current.systemVersion
        let os = UIDevice.current.systemName
        
        let headers: HTTPHeaders = [
            "appVersion": appVersion,
            "bundleVersion": bundleVersion,
            "osVersion": osVersion,
            "os": os,
        ]
        
        AF.request(endpoint, headers: headers).responseDecodable(of: Screen.self) { response in
            self.model = response.value
            self.delegate?.onSuccess()
        }
    }
    
}
