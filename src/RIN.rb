require "discordrb"
require 'net/http'
require 'uri'
require "json"
require "facter"

class RIN
	def initalize(token, prefix)
		@RIN = Discordrb::Commands::CommandBot.new(token: token,prefix: prefix)
		@BASE_WEBHOOK = "https://discordapp.com/api/webhooks/"
		@Commands = {
			"help" => "コマンドリストを表示します",
			"settalk" => "RIN自然雑談システムを、コマンドを送信したチャンネルで使えるかを設定します",
			"eval" => "開発者限定コマンドです、入力されたテキストをその場で評価します",
			"ri" => "サーバーの情報を表示します",
			"ri <name or id>" => "サーバーの情報を表示します",
			"ui" => "ユーザーの情報を表示します",
			"ui <name or id>" => "ユーザーの情報を表示します",
			"ci" => "Eventがあったチャンネルの情報を表示します",
			"share <channel_id>" => "画面共有のURLを生成します",
			"bi" => "Botの情報を表示します",
			"重要" => "データの保存はされません、今現在テスト中なのでSIAが再起動されたらすべてのデータが削除されます"
		}
		@baseurl = "rinnet.xyz:3000"
		@TalkEnabled = [
			539804456259158016
		]
		@Myas = {}
	end

	def servers
		@RIN.servers.size
	end

	# メッセージ返信時は必ずこれを使う
	def reply (channel, autor, msg)
		rep = nil
		begin
			rep = channel.send_message(msg)
		rescue
			author.pm "Sorry :joy: | メッセージを送信しようとしたのですが、エラーが発生したか権限がありませんでした！"
		end
		rep
	end

	def rin
		@RIN
	end

	def request (text, history)
		uri = URI.parse("http://#{@baseurl}/talkapi/v3")

		params = {
			"msg" => text,
			"history" => history.json(",")
		}

		ret = Net::HTTP.post_form(uri, params)
		parsed = JSON.parse(ret.body)

		if parsed.include? "respond"
			return parsed["respond"]
		else
			return parsed["Error"]
		end
	end