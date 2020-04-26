module Rfc
module Shared
module BriefPending

  def dump_pending(notification)
    return if notification.pending_examples.empty?

    formatted = "\nPending: (Failures listed here are expected and do not affect your suite's status)\n".dup

    pending_notifications = notification.pending_notifications
    colorizer = ::RSpec::Core::Formatters::ConsoleCodes

    pending_notifications.first(10).each_with_index do |notification, index|
      formatted << notification.fully_formatted(index.next, colorizer)
    end

    if pending_notifications.length > 10
      formatted << colorizer.wrap(
        "\n+ #{pending_notifications.length-10} more pending examples",
        :yellow)
    end

    output.puts(formatted)
  end
end
end
end
