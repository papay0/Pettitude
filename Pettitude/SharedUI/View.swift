//
//  View.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import UIKit

open class View: UIView {

    public init() {
        super.init(frame: .zero)
    }

    public convenience override init(frame: CGRect) {
        self.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public final func configure() {
        build()
        setupConstraints()
    }

    open func build() {

    }

    open func setupConstraints() {

    }
}
