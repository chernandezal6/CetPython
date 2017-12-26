require 'slack-notifier'
require 'net/scp'

web_hook_url = "https://hooks.slack.com/services/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"

begin

	# Backup de TSSNAPMETRO
	@host_name = "TSSNAPMETRO"
	@host = "172.16.5.3"
	@user = "teamcity"
	@password = "k348b836t$1"
	@origen = "/config.text"
	@fecha = "#{Time.new.year}-#{Time.new.month}-#{Time.new.day}"
	@destino = "c:\\Redes\\Backup\\#{@host_name}-#{@fecha}.txt"

	capitan = Slack::Notifier.new web_hook_url, http_options: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
	capitan.channel = "#procesos"
	capitan.username = "capitan america"

	Net::SCP.start(@host, @user, :password => @password) do |scp|
      puts 'SCP Started!'
      scp.download(@origen, @destino)

      capitan.ping "@bilito65 Ya fue realizado el backup de configuracion del switch #{@host_name}."
    end

rescue

end