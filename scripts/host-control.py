import sys
import json
import atexit
import ssl
from pyVmomi import vim
from pyVim import connect
import amt.client as amt

def execute_amt_cmd(function, host, amt_user, amt_password):
    try:
        amtclient = amt.Client(host, username=amt_user, password=amt_password)
        if function == "status":
            result = amtclient.power_status()
        elif function in ["on", "reset", "off", "cycle"]:
            if function == "on":
                result = amtclient.power_on()
            if function == "off":
                result = amtclient.power_off()
            if function == "reset":
                result = amtclient.power_cycle()
            if function == "cycle":
                result = amtclient.power_cycle()
        else:
            raise ValueError(f"Unsupported function: {function}")
        return {"state": result}

    except ValueError as e:
        raise ValueError({str(e)})
    except Exception as e:
        raise RuntimeError(f"Error connecting to Intel AMT: {str(e)}")

def wait_for_task(task):
    # Waits for a vSphere task to complete
    while task.info.state not in [vim.TaskInfo.State.success, vim.TaskInfo.State.error]:
        pass
    return task.info.state

def shutdown_esxi_host(host, username, password):
    # Disable SSL certificate verification (not recommended for production use)
    context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
    context.verify_mode = ssl.CERT_NONE

    # Connect to the ESXi host
    service_instance = connect.SmartConnect(host=host,
                                            user=username,
                                            pwd=password,
                                            sslContext=context)

    atexit.register(connect.Disconnect, service_instance)

    try:
        # Find the host system
        content = service_instance.RetrieveContent()
        view = content.viewManager.CreateContainerView(content.rootFolder, [vim.HostSystem], True)
        host_system = view.view[0]  # Assuming there is only one host in the inventory
        view.Destroy()

        if not host_system:
            print("No ESXi host found.")
            raise SystemError(f"No ESXi host found.")

        # Shut down the host
        task = host_system.ShutdownHost_Task(force=True)
        print("Shutting down ESXi host. This may take some time...")

        # Wait for the task to complete
        task_result = wait_for_task(task)
        if task_result == vim.TaskInfo.State.success:
            return({"success": "ESXi host successfully shut down."})
        else:
            print("Failed to shut down ESXi host.")
            raise SystemError(f"Failed to shut down ESXi host")

    except SystemError as e:
        raise SystemError({str(e)})
    except Exception as e:
        print(f"Error: {str(e)}")
        raise RuntimeError(f"Error shutting down ESXi host: {str(e)}")

if len(sys.argv) == 7:
    function = sys.argv[1]
    host = sys.argv[2]
    amt_user = sys.argv[3]
    amt_password = sys.argv[4]
    esx_user = sys.argv[5]
    esx_password = sys.argv[6]

    try:
        if function == "vm-host-off":
            result = shutdown_esxi_host(host, esx_user, esx_password)
            print(json.dumps(result))
        else:
            result = execute_amt_cmd(function, host, amt_user, amt_password)
            print(json.dumps(result))
    except Exception as e:
        print(str(e))
        sys.exit(1)
else:
    print("Insufficient parameters supplied.")
    sys.exit(1)
