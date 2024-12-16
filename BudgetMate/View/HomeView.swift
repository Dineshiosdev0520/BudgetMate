//
//  HomeView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 09/11/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: CreditCardViewModel
    @FetchRequest(entity: CardData.entity(), sortDescriptors: [])
    private var creditCards: FetchedResults<CardData>
    @FetchRequest(
        entity: ExpensesData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpensesData.date_time, ascending: true)]
    ) private var expensesData: FetchedResults<ExpensesData>
    @State private var completedExpenses: [ExpensesData] = []
    @State private var selectedCard:CardData?
    @Binding var isAddCreditCard:Bool
    @State private var isOpenCardUpdateSheet:Bool = false
    var body: some View {
        NavigationView{
            ZStack{
                BackroundBlurView()
                ScrollView(showsIndicators:false){
                    VStack{
                        if creditCards.isEmpty{
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                                    .frame(width: UIScreen.main.bounds.width - 30, height: 180)
                                Image(systemName: "plus")
                            }.foregroundColor(.blue).padding().onTapGesture {
                                withAnimation{
                                    isAddCreditCard.toggle()
                                }
                            }
                        }else{
                            TabView {
                                ForEach(creditCards, id: \.c_num) { card in
                                    ZStack(alignment:.bottom) {
                                        Image("Cart1").resizable().frame(width: UIScreen.main.bounds.width - 40).aspectRatio(contentMode: .fit)
                                        VStack(alignment:.leading,spacing:10) {
                                            
                                            Text(card.c_num ?? "No Card Number").font(Font.custom("Poppins-SemiBold", size: 24))
                                            HStack {
                                                Text("Valid\nDate").font(Font.custom("Poppins", size: 8))
                                                Text(card.expiry_date ?? "No Card Number").font(Font.custom("Poppins-SemiBold", size: 15))
                                            }
                                            Text(card.c_holder ?? "No Card Number").font(Font.custom("Poppins-SemiBold", size: 18))
                                        }.frame(maxWidth:.infinity,alignment:.leading).padding(30)
                                    }.onAppear {
                                        selectedCard = card
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                    .frame(height:240)
                                    .onChange(of: card, perform: { newValue in
                                        selectedCard = newValue
                                    })
                                    
                                }
                                .padding()
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 240)
                            .tabViewStyle(.page)
                            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                        }
                        
                        VStack{
                            Text("Available balance").font(Font.custom("Poppins", size: 16)).foregroundColor(.secondary)
                            Text(String(format: "₹ %.2f", selectedCard?.amount ?? 0.0)).font(Font.custom("Poppins-Bold", size: 26))
                        }
                        .padding()
                        
                        VStack(alignment:.leading,spacing: 5){
                            VStack(spacing:8) {
                                VStack(alignment:.leading,spacing:8) {
                                    Text("Update Card Details")
                                        .font(Font.custom("Poppins", size: 16)).foregroundColor(.secondary)
                                    HStack {
                                        Text("\(selectedCard?.card_type ?? "No Card Availavble")") .font(Font.custom("Poppins-Medium", size: 16)).frame(maxWidth: .infinity,alignment:.leading)
                                        Image(systemName: "chevron.down")
                                    }.onTapGesture{
                                        isOpenCardUpdateSheet.toggle()
                                    }
                                }
                                
                                Rectangle().frame(height: 1).foregroundColor(Color(hex: "61DF70").opacity(0.6))
                                
                            }.padding(20)
                            Divider()
                            VStack(spacing:8) {
                                VStack(alignment:.leading,spacing:8) {
                                    Text("Tip Of The Day")
                                        .font(Font.custom("Poppins", size: 16)).foregroundColor(.secondary)
                                    HStack {
                                        Text("Prepare for the Budget to abide by it") .font(Font.custom("Poppins-Medium", size: 16)).frame(maxWidth: .infinity,alignment:.leading)
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                
                                Rectangle().frame(height: 1).foregroundColor(Color(hex: "61DF70").opacity(0.6))
                                
                            }
                            .padding(20)
                            
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.1),lineWidth: 1).shadow(radius: 10,x:8,y:7)
                        )
                        .padding()
                        
                        VStack{
                            PairHeadingWithButtonView(title: "Recent Expenses" )
                            if completedExpenses.isEmpty{
                                VStack{
                                    Text("No more expenses yet!").font(Font.custom("Poppins-Medium", size: 16))
                                }.frame(height: 200)
                            }else{
                                ForEach(completedExpenses.prefix(5).reversed(), id:\.date_time){ expenses in
                                    ExpensesCardView(expenses: expenses)
                                }
                            }
                            
                        }.padding(.horizontal)
                        
                        
                    }.navigationTitle("Home").padding(.bottom,70)
                }
            }.sheet(isPresented: $isOpenCardUpdateSheet, content: {
                UpdateCardDetailsView(selectedCard: $selectedCard, isCompletedSuccess: $isOpenCardUpdateSheet)
            })
            .onAppear{
                filterEvents()
            }
        }
    }
    private func filterEvents() {
        let currentDate = Date()
        completedExpenses = expensesData.filter { $0.date_time! <= currentDate }
    }
}

