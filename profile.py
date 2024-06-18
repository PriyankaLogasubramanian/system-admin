import geni.portal as portal
import geni.rspec.pg as rspec

# Create a Request object to start building the RSpec.
request = portal.context.makeRequestRSpec()

# Node 1: Ansible Master
node1 = request.RawPC("node1")
node1.hardware_type = "c8220"  # Change this to the desired hardware type
node1.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU20-64-STD"  # Use a suitable image
node1.addService(rspec.Execute(shell="sh", command="sudo apt-get update && sudo apt-get install -y ansible"))

# Node 2: Ansible Host
node2 = request.RawPC("node2")
node2.hardware_type = "c8220"  # Change this to the desired hardware type
node2.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU20-64-STD"  # Use a suitable image
node2.addService(rspec.Execute(shell="sh", command="sudo apt-get update && sudo apt-get install -y apache2"))

# Define the link between the nodes
link = request.Link(members=[node1, node2])

# Print the RSpec to the enclosing page.
portal.context.printRequestRSpec()
