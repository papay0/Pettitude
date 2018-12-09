//
//  HomeViewController.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import ARKit
import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    weak var listener: HomePresentableListener?
    
    private lazy var internalView: HomeView = {
        return HomeView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = internalView
    }
    
    // MARK: - Private
    
    private var sceneView: ARSKView!
}
