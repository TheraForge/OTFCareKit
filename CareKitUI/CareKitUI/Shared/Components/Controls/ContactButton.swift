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

public struct ContactButton: View {
    @Environment(\.careKitStyle) private var style
    
    private let title: Text
    private let image: Image
    
    fileprivate let action: (() -> Void)?
    
    public var body: some View {
        Button(action: action ?? {}) {
            VStack {
                image
                title.fontWeight(.semibold)
                    .font(.footnote)
                    .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            }.padding()
            .frame(maxWidth: .infinity)
            .background(Color(style.color.quaternaryCustomFill))
            .cornerRadius(style.appearance.cornerRadius2)
        }
    }
    
    public init(title: Text,image: Image,action: (() -> Void)?) {
        self.title = title
        self.action = action
        self.image = image
    }
}

#if DEBUG
struct ContactButton_Previews: PreviewProvider {
    static var previews: some View {
        ContactButton(title: Text("Call"),image: Image(systemName: "phone"), action: nil)
    }
}
#endif
