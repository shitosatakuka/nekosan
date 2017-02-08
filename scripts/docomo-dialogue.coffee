# Description:
#   DOCOMOの雑談APIを利用した雑談
#
# Author:
#   FromAtom

getTimeDiffAsMinutes = (old_msec) ->
  now = new Date()
  old = new Date(old_msec)
  diff_msec = now.getTime() - old.getTime()
  diff_minutes = parseInt( diff_msec / (60*1000), 10 )
  return diff_minutes

module.exports = (robot) ->
  robot.respond /(\S+)/i, (msg) ->
    DOCOMO_API_KEY = process.env.DOCOMO_API_KEY
    message = msg.match[1]
    return unless DOCOMO_API_KEY && message

    ## ContextIDを読み込む
    KEY_DOCOMO_CONTEXT = 'docomo-talk-context'
    context = robot.brain.get KEY_DOCOMO_CONTEXT || ''

    ## 前回会話してからの経過時間調べる
    KEY_DOCOMO_CONTEXT_TTL = 'docomo-talk-context-ttl'
    TTL_MINUTES = 20
    old_msec = robot.brain.get KEY_DOCOMO_CONTEXT_TTL
    diff_minutes = getTimeDiffAsMinutes old_msec

    ## 前回会話してから一定時間経っていたらコンテキストを破棄
    if diff_minutes > TTL_MINUTES
      context = ''

    url = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=' + DOCOMO_API_KEY
    user_name = msg.message.user.name

    request = require('request');
    request.post
      url: url
      json:
        utt: message
        nickname: user_name if user_name
        context: context if context
      , (err, response, body) ->
        ## ContextIDの保存
        robot.brain.set KEY_DOCOMO_CONTEXT, body.context

        ## 会話発生時間の保存
        now_msec = new Date().getTime()
        robot.brain.set KEY_DOCOMO_CONTEXT_TTL, now_msec

        msg.send body.utt

# Description
#   A Hubot script that calls the docomo dialogue API
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DOCOMO_DIALOGUE_P
#   HUBOT_DOCOMO_DIALOGUE_API_KEY
#
# Commands:
#   * - calls the docomo dialogue API
#
# Author:
#   bouzuya <m@bouzuya.net>
#
#module.exports = (robot) ->
#  robot.brain.data.dialogue = {}
#
#  robot.hear /.*/, (res) ->
#    p = parseFloat(process.env.HUBOT_DOCOMO_DIALOGUE_P ? '0.3')
#    return unless Math.random() < p
#
#    payload = { utt: res.match[0], nickname: res.message.user.name }
#    room_id = res.message.user.reply_to || res.message.user.room
#    if ctx = robot.brain.data.dialogue[room_id]
#      payload.context = ctx.context
#      payload.mode = ctx.mode
#
#    res
#      .http 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue'
#      .header 'Content-Type', 'application/json'
#      .query APIKEY: process.env.HUBOT_DOCOMO_DIALOGUE_API_KEY
#      .post(JSON.stringify(payload)) (err, _, body) ->
#        if err?
#          robot.logger.error e
#          res.send 'docomo-dialogue: error'
#        else
#          data = JSON.parse(body)
#          res.send data.utt
#          robot.brain.data.dialogue[room_id] = {context: data.context, mode: data.mode}