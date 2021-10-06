//
//  ArtistSearchApp.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI

@main
struct ArtistSearchApp: App {
    
    let environment = AppEnvironment.initialSetup()

    var body: some Scene {
        WindowGroup {
            MainView(container: AppEnvironment.initialSetup().container)
        }
    }
}
