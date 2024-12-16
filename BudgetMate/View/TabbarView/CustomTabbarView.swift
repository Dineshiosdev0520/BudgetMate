//
//  CustomTabbarView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 10/11/24.
//

import SwiftUI

struct CustomTabbarView: View {
    @StateObject var viewRouter:ViewRouter
    
    @State var isTabbarActive:Bool = false
    @State var isTabbarActiveTrue:Bool = true
    @State private var isAddCreditCard:Bool = false
    
    @EnvironmentObject var viewModel: CreditCardViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    
    
    //   @Binding var isActiveTabbr : Bool
    
    var body: some View {
        NavigationView {
            GeometryReader{ geometry in
                ZStack(alignment:.bottom){
                    
                    switch viewRouter.currentPage {
                    case .home:
                        HomeView(isAddCreditCard: $isAddCreditCard).environmentObject(viewModel)
                    case .expenses:
                        ExpensesView().environmentObject(viewModel)
                    case .addExpenses:
                        AddExpensesView().environmentObject(viewModel)
                    case .statictics:
                        StaticticsView().environmentObject(viewModel)
                    case .profile:
                        ProfileView(isHiddenAddCardView: $isAddCreditCard).environmentObject(viewModel).environmentObject(profileViewModel)
                    }
                    
                    HStack{
                        TabbarView(viewRouter:viewRouter,assignedPage: .home , width: geometry.size.width/5, height: geometry.size.height/31 ,systemName: "house", systemActiveImage: "house", name: "Home")
                        TabbarView(viewRouter:viewRouter,assignedPage: .expenses , width: geometry.size.width/5, height: geometry.size.height/31, systemName: "chart.bar", systemActiveImage: "chart.bar", name: "Beneficiary")
                        ZStack{
                            Image(systemName: "plus")
                                .font(.system(size: 23,weight: .bold))
                                .frame(width: geometry.size.width/7.8,height: geometry.size.height/15)
                                .background(viewRouter.currentPage == .addExpenses ? Color(hex:"AF52DE") : Color(hex:"0C445B")).shadow(radius: 10)
                                .cornerRadius(50)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 50).stroke(viewRouter.currentPage == .addExpenses ? Color.white.opacity(0.8) : Color.white.opacity(0.3), lineWidth: viewRouter.currentPage == .addExpenses ? 3 : 1)
                                }
                                .shadow(color: viewRouter.currentPage == .addExpenses  ? Color(hex:"AF52DE") : .clear, radius: 10)
                                .onTapGesture {
                                    viewRouter.currentPage = .addExpenses
                                }
                        }
                       // .offset(y:-geometry.size.height/8/2.5)
                        TabbarView(viewRouter:viewRouter,assignedPage: .statictics , width: geometry.size.width/5, height: geometry.size.height/31, systemName: "chart.bar.xaxis", systemActiveImage: "chart.bar.xaxis", name: "History")
                        TabbarView(viewRouter:viewRouter,assignedPage: .profile,width: geometry.size.width/5, height: geometry.size.height/31, systemName: "person", systemActiveImage: "person", name: "Settings")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height/10)
                    .background (.ultraThinMaterial)
                    
                    if isAddCreditCard{
                        ZStack(alignment:.bottom) {
                            Color.black.opacity(0.5)
                                .onTapGesture {
                                    isAddCreditCard.toggle()
                                }
                            AddCardView(isHiddenAddCardView: $isAddCreditCard).transition(.move(edge: .bottom)).environmentObject(viewModel)
                        }
                    }
                    
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
#Preview {
    let context = PersistenceController.preview.container.viewContext
    ContentView(context: context).environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}

struct TabbarView: View {
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    let width, height: CGFloat
    let systemName, systemActiveImage, name: String
    var body: some View {
        VStack {
            Image(systemName: viewRouter.currentPage == assignedPage ? systemActiveImage : systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
            
        }.fontWeight(.semibold)
            .foregroundColor(viewRouter.currentPage == assignedPage ? Color(hex:"AF52DE") : .secondary)
        .shadow(color:viewRouter.currentPage == assignedPage ? Color(hex:"AF52DE").opacity(0.8) : .clear,radius: 10)
        .padding(.horizontal, -6)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
    }
}
