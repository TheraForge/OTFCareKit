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

import SwiftUI
import UIKit
import CareKitStore
import CareKitUI

public struct SimpleContactView<Header: View>: View {
    private let content: (_ configuration: SimpleContactViewConfiguration) -> CareKitUI.SimpleContactView<Header>
    
    @Environment(\.careKitStyle) private var style
    
    /// Owns the view model that drives the view.
    @ObservedObject public var controller: OCKSimpleContactController
    
    public var body: some View {
        content(.init(controller: controller)).background(Color(style.color.customBackground))
    }
    
    /// Create an instance that updates the content view when the observed controller changes.
    /// - Parameter controller: Owns the view model that drives the view.
    /// - Parameter content: Return a view to display whenever the controller changes.
    public init(controller: OCKContactController,
                content: @escaping (_ configuration: SimpleContactViewConfiguration) ->
        CareKitUI.SimpleContactView<Header>) {
        self.controller = controller
        self.content = content
    }
}

public extension SimpleContactView where Header == HeaderView {

    /// Create an instance that updates the content view when the observed controller changes. The default view will be displayed whenever the
    /// controller changes.
    /// - Parameter controller: Owns the view model that drives the view.
    init(controller: OCKContactController) {
        self.init(controller: controller, content: { .init(configuration: $0) })
    }
}

private extension CareKitUI.SimpleContactView where Header == HeaderView {
    init(configuration: SimpleContactViewConfiguration) {
        self.init(header: {
            Header(title: Text(configuration.title),
                   detail: Text(configuration.detail ?? ""),
                   image: Image(systemName: "person.crop.circle"),
                   disclosureImage: Image(systemName: "chevron.right"),
                   divider: nil)
        })
    }
}
