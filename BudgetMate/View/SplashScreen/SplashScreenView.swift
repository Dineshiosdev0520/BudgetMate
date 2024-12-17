//
//  SplashScreenView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 17/12/24.
//

import SwiftUI
import CoreData

struct SplashScreenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var viewModel: CreditCardViewModel
    private var profileViewModel: ProfileViewModel
    
    init(context: NSManagedObjectContext) {
        self.viewModel = CreditCardViewModel(context: context)
        self.profileViewModel = ProfileViewModel(context: context)
    }
    @State private var isOpenTabbarView:Bool = false
    var body: some View {
        ZStack{
            BackroundBlurView()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing:10){
                Image("icon").resizable().frame(width: 100,height: 100)
                Text("BudgetMate").multilineTextAlignment(.center)
                    .font(Font.custom("Poppins-Bold", size: 20))
                    .foregroundColor(.white).kerning(3)
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                isOpenTabbarView.toggle()
            }
        }
        .fullScreenCover(isPresented: $isOpenTabbarView, content: {
            CustomTabbarView(viewRouter:ViewRouter()).environmentObject(viewModel).environmentObject(profileViewModel)
        })
    }
}
