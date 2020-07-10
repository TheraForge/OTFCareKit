//
/*
 Copyright (c) 2020, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3. Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import CareKitStore
import CareKitUI
import Foundation
import SwiftUI

/// A card that displays information for a contact. The header is an `OCKHeaderView`
/// The body contains a multi-line istructions label, and four buttons; call, message,
/// email, and address. The first three buttons have title labels and image views that can
/// be modified, while the last has a title label, body label, and image view.
///
///     +-------------------------------------------------------+
///     | +------+                                              |
///     | | icon | [title]                                      |
///     | | img  | [detail]                                     |
///     | +------+                                              |
///     |                                                       |
///     |  --------------------------------------------------   |
///     |                                                       |
///     | [Instructions]                                        |
///     |                                                       |
///     | +------------+      +------------+     +------------+ |
///     | |  [title]   |      |   [title]  |     |   [title]  | |
///     | |            |      |            |     |            | |
///     | +------------+      +------------+     +------------+ |
///     |                                                       |
///     | +---------------------------------------------------+ |
///     | |  [title]                                          | |
///     | |  [detail]                                         | |
///     | |                                                   | |
///     | +---------------------------------------------------+ |
///     +-------------------------------------------------------+
///
@available(iOS 14.0, watchOS 7.0, *)
public struct DetailedContactView<Header: View, Footer: View>: View {
    private typealias ContactView = SynchronizedContactView<OCKDetailedContactController, CareKitUI.DetailedContactView<Header, Footer>>

    private let contactView: ContactView
    
    public var body: some View {
        contactView
    }

    private init(contactView: ContactView) {
        self.contactView = contactView
    }
    
    public init(contactID: String, storeManager: OCKSynchronizedStoreManager, content: @escaping (_ controller: OCKDetailedContactController) -> CareKitUI.DetailedContactView<Header, Footer>) {
        contactView = .init(controller: .init(storeManager: storeManager), query: .contactID(contactID), content: content)
    }
    
    public init(contact: OCKAnyContact, contactQuery: OCKContactQuery, storeManager: OCKSynchronizedStoreManager,
                content: @escaping (_ controller: OCKDetailedContactController) -> CareKitUI.DetailedContactView<Header, Footer>) {
        contactView = .init(controller: .init(storeManager: storeManager), query: .init(.contact(contact)), content: content)
    }
    
    public init(controller: OCKDetailedContactController, content: @escaping (_ controller: OCKDetailedContactController) -> CareKitUI.DetailedContactView<Header, Footer>) {
        contactView = .init(controller: controller, content: content)
    }
    
    public func onError(_ perform: @escaping (Error) -> Void) -> DetailedContactView<Header, Footer> {
        .init(contactView: .init(copying: contactView, settingErrorHandler: perform))
    }
}

@available(iOS 14.0, watchOS 7.0, *)
public extension DetailedContactView where Header == _DetailedContactViewHeader, Footer == _DetailedContactViewFooter {
    init(contactID: String, storeManager: OCKSynchronizedStoreManager) {
        self.init(contactID: contactID, storeManager: storeManager) {
            .init(viewModel: $0.viewModel)
        }
    }
    
    init(contact: OCKAnyContact,contactQuery: OCKContactQuery, storeManager: OCKSynchronizedStoreManager) {
        self.init(contact: contact, contactQuery: contactQuery, storeManager: storeManager) {
            .init(viewModel: $0.viewModel)
        }
    }
    
    init(controller: OCKDetailedContactController) {
        contactView = .init(controller: controller) {
            .init(viewModel: $0.viewModel)
        }
    }
}

// CODE REVIEW: Let's add actions - they are nil right now, see UIKit version
private extension CareKitUI.DetailedContactView where Header == _DetailedContactViewHeader, Footer == _DetailedContactViewFooter {
    init(viewModel: ContactViewModel?) {
        self.init(title: Text(viewModel?.title ?? ""), detail: Text(viewModel?.detail ?? ""), instructions: Text(viewModel?.instructions ?? ""), image: Image(systemName: "person.crop.circle"), disclosureImage: nil, callButton: ContactButton(title: Text("Call"), image: Image(systemName: "phone"), action: nil), messageButton: ContactButton(title: Text("Message"), image: Image(systemName: "text.bubble"), action: nil), emailButton:  ContactButton(title: Text("E-mail"), image: Image(systemName: "envelope"), action: nil), addressButton: AddressButton(title: Text("Address"), detail: Text(viewModel?.address ?? ""), image: Image(systemName: "location"), action: nil))
    }
}

/// Data used to create a `CareKitUI.DetailedContactView`.
public struct ContactViewModel {

    /// The title text to display in the header.
    public let title: String

    /// The detail text to display in the header.
    public let detail: String?
    
    /// The instructions text to display under the header.
    public let instructions: String?
    
    /// The address text to display under the address button.
    public let address: String?
}
