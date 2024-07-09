//
//  MyAppWidgetBundle.swift
//  MyAppWidget
//
//  Created by Neto on 05-07-24.
//

import WidgetKit
import SwiftUI

@main
struct MyAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyAppWidget()
        MyAppWidgetLiveActivity()
    }
}
