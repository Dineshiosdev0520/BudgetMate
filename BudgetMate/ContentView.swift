//
//  ContentView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 20/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var viewModel: CreditCardViewModel
    private var profileViewModel: ProfileViewModel
    
    init(context: NSManagedObjectContext) {
        self.viewModel = CreditCardViewModel(context: context)
        self.profileViewModel = ProfileViewModel(context: context)
    }
    
    var body: some View {
        CustomTabbarView(viewRouter:ViewRouter()).environmentObject(viewModel).environmentObject(profileViewModel)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    ContentView(context: context).environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}
