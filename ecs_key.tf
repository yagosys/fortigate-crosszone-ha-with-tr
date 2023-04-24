resource "alicloud_key_pair" "example" {
  key_pair_name   = "terraform_created_keypair_for_fortigate"
  public_key = "${file("${var.key_location}")}"
}

