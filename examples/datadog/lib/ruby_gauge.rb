class RubyGauge < Leafy::Metrics::Gauge
  include Java::OrgCourseraMetricsDatadog::Tagged

  def value
    r = Time.now.usec
    p r
    r
  end

  def name
    'leafy.demo.usec.ruby'
  end

  def tags
    t = [Date::DAYNAMES[Time.now.wday]]
    p t
    t
  end
end
