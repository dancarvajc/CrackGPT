//
//  View+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 15-04-23.
//

import SwiftUI

#if os(macOS)
struct DetectKeyViewModifier: ViewModifier {
    let keyToDetect: KeyEquivalent
    let modifiers: EventModifiers
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .background {
                Button("", action: action)
                    .keyboardShortcut(keyToDetect, modifiers: modifiers)
                    .opacity(0)
            }
    }
}

extension View {
    func detectKey(_ key: KeyEquivalent, modifiers: EventModifiers = [], action: @escaping () -> Void) -> some View {
        modifier(DetectKeyViewModifier(keyToDetect: key, modifiers: modifiers, action: action))
    }
}
#endif

enum BindDimensionTypeModifier {
    case width, height
}

extension View {
    /// Allows to get the width or height of a view.
    /// - Parameters:
    ///   - option: Width or height.
    ///   - binding: Variable which store the result.
    ///   - alwaysHighestValue: Always return the highest result.
    ///   - animations: Animates the changes of the result.
    /// - Returns: The same view but with the modifier applied.
    func bindDimension(_ dimension: BindDimensionTypeModifier, to binding: Binding<CGFloat>, alwaysHighestValue: Bool = false, animation: Bool = false) -> some View {
        return background(
            GeometryReader { g in
                let size = dimension == .width ? g.size.width : g.size.height
                Color.clear
                    .onChange(of: size) { newValue in
                        if alwaysHighestValue {
                            if newValue > binding.wrappedValue {
                                withAnimation(animation ? .default : .none) {
                                    binding.wrappedValue = newValue
                                }
                            }
                        } else {
                            withAnimation(animation ? .default : .none) {
                                binding.wrappedValue = newValue
                            }
                        }
                    }
                    .onAppear {
                        if alwaysHighestValue {
                            if size > binding.wrappedValue {
                                withAnimation(animation ? .default : .none) {
                                    binding.wrappedValue = size
                                }
                            }
                        } else {
                            withAnimation(animation ? .default : .none) {
                                binding.wrappedValue = size
                            }
                        }
                    }
            }
        )
    }
}

#if os(iOS)

// MARK: ScrollViewDidScrollViewModifier

final class ScrollViewDidScrollViewModifierViewModel: ObservableObject {
    @Published private(set) var contentOffset: CGFloat = .zero
    @Published private(set) var isDragging: (CGFloat, Bool) = (0, false)

    private var startOffset: CGFloat = -777

    func subscribe(scrollView: UIScrollView) {
        scrollView.publisher(for: \.contentOffset)
            .drop { [weak self] currentPoint in
                self?.startOffset = currentPoint.y
                return self?.startOffset == -777
            }
            .map { [weak self] currentPoint in
                let translation = (self?.startOffset ?? 0) - currentPoint.y
                return (translation, scrollView.isDragging)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isDragging)
    }
}

struct ScrollViewDidScrollViewModifier: ViewModifier {
    @StateObject private var viewModel = ScrollViewDidScrollViewModifierViewModel()
    @State private var needsSubscribe = true
    var didScroll: ((CGFloat, Bool)) -> Void

    func body(content: Content) -> some View {
        content
            .introspect(.list, on: .iOS(.v15)) { scrollView in
                guard needsSubscribe else { return }
                needsSubscribe = false
                viewModel.subscribe(scrollView: scrollView)
            }
            .introspect(.list, on: .iOS(.v16, .v17)) { scrollView in
                guard needsSubscribe else { return }
                needsSubscribe = false
                viewModel.subscribe(scrollView: scrollView)
            }
            .onReceive(viewModel.$isDragging) { isDragging in
                didScroll(isDragging)
            }
    }
}

extension View {
    func didScroll(_ didScroll: @escaping ((translation: CGFloat, isDragging: Bool)) -> Void) -> some View {
        modifier(ScrollViewDidScrollViewModifier(didScroll: didScroll))
    }
}

extension View {
    func exportToPDF() -> Data {
        let viewContentSize = getContentSize()
        let pdfController = UIHostingController(rootView: self)
        pdfController.loadView()
        let pdfRect = CGRect(origin: .zero, size: viewContentSize)
        pdfController.view.frame = CGRect(x: 0, y: 0, width: pdfRect.width, height: pdfRect.height + 100)
        pdfController.view.insetsLayoutMarginsFromSafeArea = false

        let rootVC = UIApplication.shared.activeWindow?.rootViewController
        rootVC?.addChild(pdfController)
        rootVC?.view.insertSubview(pdfController.view, at: 0)

        defer {
            pdfController.removeFromParent()
            pdfController.view.removeFromSuperview()
        }

        let renderer = UIGraphicsPDFRenderer(bounds: pdfRect)
        let data = renderer.pdfData { context in
            context.beginPage()
            pdfController.view.layer.render(in: context.cgContext)
        }
        return data
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
#endif

#if os(iOS)
extension View {
    func getContentSize() -> CGSize {
        let scrollView = UIScrollView()

        // MARK: Converting SwiftUI View to UIKit View

        guard let hostingControllerView = UIHostingController(rootView: self).view else {
            return .zero
        }
        hostingControllerView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: Constraints

        let constraints = [
            hostingControllerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingControllerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingControllerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingControllerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            // Width Anchor
            hostingControllerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ]
        scrollView.addSubview(hostingControllerView)
        scrollView.addConstraints(constraints)
        scrollView.layoutIfNeeded()

        return scrollView.contentSize
    }
}
#endif
