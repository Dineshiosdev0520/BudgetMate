//
//  CustomToastModel.swift
//  BudgetMate
//
//  Created by Dinesh Dev on 05/12/24.
//

import Foundation
import SwiftUI

struct CustomToast: Equatable {
    var type: ToastEnumModel
    var title: String
    var message: String
    var duration: Double = 3
}

enum ToastEnumModel {
    case error
    case warning
    case success
    case info
}

extension ToastEnumModel {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    
    var bgColor: Color{
        switch self {
        case .error: return Color.blue
        case .warning: return Color.blue
        case .info: return Color.blue
        case .success: return Color.blue
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

struct CustomToastModel{
    var isValid:Bool
    var title:String
    var message:String
    var isFocus:Int
}
