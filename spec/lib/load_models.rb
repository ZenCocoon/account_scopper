def load_models
  Dir[File.dirname(__FILE__) + "/../fixtures/*.rb"].entries.compact.each do |str|
    load(str)
  end
end