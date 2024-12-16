//
//  CustomToastView.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 05/12/24.
//

import SwiftUI

struct CustomToastView: View {
    var type: ToastEnumModel
    var title: String
    var message: String
    var body: some View {
        VStack {
            HStack(alignment: .center,spacing: 15) {
                Image(systemName: type.iconFileName)
                    .font(.system(size: 23))
                    .foregroundColor(type.themeColor)
               
                VStack(alignment: .leading) {
                    Text(title)
                        .font(Font.custom("Montserrat-Medium", size: 15))
                        .foregroundColor(type.themeColor)
                    Text(message)
                        .font(Font.custom("Montserrat", size: 13))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
                Spacer()
            }
            .padding(.vertical, 15)
            .padding(.horizontal)
        }
        .background(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

extension View {
    func toastView(toast: Binding<CustomToast?>) -> some View {
        self.modifier(CustomToastModifier(toast: toast))
    }
}
