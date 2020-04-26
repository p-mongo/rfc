require 'rspec/core'
require 'rfc/cpu_time_averager'
require 'rfc/shared/brief_pending'
RSpec::Support.require_rspec_core "formatters/base_text_formatter"

module Rfc
class Rif < RSpec::Core::Formatters::BaseTextFormatter
  include Shared::BriefPending

  RSpec::Core::Formatters.register self,
    :message, :dump_summary, :dump_failures, :dump_pending, :seed,
    :example_passed, :example_pending, :example_failed

  attr_reader :total_count, :passed_count, :failed_count, :completed_count

  class << self
    attr_accessor :heartbeat_interval

    # ObjectSpace statistics are generally not available on JRuby:
    # RuntimeError (ObjectSpace is disabled; each_object will only work with Class, pass -X+O to enable)
    attr_accessor :output_object_space_stats

    attr_accessor :output_system_load
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
    if total_count == 0
      # When a test suite has no examples or they are all filtered out,
      # there is no meaningful progress to report.
      return
    end

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
      if self.class.output_object_space_stats
        progress_msg += "; objects: #{ObjectSpace.count_objects[:TOTAL]} total, #{ObjectSpace.count_objects[:FREE]} free"
      end
      if self.class.output_system_load
        progress_msg += "\n#{system_load_msg}"
      end
      output.puts progress_msg
      @reported_percent = this_percent
      @reported_at = Time.now
    end
  end

  def dump_failures(notification)
  end

  private

  def system_load_msg
    stats = {}
    IO.readlines('/proc/meminfo').each do |line|
      measure, value, unit = line.split
      value = value.to_i
      if value != 0
        if unit != 'kB'
          return "Unexpected unit: #{unit} for #{line}"
        end
        value = value * 1024
      end
      measure.sub!(/:$/, '')
      stats[measure] = value
    end

    mem_used = stats['MemTotal'] - stats['MemFree'] - stats['Buffers'] - stats['Cached']
    swap_used = stats['SwapTotal'] - stats['SwapFree']
    buf_used = stats['Buffers'] + stats['Cached']
    total = stats['MemTotal']
    swap = stats['SwapTotal']
    avail = stats['MemFree'] + stats['Buffers'] + stats['Cached']

    msg = "Memory: #{m(mem_used)} RAM + #{m(swap_used)} swap used, #{m(buf_used)} buf, #{m(total)} RAM + #{m(swap)} swap total, #{m(avail)} avail"

    @cpu_time_averager ||= CpuTimeAverager.new
    @cpu_time_averager.sample
    if @cpu_time_averager.enough?
      all = @cpu_time_averager.user_delta +
        @cpu_time_averager.nice_delta +
        @cpu_time_averager.system_delta +
        @cpu_time_averager.irq_delta +
        @cpu_time_averager.iowait_delta +
        @cpu_time_averager.idle_delta
      used = ((@cpu_time_averager.user_delta +
        @cpu_time_averager.nice_delta +
        @cpu_time_averager.system_delta +
        @cpu_time_averager.irq_delta) * 100.0 / all).round
      idle = (@cpu_time_averager.idle_delta * 100 / all).round
      iowait = (@cpu_time_averager.iowait_delta * 100 / all).round

      msg += "\nCPU: %2d%% used, %2d%% iowait, %2d%% idle" % [used, iowait, idle]
    end

    msg
  end

  def m(value)
    "#{(value / 1024.0 / 1024).round}M"
  end
end
end
