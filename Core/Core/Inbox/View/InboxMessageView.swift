//
// This file is part of Canvas.
// Copyright (C) 2022-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI

public struct InboxMessageView: View {
    private let model: InboxMessageModel

    public init(model: InboxMessageModel) {
        self.model = model
    }

    public var body: some View {
        Button {

        } label: {
            cellContent
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var cellContent: some View {
        HStack(alignment: .top, spacing: 14) {
            avatar
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(model.participantName)
                        .font(.semibold16)
                        .foregroundColor(.textDarkest)
                    Spacer()
                    Text(model.date)
                        .foregroundColor(.textDark)
                        .font(.regular12)
                }
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: model.title)
                            .font(.regular14)
                            .foregroundColor(.textDarkest)
                            .lineLimit(1)
                        Text(verbatim: model.message)
                            .font(.regular14)
                            .foregroundColor(.textDark)
                            .lineLimit(1)
                    }
                    Spacer()
                    starredIndicator
                }
            }
        }
        .padding(.top, 14)
        .padding(.bottom, 12)
        .padding(.leading, 14)
        .padding(.trailing, 16)
        .background(Color.clear)
        .overlay(unreadDot)
    }

    @ViewBuilder
    private var avatar: some View {
        switch model.avatar {
        case .group:
            Circle()
                .strokeBorder(lineWidth: 1 / UIScreen.main.scale)
                .foregroundColor(.borderMedium)
                .overlay(Image.groupLine.foregroundColor(.borderDark))
                .frame(width: 36, height: 36)
        case .individual(let name, let profileImageURL):
            Avatar(name: name, url: profileImageURL)
                .frame(width: 36, height: 36)
        }
    }

    @ViewBuilder
    private var starredIndicator: some View {
        if model.isStarred {
            Image
                .starSolid
                .size(18)
                .foregroundColor(.accentColor)
        }
    }

    @ViewBuilder
    private var unreadDot: some View {
        if model.isUnread {
            ZStack(alignment: .topLeading) {
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(.electric)
                    .padding(.leading, 8)
                    .padding(.top, 13)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#if DEBUG

struct InboxMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            InboxMessageView(model: .mock)
                .preferredColorScheme($0)
                .previewLayout(.sizeThatFits)
        }

        InboxMessageView(model: .mock(participantName: "Bob Hunter, Tray B, Joe M, Alice Swanson, Marty + 3"))
            .previewLayout(.sizeThatFits)
            .previewDevice(PreviewDevice(stringLiteral: "iPhone 11"))
    }
}

#endif
