//
//  Date.swift
//  GoTutor
//
//  Created by Vidamo on 1/11/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import Foundation

extension Date {
  func yearsFrom(date:Date) -> Int? {
      let unitFlags = Set<Calendar.Component>([.year])
      return Calendar.current.dateComponents(unitFlags, from: date, to: self).year
  }
  func monthsFrom(date:Date) -> Int? {
      let unitFlags = Set<Calendar.Component>([.month])
      return Calendar.current.dateComponents(unitFlags, from: date, to: self).month

  }
  func weeksFrom(date:Date) -> Int? {
      let unitFlags = Set<Calendar.Component>([.weekOfYear])
      return Calendar.current.dateComponents(unitFlags, from: date, to: self).weekOfYear

  }
  func daysFrom(date:Date) -> Int? {
      let unitFlags = Set<Calendar.Component>([.day])
      return Calendar.current.dateComponents(unitFlags, from: date, to: self).day
  }
  func hoursFrom(date:Date) -> Int? {
      let unitFlags = Set<Calendar.Component>([.hour])
      return Calendar.current.dateComponents(unitFlags, from: date, to: self).hour
  }
  func minutesFrom(date:Date) -> Int? {
      let unitFlags = Set<Calendar.Component>([.minute])
      return Calendar.current.dateComponents(unitFlags, from: date, to: self).minute
  }
  func secondsFrom(date:Date) -> Int? {
      let unitFlags = Set<Calendar.Component>([.second])
      return Calendar.current.dateComponents(unitFlags, from: date, to: self).second
  }
  
  var day: Int {
    let myCalendar = Calendar(identifier: .gregorian)
    let day = myCalendar.component(.day, from: self)
    return day
  }
  
  var weekDay: Int {
    let myCalendar = Calendar(identifier: .gregorian)
    let w = myCalendar.component(.weekday, from: self)
    return w
  }
  
  var minutes: Int {
    let myCalendar = Calendar(identifier: .gregorian)
    let m = myCalendar.component(.minute, from: self)
    return m
  }
  
  var hour: Int {
    let myCalendar = Calendar(identifier: .gregorian)
    let h = myCalendar.component(.hour, from: self)
    return h
  }
  
  var prettyHour: String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h a"
    return timeFormatter.string(from: self)
  }
  
  var prettyHourWithMinute: String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    return timeFormatter.string(from: self)
  }
  
  var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    return dateFormatter.string(from: self)
  }
  
  var dateTimeString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE dd MMM yyyy, h:mm a"
    return dateFormatter.string(from: self)
  }

}
