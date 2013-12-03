class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_filter :authenticate_user!, except: [:sign_in, :sign_out]
  before_filter :set_time_zone
  before_filter :set_email_report_preferences

  def set_time_zone
    #current user is a devise method see https://github.com/plataformatec/devise
    # Time.zone = current_user.time_zone if current_user


    us_pacific = ActiveSupport::TimeZone.us_zones.find{|x| x.name == "Pacific Time (US & Canada)"}
    us_atlantic = ActiveSupport::TimeZone.us_zones.find{|x| x.name == "Eastern Time (US & Canada)"}
    Time.zone = us_pacific
    # Time.zone = us_atlantic
  end

  def set_email_report_preferences
    @email = Email.new(manager: "bkoehmstedt@ucmerced.edu", subject: "Goals for #{Time.zone.now.strftime("%a, %m/%d")}")
  end
end
