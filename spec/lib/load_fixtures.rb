require 'active_record/fixtures'

def load_fixtures
  Fixtures.create_fixtures(File.dirname(__FILE__) + "/../fixtures/", ActiveRecord::Base.connection.tables)
end

def fixtures(*args)
  args.each do |fixture|
    define_method fixture.to_s do |symbol|
      eval(fixture.to_s.singularize.camelize).find(Fixtures.all_loaded_fixtures[fixture.to_s][symbol.to_s]["id"])
    end
  end
end