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

/// A button with an icon and title label.
///
///     +--------------------------+
///     | [Title]           [Icon] |
///     +--------------------------+
///

public struct ChecklistItemButton: View {
    @Environment(\.careKitStyle) private var style
    @Environment(\.sizeCategory) private var sizeCategory

    @OSValue<CGFloat>(values: [.watchOS: 6], defaultValue: 6.5) private var padding
    
    fileprivate let title: String
    fileprivate let isComplete: Bool
    fileprivate let action: () -> Void
    
    public var body: some View {
            Button(action: {
                action()
            }) {
                HStack{
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.regular)
                    Spacer()
                    ZStack {
                        CircularCompletionView(isComplete: isComplete) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .padding(padding.scaled())
                                .frame(width: style.dimension.buttonHeight4.scaled(), height: style.dimension.buttonHeight4.scaled())
                        }
                    }
                }
            }.buttonStyle(NoHighlightStyle())
    }
    
    public init(title: String, isComplete: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isComplete = isComplete
        self.action = action
    }
}

#if DEBUG
struct ChecklistItemButton_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistItemButton(title: "Breakfast", isComplete: false, action: {print("Yes")})
    }
}
#endif
