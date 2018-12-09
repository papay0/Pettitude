//
//  HomeView.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import SnapKit
import UIKit

final class HomeView: View {
    
    override init() {
        super.init()
        configure()
    }
    
    override func build() {
        backgroundColor = .red
    }
    
    override func setupConstraints() {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
