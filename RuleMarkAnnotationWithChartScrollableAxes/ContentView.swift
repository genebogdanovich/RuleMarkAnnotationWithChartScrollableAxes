//
//  ContentView.swift
//  RuleMarkAnnotationWithChartScrollableAxes
//
//  Created by Gene Bogdanovich on 13.11.24.
//

import SwiftUI
import Charts

// MARK: - StepCount

struct StepCount: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}

// MARK: - ContentView

struct ContentView: View {
    @State private var stepCountRecords = [StepCount]()
    @State private var selectedDate: Date?
    
    var body: some View {
        Chart(stepCountRecords) { record in
            BarMark(
                x: .value("Date", record.date, unit: .day),
                y: .value("Count", record.steps)
            )
            
            if let selectedDate {
                RuleMark(x: .value("Selected", selectedDate, unit: .day))
                    .foregroundStyle(Color(.secondarySystemFill).opacity(0.3))
                    .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        Text(selectedDate.formatted())
                            .padding()
                            .background(Color(.secondarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
        }
        /*
         FIXME: Uncomment the following line to trigger the issue in question.
         .chartScrollableAxes(.horizontal)
         */
        .chartXSelection(value: $selectedDate)
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .onAppear {
            generateRecords()
        }
    }
    
    private func generateRecords() {
        self.stepCountRecords = (0...15).map { index in
            let date = Calendar.current.date(byAdding: .day, value: -index, to: .now)!
            let record = StepCount(date: date, steps: Int.random(in: 500...999))
            return record
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
