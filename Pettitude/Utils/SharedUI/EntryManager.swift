//
//  EntryManager.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 04/01/2019.
//  Copyright © 2019 Arthur Papailhau. All rights reserved.
//

import SwiftEntryKit

struct EntryManager {

    static var bottomAlertAttributes: EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: UIColor(white: 100.0/255.0, alpha: 0.3))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.roundCorners = .all(radius: 25)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.7,
                                                              spring: .init(damping: 1, initialVelocity: 0)),
                                             scale: .init(from: 1.05, to: 1,
                                                          duration: 0.4,
                                                          spring: .init(damping: 1,
                                                                        initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.2))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        
        return attributes
    }
    
    static func showPopupMessage( title: String,
                                  titleColor: UIColor,
                                  description: String,
                                  descriptionColor: UIColor,
                                  buttonTitleColor: UIColor,
                                  buttonBackgroundColor: UIColor,
                                  buttonAction: (() -> Void)?,
                                  completionHandler:  @escaping () -> Void) {
        
        var attributes: EKAttributes
        attributes = bottomAlertAttributes
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.BlueGradient.light, EKColor.BlueGradient.dark], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.positionConstraints = .fullWidth
        attributes.positionConstraints.safeArea = .overridden
        attributes.roundCorners = .top(radius: 20)
        
        attributes.screenInteraction = .dismiss
        
        attributes.lifecycleEvents.didDisappear = {
            completionHandler()
        }
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 24), color: titleColor, alignment: .center))
        let description = EKProperty.LabelContent(text: description, style: .init(font: MainFont.light.with(size: 34), color: descriptionColor, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: LS("screenshot"),
                                                           style: .init(font: MainFont.bold.with(size: 16),
                                                                        color: buttonTitleColor)),
                                              backgroundColor: buttonBackgroundColor,
                                              highlightedBackgroundColor: buttonTitleColor.withAlphaComponent(0.05))
        
        if let window = UIApplication.shared.windows.first {
            let message = EKPopUpMessage(title: title, description: description, button: button) {
                buttonAction?()
            }
            let contentView = EKPopUpMessageView(with: message)
            SwiftEntryKit.display(entry: contentView, using: attributes, presentInsideKeyWindow: true, rollbackWindow: .custom(window: window))
        } else {
            let simpleMessage = EKSimpleMessage(title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
            
            let contentView = EKNotificationMessageView(with: notificationMessage)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
}
