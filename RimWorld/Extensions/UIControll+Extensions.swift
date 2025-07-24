//
//  UIControll+Extensions.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import Combine
import UIKit

extension UIControl {
    struct Publisher: Combine.Publisher {
        
        typealias Output = UIControl
        typealias Failure = Never
        
        private let control: UIControl
        private let event: UIControl.Event

        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }

        func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber, control: control, event: event)
            subscriber.receive(subscription: subscription)
        }

        private final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == UIControl, S.Failure == Never {
            private var subscriber: S?
            private weak var control: UIControl?

            init(subscriber: S, control: UIControl, event: UIControl.Event) {
                self.subscriber = subscriber
                self.control = control
                control.addTarget(self, action: #selector(eventHandler), for: event)
            }

            func request(_ demand: Subscribers.Demand) {}

            func cancel() {
                subscriber = nil
            }

            @objc private func eventHandler() {
                _ = subscriber?.receive(control!)
            }
        }
    }

    func publisher(for event: UIControl.Event) -> UIControl.Publisher {
        return Publisher(control: self, event: event)
    }
}
