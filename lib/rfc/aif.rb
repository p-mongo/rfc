require 'rfc/shared/brief_pending'
require 'rfc/announce'

module Rfc
class Aif < Announce
  include Shared::BriefPending

  RSpec::Core::Formatters.register self,
    :example_group_started, :example_group_finished,
    :start, :example_started,
    :example_passed, :example_pending, :example_failed,
    :dump_summary, :dump_failures, :dump_pending

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
