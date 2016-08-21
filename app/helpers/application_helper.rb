module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success" # Green
      when "error"
        "alert-danger" # Red
      when "alert"
        "alert-warning" # Yellow
      when "notice"
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end

  # Date Ranges
  def date_range_for(time_period)
    if time_period == 'this_week'
      (Time.zone.now.to_date.beginning_of_week(:sunday).in_time_zone)..((Time.zone.now.to_date.beginning_of_week(:sunday)+6).in_time_zone.end_of_day)
    elsif time_period == 'this_month'
      (Time.zone.now.to_date.at_beginning_of_month.in_time_zone)..((Time.zone.now.to_date.at_end_of_month).in_time_zone.end_of_day)
    elsif time_period == 'this_year'
      (Time.zone.now.to_date.at_beginning_of_year.in_time_zone)..((Time.zone.now.to_date.at_end_of_year).in_time_zone.end_of_day)
    elsif time_period == 'last_week'
      ((Time.zone.now.to_date.beginning_of_week(:sunday)-7).in_time_zone)..((Time.zone.now.to_date.beginning_of_week(:sunday)-1).in_time_zone.end_of_day)
    elsif time_period == 'last_month'
      (Time.zone.now.to_date.last_month.at_beginning_of_month.in_time_zone)..(Time.zone.now.to_date.last_month.at_end_of_month.in_time_zone.end_of_day)
    elsif time_period == 'last_year'
      (Time.zone.now.to_date.last_year.at_beginning_of_year.in_time_zone)..(Time.zone.now.to_date.last_year.at_end_of_year.in_time_zone.end_of_day)
    end
  end

  def default_capture_date
  default_capture_date = Time.zone.now.to_date
  end
end