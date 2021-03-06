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

import UIKit

public class SkimaTabbarController: UITabBarController {
    
    private let viewModel: SkimaTabbarViewModel
    
    public init(fromEndpoint: String) {
        self.viewModel = SkimaTabbarViewModel(endpoint: fromEndpoint)
        super.init(nibName: .none, bundle: .none)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
    }
    
    private func configureTabs() {
        var vcs: [UIViewController] = []
        viewModel.model?.tabs?.forEach({ tab in
            guard let _endpoint = tab.endpoint else { return }
            let item = UITabBarItem()
            item.title = tab.title
            
            guard let str = tab.image, let url = URL(string: str) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        item.image = self?.resizeImage(image: image, targetSize: CGSize(width: 36, height: 36))
                    }
                }
            }

            let vc = SkimaViewController(fromEndpoint: _endpoint)
            vc.tabBarItem = item
            vcs.append(vc)
        })
        viewControllers = vcs
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension SkimaTabbarController: SkimaViewModelDelegate {
    func onSuccess() {
        configureTabs()
    }
}
