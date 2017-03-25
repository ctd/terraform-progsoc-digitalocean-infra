variable "do_token" {}
variable "do_region" { default = "sfo2" }
variable "enable_ipv6" { default = false }

provider "digitalocean" {
	token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "provisioning" {
	name = "ProgSoc Provisioning SSH Key"
	public_key = "${file("provisioning_id_rsa.pub")}"
}

resource "digitalocean_domain" "do_progsoc_org" {
	name       = "do.progsoc.org"
	ip_address = "0.0.0.0"
}

resource "digitalocean_droplet" "crypt" {
	name               = "crypt.do.progsoc.org"
	size               = "512mb"
	volume_ids         = ["${digitalocean_volume.phatdisk.id}"]
	backups            = true
	private_networking = true
	ipv6               = "${var.enable_ipv6}"
	ssh_keys           = ["${digitalocean_ssh_key.provisioning.id}"]
	image              = "ubuntu-12-04-x32"
	region             = "${var.do_region}"
}

resource "digitalocean_volume" "phatdisk" {
	region = "${var.do_region}"
	name   = "phatdisk"
	size   = 300
}

resource "digitalocean_record" "crypt_do_progsoc_org" {
	domain = "${digitalocean_domain.do_progsoc_org.name}"
	type   = "A"
	name   = "crypt"
	value  = "${digitalocean_droplet.crypt.ipv4_address}"
}

resource "digitalocean_record" "crypt-private_do_progsoc_org" {
	domain = "${digitalocean_domain.do_progsoc_org.name}"
	type   = "A"
	name   = "crypt-private"
	value  = "${digitalocean_droplet.crypt.ipv4_address_private}"
}

resource "digitalocean_droplet" "muspell" {
	name               = "muspell.do.progsoc.org"
	size               = "1gb"
	backups            = true
	private_networking = true
	ipv6               = "${var.enable_ipv6}"
	ssh_keys           = ["${digitalocean_ssh_key.provisioning.id}"]
	image              = "ubuntu-12-04-x32"
	region             = "${var.do_region}"
}

resource "digitalocean_record" "muspell_do_progsoc_org" {
	domain = "${digitalocean_domain.do_progsoc_org.name}"
	type   = "A"
	name   = "muspell"
	value  = "${digitalocean_droplet.muspell.ipv4_address}"
}

resource "digitalocean_record" "muspell-private_do_progsoc_org" {
	domain = "${digitalocean_domain.do_progsoc_org.name}"
	type   = "A"
	name   = "muspell-private"
	value  = "${digitalocean_droplet.muspell.ipv4_address_private}"
}

resource "digitalocean_droplet" "niflheim" {
	name               = "niflheim.do.progsoc.org"
	size               = "1gb"
	backups            = true
	private_networking = true
	ipv6               = "${var.enable_ipv6}"
	ssh_keys           = ["${digitalocean_ssh_key.provisioning.id}"]
	image              = "ubuntu-12-04-x32"
	region             = "${var.do_region}"
}

resource "digitalocean_record" "niflheim_do_progsoc_org" {
	domain = "${digitalocean_domain.do_progsoc_org.name}"
	type   = "A"
	name   = "niflheim"
	value  = "${digitalocean_droplet.niflheim.ipv4_address}"
}

resource "digitalocean_record" "niflheim-private_do_progsoc_org" {
	domain = "${digitalocean_domain.do_progsoc_org.name}"
	type   = "A"
	name   = "niflheim-private"
	value  = "${digitalocean_droplet.niflheim.ipv4_address_private}"
}
