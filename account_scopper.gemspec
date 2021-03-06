# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{account_scopper}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sebastien Grosjean"]
  s.date = %q{2009-11-17}
  s.description = %q{Account Scopper: Automatically scope your ActiveRecord's model by account. Ideal for multi-account applications.}
  s.email = %q{public@zencocoon.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "account_scopper.gemspec",
     "init.rb",
     "lib/account_scopper.rb",
     "spec/account_scopper_spec.rb",
     "spec/boot.rb",
     "spec/database.yml",
     "spec/fixtures/account.rb",
     "spec/fixtures/accounts.yml",
     "spec/fixtures/user.rb",
     "spec/fixtures/users.yml",
     "spec/lib/load_fixtures.rb",
     "spec/lib/load_models.rb",
     "spec/lib/load_schema.rb",
     "spec/schema.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/ZenCocoon/account_scopper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Account Scopper: Automatically scope your ActiveRecord's model by account. Ideal for multi-account applications.}
  s.test_files = [
    "spec/account_scopper_spec.rb",
     "spec/boot.rb",
     "spec/fixtures/account.rb",
     "spec/fixtures/user.rb",
     "spec/lib/load_fixtures.rb",
     "spec/lib/load_models.rb",
     "spec/lib/load_schema.rb",
     "spec/schema.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.4"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.3.4"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.3.4"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

