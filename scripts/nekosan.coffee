# Description:
#   ねこさん新機能です。
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot おはよう - "おはようございます！"と返答
#
# Notes:
#   初めて作りました。
#
# Author:
#   shitosa


module.exports = (robot) ->

  robot.hear /((疲|つか)れた|I'm tired.)/i, (msg) ->
    tired = msg.random [
      "そんにゃこと言うにゃ"
      "お肩をおもみしましょうか？？"
      "疲労→ https://ja.wikipedia.org/wiki/%E7%96%B2%E5%8A%B4"
      "がんばったにゃ"
      "にゃ、にゃ、にゃあ、にゃにゃにゃぁ" 
    ]
    msg.reply "#{tired}"
