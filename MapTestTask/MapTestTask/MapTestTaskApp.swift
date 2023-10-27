//
//  MapTestTaskApp.swift
//  MapTestTask
//
//  Created by Artem Vishniakov on 26.10.2023.
//

import SwiftUI

@main
struct MapTestTaskApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init())
        }
    }
}
