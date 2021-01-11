//
//  ScrollableStack.swift
//  golOS
//
//  Created by Felix Akira Green on 1/10/21.
//

import SwiftUI

// MARK: - PREVIEW

struct ScrollableStack_Previews: PreviewProvider {
	static var previews: some View {
		ScrollableStack()
//		SnapCarousel()
	}
}

struct ScrollableStack: View {
	var colors: [Color] = [.blue, .green, .red, .orange]
		 
	var body: some View {
//		SnapCarousel()
		HStack(alignment: .center, spacing: 30) {
			ForEach(0 ..< colors.count) { i in
				colors[i]
					.frame(width: 250, height: 400, alignment: .center)
					.cornerRadius(10)
			}
		}.modifier(ScrollingHStackModifier(items: colors.count, itemWidth: 250, itemSpacing: 30))
	}
}

// MARK: - SCROLLABLE


// Technically works, but there's not momentum, don't like

struct ScrollingHStackModifier: ViewModifier {
	@State private var scrollOffset: CGFloat
	@State private var dragOffset: CGFloat
	 
	var items: Int
	var itemWidth: CGFloat
	var itemSpacing: CGFloat
	 
	init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
		self.items = items
		self.itemWidth = itemWidth
		self.itemSpacing = itemSpacing
		  
		// Calculate Total Content Width
		let contentWidth = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
		let screenWidth = UIScreen.main.bounds.width
		  
		// Set Initial Offset to first Item
		let initialOffset = (contentWidth / 2.0) - (screenWidth / 2.0) + ((screenWidth - itemWidth) / 2.0)
		  
		self._scrollOffset = State(initialValue: initialOffset)
		self._dragOffset = State(initialValue: 0)
	}
	 
	func body(content: Content) -> some View {
		content
			.offset(x: scrollOffset + dragOffset, y: 0)
			.gesture(DragGesture()
				.onChanged { event in
//					withAnimation {
						dragOffset = event.translation.width
//					}
					print(dragOffset)
				}
				.onEnded { event in
//					 Scroll to where user dragged
//					scrollOffset += event.translation.width
					withAnimation {
						scrollOffset += event.predictedEndTranslation.width
						dragOffset = 0
					}
//					scrollOffset = dragOffset
						  
					// Now calculate which item to snap to
					let contentWidth = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
					let screenWidth = UIScreen.main.bounds.width
						  
					// Center position of current offset
					let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
						  
					// Calculate which item we are closest to using the defined size
					var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)
						  
					// Should we stay at current index or are we closer to the next item...
					if index.remainder(dividingBy: 1) > 0.5 {
						index += 1
					} else {
						index = CGFloat(Int(index))
					}
						  
					// Protect from scrolling out of bounds
					index = min(index, CGFloat(items) - 1)
					index = max(index, 0)
						  
					// Set final offset (snapping to item)
					let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing
						  
					// Animate snapping
					withAnimation {
//						scrollOffset = event.predictedEndTranslation.width
//						scrollOffset = newOffset
					}
					print(scrollOffset)
					print(newOffset)
					print(event.predictedEndTranslation)
					
				}
			)
	}
	
//	func onEnd(_ action: @escaping (DragGesture.Value) -> Void) -> _EndedGesture<_ChangedGesture<DragGesture>>
//
//	}
}

