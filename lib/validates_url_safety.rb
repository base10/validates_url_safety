ActiveRecord::Base.class_eval do
  def self.converts_whitespace_for_url(*attr_names)
    configuration = { :if => :allow_validation }
    configuration.update(attr_names.extract_options!)

    replace = /(\ |\_)/

    validates_each(attr_names) do |record, attr_name, value|
      unless record.send( attr_name ).nil?
        record.send( attr_name).gsub!(replace, '-')
      end
    end
  end

  ## FIXME: This should likely be placed with activemodel validations in
  ## more official fashion
  def self.validates_url_safety_of(*attr_names)
    char_class = /[^0-9A-Za-z\_\-]/

    validates_each(attr_names) do |record, attr_name, value|
      unless record.send( attr_name ).nil?
        if record.send(attr_name).match char_class
          record.errors.add(attr_name, "contains illegal characters")
        end
      end
    end
  end
end
