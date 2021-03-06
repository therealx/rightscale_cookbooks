#
# Cookbook Name:: app
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

rightscale_marker

class Chef::Recipe
  include RightScale::App::Helper
end

# Adding iptables rule to allow loadbalancers <-> application servers connections
pool_names(node[:lb][:pools]).each do |pool_name|
  # See cookbooks/sys_firewall/providers/default.rb for the "update" action.
  sys_firewall "Open this appserver's ports to all loadbalancers" do
    machine_tag "loadbalancer:#{pool_name}=lb"
    port node[:app][:port].to_i
    enable true
    ip_tag "server:#{node[:app][:backend_ip_type]}_ip_0"
    action :update
  end
end
