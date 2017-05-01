# This module waits for the Capybara default wait for AJAX requests. Once that is
# over, it keeps looping until all AJAX requests finish by checking jQuery.active
# Thanks, thoughtbot: https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  # Thanks, Artsy
  # http://artsy.github.io/blog/2012/02/03/reliably-testing-asynchronous-ui-w-slash-rspec-and-capybara/
  def wait_for_dom(_timeout = Capybara.default_max_wait_time)
    uuid = SecureRandom.uuid
    page.find('body')
    page.evaluate_script <<-EOS
      setTimeout(function() {
        $('body').append("<div id='capybara-#{uuid}'></div>");
      }, 1);
    EOS
    page.find("#capybara-#{uuid}")
  end

  def finished_all_ajax_requests?
    result = page.evaluate_script('jQuery.active')
    result.nil? || result.zero?
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