//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    ContentView(context: context).environment(\.managedObjectContext, context)
//        .preferredColorScheme(.dark)
//}

struct PairHeadingWithButtonView: View {
    var title:String
    var body: some View {
        HStack{
            Text(title).font(Font.custom("Poppins-Bold", size: 23))
            Spacer()
            Button("See All"){}.font(Font.custom("Poppins-Medium", size: 15))
        }
    }
}


struct DashedLine: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 200, y: 0))
        }
        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
        .foregroundColor(.gray)
    }
}


struct UpdateCardDetailsView: View {
    @Binding var selectedCard: CardData?
    @Binding var isCompletedSuccess: Bool
    @EnvironmentObject var viewModel: CreditCardViewModel
    @State private var toast:CustomToast?
    @State private var amount: String = ""
    var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 50, height: 5)
                .cornerRadius(5)
            
            Text("Update Details").font(Font.custom("Poppins-SemiBold", size: 18)).foregroundColor(Color(hex: "E33C3C"))
            
            CardTextView(text: selectedCard?.c_num ?? "")
            CardTextView(text: selectedCard?.card_type ?? "")
            CardTextView(text: selectedCard?.c_holder ?? "")
            
            HStack {
                CardTextView(text: selectedCard?.expiry_date ?? "")
                CardTextView(text: selectedCard?.cvv ?? "")
            }
            CustomTFView(text:$amount,placeHolder: "Update current amount" )
            .keyboardType(.numberPad)
            Button("Update") {
                if viewModel.validateFields(name: selectedCard?.c_holder ?? "", c_num: selectedCard?.c_num ?? "", expiryDate: selectedCard?.expiry_date ?? "", cvv: selectedCard?.cvv ?? "", amount: amount, c_type: selectedCard?.card_type ?? ""){
                    selectedCard?.amount = Double(amount) ?? 0
                    viewModel.updateAmount(newAmount: selectedCard?.amount ?? 0.0)
                }else{
                    toast = CustomToast(type: .error, title: "Error", message: viewModel.errorMessage ?? "Please fill all require fields.")
                }
            }
            .font(Font.custom("Poppins-SemiBold", size: 16))
            .padding()
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color(hex: "E3823C"), Color(hex: "E33C3C")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(10)
            .foregroundColor(.white)
            Spacer()
        }.onChange(of: viewModel.isCompletedSuccess){
            isCompletedSuccess.toggle()
        }
        .onAppear{
            viewModel.selectedCard = selectedCard
        }
        .padding()
        .padding(.bottom, 30)
        .font(Font.custom("Poppins-Medium", size: 14))
        .background(.ultraThinMaterial)
        .toastView(toast: $toast)
    }
}

struct CustomTFView: View {
    @Binding var text: String
    @State var placeHolder:String?
    var body: some View {
        TextField( placeHolder ?? "Enter value", text: $text)
            .padding()
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(.ultraThickMaterial)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.4), lineWidth: 0.5)
            )
    }
}


struct CardTextView: View {
    @State var text: String
    var body: some View {
        Text(text)
            .padding()
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(.ultraThickMaterial)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.4), lineWidth: 0.5)
            )
    }
}
