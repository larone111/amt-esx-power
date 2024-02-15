Simple container for Home Assistant allowing you to start or stop an Intel AMT based host. It will also cleanly shut down an ESXi host.

Usage:

Add the following parameters to your secrets.yml

    amt_user: "<user>"
    amt_password: "<pass>"
    esx_user: "<user>"
    esx_password: "<pass>"

Add the following switch to your configuration.yml

    switch:
    - platform: rest
        name: <friendly switch name>
        resource: http://<docker host ip>:9000/hooks/host-control
        state_resource: http://<docker host ip>:9000/hooks/host-control-state?state=status&host=<host ip>
        body_on: '{"state": "on", "host": "<host ip>"}'
        body_off: '{"state": "vm-host-off", "host": "<host ip>"}'
        is_on_template: '{{ value_json.state == "2" }}'
        headers:
        Content-Type: application/json
        X-AMT-User: !secret amt_user
        X-AMT-Password: !secret amt_password
        X-Esx-User: !secret esx_user
        X-Esx-Password: !secret esx_password

        verify_ssl: false
        timeout: 30

Add the switch to your HA dashboard and enjoy!