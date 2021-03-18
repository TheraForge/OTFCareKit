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

public struct DetailedContactView<Header: View, Footer: View>: View {
    // MARK: - Properties
    @Environment(\.isCardEnabled) private var isCardEnabled
    @Environment(\.careKitStyle) private var style
    
    private let isHeaderPadded: Bool
    private let isDetailDisclosurePadded: Bool
    private let header: Header
    private let footer: Footer

    private let instructions: Text?
    
    public var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top) {
                HStack {
                    VStack { header }
                        .if(isCardEnabled && isHeaderPadded) { $0.padding([.horizontal, .top]) }
                }

                instructions?
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(nil)
                    .if(isCardEnabled) { $0.padding([.horizontal]) }

                VStack { footer }
                    .if(isCardEnabled) { $0.padding([.horizontal, .bottom]) }
            }
        }
    }

    // MARK: - Init

    /// Create an instance.
    /// - Parameter instructions: Instructions text to display under the header.
    /// - Parameter header: Header to inject at the top of the card. Specified content will be stacked vertically.
    /// - Parameter footer: View to inject under the instructions. Specified content will be stacked vertically.
    public init(instructions: Text?, @ViewBuilder header: () -> Header, @ViewBuilder footer: () -> Footer) {
        self.instructions = instructions
        self.header = header()
        self.footer = footer()
        self.isHeaderPadded = true
        self.isDetailDisclosurePadded = true
    }
}

/// The default header used by a `DetailedContactView`.
public struct _DetailedContactViewHeader: View {

    @Environment(\.careKitStyle) private var style

    let title: Text
    let detail: Text?
    let image: Image?

    public var body: some View {
        VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top) {
            HeaderView(title: title, detail: detail, image: image)
            Divider()
        }
    }
}

/// The default footer used by a `DetailedContactView`.
public struct _DetailedContactViewFooter: View {

    @Environment(\.careKitStyle) private var style

    let horizontalButtons: _DetailedContactHorizontalButtons?
    let addressButton: AddressButton?
    
    public var body: some View {
        VStack {
            horizontalButtons
            addressButton
        }
    }
    
    public init(@ViewBuilder horizontalButtons: () -> _DetailedContactHorizontalButtons, addressButton: AddressButton) {
        self.horizontalButtons = horizontalButtons()
        self.addressButton = addressButton
    }
}

public struct _DetailedContactHorizontalButtons: View {
    
    @Environment(\.sizeCategory) var sizeClass: ContentSizeCategory
    
    let callButton: ContactButton?
    let messageButton: ContactButton?
    let emailButton: ContactButton?
    
    @ViewBuilder
    public var body: some View {
        if sizeClass < .extraLarge {
            HStack {
                Group {
                    callButton
                    messageButton
                    emailButton
                }
            }
        } else {
            VStack {
                Group {
                    callButton
                    messageButton
                    emailButton
                }
            }
        }
    }
    
    public init(callButton: ContactButton?, messageButton: ContactButton?, emailButton: ContactButton?) {
        self.callButton = callButton
        self.messageButton = messageButton
        self.emailButton = emailButton
    }
}

public extension DetailedContactView where Header == _DetailedContactViewHeader, Footer == _DetailedContactViewFooter {
    init(title: Text, detail: Text?, instructions: Text?, image: Image?, disclosureImage: Image?, callButton: ContactButton?, messageButton: ContactButton?, emailButton: ContactButton?, addressButton: AddressButton) {
        self.init(instructions: instructions, header: {
            _DetailedContactViewHeader(title: title, detail: detail, image: image)
        }, footer: {
            Footer(horizontalButtons: { () -> _DetailedContactHorizontalButtons in
                _DetailedContactHorizontalButtons(callButton: callButton, messageButton: messageButton, emailButton: emailButton)
            }, addressButton: addressButton)
        })
    }
}

#if DEBUG
struct DetailedContactView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            DetailedContactView(instructions: Text("Dr. Torres is a family practice doctor with over 20 years of experience."), header: {
                _DetailedContactViewHeader(title: Text(verbatim: "Dr. Torres"),
                                           detail: Text(verbatim: "Family Practice"),
                                           image: Image(systemName: "person.crop.circle"))
            }, footer: {
                _DetailedContactViewFooter(horizontalButtons: { () -> _DetailedContactHorizontalButtons in
                    _DetailedContactHorizontalButtons(callButton:
                                                        ContactButton(title: Text("Call"),
                                                                      image: Image(systemName: "phone"),
                                                                      action: nil),
                                                      messageButton: ContactButton(title: Text("Message"),
                                                                                   image: Image(systemName: "text.bubble"),
                                                                                   action: nil),
                                                      emailButton: ContactButton(title: Text("E-mail"),
                                                                                 image: Image(systemName: "envelope"),
                                                                                 action: nil))
                }, addressButton:
                    AddressButton(title: Text("Address"),
                                  detail: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum scelerisque, erat a rutrum fermentum, nulla massa feugiat ligula, ac porttitor magna nibh et nisl."),
                                  image: Image(systemName: "location"),
                                  action: nil))
            })
        }
        .environment(\.colorScheme, .dark)
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .environment(\.careKitStyle, OCKStyle())
    }
}
#endif
