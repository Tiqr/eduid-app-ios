//
//  VerifyWithIdInputViewModel.swift
//  eduID
//
//  Created by Yasser Farahi on 20/02/2025.
//

import Foundation
import OpenAPIClient
import Combine

final class VerifyWithIdInputViewModel: ObservableObject {
    
    @Published var person: VerifyPerson?
    private var controlCode: CurrentValueSubject<ControlCode?, Never>?
    var controlCodePublisher: AnyPublisher<ControlCode?, Never>? {
        return controlCode?.eraseToAnyPublisher()
    }
    
    init(controlCode: ControlCode? = nil) {
        if let firstName = controlCode?.firstName ,
           let lastName = controlCode?.lastName ,
           let dateOfBirth = controlCode?.dayOfBirth {
            self.person = VerifyPerson(lastName: lastName, firstName: firstName, dateOfBirth: dateOfBirth)
        }
    }
    
    func createVerificationCode() async {
        guard let person else {
            assertionFailure("No valid details provided")
            return
        }
        let controlCode: ControlCode = .init(firstName: person.firstName, lastName: person.lastName, dayOfBirth: person.dateOfBirth)
        do {
            let controlCode = try await UserControllerAPI.createUserControlCode(controlCode: controlCode)
            self.controlCode?.send(controlCode)
        } catch {
            assertionFailure(" Failed to generate control code: \(error) -- \(error.localizedDescription)")
        }
    }
    
}
