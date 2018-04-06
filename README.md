# agnostic-firewall
Manage your Netfilter rules whitout worring about IPv4 IPv6 protocols.

### The base idea: on dual-stack (IPv4/IPv6), most of the Netfilter rules are identical.
### The goal: factorize as much as possible the Netfilter rules.

# Installation:
````
git clone https://github.com/lspagnol/agnostic-firewall
cd agnostic-firewall
sh install.sh
````
# Configuration:

## */etc/firewall/firewall.cf*
* Main configuration file.
* The rulesets filenames can be changed by editing the `RULES` variable.
* IPv4 or IPv6 firewall can be disabled by uncomment `V4_DISABLE` or `V6_DISABLE`.

## */etc/firewall/Base.rules*
* Basic common rules: loopback, established, routing and IPv6 neighbor, various ICMP, ...

## */etc/firewall/Admin.rules*
* Allow connexions from your administrative hosts or networks.

## */etc/firewall/Services.rules*
* Grant **only necessary access** from the world to your server,
* give it **only necessary access** to the world (such as LDAP, SQL, ...),

# Syntax of rules:
* Just replace `iptables/ip6tables` with `ipt`.
* The script will try to know if rules apply to IPv4, IPv6 or both:
  * check type of IP addresses,
  * resolve V4/V6 addresses for host/fqdn based rule.
* Declaration can be explicit: use `ipt4` or `ipt6` instead of `ipt`.

# Usage:

## Rules management:
* Edit the ruleset of your services: `nano /etc/firewall/Services.rules`
* Compile your rules: `firewall compile`
* Try your rules (with automatic flush of rules for nuts like me ...) : `firewall try`
* It's okay ? ... then apply your rules: `firewall apply`
* Save the Netfilter rules (they will be applied at boot time): `firewall save`
  * The *compiled* IPv4 rules are stored in `/etc/firewall/firewall_V4.sv`
  * The *compiled* IPv6 rules are stored in `/etc/firewall/firewall_V6.sv`
* If you have done some minor changes on your rules or you whish to update them (FQDN resolution): just do `firewall update`

## Firewall management:
* Start firewall: `firewall start` or `service firewall start`
* Stop firewall (flush rules and set policy to *accept*): `firewall stop` or `service firewall stop`
