//
//  ViewRouter.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 10/11/24.
//

import SwiftUI

class ViewRouter:ObservableObject{
    @Published var currentPage : Page = .home
    @Published var currentButton : ActiveButton = .active
}
enum Page{
    case home
    case expenses
    case addExpenses
    case statictics
    case profile
}

enum ActiveButton{
    case active
    case inActive
}
