//
//  AddExpensesView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 20/10/24.
//

import SwiftUI

struct AddExpensesView: View {
    @State private var transactionTime:String = ""
    @State private var transactionDateAndTime:Date = Date()
    @State private var paymentType:[String] = ["Online","Cash","Card Payment"]
    @State private var selectedPaymentType:String = "Payment Type"
    @State private var selectedCard:String = ""
    @State private var toast: CustomToast?
    @State private var bindaleValue:String = ""
    @EnvironmentObject var viewModel: CreditCardViewModel
    @StateObject private var addExpenseVM:AddExpenseViewModel = AddExpenseViewModel()
    @FetchRequest(entity: CardData.entity(), sortDescriptors: [])
    private var creditCards: FetchedResults<CardData>
    var body: some View {
        NavigationView {
            ZStack{
                BackroundBlurView()
                ScrollView(showsIndicators:false){
                    VStack(spacing:15){
                        AddExpensesTFView(bindbleValue: $bindaleValue, text: $transactionTime, title: "Transaction Date and Time",placeHolder:"Transaction Date and Time",isTextField: false, isDatePickerView: true, transactionDate: $addExpenseVM.expenseDate)
                        
                        AddExpensesTFView(bindbleValue: $bindaleValue, text: $addExpenseVM.expenseAmount, title: "Amount",placeHolder:"Spending Amount", isTextField: true, transactionDate: $transactionDateAndTime)
                        
                        AddExpensesTFView(bindbleValue: $bindaleValue, text: $addExpenseVM.purpose, title: "Purpose",placeHolder:"purpose E.g electronics,etc..", isTextField: true, transactionDate: $transactionDateAndTime)
                        
                        AddExpensesTFView(bindbleValue: $addExpenseVM.payMethod, text: $selectedPaymentType, title: "Payment Type",menuValue: paymentType, isTextField: false, transactionDate: $transactionDateAndTime)
                        
                        if selectedPaymentType == "Card Payment"{
                            AddExpensesTFView(bindbleValue: $addExpenseVM.expenseCardNum, text: $selectedCard , title: "Select Card",menuValue: creditCards.map { $0.c_num ?? "" }, isTextField: false, transactionDate: $transactionDateAndTime)
                        }
                        
                        Button("ADD EXPENSE"){
                            if addExpenseVM.validateFields(){
                                viewModel.addExpense(expenseAmount: Double(addExpenseVM.expenseAmount) ?? 0.0, expenseDate: addExpenseVM.expenseDate, payMethod: addExpenseVM.payMethod, purpose: addExpenseVM.purpose, expenseCardNum: addExpenseVM.expenseCardNum){
                                    addExpenseVM.resetData()
                                }
                            }else{
                                self.toast = CustomToast(type: .error, title: "Error", message: addExpenseVM.errorMessage ?? "Please fill all require field.", duration: 3)
                            }
                        }.frame(maxWidth:.infinity).padding().background(Color(hex: "AF52DE")).cornerRadius(13).foregroundColor(.white).padding()
                    }.padding(.bottom,70)
                }
            }.navigationTitle("Add Expenses")
                .toastView(toast: $toast)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    ContentView(context: context).environment(\.managedObjectContext, context)
        .preferredColorScheme(.dark)
}

struct BackroundBlurView:View {
    var body: some View {
        ZStack{
            Color(hex: "211134")
            Circle()
                .fill(Color(hex:"0C445B").opacity(1))
                .frame(width: 300,height: 300)
                .blur(radius: 80)
                .offset(x:-100,y:-300)
            Circle()
                .fill(Color(hex:"0C445B").opacity(1))
                .frame(width: 300,height: 300)
                .blur(radius: 50).offset(x:150,y:-60)
            Circle()
                .fill(Color(hex:"0C445B").opacity(1))
                .frame(width: 300,height: 300)
                .blur(radius: 50).offset(x:-100,y:190)
            Circle()
                .fill(Color(hex:"0C445B").opacity(1))
                .frame(width: 300,height: 300)
                .blur(radius: 80).offset(x:150,y:-60)
        }.edgesIgnoringSafeArea(.all)
           
    }
}

struct AddExpensesTFView:View {
    @Binding var bindbleValue:String
    @Binding var text:String
    @State var title:String
    @State var placeHolder:String?
    @State var menuValue:[String]?
    @State var isTextField:Bool
    @State var isDatePickerView:Bool?
    @Binding var transactionDate:Date
    

    var body: some View {
        
        VStack(alignment:.leading,spacing: 0){
            Text(title.uppercased()).font(Font.custom("Poppins-Medium", size: 12)).foregroundColor(.gray)
            if isTextField{
                TextField(placeHolder ?? "",text: $text).font(Font.custom("Poppins-SemiBold", size: 15))
                    .padding(.vertical)
            }else if isDatePickerView ?? false{
                DatePicker(selection: $transactionDate, in:Date()...Date().addingTimeInterval(60 * 60 * 24 * 365)) {
                    Text("\(formatDateToString(date: transactionDate, format:  "MMM, dd yyyy | hh:mm a"))").font(Font.custom("Poppins-SemiBold", size: 15))
                        .onAppear{
                            print(transactionDate)
                        }
                }.font(Font.custom("Poppins-SemiBold", size: 13)).padding(.vertical,10)
            }
            else{
                Menu {
                    ForEach(menuValue ?? [], id: \.self) { value in
                        Button(action: {
                            bindbleValue = value
                            text = value
                        }) {
                            Text(value).font(Font.custom("Poppins-SemiBold", size: 15))
                        }
                    }
                } label: {
                    HStack {
                        Text(bindbleValue)
                        Spacer()
                        Image(systemName: "chevron.down") // Custom image
                    }.foregroundColor(.white).font(Font.custom("Poppins-SemiBold", size: 15))
                        .padding(.vertical)
                }
            }
            RoundedRectangle(cornerRadius: 2)
                .frame(height: 1).foregroundColor(Color(hex: "AF52DE").opacity(0.7))
            
        }.padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.white.opacity(0.2),lineWidth: 1)
            }
            .padding(.horizontal)
    }
}

let gradientSurface = LinearGradient(colors: [.white.opacity(0.1), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
 let gradientBorder = LinearGradient(colors: [.white.opacity(0.2), .white.opacity(0.0), .white.opacity(0.0), .green.opacity(0.0), .green.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)

struct CardView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .foregroundStyle(.white.opacity(0.13)).blur(radius: 1)
            .background(.ultraThinMaterial)
            .mask( RoundedRectangle(cornerRadius: 15,
                                    style: .circular).foregroundColor(.black) )
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .stroke(lineWidth: 1.5)
                    .foregroundStyle(gradientBorder)
                    .opacity(0.8)
            )
    }
}


func formatDateToString(date: Date,format:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}
