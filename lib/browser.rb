# frozen_string_literal: true
require "selenium-webdriver"
require "dotenv/load"

module Browser
  def self.driver
    root = File.expand_path("..", __dir__)
    drivers = File.join(root, "drivers")

    browser = ENV["BROWSER"] || "edge"

    case browser
    when "chrome"
      path = File.join(drivers, "chromedriver")

      Selenium::WebDriver.for(
        :chrome,
        service: Selenium::WebDriver::Chrome::Service.new(path: path)
      )

    when "edge"
      path = File.join(drivers, "msedgedriver.exe")

      Selenium::WebDriver.for(
        :edge,
        service: Selenium::WebDriver::Edge::Service.new(path: path)
      )
    else
      raise "Unsupported browser: #{browser}"
    end
  end
end
