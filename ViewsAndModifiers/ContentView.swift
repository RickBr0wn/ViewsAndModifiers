//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Rick Brown on 30/11/2020.
//

import SwiftUI

struct BorderedCaption: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.title)
      .padding(10)
      .overlay(
        RoundedRectangle(cornerRadius: 15)
          .stroke(lineWidth: 2)
      )
      .foregroundColor(Color.blue)
  }
}

extension View {
  func titleStyle() -> some View {
    self.modifier(BorderedCaption())
  }
}

struct Watermark: ViewModifier {
  var text: String
  
  func body(content: Content) -> some View {
    ZStack(alignment: .bottomTrailing) {
      content
      
      Text(text)
        .font(.caption)
        .foregroundColor(.white)
        .padding(5)
        .background(Color.black)
    }
  }
}

extension View {
  func watermarked(with text: String) -> some View {
    self.modifier(Watermark(text: text))
  }
}

struct GridStack<Content: View>: View {
  let rows: Int
  let columns: Int
  let content: (Int, Int) -> Content
  
  var body: some View {
    VStack {
      ForEach(0..<rows, id: \.self) { row in
        HStack {
          ForEach(0..<self.columns, id: \.self) { column in
            self.content(row, column)
          }
        }
      }
    }
  }
  
  init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
    self.rows = rows
    self.columns = columns
    self.content = content
  }
}

/// Create a custom ViewModifier (and accompanying View extension)
/// that makes a view have a large, blue font suitable for prominent titles in a view.

struct BlueTitle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.largeTitle)
      .foregroundColor(.blue)
  }
}

extension View {
  func largeBlue() -> some View {
    self.modifier(BlueTitle())
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Text("Hello, world!")
        .titleStyle()
      
      Color.blue
        .frame(width: 300, height: 300, alignment: .center)
        .watermarked(with: "Rick Brown")
      
      GridStack(rows: 4, columns: 4) { row, col in
        Image(systemName: "\(row * 4 + col).circle")
        Text("R\(row) C\(col)")
      }
      
      Text("LARGE BLUE")
        .largeBlue()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
