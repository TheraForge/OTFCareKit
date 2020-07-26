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

/// A card that displays a vertically stacked checklist of items. In CareKit, this view is intended to display
/// multiple events for a particular task.
///
///     +-------------------------------------------------------+
///     | +------+                                              |
///     | | icon | [title]                       [detail        |
///     | | img  | [detail]                       disclosure]   |
///     | +------+                                              |
///     |                                                       |
///     |  --------------------------------------------------   |
///     |                                                       |
///     |  +-------------------------------------------------+  |
///     |  | [title]                                   [img] |  |
///     |  +-------------------------------------------------+  |
///     |  +-------------------------------------------------+  |
///     |  | [title]                                   [img] |  |
///     |  +-------------------------------------------------+  |
///     |                         .                             |
///     |                         .                             |
///     |                         .                             |
///     |  +-------------------------------------------------+  |
///     |  | [title]                                   [img] |  |
///     |  +-------------------------------------------------+  |
///     |                                                       |
///     |  [instructions]                                       |
///     +-------------------------------------------------------+
///

public struct ChecklistTaskView<Header: View, List: View>: View {
    // MARK: - Properties
    @Environment(\.careKitStyle) private var style
    @Environment(\.isCardEnabled) private var isCardEnabled
    
    private let isHeaderPadded: Bool
    private let header: Header
    private let list: List
    private let instructions: Text?
    
    public var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top) {
                HStack {
                    header
                }.if(isCardEnabled && isHeaderPadded) { $0.padding([.horizontal, .top]) }
                
                VStack { list }
                    .if(isCardEnabled) { $0.padding([.horizontal]) }
                
                instructions?
                    .font(.caption)
                    .fontWeight(.regular)
                    .lineLimit(nil)
                    .foregroundColor(Color(style.color.secondaryLabel))
                    .if(isCardEnabled) { $0.padding([.horizontal, .bottom]) }

            }
            
        }
    }
    
    public init(instructions: Text? = nil, @ViewBuilder header: () -> Header, @ViewBuilder list: () -> List) {
        self.init(isHeaderPadded: true, instructions: instructions, header: header, list: list)
    }
    
    init(isHeaderPadded: Bool, instructions: Text? = nil,
         @ViewBuilder header: () -> Header, @ViewBuilder list: () -> List) {
        self.isHeaderPadded = isHeaderPadded
        self.instructions = instructions
        self.header = header()
        self.list = list()
    }
}

public extension ChecklistTaskView where Header == _ChecklistItemViewHeader<_ChecklistItemViewDisclosure> {
    init(title: Text, detail: Text? = nil, instructions: Text? = nil, @ViewBuilder list: () -> List) {
        self.init(isHeaderPadded: true, instructions: instructions, header: {
            Header(title: title, detail: detail, isDisclosurePadded: true)
        }, list: list)
    }
}

public extension ChecklistTaskView where List == _ChecklistItemViewList {
    init(instructions: Text? = nil, @ViewBuilder header: () -> Header) {
        self.init(isHeaderPadded: true, instructions: instructions, header: header, list: {
            List()
        })
    }
    
    func updateItem(at index: Int, withTitle title: String) {
        list.updateItem(at: index, withTitle: title)
    }

    func insertItem(withTitle title: String, isComplete complete: Bool,andAction action: @escaping () -> Void, at index: Int) {
        list.insertItem(withTitle: title, isComplete: complete, andAction: action, at: index)
    }

    func addItem(withTitle title: String, isComplete complete: Bool, andAction action: @escaping () -> Void) {
        list.addItem(withTitle: title, isComplete: complete, andAction: action)
    }

    func removeItem(at index: Int) {
        list.removeItem(at: index)
    }

    func clearItems() {
        list.clearItems()
    }
}

public extension ChecklistTaskView where Header == _ChecklistItemViewHeader<_ChecklistItemViewDisclosure>, List == _ChecklistItemViewList {
    init(title: Text, detail: Text? = nil, instructions: Text? = nil, isComplete: Bool, action: @escaping () -> Void = {}) {
        self.init(instructions: instructions, header: {
            Header(title: title, detail: detail, isDisclosurePadded: true)
        }, list: {
            List()
        })
    }
}


/// The default header used by `ChecklistItemView`
public struct _ChecklistItemViewHeader<DetailDisclosure: View>: View {
    @Environment(\.careKitStyle) private var style
    @Environment(\.isCardEnabled) private var isCardEnabled
    
