function set_repo()
{
	cat <<-__EOF__ | doas tee /etc/apk/repositories
	http://dl-cdn.alpinelinux.org/alpine/v3.24/main
	http://dl-cdn.alpinelinux.org/alpine/v3.24/community
	__EOF__
	doas apk update
	doas apk upgrade
}

function passwordless_sudo()
{
	doas apk add sudo
	doas echo "${USER} ALL=(ALL) NOPASSWD:ALL" | doas tee /etc/sudoers.d/${USER}
}

function passwordless_doas()
{
	doas echo permit nopass ${USER} | doas tee /etc/doas.d/30-${USER}.conf
}

function install_prereqs()
{
	doas apk add cgroup-tools
	doas apk add iptables
	doas apk add curl wget
	doas rc-update add cgroups default
	doas rc-service cgroups start
}

function install_my_certs()
{
	doas apk add ca-certificates
	doas cat <<-__EOF__ | doas tee /usr/local/share/ca-certificates/my-ca.crt
	-----BEGIN CERTIFICATE-----
	MIIDjDCCAnSgAwIBAgIBATANBgkqhkiG9w0BAQsFADBXMQswCQYDVQQGEwJGUjEY
	MBYGA1UECgwPQ2hyaXN0b3BoZSBMZWh5MRAwDgYDVQQLDAdSb290IENBMRwwGgYD
	VQQDDBNTeW1waG9yaW5lcyBSb290IENBMB4XDTIyMDExOTE0NTI1MFoXDTMwMTIz
	MTIzNTk1OVowVzELMAkGA1UEBhMCRlIxGDAWBgNVBAoMD0NocmlzdG9waGUgTGVo
	eTEQMA4GA1UECwwHUm9vdCBDQTEcMBoGA1UEAwwTU3ltcGhvcmluZXMgUm9vdCBD
	QTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANpyrbbfEeDJjR6yI+Zh
	eFiHkRLc001S6VpElapnWXIDi0rPU4qUlLdAe2gcWcc16Kti8iHa8T1rMmCp3JSY
	bLWj7H+HzvdAtU11qn9Tjh7tcfxlMh3a7e6IwuK2cmSirNbvSxgnihDJDnaFqtIu
	0YwtWkeJ/AL7Ux/J9Ede+Phd2yiL16Kw9Z3hboJ95DnJO+hIUayHsj6z4LOQ3Ts5
	kDppq9lzZiB1Hc2kUaNijg2nABpHxWOcr8GtZBwlba8sQ8/eifx5oqxqpbMp4inf
	AdrGf3rJXfd49VPwOTb2cvziiJBcAVGDa9OMeXBLrjZN8e4kF8xlRv7vcKhs2kln
	YbMCAwEAAaNjMGEwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYD
	VR0OBBYEFBedm+ggFtJiABRu1O/QdKT8yQQYMB8GA1UdIwQYMBaAFBedm+ggFtJi
	ABRu1O/QdKT8yQQYMA0GCSqGSIb3DQEBCwUAA4IBAQA0RPYN6euBTgamILPbq1Br
	+HNutSEO37e0L5YTuuMZb5+6S/8+yot178Oi2ZOHrvAkcIkZm7rFvIaVw/6Y02Ik
	mDDnETIzv+gkmlFqkQUbn4qmjbhesYs+2ZdddYzBUpt9j/fQuEo/wgzkg917onQ7
	FIc1JYy3qelbb1Y4d5KcOZ0X3ztSxj1aolrcTJG5Qqkn/2uJR4M3rMn62ynNOXZZ
	hCioL6sgStVSWcBQpH/tIWwE6apjOh1fyV/UDQDtHdi48dQ1ivdTXWokxchJ++tc
	L8SlrSjQGSa2vzzzJ0JGMJgx/fFyRlVj+0uu/AteGPB1xNBk9z7dfM8DVgSTQFOg
	-----END CERTIFICATE-----
	__EOF__
	doas update-ca-certificates
}

function install_k3s()
{
	curl https://get.k3s.io | sh -
}

function config_user()
{
	mkdir -p .kube
	doas cp /etc/rancher/k3s/k3s.yaml .kube/config
	doas chown chris:chris .kube/config
	cat <<-__EOF__ > .profile
	export KUBECONFIG=~/.kube/config
	alias kc='k3s kubectl'
	__EOF__
}

function save_config()
{
	doas lbu add /usr/local/bin  # sauver les executables
	doas lbu add /etc/init.d/k3s
	doas lbu add /etc/runlevels/default/k3s
	doas lbu commit
	doas lbu commit
}

function wait_for_k3s()
{
	k3s kubectl --kubeconfig=${HOME}/.kube/config wait --for=condition=available -n kube-system deploy traefik
}

doas whoami
set_repo
passwordless_sudo
passwordless_doas
install_prereqs
install_k3s
config_user
install_my_certs
save_config
wait_for_k3s

