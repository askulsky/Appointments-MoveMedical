//
//  AppointmentsApp.swift
//  Appointments
//
//  Created by Aaron Skulsky on 11/5/22.
//

import SwiftUI

@main
struct AppointmentsApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
