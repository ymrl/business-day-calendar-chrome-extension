settings = new Vue
  el: '#settings'
  data:
    weekdays:[{
      index: 0
      use: false
      label: chrome.i18n.getMessage "Sunday"
    },{
      index: 1
      use: false
      label: chrome.i18n.getMessage "Monday"
    },{
      index: 2
      use: false
      label: chrome.i18n.getMessage "Tuesday"
    },{
      index: 3
      use: false
      label: chrome.i18n.getMessage "Wednesday"
    },{
      index: 4
      use: false
      label: chrome.i18n.getMessage "Thursday"
    },{
      index: 5
      use: false
      label: chrome.i18n.getMessage "Friday"
    },{
      index: 6
      use: false
      label: chrome.i18n.getMessage "Saturday"
    }]
    externalCalendars:[ ]
  methods:
    save: ->
      window.saveSettings
        weekdays: _.filter(@weekdays, (v)->v.use).map((v)->v.index)
        externalCalendars: _.filter(this.externalCalendars, (v)->v.url).map (v)->
          url: v.url
          name: v.name

    removeUrl: (e)->
      @externalCalendars.splice e.targetVM.$index, 1
    addUrl: ->
      @externalCalendars.push {name: '', url: ''}

window.loadSettings ['weekdays', 'externalCalendars'], (data)->
  for day in settings.weekdays
    day.use = _.contains(data.weekdays, day.index)
  settings.externalCalendars = data.externalCalendars
  if settings.externalCalendars.length is 0
    settings.externalCalendars.push {name: '', url: ''}
