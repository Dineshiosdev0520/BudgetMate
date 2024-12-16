//
//  ProfileViewModel.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 10/11/24.
//

import Foundation
import CoreData

class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var number: String = ""
    @Published var s_name:String = ""
    @Published var isCompletedSuccess: Bool = false
    @Published var isCompletedFailed: Bool = false
    @Published var errorMessage: String?
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadProfile()
    }
    
    func validateFields() -> Bool {
        errorMessage = nil
        if name.isEmpty {
            errorMessage = "Please enter a user name."
            return false
        }else if s_name.isEmpty {
            errorMessage = "Please enter a nick name."
            return false
        }else if email.isEmpty{
            errorMessage = "Please select a email."
            return false
        }else if number.isEmpty {
            errorMessage = "Please select a mobile number."
            return false
        }else{
            return true
        }
    }
    
    private func loadProfile() {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            if let profile = try viewContext.fetch(fetchRequest).first {
                name = profile.name ?? ""
                email = profile.email ?? ""
                number = profile.number ?? ""
                s_name = profile.s_name ?? ""
            }
        } catch {
            print("Error loading profile: \(error.localizedDescription)")
        }
    }
    
    func saveProfile() {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let profile = try viewContext.fetch(fetchRequest).first ?? Profile(context: viewContext)
            profile.name = name
            profile.email = email
            profile.number = number
            profile.s_name = s_name
            try viewContext.save()
            isCompletedSuccess.toggle()
        } catch {
            print("Error saving profile: \(error.localizedDescription)")
        }
    }
    
     func updateProfile(number:String,name:String,s_name:String) {
        // Fetch the credit card by card number
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "number == %@", number)
        
        do {
            let update = try viewContext.fetch(fetchRequest)
            if let update = update.first {
                update.s_name = s_name
                update.name = name
                isCompletedSuccess.toggle()
            }
        } catch {
            isCompletedFailed.toggle()
            print("Failed to update card amount: \(error.localizedDescription)")
        }
    }
}
