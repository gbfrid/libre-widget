//
//  BGWidgetBundle.swift
//  BGWidget
//
//  Created by Gabe Fridkis on 2/24/23.
//

import WidgetKit
import SwiftUI

@main
struct BGWidgetBundle: WidgetBundle {
    var body: some Widget {
        BGWidget()
        BGWidgetLiveActivity()
    }
}
