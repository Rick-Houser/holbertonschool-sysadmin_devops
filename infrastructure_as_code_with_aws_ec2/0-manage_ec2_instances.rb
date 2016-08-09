#!/usr/bin/env ruby
require 'bundler/setup'
require 'optparse'
Bundler.require

creds = YAML.load_file("config.yaml", safe: true)
instance = Aws::EC2::Client.new(
		region: 'us-west-2',
		credentials: Aws::Credentials.new(creds['access_key_id'],
																			creds['secret_access_key'])
)

options = {}
OptionParser.new do |opt|
  opt.on('-a', '--action ACTION') { |o| options[:action] = o }
	opt.on('-i', '--instance_id INSTANCE') { |o| options[:instance] = o }
end.parse!

case options[:action]
when "launch" # create the instance (and launch it)
	ec2 = instance.run_instances(image_id: creds["image_id"],
														  min_count: 1, # required
														  max_count: 1, # required
														  key_name: creds['key_pair'],
														  security_group_ids: creds["security_group_ids"],
														  instance_type: creds["instance_type"],
														  placement: {
																availability_zone: creds["availability-zone"]
															})
	puts "Launching machine ..."
	inst_id = ec2.instances[0].instance_id
	puts inst_id
	puts instance.db_instances[0]

when "stop"
	ec2 = Aws::EC2::Resource.new(region: 'us-west-2',
															credentials: Aws::Credentials.new(creds['access_key_id'],
																																creds['secret_access_key']))

	# Stop instance if it exists
	ec2.instances.each do |i|
		if i.id == options[:instance] && i.state.name != "stopped"
			i.stop
		end
		# Can also compare status codes.
		# if i.exists?
		# 	case i.state.code
		# 	when 48  # terminated
		# 		puts "#{id} is terminated, so you cannot stop it"
		# 	when 64  # stopping
		# 		puts "#{id} is stopping, so it will be stopped in a bit"
		# 	when 89  # stopped
		# 		puts "#{id} is already stopped"
		# 	else
		# 		i.stop
		# 	end
		# end
	end

when "start"
	ec2 = Aws::EC2::Resource.new(region: 'us-west-2',
															credentials: Aws::Credentials.new(creds['access_key_id'],
																																creds['secret_access_key']))

	# Start instance, wait for it to run, then show public dns
	ec2.instances.each do |i|
		if i.id == options[:instance]
			i.start
			i.wait_until_running
			puts i.public_dns_name
		end
	end

when "terminate"
	ec2.instances.each do |i|
		if i.id == options[:instance]
			i.terminate
		end
	end
	
else
	puts "Invalid action"
end
