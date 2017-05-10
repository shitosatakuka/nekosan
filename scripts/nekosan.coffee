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

  robot.hear /(ありがとう|サンキュー)/i, (msg) ->
    tired = msg.random [
      "そんにゃこと言うにゃ"
      "お肩をおもみしましょうか？？"
      "ありがとう→ https://ja.wikipedia.org/wiki/%E3%81%82%E3%82%8A%E3%81%8C%E3%81%A8%E3%81%86"
      "どういたしまして"
      "にゃ、にゃ、にゃあ、にゃにゃにゃぁ" 
    ]
    msg.reply "#{tired}"
