//
//  SkimaViewController.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

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
