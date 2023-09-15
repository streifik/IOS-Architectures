//
//  ViewModifier.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 01.09.23.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
