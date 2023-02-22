# frozen_string_literal: true

require_relative "lib/multi_model_wizard/version"

Gem::Specification.new do |spec|
  spec.name = 'multi_model_wizard'
  spec.version = MultiModelWizard::VERSION
  spec.authors = ["micahbowie-pu"]
  spec.authors = ["proctoru"]
  spec.email = ["ruby-gems@meazurelearning.com "]

  spec.summary = 'Creates a smart object for your wizards or forms. Create one form and form object that can update multiple models with ease.'
  spec.description = 'MultiModelWizard is a way to create and update multiple ActiveRecord models using one form object.'
  spec.homepage = 'https://github.com/ProctorU/multi_model_wizard'
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["allowed_push_host"] = 'https://rubygems.org/'
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel', '>= 5.0'
  spec.add_dependency 'activesupport', '>= 5.0'

  spec.add_development_dependency 'activerecord', '>= 5.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'byebug'
end
