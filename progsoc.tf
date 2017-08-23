variable "do_token" {}
variable "do_region" { default = "sfo2" }
variable "enable_ipv6" { default = false }

variable "cf_email" {}
variable "cf_token" {}

variable "ps_domain" { default = "progsoc.org" }

provider "digitalocean" {
	token = "${var.do_token}"
}

provider "cloudflare" {
	email = "${var.cf_email}"
	token = "${var.cf_token}"
}

resource "digitalocean_ssh_key" "provisioning" {
	name = "ProgSoc Provisioning SSH Key"
	public_key = "${file("provisioning_id_rsa.pub")}"
}

resource "digitalocean_droplet" "crypt" {
	name               = "crypt.${var.ps_domain}"
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

resource "cloudflare_record" "crypt" {
	domain = "${var.ps_domain}"
	name   = "crypt"
	type   = "A"
	value  = "${digitalocean_droplet.crypt.ipv4_address}"
}

resource "cloudflare_record" "crypt-private" {
	domain = "${var.ps_domain}"
	name   = "crypt-private"
	type   = "A"
	value  = "${digitalocean_droplet.crypt.ipv4_address_private}"
}

resource "digitalocean_droplet" "muspell" {
	name               = "muspell.${var.ps_domain}"
	size               = "1gb"
	backups            = true
	private_networking = true
	ipv6               = "${var.enable_ipv6}"
	ssh_keys           = ["${digitalocean_ssh_key.provisioning.id}"]
	image              = "ubuntu-12-04-x32"
	region             = "${var.do_region}"
}

resource "cloudflare_record" "muspell" {
	domain = "${var.ps_domain}"
	name   = "muspell"
	type   = "A"
	value  = "${digitalocean_droplet.muspell.ipv4_address}"
}

resource "cloudflare_record" "muspell-private" {
	domain = "${var.ps_domain}"
	name   = "muspell-private"
	type   = "A"
	value  = "${digitalocean_droplet.muspell.ipv4_address_private}"
}

resource "digitalocean_droplet" "niflheim" {
	name               = "niflheim.${var.ps_domain}"
	size               = "1gb"
	backups            = true
	private_networking = true
	ipv6               = "${var.enable_ipv6}"
	ssh_keys           = ["${digitalocean_ssh_key.provisioning.id}"]
	image              = "ubuntu-12-04-x32"
	region             = "${var.do_region}"
}

resource "cloudflare_record" "niflheim" {
	domain = "${var.ps_domain}"
	name   = "niflheim"
	type   = "A"
	value  = "${digitalocean_droplet.niflheim.ipv4_address}"
}

resource "cloudflare_record" "niflheim-private" {
	domain = "${var.ps_domain}"
	name   = "niflheim-private"
	type   = "A"
	value  = "${digitalocean_droplet.niflheim.ipv4_address_private}"
}
