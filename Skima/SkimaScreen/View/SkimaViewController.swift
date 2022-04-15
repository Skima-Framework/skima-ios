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
import PureLayout

public class SkimaViewController: UIViewController {

    private let viewModel: SkimaViewModel
    
    public init(fromEndpoint: String) {
        self.viewModel = SkimaViewModel(endpoint: fromEndpoint)
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.delegate = self
        viewModel.loadData()
        navigationController?.navigationBar.isHidden = true
    }

    func renderScreen(_ screen: Screen) {
        WidgetsEngine.shared.render(screen.ui, in: view, scopeId: screen.metadata?.id)
    }
}

extension SkimaViewController: SkimaViewModelDelegate {
    func onSuccess() {
        guard let screenModel = viewModel.model else { return }
        if let _color = screenModel.backgroundColor {
            view.backgroundColor = UIColor.init(hex: _color)
        }
        renderScreen(screenModel)
    }
}
