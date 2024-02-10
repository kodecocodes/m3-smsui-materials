/// Copyright (c) 2023 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

// Main View of the App
struct ContentView: View {
  @Bindable var financialData: FinancialData
  @State private var showingAddView = false

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Totals")) {
          HStack {
            Text("Total Expenses")
            Spacer()
            Text("$\(financialData.totalExpenses, specifier: "%.2f")")
              .foregroundColor(.red)
          }
          HStack {
            Text("Total Income")
            Spacer()
            Text("$\(financialData.totalIncome, specifier: "%.2f")")
              .foregroundColor(.green)
          }
        }
        Section(header: Text("Entries")) {
          ForEach(financialData.entries) { entry in
            FinancialEntryRow(entry: entry)
          }
        }
      }
      .navigationTitle("Budget Tracker")
      .navigationBarItems(trailing: Button(action: {
        showingAddView = true
      }, label: {
        Image(systemName: "plus")
      }))
      .sheet(isPresented: $showingAddView) {
        AddFinancialEntryView(financialEntries: $financialData.entries, showingAddView: $showingAddView)
      }
    }
  }
}

// View for displaying a single financial entry
struct FinancialEntryRow: View {
  var entry: FinancialEntry

  var body: some View {
    HStack {
      Text(entry.isExpense ? "Expense" : "Income")
      Spacer()
      Text("$\(entry.amount, specifier: "%.2f")")
        .foregroundColor(entry.isExpense ? .red : .green)
    }
  }
}

// Additional View for adding a new financial entry
struct AddFinancialEntryView: View {
  @Binding var financialEntries: [FinancialEntry]
  @Binding var showingAddView: Bool
  @State private var amount: Double = 0
  @State private var category: String = ""
  @State private var isExpense = true

  var body: some View {
    NavigationStack {
      Form {
        TextField("Amount", value: $amount, format: .number)
        TextField("Category", text: $category)
        Toggle(isOn: $isExpense) {
          Text("Is Expense")
        }
      }
      .scrollDisabled(true)
      .navigationTitle("Add Entry")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            showingAddView.toggle()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            let newEntry = FinancialEntry(id: UUID(), amount: amount, category: category, isExpense: isExpense)
            financialEntries.append(newEntry)
            showingAddView.toggle()
          }
        }
      }
    }
  }
}


// MARK: - Preview

#Preview {
  PreviewContainerView()
}

struct PreviewContainerView: View {
  @State var financialData = FinancialData()

  var body: some View {
    ContentView(financialData: financialData)
  }
}
