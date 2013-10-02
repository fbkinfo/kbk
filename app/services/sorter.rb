class Sorter
  attr_reader :column, :direction

  def self.sortable_fields
    @sortable_fields
  end

  def self.sort_with(*fields)
    @sortable_fields = fields
  end

  def self.sort_with_default(column, direction = 'asc')
    @column = column
    @direction = direction
  end

  def initialize(sort_params)
    sort_params ||= {}
    @column = sort_params[:column] if sort_params[:column]

    if %w(asc desc).include?(sort_params[:direction])
      @direction = sort_params[:direction]
    end
  end

  def apply(scope)
    sort_scope(scope)
  end

  def sort_scope(scope)
    if @column
      if self.class.sortable_fields.include?(@column)
        scope.order("#{@column} #{@direction}")
      elsif block_given?
        yield(scope, @column, @direction) || scope
      else
        scope
      end
    else
      scope
    end
  end
end
