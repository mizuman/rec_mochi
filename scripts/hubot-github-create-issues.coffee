# Description:
#   Create issues with hubot
#
# Commands:
#   hubot issues create for {user}/{repo} #label1,label2# <title> - <content> → タスク登録用。githubにmizuman名義でissueを作るよ
#
# Author:
#   Soulou

githubot = require('githubot')

module.exports = (robot) ->
  useIdentity = process.env.HUBOT_GITHUB_IDENTITY?

  handleTokenError = (res, err) ->
    switch err.type
      when 'redis'
        res.reply "Oops: #{err}"
      when 'github user'
        res.reply "Sorry, you haven't told me your GitHub username."

  parseLabels = (rawLabels) ->
    if rawLabels then rawLabels.slice(1, -2).split(",") else rawLabels
  parseMilestone = (rawMilestone) ->
    if rawMilestone then rawMilestone.slice(3, -1) else rawMilestone
  parseBody = (rawBody) ->
    if rawBody then rawBody.slice(2).trim() else rawBody

  robot.respond /issues create (for\s)?(([-_\.0-9a-z]+\/)?[-_\.0-9a-z]+) (in\s[a-z0-9]+\s)?(#[a-z0-9, ]+#\s)?([^-]+)(-\s.+)?/i, (res) ->
    repo = githubot.qualified_repo res.match[2]
    payload = {body: ""}
    payload.milestone = parseMilestone res.match[4]
    payload.labels = parseLabels res.match[5]
    payload.title = res.match[6].trim()
    payload.body = parseBody res.match[7]
    console.log(res.match)
    console.log(payload.body)
    url  = "/repos/#{repo}/issues"
    user = res.envelope.user.name

    createIssue = (github, payload) ->
      github.post url, payload, (issue) ->
        res.reply "I've opened the issue ##{issue.number} for #{user} (#{issue.html_url})"

    return createIssue(githubot(robot), payload) unless useIdentity

    robot.identity.findToken user, (err, token) ->
      if err
        handleTokenError(res, err)
      else
        createIssue(githubot(robot, token: token), payload)
