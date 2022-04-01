//
//  ScreenViewModel.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

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
