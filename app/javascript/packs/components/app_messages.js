const ALERT_CLASS = {
  'error': 'alert-danger',
  'notice': 'alert-success'
}

const appMessages = ({messageType, content}) => {
  const alertKeys = Object.keys(ALERT_CLASS)

  if (!alertKeys.includes(messageType)) {
    console.warn(`messageType must be a ${alertKeys.join(' or ')}`)
  }

  if (content.length) {
    $('#app-messages').html(
      `<div class="alert-dismissible alert ${ALERT_CLASS[messageType]}"><button aria-hidden="true" class="close" data-dismiss="alert" type="button"> ×</button>${content}</div>`
    )
  } else {
    $('#app-messages').html('')
  }
}

export default appMessages