//struct SnapCarousel: View {
//	 @EnvironmentObject var UIState: UIStateModel
//
//	 var body: some View {
//		  let spacing: CGFloat = 16
//		  let widthOfHiddenCards: CGFloat = 32 /// UIScreen.main.bounds.width - 10
//		  let cardHeight: CGFloat = 279
//
//		  let items = [
//				Card(id: 0, name: "Hey"),
//				Card(id: 1, name: "Ho"),
//				Card(id: 2, name: "Lets"),
//				Card(id: 3, name: "Go")
//		  ]
//
//		  return Canvas {
//				/// TODO: find a way to avoid passing same arguments to Carousel and Item
//				Carousel(
//					 numberOfItems: CGFloat(items.count),
//					 spacing: spacing,
//					 widthOfHiddenCards: widthOfHiddenCards
//				) {
//					 ForEach(items, id: \.self.id) { item in
//						  Item(
//								_id: Int(item.id),
//								spacing: spacing,
//								widthOfHiddenCards: widthOfHiddenCards,
//								cardHeight: cardHeight
//						  ) {
//								Text("\(item.name)")
//						  }
//						  .foregroundColor(Color.white)
//						  .background(Color("surface"))
//						  .cornerRadius(8)
//						  .shadow(color: Color("shadow1"), radius: 4, x: 0, y: 4)
//						  .transition(AnyTransition.slide)
//						  .animation(.spring())
//					 }
//				}
//		  }
//	 }
//}
//
//struct Card: Decodable, Hashable, Identifiable {
//	 var id: Int
//	 var name: String = ""
//}
//
//public class UIStateModel: ObservableObject {
//	 @Published var activeCard: Int = 0
//	 @Published var screenDrag: Float = 0.0
//}
//
//struct Carousel<Items : View> : View {
//	 let items: Items
//	 let numberOfItems: CGFloat //= 8
//	 let spacing: CGFloat //= 16
//	 let widthOfHiddenCards: CGFloat //= 32
//	 let totalSpacing: CGFloat
//	 let cardWidth: CGFloat
//
//	 @GestureState var isDetectingLongPress = false
//
//	 @EnvironmentObject var UIState: UIStateModel
//
//	 @inlinable public init(
//		  numberOfItems: CGFloat,
//		  spacing: CGFloat,
//		  widthOfHiddenCards: CGFloat,
//		  @ViewBuilder _ items: () -> Items) {
//
//		  self.items = items()
//		  self.numberOfItems = numberOfItems
//		  self.spacing = spacing
//		  self.widthOfHiddenCards = widthOfHiddenCards
//		  self.totalSpacing = (numberOfItems - 1) * spacing
//		  self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
//
//	 }
//
//	 var body: some View {
//		  let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
//		  let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
//		  let leftPadding = widthOfHiddenCards + spacing
//		  let totalMovement = cardWidth + spacing
//
//		  let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
//		  let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)
//
//		  var calcOffset = Float(activeOffset)
//
//		  if (calcOffset != Float(nextOffset)) {
//				calcOffset = Float(activeOffset) + UIState.screenDrag
//		  }
//
//		  return HStack(alignment: .center, spacing: spacing) {
//				items
//		  }
//		  .offset(x: CGFloat(calcOffset), y: 0)
//		  .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
//				self.UIState.screenDrag = Float(currentState.translation.width)
//
//		  }.onEnded { value in
//				self.UIState.screenDrag = 0
//
//				if (value.translation.width < -50) {
//					 self.UIState.activeCard = self.UIState.activeCard + 1
//					 let impactMed = UIImpactFeedbackGenerator(style: .medium)
//					 impactMed.impactOccurred()
//				}
//
//				if (value.translation.width > 50) {
//					 self.UIState.activeCard = self.UIState.activeCard - 1
//					 let impactMed = UIImpactFeedbackGenerator(style: .medium)
//					 impactMed.impactOccurred()
//				}
//		  })
//	 }
//}
//
//struct Canvas<Content : View> : View {
//	 let content: Content
//	 @EnvironmentObject var UIState: UIStateModel
//
//	 @inlinable init(@ViewBuilder _ content: () -> Content) {
//		  self.content = content()
//	 }
//
//	 var body: some View {
//		  content
//				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
//				.background(Color.white.edgesIgnoringSafeArea(.all))
//	 }
//}
//
//struct Item<Content: View>: View {
//	 @EnvironmentObject var UIState: UIStateModel
//	 let cardWidth: CGFloat
//	 let cardHeight: CGFloat
//
//	 var _id: Int
//	 var content: Content
//
//	 @inlinable public init(
//		  _id: Int,
//		  spacing: CGFloat,
//		  widthOfHiddenCards: CGFloat,
//		  cardHeight: CGFloat,
//		  @ViewBuilder _ content: () -> Content
//	 ) {
//		  self.content = content()
//		  self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
//		  self.cardHeight = cardHeight
//		  self._id = _id
//	 }
//
//	 var body: some View {
//		  content
//				.frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
//	 }
//}

//struct SnapCarousel_Previews: PreviewProvider {
//	 static var previews: some View {
//		  SnapCarousel()
//	 }
//}
