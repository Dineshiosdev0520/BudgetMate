//
//  BudgetMateApp.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 20/10/24.
//

import SwiftUI
import CoreData

@main
struct BudgetMateApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
