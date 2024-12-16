//
//  StaticticsView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 09/11/24.
//

import SwiftUI
import Charts

struct StaticticsView: View {
    @State var tabSelectedValue = 0
    let temperatureData = TemperatureData.example
    @EnvironmentObject var viewModel: CreditCardViewModel
    @FetchRequest(entity: CardData.entity(), sortDescriptors: [])
    private var creditCards: FetchedResults<CardData>
    @FetchRequest(entity: ExpensesData.entity(), sortDescriptors: [])
    private var expensesData: FetchedResults<ExpensesData>
    var groupedExpenses: [String: [ExpensesData]] {
        Dictionary(grouping: expensesData, by: { $0.pay_method ?? "Unknown" })
    }
    @State private var selectedCard:CardData?
    let linearGradient = LinearGradient(gradient:Gradient(colors:[Color(hex:"2B00A5").opacity(0.25),Color(hex:"120045").opacity(0)]),startPoint: .top,endPoint: .bottom)
    var body: some View {
        NavigationView{
            ZStack{
                BackroundBlurView()
                ScrollView(showsIndicators:false){
                    VStack(alignment:.leading){
                        Picker("", selection: $tabSelectedValue) {
                            Text("1W").tag(0)
                            Text("1M").tag(1)
                            Text("3M").tag(2)
                            Text("6M").tag(3)
                            Text("1Y").tag(4)
                            Text("ALL").tag(5)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        Chart {
                            ForEach(temperatureData) { data in
                                LineMark(x: .value("day", data.day),
                                         y: .value("amount", data.amount))
                            }
                            .interpolationMethod(.cardinal)
                            
                        }
                        .chartXScale(domain: ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
                        .chartXAxis {
                            AxisMarks(values: temperatureData.map { $0.day }) { value in
                                AxisTick()
                                if let day = value.as(String.self) {
                                    AxisValueLabel(day)
                                }
                            }
                        }
                        .aspectRatio(2, contentMode: .fit)
                        .padding()
                        
                        VStack{
                            HStack{
                                Menu {
                                    ForEach(creditCards, id: \.c_num) { card in
                                        Button(action: {
                                            selectedCard = card
                                        }) {
                                            Text(card.card_type ?? "").font(Font.custom("Poppins-SemiBold", size: 15))
                                        }
                                    }
                                } label: {
                                    HStack{
                                        Text("\(selectedCard?.card_type ?? "") Spendings")
                                        Image(systemName:"chevron.up.chevron.down")
                                    }.padding(5).padding(.horizontal,14).background(.ultraThinMaterial).cornerRadius(10)
                                    
                                }.frame(maxWidth:.infinity,alignment:.leading)
                                
                                Text("Due Date 10th Oct")
                            }
                            HStack{
                                Text("₹ \(String(format: "%.2f", card_expenses(card_num: selectedCard?.c_num ?? "0.0")))").font(Font.custom("Poppins-Bold", size: 18))
                                Spacer()
                                Button("Pay Early"){}.padding(.horizontal).padding(.vertical,5).background(Color(hex: "AF52DE")).cornerRadius(10).foregroundColor(.white)
                            }
                        }.padding().foregroundColor(.white)
                            .frame(maxWidth:.infinity).font(Font.custom("Poppins", size: 14))
                            .background(Color(hex: "52567C"))
                            .cornerRadius(10)
                            .padding()
                        
                        
                        ForEach(groupedExpenses.keys.sorted(), id: \.self) { key in
                            Section(header: Text(key)) {
                                ForEach(groupedExpenses[key] ?? [], id: \.self) { expense in
                                    ExpensesCardView(expenses: expense)                                    }
                            }
                        }.padding(.horizontal)
                    }.navigationTitle("Statictics").padding(.bottom,70)
                        .onAppear{
                            selectedCard = creditCards.first
                        }
                }
            }
        }
    }
    
    func card_expenses(card_num:String) -> Double {
        return expensesData
            .filter { $0.card_num == card_num }
            .reduce(0.0) { $0 + $1.amount }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    ContentView(context: context).environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}


struct TemperatureData: Identifiable {
    var id = UUID()
    var day: String // Using String to represent days, e.g., "2024-10-18"
    var amount: String // Temperature in Celsius
    
    static let example = [
        TemperatureData(day: "Sun", amount: "1k"),
        TemperatureData(day: "Mon", amount: "1.5k"),
        TemperatureData(day: "Tue", amount: "1.2k"),
        TemperatureData(day: "Wed", amount: "2.5k"),
        TemperatureData(day: "Thu", amount: "2.0k"),
        TemperatureData(day: "Fri", amount: "3.5k"),
        TemperatureData(day: "Sat", amount: "5k")
    ]
}
