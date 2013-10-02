class InvestigationPublish
  def initialize(investigation)
    @model = investigation
  end

  def update(date)
    return false if date.blank?

    date = parse_date(date)
    return false if date.blank?

    if (!active? || @model.published_until < date) && date <= Date.current
      @model.published_until = date
      @model.save
    end
  end

  def cancel
    @model.published_until = nil
    @model.save
  end

  def active?
    !@model.deleted? && @model.published_until.present?
  end

  private

  def parse_date(date)
    if date.is_a?(String)
      Date.parse(date)
    else
      date
    end
  rescue ArgumentError
  end

end