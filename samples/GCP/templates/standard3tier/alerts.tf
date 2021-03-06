/**
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
# This sample is using modules to create a number of alerts
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

# This section will declare the providers needed...
# terraform init -upgrade

//
// Various sample alerts
//
resource "google_monitoring_alert_policy" "lb_alert001" {
  // L7 load balancer error request count = 0/sec
  display_name = "Availability HTTP/S Load Balancing Rule"
  combiner     = "OR"
  conditions {
    display_name = "Availability HTTP/S Load Balancing Rule"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" metric.label.response_code!=\"200\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  }
  documentation {
    content = "The load balancer rule $${condition.display_name} has generated this alert for the $${metric.display_name}."
  }
}

resource "google_monitoring_alert_policy" "lb_alert002" {
  // L7 Load balancer total latency > 100ms
  display_name = "Latency HTTP/S Load Balancing Rule GT 100s"
  combiner     = "OR"
  conditions {
    display_name = "Latency HTTP/S Load Balancing Rule GT 100s"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/total_latencies\" resource.type=\"https_lb_rule\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 100
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"
      }
    }
  }
  documentation {
    content = "The load balancer rule $${condition.display_name} has generated this alert for the $${metric.display_name}."
  }
}

resource "google_monitoring_alert_policy" "lb_alert003" {
  // L7 load balancer Frontend RTT latency > 50ms
  display_name = "Latency HTTP/S Load Balancing Rule Frontend RRT GT 50s"
  combiner     = "OR"
  conditions {
    display_name = "Latency HTTP/S Load Balancing Rule Frontend RRT GT 50s"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/frontend_tcp_rtt\" resource.type=\"https_lb_rule\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 50
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"
      }
    }
  }
  documentation {
    content = "The load balancer rule $${condition.display_name} has generated this alert for the $${metric.display_name}."
  }
}

resource "google_monitoring_alert_policy" "lb_alert004" {
  // L7 load balancer Backend RTT latency > 50ms
  display_name = "Latency HTTP/S Load Balancing Rule backend RRT GT 50s"
  combiner     = "OR"
  conditions {
    display_name = "Latency HTTP/S Load Balancing Rule backend RRT GT 50s"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/backend_latencies\" resource.type=\"https_lb_rule\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 50
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"
      }
    }
  }
  documentation {
    content = "The load balancer rule $${condition.display_name} has generated this alert for the $${metric.display_name}."
  }
}

resource "google_monitoring_alert_policy" "lb_alert005" {
  // L7 load balancer request count > 100/sec
  display_name = "Volume HTTP/S Load Balancing Rule request count GT 100s"
  combiner     = "OR"
  conditions {
    display_name = "Volume HTTP/S Load Balancing Rule request count GT 100s"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 100
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  documentation {
    content = "The load balancer rule $${condition.display_name} has generated this alert for the $${metric.display_name}."
  }
}

resource "google_monitoring_alert_policy" "cpu_alert001" {
  // CPU utilitisation
  display_name = "CPU utilisation GT 0.9"
  combiner     = "OR"
  conditions {
    display_name = "CPU utilisation GT 0.9"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.9
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "120s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  documentation {
    content = "The CPU rule $${condition.display_name} has generated this alert for the $${metric.display_name}."
  }
}

//
// Various sample SLOs
//
resource "google_monitoring_custom_service" "service_slo" {
  service_id   = "service-slo"
  display_name = "Service SLO"
}

resource "google_monitoring_slo" "slo_lbbackend" {
  service      = google_monitoring_custom_service.service_slo.service_id
  display_name = "Standard SLO LB Backend latency"

  goal                = 0.8
  rolling_period_days = 20

  windows_based_sli {
    window_period = "100s"

    good_total_ratio_threshold {
      threshold = 0.1
      performance {
        distribution_cut {
          distribution_filter = join(" AND ", [
            "metric.type=\"loadbalancing.googleapis.com/https/backend_latencies\"",
            "resource.type=\"https_lb_rule\"",
          ])

          range {
            min = 1
            max = 9
          }
        }
      }
    }
  }
}

resource "google_monitoring_slo" "slo_lbtlbackend" {
  service      = google_monitoring_custom_service.service_slo.service_id
  display_name = "Standard SLO LB Total latency"

  goal                = 0.8
  rolling_period_days = 20

  windows_based_sli {
    window_period = "100s"

    good_total_ratio_threshold {
      threshold = 0.1
      performance {
        distribution_cut {
          distribution_filter = join(" AND ", [
            "metric.type=\"loadbalancing.googleapis.com/https/total_latencies\"",
            "resource.type=\"https_lb_rule\"",
          ])

          range {
            min = 1
            max = 9
          }
        }
      }
    }
  }
}

resource "google_monitoring_slo" "slo_monitor" {
  service      = google_monitoring_custom_service.service_slo.service_id
  display_name = "Standard SLO to monitor the monitor"

  goal            = 0.95
  calendar_period = "FORTNIGHT"

  windows_based_sli {
    window_period = "400s"
    good_bad_metric_filter = join(" AND ", [
      "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\"",
      "resource.type=\"uptime_url\"",
    ])
  }
}

resource "google_monitoring_slo" "slo_gce" {
  service      = google_monitoring_custom_service.service_slo.service_id
  display_name = "Standard SLO to monitor the GCEs"

  goal                = 0.9
  rolling_period_days = 20

  windows_based_sli {
    window_period = "600s"
    metric_mean_in_range {
      time_series = join(" AND ", [
        "metric.type=\"agent.googleapis.com/cassandra/client_request/latency/95p\"",
        "resource.type=\"gce_instance\"",
      ])

      range {
        max = 5
      }
    }
  }
}

resource "google_monitoring_slo" "slo_monitor_up" {
  service      = google_monitoring_custom_service.service_slo.service_id
  display_name = "Standard SLO to monitor the monitor uptime"

  goal                = 0.9
  rolling_period_days = 20

  windows_based_sli {
    window_period = "400s"
    metric_sum_in_range {
      time_series = join(" AND ", [
        "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\"",
        "resource.type=\"uptime_url\"",
      ])

      range {
        max = 5000
      }
    }
  }
}

