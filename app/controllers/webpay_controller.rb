require 'net/http'
require 'cgi'

class WebpayController < ApplicationController
	
	protect_from_forgery :except => [:success, :index, :failure, :check]
	
	def index
		require 'date'
		@oc = "OC_" + Time.now.strftime("%Y%m%d%H%M%S")
		@mount = 10000
	end

	def success
		Rails.logger.debug "\n<<<<< success-request \n" 
	end

	def failure
		Rails.logger.debug "\n<<<<< failure-request \n" 
	end

	def check

    user_agent     = "Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120716 Firefox/15.0a2"

    # parametros de la peticion
    host =  Rails.application.config.host_webserver_bridge
    request_params = "/wpi/cgi-bin/tbk_check_mac.cgi"

    Rails.logger.debug "<<<<< request: #{host}#{request_params}"

    # se arma la peticion al server remoto (que es asi mismo)
    response = Net::HTTP.start(host) do |http|
      request               = Net::HTTP::Get.new("#{request_params}")
      request["User-Agent"] = URI.escape(user_agent)
      request["Accept"]     = "*/*"
      request["Accept-Encoding"] = "gzip, deflate"

      http.request(request)
    end

    # se carga la respueta en body
    body = response.body

    Rails.logger.debug "<<<<< body: #{body}"

    Rails.logger.debug "\n<<<<< check-request \n"	
    render :text => 'ACEPTADO', :layout => false
  end


  private


end