    fileprivate let title: Text
    fileprivate let detail: Text?
    fileprivate let isDisclosurePadded: Bool
    fileprivate let disclosure: DetailDisclosure
    
    public var body: some View {
        VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top) {
            HStack {
                HeaderView(title: title, detail: detail)
                Spacer()
                disclosure
                    .if(isCardEnabled && isDisclosurePadded) { $0.padding([.horizontal, .leading]) }
            }
            Divider()
        }
    }
    
    init(title: Text, detail: Text? = nil, isDisclosurePadded: Bool, @ViewBuilder disclosure: () -> DetailDisclosure) {
        self.title = title
        self.detail = detail
        self.isDisclosurePadded = isDisclosurePadded
        self.disclosure = disclosure()
    }
}

public extension _ChecklistItemViewHeader where DetailDisclosure == _ChecklistItemViewDisclosure {
    init(title: Text, detail: Text? = nil, isDisclosurePadded: Bool) {
        self.init(title: title, detail: detail, isDisclosurePadded: isDisclosurePadded, disclosure: {
            DetailDisclosure()
        })
    }
}

/// The default detail disclosure used by a `_ChecklistItemViewDisclosure`.
public struct _ChecklistItemViewDisclosure: View {

    @Environment(\.careKitStyle) private var style
    @Environment(\.sizeCategory) private var sizeCategory

    @OSValue<CGFloat>(values: [.watchOS: 6], defaultValue: 16) private var padding
    
    public var body: some View {
        Image(systemName: "chevron.right")
            .scaled(size: style.dimension.symbolPointSize4)
            .foregroundColor(Color(style.color.customGray3))
    }
}

/// The default list used by `ChecklistItemView`
public struct _ChecklistItemViewList: View {
    @Environment(\.careKitStyle) private var style
    @ObservedObject fileprivate var dataSource = ChecklistDataSource()
    
    public var body: some View {
        VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top) {
            ForEach(dataSource.items) { item in
                ChecklistItemButton(title: item.title, isComplete: item.isComplete, action: item.action)
                Divider()
            }
        }
    }
    
    public func updateItem(at index: Int, withTitle title: String) {
        dataSource.updateItem(at: index, withTitle: title)
    }
    
    public func insertItem(withTitle title: String, isComplete complete: Bool, andAction action: @escaping () -> Void, at index: Int) {
        dataSource.insertItem(withTitle: title, isComplete: complete, andAction: action, at: index)
    }
    
    public func addItem(withTitle title: String, isComplete complete: Bool, andAction action: @escaping () -> Void) {
        dataSource.addItem(withTitle: title, isComplete: complete, andAction: action)
    }
    
    public func removeItem(at index: Int) {
        dataSource.removeItem(at: index)
    }
    
    public func clearItems() {
        dataSource.clearItems()
    }
}

internal struct ChecklistItem: Identifiable {
    var id = UUID()
    var title: String
    var isComplete: Bool = false
    var action: () -> Void
}

internal class ChecklistDataSource: ObservableObject {
    @Published var items: [ChecklistItem]
    
    init() {
        self.items = [ChecklistItem]()
    }
    
    public func updateItem(at index: Int,withTitle title: String) {
        guard index < items.count else { return }
        items[index].title = title
    }
    
    public func insertItem(withTitle title: String,isComplete complete: Bool,andAction action: @escaping () -> Void, at index: Int) {
        guard index < items.count else { return }
        items.insert(ChecklistItem(title: title, isComplete: complete, action: action), at: index)
    }
    
    public func addItem(withTitle title: String,isComplete complete: Bool,andAction action: @escaping () -> Void) {
        items.append(ChecklistItem(title: title, isComplete: complete, action: action))
    }
    
    public func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
    }
    
    public func clearItems() {
        items.removeAll()
    }
}

#if DEBUG
struct ChecklistTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let task = ChecklistTaskView(instructions: Text("Take the tablet with a glass full of water."), header: {
            _ChecklistItemViewHeader<_ChecklistItemViewDisclosure>(title: Text("Doxylamine"), detail: Text("2 remaining"), isDisclosurePadded: true, disclosure: {
                _ChecklistItemViewDisclosure()
            })
        })
        
        task.addItem(withTitle: "1", isComplete: true, andAction: {})
        task.addItem(withTitle: "2", isComplete: true, andAction: {})
        task.addItem(withTitle: "3", isComplete: true, andAction: {})
        task.addItem(withTitle: "4", isComplete: true, andAction: {})
        return task
    }
}
#endif

