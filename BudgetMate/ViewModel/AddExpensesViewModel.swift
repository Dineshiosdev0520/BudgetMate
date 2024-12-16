//
//  AddExpensesViewModel.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 22/11/24.
//

import Foundation


class AddExpenseViewModel: ObservableObject {
    @Published var expenseAmount: String = ""
    @Published var expenseDate = Date()
    @Published var payMethod = "Select Payment Type"
    @Published var purpose = ""
    @Published var expenseCardNum = "Select Card"
    
    @Published var errorMessage: String?
    
    func validateFields() -> Bool {
        errorMessage = nil
        if expenseAmount.isEmpty {
            errorMessage = "Please enter a valid amount."
            return false
        }else if purpose.isEmpty {
            errorMessage = "Please enter a purpose for the expense."
            return false
        }else if payMethod.isEmpty || payMethod.contains("Select"){
            errorMessage = "Please select a payment method."
            return false
        }else if payMethod == "Card Payment" && ( payMethod.contains("Select") || expenseCardNum.isEmpty ) {
            errorMessage = "Please select a card for payment."
            return false
        }else{
            return true
        }
    }
    
    func resetData(){
        expenseAmount = ""
        expenseDate = Date()
        payMethod = "Select Payment Type"
        purpose = ""
        expenseCardNum = "Select Card"
    }
}

