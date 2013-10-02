require 'recursive_open_struct'

class Filter
  attr_reader :filterer, :counters

  class F < RecursiveOpenStruct
    def self.model_name; ActiveModel::Name.new(self) end

    def self.filter_by_dates_or_period(s, period, from, to)
      if !from.blank? && !to.blank?
        s = s.where(yield Date.parse(from)..Date.parse(to)+1.day)
      elsif period.to_i > 0
        s = s.where(yield (Date.today-period.to_i.days)..Date.today+1.day)
      end

      s
    end
  end

  def filter_scope(scope)
    self.class.filterable_fields.each do |f|
      scope = scope.where(f => @filterer.send(f)) unless @filterer.send(f).blank?
    end

    scope = yield(scope, @filterer) if block_given?
    scope
  end

  def apply
    apply_filters
    apply_counters

    @scope
  end

  def self.filterable_fields
    @filterable_fields
  end

  def self.filter_with(*fields)
    @filterable_fields = fields
  end
end
