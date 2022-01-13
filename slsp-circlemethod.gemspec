# frozen_string_literal: true

require_relative "lib/slsp/circlemethod/version"

Gem::Specification.new do |spec|
  spec.name = "slsp-circlemethod"
  spec.version = SLSP::CircleMethod::VERSION
  spec.authors = ["Joji Wakairo"]
  spec.email = ["jw1@ninegw.sakura.ne.jp"]

  spec.summary = "SLSP:: CircleMethod provides methods using the circle method for Sports League Scheduling Problems."
  spec.description = "SLSP:: CircleMethod provides methods using the circle method for Sports League Scheduling Problems. By using the circle method, this gem computes schedules of matches of n teams considering rounds and breaks, which are two consecutive home matches or two consecutive away matches."
  spec.homepage = "https://github.com/wakairo/slsp-circlemethod"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wakairo/slsp-circlemethod"
  spec.metadata["changelog_uri"] = "https://github.com/wakairo/slsp-circlemethod/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
end
