//
//  CreditCardViewModel.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 10/11/24.
//


import Foundation
import CoreData

class CreditCardViewModel: ObservableObject {
    // Properties for Credit Card management
    @Published var cHolder = ""
    @Published var cNum = ""
    @Published var cardType = ""
    @Published var cvv = ""
    @Published var expiryDate = ""
    @Published var amount: Double = 0.0
    
   
    @Published var isCompletedSuccess:Bool = false
    @Published var isCompletedFailed:Bool = false
    @Published var selectedCard: CardData?
    @Published var errorMessage:String?
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func validateFields(name:String, c_num:String, expiryDate:String, cvv:String,amount:String,c_type:String) -> Bool {
        errorMessage = nil
        if c_num.isEmpty {
            errorMessage = "Please enter a card number."
            return false
        }else if c_type.isEmpty {
            errorMessage = "Please enter a card type."
            return false
        }else if name.isEmpty{
            errorMessage = "Please enter a card holder name."
            return false
        }else if expiryDate.isEmpty {
            errorMessage = "Please enter a expiry date."
            return false
        }else if cvv.isEmpty {
            errorMessage = "Please enter a cvv number."
            return false
        }else if amount.isEmpty {
            errorMessage = "Please enter a card amount."
            return false
        }else{
            return true
        }
    }
    
    // MARK: - Add Credit Card
    func addCard(completion:@escaping () -> Void) {
        let newCard = CardData(context: viewContext)
        newCard.c_holder = cHolder
        newCard.c_num = cNum
        newCard.card_type = cardType
        newCard.cvv = cvv
        newCard.expiry_date = expiryDate
        newCard.amount = amount
        
        saveContext()
        completion()
    }
    
    // MARK: - Update Credit Card Amount
    func updateAmount(newAmount: Double) {
        guard let card = selectedCard else { return }
        card.amount = newAmount
        saveContext()
    }
    
    // MARK: - Add Expense
    func addExpense(expenseAmount:Double, expenseDate:Date, payMethod:String, purpose:String, expenseCardNum:String,completion:@escaping () -> Void) {
        let newExpense = ExpensesData(context: viewContext)
        newExpense.amount = expenseAmount
        newExpense.date_time = expenseDate
        newExpense.pay_method = payMethod
        newExpense.purpose = purpose
        newExpense.card_num = expenseCardNum
        
        // Update card amount if pay method is "Card" and card_num matches
        if payMethod == "Card Payment" {
            updateCardAmountAfterExpense(expenseCardNum: expenseCardNum, expenseAmount: expenseAmount)
        }
        completion()
        saveContext()
    }
    
    private func updateCardAmountAfterExpense(expenseCardNum:String,expenseAmount:Double) {
        // Fetch the credit card by card number
        let fetchRequest: NSFetchRequest<CardData> = CardData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "c_num == %@", expenseCardNum)
        
        do {
            let cards = try viewContext.fetch(fetchRequest)
            if let card = cards.first {
                card.amount -= expenseAmount
                isCompletedSuccess.toggle()
            }
        } catch {
            isCompletedFailed.toggle()
            print("Failed to update card amount: \(error.localizedDescription)")
        }
    }
    
    
    private func saveContext() {
        do {
            try viewContext.save()
            isCompletedSuccess.toggle()
            print(viewContext)
        } catch {
            isCompletedFailed.toggle()
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    func reset(){
        cHolder = ""
        cNum = ""
        expiryDate = ""
        cvv = ""
        cardType = ""
    }
}
