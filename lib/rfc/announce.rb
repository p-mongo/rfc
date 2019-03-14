require 'rspec/core'
RSpec::Support.require_rspec_core "formatters/base_text_formatter"
RSpec::Support.require_rspec_core "formatters/console_codes"

module Rfc
class Announce < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self,
    :example_group_started, :example_group_finished,
    :example_started,
    :example_passed, :example_pending, :example_failed

  def initialize(output)
    super
    @group_level = 0
  end

  def example_group_started(notification)
    output.puts if @group_level == 0
    output.puts "#{current_indentation}#{notification.group.description.strip}"

    @group_level += 1
  end

  def example_group_finished(_notification)
    @group_level -= 1 if @group_level > 0
  end

  def example_started(notification)
    example = notification.example
    output.puts(RSpec::Core::Formatters::ConsoleCodes.wrap(
      "#{current_indentation}#{example.description.strip}...", :blue))
  end

  def example_passed(passed)
    output.puts passed_output(passed.example)
  end

  def example_pending(pending)
    output.puts pending_output(pending.example,
                               pending.example.execution_result.pending_message)
  end

  def example_failed(failure)
    output.puts failure_output(failure.example)
  end

private

  def passed_output(example)
    RSpec::Core::Formatters::ConsoleCodes.wrap(
      "#{current_indentation}  passed", :success)
  end

  def pending_output(example, message)
    RSpec::Core::Formatters::ConsoleCodes.wrap(
      "#{current_indentation}" \
      "  PENDING: #{message}",
      :pending)
  end

  def failure_output(example)
    RSpec::Core::Formatters::ConsoleCodes.wrap(
      "#{current_indentation}" \
      "  FAILED - #{next_failure_index}",
      :failure)
  end

  def next_failure_index
    @next_failure_index ||= 0
    @next_failure_index += 1
  end

  def current_indentation
    '  ' * @group_level
  end
end
end
