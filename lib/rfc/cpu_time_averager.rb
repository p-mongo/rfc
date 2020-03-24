module Rfc
  class CpuTimeAverager
    Sample = Struct.new(
      :user, :nice, :system, :idle, :iowait, :irq, :softirq, :steal,
      :guest, :guest_nice,
    )

    def initialize
      @samples = []
    end

    def sample
      # https://www.linuxhowtos.org/manpages/5/proc.htm
      IO.readlines('/proc/stat').each do |line|
        if line =~ /^cpu/
          _, user, nice, system, idle, iowait, irq, softirq, steal,
            guest, guest_nice = line.split.map(&:to_i)
          @samples << [Time.now, Sample.new(
            user, nice, system, idle, iowait, irq, softirq, steal,
            guest, guest_nice,
          )]
          break
        end
      end

      threshold = Time.now - 10
      while @samples.length > 2 && @samples.first.first < threshold
        @samples.shift
      end
    end

    def enough?
      @samples.last.first - @samples.first.first >= 2
    end

    def first
      @samples.first
    end

    def last
      @samples.last
    end

    %i(user nice system idle iowait irq softirq steal guest guest_nice).each do |attr|
      define_method("#{attr}_delta") do
        last.last.send(attr) - first.last.send(attr)
      end
    end
  end
end
