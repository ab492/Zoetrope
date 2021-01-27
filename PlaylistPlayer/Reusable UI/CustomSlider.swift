//
//  CustomSlider.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/01/2021.
//

import SwiftUI
import ABUtilities

struct CustomSlider: View {

    // MARK: - Types

    struct Configuration {
        var knobWidth: CGFloat
        var barHeight: CGFloat
        var minimumTrackTint: Color
        var maximumTrackTint: Color
        var onDragStart: (() -> Void)?
        var onDragFinish: (() -> Void)?

        init(knobWidth: CGFloat = 25,
             barHeight: CGFloat = 6,
             minimumTrackTint: Color = .accentColor,
             maximumTrackTint: Color = .gray,
             onDragStart: (() -> Void)? = nil,
             onDragFinish: (() -> Void)? = nil) {
            self.knobWidth = knobWidth
            self.barHeight = barHeight
            self.minimumTrackTint = minimumTrackTint
            self.maximumTrackTint = maximumTrackTint
            self.onDragStart = onDragStart
            self.onDragFinish = onDragFinish
        }
    }

    // MARK: - State and Properties

    @Binding var value: CGFloat
    @State private var lastOffset: CGFloat = 0
    @State private var isDragging = false

    private var range: ClosedRange<CGFloat>
    private let configuration: Configuration

    // MARK: - Init

    init(value: Binding<CGFloat>, in range: ClosedRange<CGFloat>, configuration: Configuration = Configuration()) {
        self._value = value
        self.range = range
        self.configuration = configuration
    }

    // MARK: - View

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Rectangle()
                        .frame(width: $value.wrappedValue.map(from: range, to: sliderWidthExcludingKnob(geometry: geometry)),
                               height: configuration.barHeight)
                        .foregroundColor(configuration.minimumTrackTint)
                    Rectangle()
                        .frame(height: configuration.barHeight)
                        .foregroundColor(configuration.maximumTrackTint)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                HStack {
                    Circle()
                        .frame(width: configuration.knobWidth, height: configuration.knobWidth)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                        .scaleEffect(isDragging ? 2 : 1)
                        .animation(.interactiveSpring())
                        .offset(x: $value.wrappedValue.map(from: range, to: sliderWidthExcludingKnob(geometry: geometry)))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in

                                    if isDragging == false {
                                        configuration.onDragStart?()
                                        isDragging = true
                                    }

                                    let sliderWidth = self.sliderWidthExcludingKnob(geometry: geometry)

                                    if abs(value.translation.width) < 0.1 {
                                        self.lastOffset = self.$value.wrappedValue.map(from: range, to: sliderWidth)
                                    }

                                    let sliderPosition = (lastOffset + value.translation.width).clamped(to: sliderWidth)
                                    let sliderValue = sliderPosition.map(from: sliderWidth, to: range)

                                    self.value = sliderValue
                                }
                                .onEnded { _ in
                                    configuration.onDragFinish?()
                                    isDragging = false
                                }
                        )
                    Spacer()
                }
            }
        }
    }

    // MARK: - Helpers

    private func sliderWidthExcludingKnob(geometry: GeometryProxy) -> ClosedRange<CGFloat> {
        return 0...geometry.size.width - configuration.knobWidth
    }
}

