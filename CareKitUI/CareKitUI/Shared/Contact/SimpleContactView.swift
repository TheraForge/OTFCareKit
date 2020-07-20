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

/// A card that displays information for a contact.
///
/// # Style
/// The card supports styling using `careKitStyle(_:)`.
///
///
/// A card that displays information for a contact. The header is an `OCKHeaderView`.
///
///     +-------------------------------------------------------+
///     | +------+                                              |
///     | | icon | [title]                       [detail        |
///     | | img  | [detail]                       disclosure]   |
///     | +------+                                              |
///     +-------------------------------------------------------+
///
public struct SimpleContactView<Header: View, DetailDisclosure: View>: View {

    // MARK: - Properties

    @Environment(\.isCardEnabled) private var isCardEnabled
    
    private let isHeaderPadded: Bool
    private let isDetailDisclosurePadded: Bool
    private let header: Header
    private let detailDisclosure: DetailDisclosure
    
    public var body: some View {
        CardView {
            HStack {
                VStack { header }
                    .if(isCardEnabled && isHeaderPadded) { $0.padding([.vertical, .leading]) }
                Spacer()
                VStack { detailDisclosure }
                    .if(isCardEnabled && isDetailDisclosurePadded) { $0.padding([.vertical, .trailing]) }
            }
        }
    }

    // MARK: - Init

    /// Create an instance.
    /// - Parameter header: Header to inject at the top of the card. Specified content will be stacked vertically.
    /// - Parameter footer: View to inject under the instructions. Specified content will be stacked vertically.
    public init(@ViewBuilder header: () -> Header, @ViewBuilder detailDisclosure: () -> DetailDisclosure) {
        self.init(isHeaderPadded: true, isDetailDisclosurePadded: true, header: header, detailDisclosure: detailDisclosure)
    }
    
    private init(isHeaderPadded: Bool, isDetailDisclosurePadded: Bool,
                 action: @escaping () -> Void = {}, @ViewBuilder header: () -> Header, @ViewBuilder detailDisclosure: () -> DetailDisclosure) {
        self.isHeaderPadded = isHeaderPadded
        self.isDetailDisclosurePadded = isDetailDisclosurePadded
        self.header = header()
        self.detailDisclosure = detailDisclosure()
    }
}

public extension SimpleContactView where Header == HeaderView, DetailDisclosure == _SimpleContactViewDetailDisclosure {

    /// Create an instance.
    /// - Parameter title: Title text to display in the header.
    /// - Parameter detail: Detail text to display in the header.
    /// - Parameter instructions: Instructions text to display under the header.
    /// - Parameter footer: View to inject under the instructions. Specified content will be stacked vertically.
    init(title: Text, detail: Text?,image: Image?) {
        self.init(isHeaderPadded: true, isDetailDisclosurePadded: true) { () -> HeaderView in
            Header(title: title, detail: detail, image: image)
        } detailDisclosure: { () -> _SimpleContactViewDetailDisclosure in
            DetailDisclosure()
        }

    }
}

public extension SimpleContactView where DetailDisclosure == _SimpleContactViewDetailDisclosure {

    /// Create an instance.
    /// - Parameter isComplete: True if the circle button is complete.
    /// - Parameter action: The action to perform when the whole view is tapped.
    /// - Parameter header: The header view to inject to the left of the button. The specified content will be stacked vertically.
    init(@ViewBuilder header: () -> Header) {
        self.init(header: header) { () -> _SimpleContactViewDetailDisclosure in
            DetailDisclosure()
        }
    }
}

/// The default detail disclosure used by a `_SimpleContactViewDetailDisclosure`.
public struct _SimpleContactViewDetailDisclosure: View {

    @Environment(\.careKitStyle) private var style
    @Environment(\.sizeCategory) private var sizeCategory

    @OSValue<CGFloat>(values: [.watchOS: 6], defaultValue: 16) private var padding
    
    public var body: some View {
        Image(systemName: "chevron.right")
            .scaled(size: style.dimension.symbolPointSize4)
            .foregroundColor(Color(style.color.customGray3))
    }
}

#if DEBUG
struct SimpleContactView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleContactView(header: {
             HeaderView(title: Text(verbatim: "Title"),
                        detail: Text(verbatim: "Subtitle"),
                        image: Image(systemName: "person.crop.circle"))
        })
        .environment(\.colorScheme, .dark)
    }
}
#endif
