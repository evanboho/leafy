class JavaGauge
  include Java::OrgCourseraMetricsDatadog::Tagged
  include com.codahale.metrics.Gauge

  def value
    r = Time.now.usec
    p r
    r
  end

  def name
    'leafy.demo.usec.java'
  end

  def tags
    t = [Date::DAYNAMES[Time.now.wday]]
    p t
    t
  end
end
