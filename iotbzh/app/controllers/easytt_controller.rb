#require 'date'

class EasyttController < ApplicationController
  include EasyttHelper

  # Constants
  DEFAULT_REFDATE = Date.today
  DEFAULT_VIEWTYPE = "week"

  # Response to route '/easytt/...'
  def index
    @view = get_view
    userid = User.current.id
    if (params.has_key?(:userid))
      userid = params[:userid]
    end

    # Give data to the view
    if (@view.is_a? BaseView)
      @view.set_datas(@entries = TimeEntry.where("user_id = ? AND spent_on >= ? AND spent_on <= ?", userid, @view.startdate, @view.enddate).all)
    end
  end

private
  # Get the reference date from the URL if any
  # If no valid date is given, use today.
  def get_refdate
    return Date.strptime(params[:refdate])
  rescue
    params[:refdate] = DEFAULT_REFDATE
    return DEFAULT_REFDATE
  end

  # Get a view object corresponding to the viewtype and refdate.
  def get_view
    # If not viewtype is given, use the default view.
    viewtype = DEFAULT_VIEWTYPE
    if (params.has_key?(:viewtype))
      viewtype = params[:viewtype]
    end

    # Get the reference date
    refdate = get_refdate

    # Build the correct view object
    case params[:viewtype]
    when "day"
      return DayView.new(refdate)
    when "week"
      return WeekView.new(refdate)
    when "workweek"
      return WorkWeekView.new(refdate)
    when "month"
      return MonthView.new(refdate)
    when "workmonth"
      return WorkMonthView.new(refdate)
    else
      redirect_to action: "index", viewtype: viewtype, refdate: refdate
    end
  end
end



  #   # Set default viewtype if none set
  #   unless (params.has_key?(:viewtype))
  #     params[:viewtype] = "week"
  #   end
  #   @viewtype = params[:viewtype]

  #   case @viewtype
  #   when "day"
  #     @view = DayView.new(@refdate)
  #     # Get time frame
  #     referencedate = @refdate
  #     @startdate = @refdate
  #     @enddate = @refdate
  #     @dayperrow = 1
  #     @nextdate = @refdate.advance(:days => +1)
  #     @previousdate = @refdate.advance(:days => -1)
  #   when "workweek"
  #     @view = WorkWeekView.new(@refdate)
  #     # Get time frame
  #     referencedate = @refdate.beginning_of_week
  #     @startdate = referencedate
  #     @enddate = referencedate.advance(:days => +5)
  #     @dayperrow = 5
  #     @nextdate = @refdate.advance(:weeks => +1)
  #     @previousdate = @refdate.advance(:weeks => -1)
  #   when "week"
  #     @view = WeekView.new(@refdate)
  #     # Get time frame
  #     referencedate = @refdate.beginning_of_week
  #     @startdate = referencedate
  #     @enddate = referencedate.end_of_week
  #     @dayperrow = 7
  #     @nextdate = @refdate.advance(:weeks => +1)
  #     @previousdate = @refdate.advance(:weeks => -1)
  #   when "workmonth"
  #     @view = WorkMonthView.new(@refdate)
  #     # Get time frame
  #     referencedate = @refdate.beginning_of_month
  #     @startdate = referencedate.beginning_of_week
  #     @enddate = referencedate.end_of_month.end_of_week
  #     @dayperrow = 5
  #     @nextdate = @refdate.advance(:months => +1)
  #     @previousdate = @refdate.advance(:months => -1)
  #   when "month"
  #     @view = MonthView.new(@refdate)
  #     # Get time frame
  #     referencedate = @refdate.beginning_of_month
  #     @startdate = referencedate.beginning_of_week
  #     @enddate = referencedate.end_of_month.end_of_week
  #     @dayperrow = 7
  #     @nextdate = @refdate.advance(:months => +1)
  #     @previousdate = @refdate.advance(:months => -1)
  #   else
  #     params[:viewtype] = "week"
  #     redirect_to action: "index", viewtype: @viewtype, refdate: @refdate
  #   end

  #   unless (referencedate == @refdate)
  #     redirect_to action: "index", viewtype: @viewtype, refdate: referencedate
  #   end

  #   @entries = TimeEntry.where("user_id = ? AND spent_on >= ? AND spent_on <= ?", User.current.id, @startdate, @enddate).all
  # end

  # def populate_day(date)
  #   data = ""
  #   total_hours = 0.0
  #   @entries.each { |entry|
  #     if (entry.spent_on == date)
  #       height = (20 * entry.hours).to_s
  #       style = "easytt_timeslot_ok"
  #       if ((total_hours + entry.hours) > 8.0)
  #         style = "easytt_timeslot_error"
  #       end
  #       total_hours += entry.hours
  #       data += "<div class=\"easytt_timeslot " + style
  #       data += "\" style=\"height: " + height + "px; line-height: " + height + "px;\">"
  #       data += entry.hours.to_s + "h "+ "of" + " " + entry.activity.name + " " + "on" + " " + entry.project.name
  #       data += "</div>\n"
  #     end
  #   }
  #   data.html_safe
  # end

  # def print_day_name(daynum)
  #   while daynum > 6
  #     daynum = daynum - 7
  #   end
  #   data = "<div class=\"easytt_view_dayperrow_" + @dayperrow.to_s + " easytt_cell_header\">" + l('date.day_names')[daynum] + "</div>"
  #   data.html_safe
  # end

  # def print_day_names
  #   data = "<div class=\"easytt_row easytt_rowheader_dayname\">"

  #   if (@dayperrow == 1)
  #     data += print_day_name(@refdate.cwday)
  #   else
  #     data += print_day_name(1)
  #     data += print_day_name(2)
  #     data += print_day_name(3)
  #     data += print_day_name(4)
  #     data += print_day_name(5)
  #     if (@dayperrow == 7)
  #       data += print_day_name(6)
  #       data += print_day_name(0)
  #     end
  #   end

  #   data += "</div>"
  #   data.html_safe
  # end

  # def print_row_header
  # end

  # def print_row_data
  # end

  # def print_row
    
  # end

  # def print_calendar
  #   #while (@startdate <= @enddate)
  #   #  print_row
  #   #end
  # end