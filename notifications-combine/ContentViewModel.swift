//
//  ContentViewModel.swift
//  notifications-combine
//
//  Created by Joacim Nidén on 2020-06-03.
//  Copyright © 2020 Joacim Nidén. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {

	@Published var isNotificationsAuthorized: Bool = NotificationsManager.shared.isAuthorized {
		didSet {
			if isNotificationsAuthorized != oldValue {
				notificationsManager.toggle(isNotificationsAuthorized)
			}
		}
	}
	
	private let notificationsManager = NotificationsManager.shared
	
	var notificationsCancellable: AnyCancellable?
	
	init() {
		self.onAppear()
	}
	
	func toggleNotification(_ isOn: Bool) {
		notificationsManager.toggle(isOn)
	}
	
	func onAppear() {
		notificationsCancellable = notificationsManager.getNotificationSettingsPublisher()
			.sink(receiveValue: { settings in
				DispatchQueue.main.async {
					self.isNotificationsAuthorized = settings.authorizationStatus == .authorized
				}
		})
	}
}


