require 'rspec/core/formatters/base_text_formatter'

module Rfc
class Riff < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self,
    :message, :dump_summary, :dump_failures, :dump_pending, :seed,
    :example_passed, :example_pending, :example_failed

  attr_reader :total_count, :passed_count, :failed_count, :completed_count

  class << self
    attr_accessor :heartbeat_interval
  end
  self.heartbeat_interval = 10

  def start(notification)
    @total_count = notification.count
    @passed_count = 0
    @pending_count = 0
    @failed_count = 0
    @completed_count = 0
    @this_percent = 0
    @started_at = Time.now

    # There is no progress at this point but report the total number of
    # examples prior to running any of them
    report_progress
  end

  def example_passed(_notification)
    @passed_count += 1
    @completed_count += 1
    report_progress
  end

  def example_pending(notification)
    @pending_count += 1
    @completed_count += 1
    report_progress
  end

  def example_failed(notification)
    @failed_count += 1
    @completed_count += 1

    output.puts notification.fully_formatted(failed_count)
    output.puts
  end

  def report_progress
    this_percent = @completed_count * 100 / total_count
    if @reported_percent != this_percent || @reported_at.nil? ||
      Time.now-@reported_at > self.class.heartbeat_interval
    then
      progress_msg = %Q`\
#{Time.now.strftime('[%Y-%m-%d %H:%M:%S %z]')} \
#{this_percent}% (#{@completed_count}/#{@total_count} examples) complete`
      if @pending_count > 0
        progress_msg += ", #{@pending_count} pending"
      end
      if @failed_count > 0
        progress_msg += ", #{@failed_count} failed"
      end
      output.puts progress_msg
      @reported_percent = this_percent
      @reported_at = Time.now
    end
  end

  def dump_failures(notification)
  end
end
end
