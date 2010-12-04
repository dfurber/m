class Key < ActiveRecord::Base

  # field :name, :type => String
  # field :value, :type => String
  # field :description, :type => String
  # field :typecast, :type => String
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :typecast, :with => /String|Integer|Decimal/
  validates_presence_of :value
  
  default_scope :order => :name
  scope :name_or_value, lambda {|p|
    where({:name.matches => "%#{p}%"} | {:value.matches => "%#{p}%"})
  }

  def value
    prelim = read_attribute('value')
    case typecast
    when 'String'
      prelim
    when 'Integer'
      prelim.to_i
    when 'Decimal'
      prelim.to_f
    when 'Boolean'
      prelim.to_i == 1
    end
  end
  
  def raw_value
    read_attribute('value')
  end
  
  def display_value
    if typecast == 'Boolean'
      raw_value == "0" ? "no" : "yes"
    else
      raw_value.size > 20 ? "#{raw_value[0..20]}..." : raw_value
    end
  end
  
  def self.ensure!(*args)
    options = args.extract_options!
    options.symbolize_keys!
    key = Key.find_or_initialize_by_name options[:name]
    key.typecast = options[:typecast] || 'String' 
    key.value ||= options[:value]
    key.description ||= options[:description]
    key.save!
  end
  
  def self.[](name)
    @keys ||= {}
    return @keys[name] if @keys[name]
    if table_exists?
      key = Key.find_by_name name
      @keys[name] = key.present? ? key.value : nil
    end
  end

end
