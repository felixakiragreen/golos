//
//  AutoFocusTextField.swift
//  golOS
//
//  Created by Felix Akira Green on 12/30/20.
//

import SwiftUI

struct AutoFocusTextField: UIViewRepresentable {
	private let placeholder: String
	@Binding private var text: String
	private let onEditingChanged: ((_ focused: Bool) -> Void)?
	private let onCommit: (() -> Void)?
	 
	init(_ placeholder: String, text: Binding<String>, onEditingChanged: ((_ focused: Bool) -> Void)? = nil, onCommit: (() -> Void)? = nil) {
		self.placeholder = placeholder
		_text = text
		self.onEditingChanged = onEditingChanged
		self.onCommit = onCommit
	}
	 
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	 
	func makeUIView(context: UIViewRepresentableContext<AutoFocusTextField>) -> UITextField {
		let textField = UITextField()
		textField.delegate = context.coordinator
		textField.placeholder = placeholder
		return textField
	}
	 
	func updateUIView(_ uiView: UITextField, context:
		UIViewRepresentableContext<AutoFocusTextField>)
	{
		uiView.text = text
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // needed for modal view to show completely before aufo-focus to avoid crashes
			if uiView.window != nil, !uiView.isFirstResponder {
				uiView.becomeFirstResponder()
			}
		}
	}
	 
	class Coordinator: NSObject, UITextFieldDelegate {
		var parent: AutoFocusTextField
		  
		init(_ autoFocusTextField: AutoFocusTextField) {
			self.parent = autoFocusTextField
		}
		  
		func textFieldDidChangeSelection(_ textField: UITextField) {
			parent.text = textField.text ?? ""
		}
		  
		func textFieldDidEndEditing(_ textField: UITextField) {
			parent.onEditingChanged?(false)
		}
		  
		func textFieldDidBeginEditing(_ textField: UITextField) {
			parent.onEditingChanged?(true)
		}
		  
		func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			parent.onCommit?()
			return true
		}
	}
}

struct AutoFocusTextField_Previews: PreviewProvider {
	static var previews: some View {
		AutoFocusTextField("Search", text: .constant("sfg"))
	}
}
