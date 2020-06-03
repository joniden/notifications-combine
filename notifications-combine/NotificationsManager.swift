//
//  NotificationsManager.swift
//  notifications-combine
//
//  Created by Joacim Nidén on 2020-06-03.
//  Copyright © 2020 Joacim Nidén. All rights reserved.
//

import Foundation
import UserNotifications
import Combine
import SwiftUI

class NotificationsManager {
	
	static var shared = NotificationsManager()
	private init() {}
	
	/**
	There are 2 parts of this manager, one is for the system notifications settings.
	The other one is for fetching notifications from core data and they should remain separate in this class
	*/
	
	// MARK: - Notfication Settings
	
	private let center = UNUserNotificationCenter.current()
	var isAuthorized = false
	
	/// Setup notifications
	/// - Parameter delegate: Pass this delegate from App Delegate
	func setup(_ delegate: UNUserNotificationCenterDelegate) {
		center.delegate = delegate
		center.getNotificationSettings { settings in
			self.isAuthorized = settings.authorizationStatus == .authorized
		}
	}
	
	/// Get settings as a publisher, used in a viewmodel
	/// - Returns: UNNotificationSettings, can never fail
	func getNotificationSettingsPublisher() -> AnyPublisher<UNNotificationSettings, Never> {
		let notificationSettingsFuture = Future<UNNotificationSettings, Never> { promise in
			self.center.getNotificationSettings { settings in
				promise(.success(settings))
			}
		}
		return notificationSettingsFuture.eraseToAnyPublisher()
	}
	
	func toggle(_ authorize: Bool) {
		center.getNotificationSettings { settings in
			
			switch settings.authorizationStatus {
				case .notDetermined:
					self.requestAuth()
				case .authorized:
					if !authorize {
						self.openSettingsScreen()
					}
				case .denied:
					if authorize {
						self.openSettingsScreen()
				}
				default:
					break
			}
		}
	}
	
	func removeAllNotifications() {
		center.removeAllDeliveredNotifications()
		center.removeAllPendingNotificationRequests()
	}
	
	private func openSettingsScreen() {
		if let bundleIdentifier = Bundle.main.bundleIdentifier,
			let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
			DispatchQueue.main.async {
				if UIApplication.shared.canOpenURL(appSettings) {
					UIApplication.shared.open(appSettings)
				}
			}
		}
	}
	
	private func requestAuth() {
		center.requestAuthorization(options: [.alert, .sound, .badge]) {
			(granted, error) in
			
			if let error = error {
				print(error)
			} else if granted {
			
			}
		}
	}
}
