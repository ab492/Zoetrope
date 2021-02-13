//
//  BarSlider.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 28/01/2021.
//

import SwiftUI
import ABUtilities

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
//    private let knobPadding = CGFloat(3) TODO: Fix issue with larger tap area - this added padding to beginnging.
    
    // MARK: - Init

    init(value: Binding<CGFloat>,
         in range: ClosedRange<CGFloat>,
         configuration: Configuration = Configuration(),
         onDragStart: (() -> Void)? = nil,
         onDragFinish: (() -> Void)? = nil) {
        self._value = value
        self.range = range
        self.configuration = configuration
        self.onDragStart = onDragStart
        self.onDragFinish = onDragFinish
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(configuration.minimumTrackTint)
                        .frame(width: $value.wrappedValue.map(from: range, to: 0...geo.size.width)) // TODO: This gets reported as NAN at points!
                    Rectangle()
                        .fill(configuration.maximumTrackTint)
                }
//                .animation(isDragging ? .none : Animation.easeIn(duration: 0.1))
                .frame(height: configuration.barHeight)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                HStack(spacing: 0) {
                    Circle()
                        .fill(configuration.knobColor)
                        .frame(width: configuration.knobWidth, height: configuration.knobWidth)
                        .contentShape(Rectangle())
                        .offset(x: valueForKnob(geometry: geo))
//                        .animation(isDragging ? .none : Animation.easeIn(duration: 0.1))
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
        }
        .frame(height: max(configuration.knobWidth, configuration.barHeight))
    }

    private func valueForKnob(geometry: GeometryProxy) -> CGFloat {
        $value.wrappedValue.map(from: range, to: 0...geometry.size.width) - (configuration.knobWidth * valueAsPercent())
    }

    private func valueAsPercent() -> CGFloat {
        let percent = ((value - range.lowerBound) / (range.upperBound - range.lowerBound) * 100) / 100
        return percent.clamped(to: 0...1)
    }

    
}

