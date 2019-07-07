require 'rfc/announce'

module Rfc
class Aif < Announce
  RSpec::Core::Formatters.register self,
    :example_group_started, :example_group_finished,
    :start, :example_started,
    :example_passed, :example_pending, :example_failed,
    :dump_failures, :dump_summary

  def start(notification)
    @failed_count = 0
  end

  def example_failed(failure)
    @failed_count += 1

    output.puts failure.fully_formatted(@failed_count)
    output.puts
  end

  def dump_failures(notification)
  end

  def dump_summary(summary)
  end

end

AIF = Aif
end
