class DocumentForm
  ATTRIBUTES = [:renew_investigation_publish]
  attr_accessor *ATTRIBUTES

  def initialize(attributes_or_record = {})
    if attributes_or_record.is_a?(Document)
      @document = attributes_or_record
    else
      @document = Document.new

      if attributes_or_record[:user]
        @document.user = attributes_or_record[:user]
        @document.author = @document.user.author
      end
    end
  end

  def populate(params)
    @document.document_date = Date.current
    @document.investigation_id = params[:investigation_id] if params[:investigation_id]

    if params[:cause_id]
      @document.cause = Document.find(params[:cause_id])
      @document.investigation_id = @document.cause.investigation_id

      if @document.cause.outgoing?
        @document.kind = :incoming
      end
    end
  end

  def attributes
    virtual_attributes.merge(@document.attributes)
  end

  def attributes=(attrs)
    attrs.each do |column|
      send("#{column[0]}=", column[1])
    end
  end

  def save
    result = @document.save

    update_investigation_publish if result

    result
  end

  def update_investigation_publish
    if renew_investigation_publish && @document.investigation.published_until?
      @document.investigation.publish.update(@document.document_date)
    end
  end

  def investigations_list
    Investigation.all.pluck(:title, :id)
  end

  def authors_list
    Author.all.pluck(:name, :id)
  end

  def organizations_list
    Organization.all.pluck(:name, :id)
  end

  def organization_id=(value)
    if value.present? && not_id?(value)
      super(Organization.find_or_create_by!(name: value).id)
    else
      super
    end
  end

  def investigation_id=(value)
    if value.present? && not_id?(value)
      record = Investigation.find_or_create_by!(title: value, user_id: user.id)
      super(record.id)
    else
      super
    end
  end

  def author_id=(value)
    if value.present? && not_id?(value)
      super(Author.find_or_create_by!(name: value).id)
    else
      super
    end
  end

  def respond_to?(meth)
    if @document.respond_to?(meth)
      true
    else
      super
    end
  end

  def method_missing(meth, *args, &block)
    if @document.respond_to?(meth)
      @document.public_send(meth, *args, &block)
    else
      super
    end
  end

  def self.respond_to?(meth)
    if Document.respond_to?(meth)
      true
    else
      super
    end
  end

  def self.method_missing(meth, *args, &block)
    if Document.respond_to?(meth)
      Document.public_send(meth, *args, &block)
    else
      super
    end
  end

  private

  def virtual_attributes
    Hash[ ATTRIBUTES.map{ |a| [a, public_send(a)] } ]
  end

  def not_id?(id)
    !id.to_s.match(/^(\d)+$/)
  end

end