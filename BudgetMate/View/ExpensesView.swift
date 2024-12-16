//
//  ExpensesView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 09/11/24.
//

import SwiftUI

struct ExpensesView: View {
    @FetchRequest(entity: CardData.entity(), sortDescriptors: [])
    private var creditCards: FetchedResults<CardData>
    @FetchRequest(
        entity: ExpensesData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpensesData.date_time, ascending: true)]
    ) private var expensesData: FetchedResults<ExpensesData>
    
    @State private var upcomingEvents: [ExpensesData] = []
    @State private var completedExpenses: [ExpensesData] = []
    var totalExpenses: Double {
        expensesData.reduce(0) { $0 + $1.amount }
    }
    @State private var selectedCard: CardData?
    var body: some View {
        NavigationView{
            ZStack{
                BackroundBlurView()
                ScrollView(showsIndicators:false){
                    VStack(alignment:.leading,spacing:20){
                        VStack{
                            HStack{
                                VStack(alignment:.leading){
                                    Text("Total Expenses")
                                    Text(String(format: "₹ %.2f" ,totalExpenses)).font(Font.custom("Poppins-Bold", size: 28))
                                }
                            }
                            .padding().frame(maxWidth: .infinity,alignment: .leading)
                            .background(Color(hex:"AF52DE"))
                            .cornerRadius(14)
                            .padding()
                        }
                        Section("UPCOMMING"){
                            VStack{
                                ForEach(upcomingEvents){ expense in
                                    ExpensesCardView(expenses: expense)
                                }
                            }
                        }.padding(.horizontal)
                        VStack{
                            PairHeadingWithButtonView(title: "Expenses" )
                            ForEach(completedExpenses.reversed(),id:\.date_time ){expenses in
                                ExpensesCardView(expenses: expenses)
                            }
                        }.padding()
                    }.navigationTitle("Expenses").padding(.bottom,70)
                }
            }
        }.onAppear(perform: filterEvents)
    }
    private func filterEvents() {
        let currentDate = Date()
        
        // Separate into upcoming and completed
        upcomingEvents = expensesData.filter { $0.date_time! > currentDate }
        completedExpenses = expensesData.filter { $0.date_time! <= currentDate }
        print(upcomingEvents)
        print(completedExpenses)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    ContentView(context: context).environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}

struct ExpensesCardView: View {
    @State var expenses: ExpensesData
    var body: some View {
        VStack(alignment:.leading){
            HStack(alignment:.center){
                Text(expenses.purpose ?? "").font(Font.custom("Poppins-SemiBold", size: 17)).frame(maxWidth: .infinity,alignment: .leading)
                Text(String(format: "₹ %.2f", expenses.amount)).font(Font.custom("Poppins-SemiBold", size: 17))
                    .padding(.horizontal).padding(.vertical,5).foregroundColor(.green)
            }
            HStack {
                Text("\(formatDateToString(date: expenses.date_time!, format:  "MMM, dd yyyy | hh:mm a"))")
                Text(expenses.pay_method ?? "").frame(maxWidth: .infinity,alignment: .trailing)
            }.font(Font.custom("Poppins", size: 14)).foregroundColor(.white.opacity(0.7))
        }.padding()
            .background(Color(hex:"19173D")).cornerRadius(18)
            .overlay{
                RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.3),lineWidth: 0.3)
            }.onAppear{
                print(expenses)
            }
    }
    
}
