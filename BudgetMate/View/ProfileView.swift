//
//  ProfileView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 27/10/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewRouter = ViewRouter()
    @FetchRequest(entity: Profile.entity(), sortDescriptors: [])
    private var profile_data: FetchedResults<Profile>
    @State private var currentUserValue:Profile?
    @Binding var isHiddenAddCardView: Bool
    @State private var isEditProfile: Bool = false
    @State var isUpdateProfile: Bool = false
    @EnvironmentObject var profileViewModel: ProfileViewModel
    var body: some View {
        NavigationView{
            ZStack{
                BackroundBlurView()
                ScrollView(showsIndicators:false){
                    VStack(spacing:10){
                        
                        HStack(alignment:.top){
                            
                            Image(systemName: "person.crop.circle").resizable().frame(width:60,height:60).foregroundColor(.gray).overlay(
                                RoundedRectangle(cornerRadius: 50).stroke(.white,lineWidth: 2)
                            )
                            
                            VStack(alignment:.leading,spacing:0) {
                                HStack {
                                    Text(profile_data.first?.name ?? "User Name").font(Font.custom("Poppins-Medium", size: 16)).foregroundColor(profile_data.isEmpty ? .white.opacity(0.6) : .white).frame(maxWidth:.infinity,alignment:.leading)
                                    Button(action: {
                                        isEditProfile = profile_data.isEmpty ? false : true
                                        isUpdateProfile = true
                                        
                                    }, label: {
                                        Text(profile_data.isEmpty ? "Update" : "Edit").font(Font.custom("Poppins", size: 12)).foregroundColor(.blue)
                                    })
                                }
                                Text(profile_data.first?.s_name ?? "Second name").font(Font.custom("Poppins", size: 15))
                                Text(profile_data.first?.email ?? "email").font(Font.custom("Poppins", size: 15))
                                Text(profile_data.first?.number ?? "Mobile Number").font(Font.custom("Poppins", size: 15))
                                if !profile_data.isEmpty{
                                    HStack {
                                        Text("Verified")
                                        Image(systemName:"checkmark.seal.fill")
                                    }.font(Font.custom("Poppins-SemiBold", size: 16)).foregroundColor(.green)
                                }
                                
                                
                            }.foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth:.infinity,alignment:.leading)
                            
                        }.padding()
                            .background(.ultraThinMaterial).cornerRadius(15).overlay(
                                RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.2),lineWidth: 1)
                            ).shadow(radius: 10,x:7,y:7).padding()
                        
                        HStack(spacing:20){
                            Button("Add Expenses"){
                                withAnimation{
                                    viewRouter.currentPage = .addExpenses
                                }
                            }.frame(maxWidth:.infinity).padding().background(Color(hex: "AF52DE")).cornerRadius(13)
                            Button("Add Card"){
                                withAnimation{
                                    isHiddenAddCardView.toggle()
                                }
                            }.frame(maxWidth:.infinity).padding().background(Color(hex: "AF52DE")).cornerRadius(13)
                        }.foregroundColor(.white).font(Font.custom("Poppins-Medium", size: 16)).padding(.horizontal)
                        
                        VStack(alignment:.leading,spacing:10){
                            Text("SUPPORT").foregroundColor(.secondary).font(Font.custom("Poppins", size: 13))
                            
                            ProfileCardPairView(image: "envelope", text: "Contact via Mail", imageColor: .blue)
                            ProfileCardPairView(image: "phone", text: "Contact via Phone", imageColor: .brown,isHiddenDivider: false)
                            
                        }.padding().background(.ultraThinMaterial).cornerRadius(15).overlay(
                            RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.2),lineWidth: 1)
                        ).shadow(radius: 10,x:7,y:7).padding()
                        
                        VStack(alignment:.leading,spacing:10){
                            Text("INFORMATION").foregroundColor(.secondary).font(Font.custom("Poppins", size: 13))
                            ProfileCardPairView(image: "hand.raised.square", text: "About us", imageColor: .pink)
                            ProfileCardPairView(image: "lock.rectangle", text: "Privacy Policy", imageColor: .green)
                            ProfileCardPairView(image: "newspaper", text: "Terms & Condition", imageColor: .orange)
                            ProfileCardPairView(image: "questionmark.app.dashed", text: "FAQ's", imageColor: .cyan)
                            ProfileCardPairView(image: "square.and.arrow.up", text: "Share", imageColor: .accentColor,isHiddenDivider: false)
                            
                        }.padding().background(.ultraThinMaterial).cornerRadius(15).overlay(
                            RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.2),lineWidth: 1)
                        ).shadow(radius: 10,x:7,y:7).padding(.horizontal)
                        
                        VStack(alignment:.leading,spacing:20){
                            Text("Logout").foregroundColor(.secondary).font(Font.custom("Poppins", size: 13))
                            ProfileCardPairView(image: "rectangle.portrait.and.arrow.forward", text: "Logout", imageColor: .red,isHiddenDivider: false)
                            
                        }.padding().background(.ultraThinMaterial).cornerRadius(15).overlay(
                            RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.2),lineWidth: 1)
                        ).shadow(radius: 10,x:7,y:7).padding()
                            .padding(.bottom,70)
                    }.navigationTitle("Proflie")
                }
            }.onAppear{
                currentUserValue = profile_data.first
            }
            .sheet(isPresented: $isUpdateProfile, content: {
                ProfileUpdateView(profile: $currentUserValue, isCompletedSuccess: $isUpdateProfile, isUpdate: $isEditProfile)
            })
        }
    }
}

