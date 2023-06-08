//
//  ShowNextScreenDelegate.swift
//  
//
//  Created by Yasser Farahi on 08/05/2023.
//

import Foundation
protocol ShowNextScreenDelegate {
    func nextScreen(for type: NextScreenFlowType)
}

enum NextScreenFlowType {
    case registerWithoutRecovery, none
}
