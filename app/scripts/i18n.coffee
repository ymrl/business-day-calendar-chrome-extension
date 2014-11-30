$('*[data-i18n-message]').each (idx, elm)->
  $elm = $(elm)
  msg = $elm.data('i18nMessage')
  if msg
    $elm.text(chrome.i18n.getMessage(msg))
