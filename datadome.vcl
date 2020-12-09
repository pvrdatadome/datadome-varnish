# DataDome VCL for Varnish 4.0 / 4.1 / 5.0 / 5.1

import std;
import data_dome_shield;

# DataDome API Backend
backend data_dome_backend {
    .host = "apivarnish.datadome.co";
    .port = "80";
    .connect_timeout = 150ms;
    .first_byte_timeout = 50ms;
    .between_bytes_timeout = 50ms;
}

sub vcl_init {
    # Initialize DataDome Module with the DataDome Key
    data_dome_shield.init(data_dome_backend, "DOMEKEY");
}

sub vcl_recv {
    # Check if this request should be addressed by DataDome
    # AND if it was not already addressed
    if (data_dome_shield.is_suitable()) {
        data_dome_shield.prepare_request();
        return (pass);
    }
}

sub vcl_pass {
  if (data_dome_shield.has_prepared_request()) {
    return (fetch);
  }
}

sub vcl_backend_fetch {
    if (data_dome_shield.is_datadome_call()) {
        # setup specified setting to request
        data_dome_shield.prepare_backends_request();
        return (fetch);
    }
    # cleanup datadome-related stuff from the backend request
    data_dome_shield.cleanup_backends_request();
}

sub vcl_backend_response {
  if (data_dome_shield.is_datadome_call()) {
    return (deliver);
  }
}

sub vcl_backend_error {
  if (data_dome_shield.is_datadome_call()) {
    return (deliver);
  }
}

sub vcl_deliver {
    # Check if the request was addressed by DataDome
    if (data_dome_shield.has_prepared_request()) {
        # Check if we should print a captcha
        if (!data_dome_shield.is_valid()) {
            return (deliver);
        }
        return (restart);
    }
}

