//
//  IceSection.swift
//  Ice
//

import SwiftUI

struct IceSection<Header: View, Content: View, Footer: View>: View {
    private let header: Header
    private let content: Content
    private let footer: Footer
    private let spacing: CGFloat = 10

    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }

    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header == EmptyView {
        self.init {
            EmptyView()
        } content: {
            content()
        } footer: {
            footer()
        }
    }

    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init {
            header()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        @ViewBuilder content: () -> Content
    ) where Header == EmptyView, Footer == EmptyView {
        self.init {
            EmptyView()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        _ title: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) where Header == Text, Footer == EmptyView {
        self.init {
            Text(title)
                .font(.headline)
        } content: {
            content()
        }
    }
    // For Temporarily show individual menu bar items
    init(
        _ title: LocalizedStringKey,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header == Text {
        self.init {
            Text(title)
                .font(.headline)
        } content: {
            content()
        } footer: {
            footer()
        }
    }

    var body: some View {
        IceGroupBox(padding: spacing) {
            header
        } content: {
            _VariadicView.Tree(IceSectionLayout(spacing: spacing)) {
                content
                    .frame(maxWidth: .infinity)
            }
        } footer: {
            footer
        }
    }
}

private struct IceSectionLayout: _VariadicView_UnaryViewRoot {
    let spacing: CGFloat

    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(Array(children.enumerated()), id: \.element.id) { index, child in
                child
                if index != children.count - 1 {
                    Divider()
                }
            }
        }
    }
}
