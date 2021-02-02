class ViewContext
  attr_accessor :start_date, :start_date_param

  def initialize(start_date = nil, options = {})
    @start_date = start_date
    @start_date_param = options.fetch(:start_date_param, :start_date)
  end

  def params
    if @start_date.present?
      ActionController::Parameters.new({start_date_param => @start_date})
    else
      ActionController::Parameters.new
    end
  end

  def render(options = {})
    options
  end
end
