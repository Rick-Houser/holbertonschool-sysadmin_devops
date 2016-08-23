#!/usr/bin/ruby

require 'optparse'
require 'yaml'
require 'aws-sdk'

options = {:verbose => nil, :bucketname => nil, :filepath => nil, :action => nil}

parser = OptionParser.new do |opts|
	opts.banner = "Usage: s3_script.rb [options]"
  opts.on('-v', '--verbose', 'Run verbosely') do |verbose|
    options[:verbose] = verbose;
  end
	opts.on('-b', '--bucketname=BUCKET_NAME', 'Name of the bucket to perform the action on') do |bucketname|
		options[:bucketname] = bucketname;
	end

	opts.on('-f', '--filepath=FILE_PATH', 'Path to the file') do |filepath|
		options[:filepath] = filepath;
	end

  opts.on('-a', '--action=ACTION', 'Select action to perform [list, upload, delete, download]') do |action|
		options[:action] = action;
	end

  Show usage when no options or -h & --help options without showing help in opts listing (per project reqs).
  if ARGV[1] == nil || ARGV[1] == '-h' || ARGV[1] == '--help'
    puts opts
    exit
  end
end

parser.parse!

# User credentials loaded from yaml file
credentials = YAML.load_file('config.yaml')

s3 = Aws::S3::Resource.new(
  access_key_id: credentials['access_key_id'],
  secret_access_key: credentials['secret_access_key'],
  region: 'us-west-2'
)

case options[:action]

# Return list of bucket key and hash(etag)
when 'list'
  s3.bucket(options.bucketname).objects.each do |object|
    puts '#{object.key} => #{object.etag}'
  end

# Upload file to bucket
when 'upload'
  name = File.basename(options.filepath)
  obj = s3.bucket(options.bucketname).object(name)
  obj.upload_file(options.filepath)

# Delete a file from bucket
when 'delete'
  bucket = s3.bucket(options.bucketname)
  obj = bucket.object(options.filepath)
  obj.delete

# Download file from bucket
when 'download'
  file = options.filepath
  obj = s3.bucket(options.bucketname).object(file)
  obj.get(response_target: file)

else
  exit
end
