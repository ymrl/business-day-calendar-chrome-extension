DEFAULTS =
  weekdays:[1,2,3,4,5]
  externalCalendars:[{
    url: 'https://www.google.com/calendar/ical/ja.japanese%23holiday%40group.v.calendar.google.com/public/basic.ics'
    name: 'Japanese Holidays'
  }]
  defaultCalculationSpan: 3


window.loadSettings = (keys, callback)->
  chrome.storage.sync.get keys, (items)->
    refs = if _.isString keys
        [keys]
      else
        keys
    values = {}
    _.forEach refs, (key)->
      values[key] = items[key] or DEFAULTS[key]
      null
    callback(values)

window.saveSettings = (data)->
  chrome.storage.sync.set data
  chrome.runtime.sendMessage
    type:'settingSaved'

