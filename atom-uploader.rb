require 'net/http'
require "uri"
require 'json'

url = URI.parse('https://atom.io')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
req = Net::HTTP::Get.new("/api/updates")

res = http.request(req)

if res.code != "200"
  puts "Error Code: " + res.code
  raise res.body
end

body = JSON.parse(res.body)

atom_version = body["name"]

puts "Atom Version: " + atom_version

url = URI.parse('https://packagecloud.io')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
req = Net::HTTP::Get.new("/api/v1/repos/joshua-anderson/atom/package/deb/ubuntu/trusty/atom/amd64/versions.json")
req.basic_auth ENV['PACKAGECLOUD_TOKEN'], ''

res = http.request(req)

if res.code != "200"
  puts "Error Code: " + res.code
  raise res.body
end
body = JSON.parse(res.body)

uploaded_version = body[0]["version"]

puts 'Uploaded Version: ' + uploaded_version

if atom_version == uploaded_version
  puts 'Already up to date!'
  exit
end

raise "Error" if !system('curl -L -o $PWD/atom.deb https://atom.io/download/deb')
raise "Error" if !system('bundle exec package_cloud push joshua-anderson/atom/ubuntu/trusty atom.deb')
raise "Error" if !system("bundle exec package_cloud yank joshua-anderson/atom/ubuntu/trusty atom_#{uploaded_version}_amd64.deb")
raise "Error" if !system('bundle exec package_cloud push joshua-anderson/atom/ubuntu/wily atom.deb')
raise "Error" if !system("bundle exec package_cloud yank joshua-anderson/atom/ubuntu/wily atom_#{uploaded_version}_amd64.deb")
