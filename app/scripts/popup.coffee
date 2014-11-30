nextBusinessDay = (day, span, callback)->
  chrome.runtime.sendMessage({
    type:'nextBusinessDay'
    date: day
    span: span
  }, (response)->
    callback(response.result)
  )
previousBusinessDay = (day, span, callback)->
  chrome.runtime.sendMessage({
    type:'previousBusinessDay'
    date: day
    span: span
  }, (response)->
    callback(response.result)
  )

isBusinessDay = (day,callback)->
  chrome.runtime.sendMessage({
    type:'isBusinessDay'
    date: day
  }, (response)->
    callback(response.result)
  )


calculator = new Vue
  el: '#calculator'
  data:
    startDate:moment().format('YYYY-MM-DD')
    span: 3
    spanOption: 'business'
    endDate: ''
    calendar: moment().startOf('month').format('YYYY-MM-DD')
  methods:
    calculate: ->
      return unless moment(@startDate).isValid()
      if @spanOption is 'business'
        nextBusinessDay @startDate, @span, (date)=>
          @endDate = date
      else
        @endDate = moment(@startDate).add(@span, 'days').format('YYYY-MM-DD')
    calculatePrevious: ->
      return unless moment(@endDate).isValid()
      if @spanOption is 'business'
        previousBusinessDay @endDate, @span, (date)=>
          @startDate = date
      else
        @startDate = moment(@endDate).add(-1 * @span, 'days').format('YYYY-MM-DD')
    calendarClick: (e)->
      @startDate = e.targetVM.formatedStr
      @calculate()
    calendarNext: ->
      @calendar = moment(@calendar).add(1, 'month').format('YYYY-MM-DD')
    calendarPrev: ->
      @calendar = moment(@calendar).add(-1, 'month').format('YYYY-MM-DD')
  computed:
    calendarYear: -> moment(@calendar).year()
    calendarMonth: -> moment(@calendar).month() + 1
    calendarWeeks: ->
      m = moment(@calendar).day(0)
      today = moment().startOf('day')
      end = moment(@calendar).endOf('month').toDate()
      ret = []
      while m.toDate() < end
        arr = []
        while true
          (=>
            data =
              formatedStr: m.format('YYYY-MM-DD')
              date: m.date()
              businessDay: false
              today: m.isSame today,'day'
              otherMonth: not(m.isSame(@calendar, 'month'))
            isBusinessDay m.format('YYYY-MM-DD'), (response)->
              data.businessDay = response
            arr.push data
          )()
          m.add(1,'day')
          break if m.day() is 0
        ret.push {days: arr}
      ret
      
nextBusinessDay calculator.startDate, calculator.span, (date)=>
  calculator.endDate = date
