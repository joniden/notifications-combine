//
//  ContentView.swift
//  notifications-combine
//
//  Created by Joacim Nidén on 2020-06-03.
//  Copyright © 2020 Joacim Nidén. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	@ObservedObject var model = ContentViewModel()
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text("Notifications").font(.title).bold()
			Text("We recommend turning notifications on")
			VStack(alignment: .leading) {
				HStack {
					Toggle(isOn: $model.isNotificationsAuthorized) {
						Text("Notification status")
					}
				}
			}
			
		}.background(model.isNotificationsAuthorized ? Color.green : Color.gray)
		.foregroundColor(model.isNotificationsAuthorized ? Color.white : Color.black).padding()
	}
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