//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    ContentView(context: context).environment(\.managedObjectContext, context)
//        .preferredColorScheme(.dark)
//}

struct AddCardView: View {
    
    @State var cardNumber: String = ""
    @State var cardname: String = ""
    @State var expiryDate: String = ""
    @State var cvv: String = ""
    @State var isUpdateCard: Bool?
    @Binding var isHiddenAddCardView: Bool
    @EnvironmentObject var viewModel: CreditCardViewModel
    @State private var toast : CustomToast?
    
    var body: some View {
        
        VStack(spacing:15){
            VStack(alignment:.center){
                HStack(alignment:.center){
                    Image(systemName: "plus").foregroundColor(Color(hex: "E3B53C"))
                    Text("Add Card").font(.headline).foregroundColor(Color(hex: "E3B53C"))
                }
                Text("Add your credit/debit card").font(.subheadline)
            }
            TextField("Card Number", text: $viewModel.cNum).padding().background(.ultraThickMaterial).cornerRadius(10)
            TextField("Card Type", text: $viewModel.cardType).padding().background(.ultraThickMaterial).cornerRadius(10)
            TextField("Card Holder Name", text: $viewModel.cHolder).padding().background(.ultraThickMaterial).cornerRadius(10)
            HStack{
                TextField("Expiry Date", text: $viewModel.expiryDate).padding().background(.ultraThickMaterial).cornerRadius(10)
                TextField("CVV", text: $viewModel.cvv).padding().background(.ultraThickMaterial).cornerRadius(10)
            }
            
            Button("Add Card"){
              if viewModel.validateFields(name: viewModel.cHolder, c_num: viewModel.cNum, expiryDate: viewModel.expiryDate, cvv: viewModel.cvv, amount: "0.0", c_type: viewModel.cardType){
                    viewModel.addCard(){
                        viewModel.reset()
                    }
              }else{
                  self.toast = CustomToast(type: .error, title: "Validation Error", message: viewModel.errorMessage ?? "Please fill all required fields.")
              }
            }.font(Font.custom("Poppins-SemiBold", size: 16))
                .padding().padding(.horizontal,30).frame(maxWidth: .infinity).background(LinearGradient(colors: [Color(hex: "E3823C"), Color(hex: "E33C3C")], startPoint: .leading, endPoint: .trailing)).cornerRadius(10).foregroundColor(.white)
            
        }.padding().padding(.bottom,30).font(Font.custom("Poppins-Medium", size: 14))
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.white.opacity(0.2),lineWidth: 1)
            }
            .onChange(of:viewModel.isCompletedSuccess,perform:{ newValue in
                isHiddenAddCardView = false
            })
            .toastView(toast: $toast)
    }
}

struct ProfileCardPairView: View {
    var image:String
    var text:String
    var imageColor:Color
    var isHiddenDivider:Bool?
    
    var body: some View {
        VStack(spacing:0) {
            HStack{
                Image(systemName:image).foregroundColor(imageColor)
                Text(text).font(Font.custom("Poppins-Medium", size: 14)).frame(maxWidth:.infinity,alignment:.leading)
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }.padding(.vertical,6)
            if isHiddenDivider ?? true{
                Divider().padding(.top,12)
            }
        }
    }
}


struct ProfileUpdateView: View {
    @Binding var profile: Profile?
    @Binding var isCompletedSuccess: Bool
    @Binding var isUpdate: Bool
    @State private var toast:CustomToast?
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 50, height: 5)
                .cornerRadius(5)
            
            Text("Update Profile").font(Font.custom("Poppins-SemiBold", size: 18)).foregroundColor(Color(hex: "AF52DE"))
            
            CustomTFView(text: $viewModel.name, placeHolder:"User Name*")
            CustomTFView(text: $viewModel.s_name, placeHolder:"Nick Name*")
            CustomTFView(text: $viewModel.email, placeHolder:"Email ID*").keyboardType(.emailAddress).disabled(isUpdate).opacity(isUpdate ? 0.5 : 1)
            CustomTFView(text: $viewModel.number, placeHolder:"Mobile Number*").keyboardType(.numberPad).disabled(isUpdate).opacity(isUpdate ? 0.5 : 1)
            
            Button("Update") {
                if viewModel.validateFields(){
                    if isUpdate{
                        viewModel.updateProfile(number: viewModel.number, name: viewModel.name, s_name: viewModel.s_name)
                    }else{
                        viewModel.saveProfile()
                    }
                }else{
                    self.toast = CustomToast(type: .error, title: "Validation Error", message: viewModel.errorMessage ?? "Please fill all reqired fields", duration: 3)
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
        }.onAppear{
            viewModel.name = profile?.name ?? ""
            viewModel.s_name = profile?.s_name ?? ""
            viewModel.email = profile?.email ?? ""
            viewModel.number = profile?.number ?? ""
        }.toastView(toast: $toast)
        .padding()
        .padding(.bottom, 30)
        .font(Font.custom("Poppins-Medium", size: 14))
        .background(.ultraThinMaterial)
    }
}
