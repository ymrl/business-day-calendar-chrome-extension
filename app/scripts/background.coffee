HOLIDAYS = []
WEEKDAYS = []

fetchCalendar = (url)->
  $.get url, (data)->
    jCal = ICAL.parse(data)
    component = if jCal[0] is 'vcalendar'
        new ICAL.Component(jCal)
      else
        new ICAL.Component(jCal[1])
    events = component.getAllSubcomponents().map (v)->new ICAL.Event(v)
    for ev in events
      startDate = ev.startDate.toJSDate()
      endDate = ev.endDate.toJSDate()
      m = moment(startDate)
      while m.toDate() < endDate
        ds = m.format('YYYY-MM-DD')
        HOLIDAYS.push(ds) unless _.contains(HOLIDAYS, ds)
        m.add({day: 1}).hour(0).minute(0).second(0).millisecond(0)

fetchCalendars = ->
  window.loadSettings 'externalCalendars', (data)->
    HOLIDAYS.length = 0
    for calendar in data.externalCalendars
      fetchCalendar calendar.url

loadWeekdays = ->
  window.loadSettings ['weekdays', 'externalCalendars'], (data)->
    WEEKDAYS = data.weekdays

isBusinessDay = (date)->
  m = moment(date)
  return _.contains(WEEKDAYS, m.day()) and (not _.contains(HOLIDAYS, m.format('YYYY-MM-DD')))

nextBusinessDay = (date, days=1)->
  m = moment(date)
  while days > 0
    days -= 1
    m.add(1, 'day')
    while (not isBusinessDay(m))
      m.add(1, 'day')
  return m.format('YYYY-MM-DD')

previousBusinessDay = (date, days=1)->
  m = moment(date)
  while days > 0
    days -= 1
    m.add(-1, 'day')
    while (not isBusinessDay(m))
      m.add(-1, 'day')
  return m.format('YYYY-MM-DD')

fetchCalendars()
loadWeekdays()

chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  if request.type is 'nextBusinessDay'
    sendResponse(result: nextBusinessDay(request.date, request.span || 1))
  else if request.type is 'previousBusinessDay'
    sendResponse(result: previousBusinessDay(request.date, request.span || 1))
  else if request.type is 'isBusinessDay'
    sendResponse(result: isBusinessDay(request.date))
  else if request.type is 'settingSaved'
    fetchCalendars()
    loadWeekdays()
