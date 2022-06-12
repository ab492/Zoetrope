//
//  BarSlider.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 28/01/2021.
//

import SwiftUI
import ABExtensions

struct CustomSlider: View {

    // MARK: - Types

    struct Configuration {
        var knobWidth: CGFloat
        var barHeight: CGFloat
        var knobColor: Color
        var minimumTrackTint: Color
        var maximumTrackTint: Color

        init(knobWidth: CGFloat = 25,
             barHeight: CGFloat = 4,
             knobColor: Color = .white,
             minimumTrackTint: Color = .accentColor,
             maximumTrackTint: Color = .gray) {
            self.knobWidth = knobWidth
            self.barHeight = barHeight
            self.knobColor = knobColor
            self.minimumTrackTint = minimumTrackTint
            self.maximumTrackTint = maximumTrackTint
        }
    }

    // MARK: - Types

    @Binding var value: CGFloat
    @State private var isDragging = false
    @State private var lastOffset: CGFloat = 0

    private var range: ClosedRange<CGFloat>
    private let configuration: Configuration
    private var onDragStart: (() -> Void)?
    private var onDragFinish: (() -> Void)?
    private let knobVerticalPadding = CGFloat(35)
    
    /// As debugging the scrubber bar is tricky due to various layers and tap areas, enable the ui debug flag to help visually highlight layers.
    private let uiDebug: Bool

    // MARK: - Init

    init(value: Binding<CGFloat>,
         in range: ClosedRange<CGFloat>,
         configuration: Configuration = Configuration(),
         uiDebug: Bool,
         onDragStart: (() -> Void)? = nil,
         onDragFinish: (() -> Void)? = nil) {
        self._value = value
        self.range = range
        self.configuration = configuration
        self.uiDebug = uiDebug
        self.onDragStart = onDragStart
        self.onDragFinish = onDragFinish
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                track(for: geo)
                knob(for: geo)
                dragGesture(for: geo)
            }
        }
        .frame(height: max(configuration.knobWidth + knobVerticalPadding, configuration.barHeight))
    }

    private func track(for geo: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(configuration.minimumTrackTint)
                .frame(width: $value.wrappedValue.map(from: range, to: 0...geo.size.width))
            Rectangle()
                .fill(configuration.maximumTrackTint)
        }
        .frame(height: configuration.barHeight)
        // Corner radius was 16, but changed to 2 when .drawingGroup modifier was introduced on `TransportControls`.
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }

    private func knob(for geo: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Circle()
                .fill(configuration.knobColor)
                .frame(width: configuration.knobWidth, height: configuration.knobWidth)
                .offset(x: valueForKnob(geometry: geo))
            Spacer()
        }
    }

    /// An invisible view with a drag gesture to sit on top of the knob. This is required to allow a larger tap area without changing the way the slider is drawn.
    private func dragGesture(for geo: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(uiDebug ? Color.green : Color.clear)
                .opacity(uiDebug ? 0.5 : 0)
                .frame(width: configuration.knobWidth + knobVerticalPadding, height: configuration.knobWidth + knobVerticalPadding)
                .contentShape(Rectangle())
                .offset(x: valueForKnob(geometry: geo) - (knobVerticalPadding / 2))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in

                            if isDragging == false {
                                onDragStart?()
                                isDragging = true
                            }

                            let sliderWidth = 0...geo.size.width

                            if abs(value.translation.width) < 0.1 {
                                self.lastOffset = self.$value.wrappedValue.map(from: range, to: sliderWidth)
                            }

                            let sliderPosition = (lastOffset + value.translation.width).clamped(to: sliderWidth)
                            let sliderValue = sliderPosition.map(from: sliderWidth, to: range)

                            self.value = sliderValue

                        }
                        .onEnded { _ in
                            onDragFinish?()
                            isDragging = false
                        }
                )
            Spacer()
        }
    }

    // MARK: - Helpers

    private func valueForKnob(geometry: GeometryProxy) -> CGFloat {
        let value = $value.wrappedValue.map(from: range, to: 0...geometry.size.width) - (configuration.knobWidth * valueAsPercent())
        return value.clamped(to: 0...geometry.size.width) // TODO: Could easily just clamp to minimum of zero here.
    }

    private func valueAsPercent() -> CGFloat {
        guard range.upperBound - range.lowerBound > 0 else { return 0 }
        let percent = ((value - range.lowerBound) / (range.upperBound - range.lowerBound) * 100) / 100
        return percent.clamped(to: 0...1)
    }
}
