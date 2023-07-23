# terraform.tfvars

# Replace the values with your desired configuration
project_id = "jovial-totality-390103"
region = "us-central1"
zone = "us-central1-a" # Replace with the desired zone or remove this line if not needed
subnetwork = "projects/jovial-totality-390103/regions/us-central1/subnetworks/default"
num_instances = 1
// nat_ip = "x.x.x.x" # Replace with the public IP address or remove this line if not needed
network_tier = "STANDARD"
hostname = "webserver-prod"
service_account = {
  email = "terraform-sa@jovial-totality-390103.iam.gserviceaccount.com"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/compute"
  ]
}
