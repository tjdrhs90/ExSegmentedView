//
//  SegmentedFlexibleView.swift
//  TestProject
//
//  Created by ssg on 11/4/24.
//

import SwiftUI

// https://medium.com/@c64midi/android-style-segmented-control-in-swiftui-f2d9e8469bdf
/// 커스텀 세그먼트 뷰 (컨텐츠 크기만큼 동적 너비 버전)
struct SegmentedFlexibleView: View {
    
    let segments: [String]
    @Binding var currentPage: Int
    @Namespace private var name
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(segments.indices, id: \.self) { index in
                        Button {
                            currentPage = index
                        } label: {
                            VStack {
                                Text(segments[index])
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .foregroundStyle(currentPage == index ? .orange : Color(uiColor: .systemGray))
                                ZStack {
                                    Capsule()
                                        .fill(.clear)
                                        .frame(height: 4)
                                    if currentPage == index {
                                        Capsule()
                                            .fill(.orange)
                                            .frame(height: 4)
                                            .matchedGeometryEffect(id: "Tab", in: name)
                                    }
                                }
                            }
                            .padding(.horizontal, 8) // 각 항목의 양쪽 여백 추가
                        }
                        .id(index)
                    }
                }
            }
            .onChange(of: currentPage) { _, newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
        .animation(.spring(duration: 0.3), value: currentPage)
    }
}

#Preview {
    struct Preview: View {
        var segments: [Color] = [.red, .green, .blue, .brown, .purple, .pink, .yellow, .orange, .cyan, .teal, .gray, .black]
        
        @State var currentPage = 0
        
        var body: some View {
            VStack {
                SegmentedFlexibleView(segments: segments.map { "\($0)" },
                                      currentPage: $currentPage)
                
                TabView(selection: $currentPage) {
                    ForEach(segments.indices, id: \.self) { index in
                        segments[index]
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .scrollTargetBehavior(.paging)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    return Preview()
}
