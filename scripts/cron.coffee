cronJob = require('cron').CronJob

module.exports = (robot) ->
	cronjob_svmtg = new cronJob('00 20 13 * * 2', () =>
		envelope = room: "team_tot_sv"
		robot.send envelope, "<!channel> そろそろ定例ですよー https://redmine.nttcloud.net/projects/tot-svsoc/wiki"
	)
	cronjob_svmtg.start()

	cronjob_payday = new cronJob('00 00 7 20 * 1-5', () =>
		envelope = room: "general"
		robot.send envelope, "今日は給料日です。残業できないから気をつけて。（既に出社している人は早いです。カフェとかで時間をつぶしてね）"
	)
	cronjob_payday.start()

	cronjob_payday = new cronJob('00 20 17 20 * 1-5', () =>
		envelope = room: "general"
		robot.send envelope, "The last 10 minutes!"
	)
	cronjob_payday.start()

	cronjob_tgif = new cronJob('00 30 17 1-19,21-31 * 5', () =>
		envelope = room: "random"
		robot.send envelope, "TGIF!:beers:"
	)
	cronjob_tgif.start()

	cronjob_voucher = new cronJob('00 45 11 15 * 1-5', () =>
		envelope = room: "random"
		robot.send envelope, "バウチャーはもらった？"
	)
	cronjob_voucher.start()