import geni.portal as portal
import geni.rspec.pg as rspec

# Create a Request object to start building the RSpec.
request = portal.context.makeRequestRSpec()

# Prefix for IP addresses
prefixForIP = "192.168.1."
link = request.LAN("lan")

# Create a XenVM for the webserver
webserver = request.XenVM("webserver")
webserver.routable_control_ip = True
webserver.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU20-64-STD"
webserver_iface = webserver.addInterface("if0")
webserver_iface.component_id = "eth1"
webserver_iface.addAddress(rspec.IPv4Address(prefixForIP + "1", "255.255.255.0"))
link.addInterface(webserver_iface)
webserver.addService(rspec.Execute(shell="sh", command="sudo apt-get update && sudo apt-get install -y apache2"))

# Create a XenVM for the observer
observer = request.XenVM("observer")
observer.routable_control_ip = False
observer.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU20-64-STD"
observer_iface = observer.addInterface("if1")
observer_iface.component_id = "eth1"
observer_iface.addAddress(rspec.IPv4Address(prefixForIP + "2", "255.255.255.0"))
link.addInterface(observer_iface)
observer.addService(rspec.Execute(shell="sh", command="sudo apt-get update && sudo apt-get install -y nfs-kernel-server && sudo mkdir -p /var/webserver_monitor && sudo chown nobody:nogroup /var/webserver_monitor && sudo chmod 777 /var/webserver_monitor"))

# Print the RSpec to the enclosing page.
portal.context.printRequestRSpec()
