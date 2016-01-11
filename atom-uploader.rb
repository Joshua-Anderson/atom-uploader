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

url = URI.parse('https://api.bintray.com/')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
req = Net::HTTP::Get.new("/packages/joshua-anderson/atom/atom/versions/_latest")
req.basic_auth 'joshua-anderson', ENV['BINTRAY_TOKEN']

res = http.request(req)

if res.code != "200"
  puts "Error Code: " + res.code
  raise res.body
end

body = JSON.parse(res.body)

uploaded_version = body["name"]

puts "Uploaded Version: " + uploaded_version

if atom_version == uploaded_version
  puts 'Already up to date!'
  exit
end

req = Net::HTTP::Post.new("/packages/joshua-anderson/atom/atom/versions")
req.basic_auth 'joshua-anderson', ENV['BINTRAY_TOKEN']
req.body = "{
\"name\":\"#{atom_version}\",
}"
req.content_type = 'application/json'

res = http.request(req)

if res.code != "201"
  puts "Error Code: " + res.code
  raise res.body
end

puts "Created Version: " + atom_version

raise "Error" if !system('curl -L -o $PWD/atom.deb https://atom.io/download/deb')

puts "Downloaded Version: " + atom_version

raise "Error" if !system("curl -T atom.deb -H \"X-Bintray-Debian-Distribution: wheezy\" -H \"X-Bintray-Debian-Component: main\" -H \"X-Bintray-Debian-Architecture: amd64\" -ujoshua-anderson:#{ENV['BINTRAY_TOKEN']} https://api.bintray.com/content/joshua-anderson/atom/atom/#{atom_version}/pool/main/a/atom_#{atom_version}_amd64.deb")

req = Net::HTTP::Post.new("/content/joshua-anderson/atom/atom/#{atom_version}/publish")
req.basic_auth 'joshua-anderson', ENV['BINTRAY_TOKEN']

res = http.request(req)

if res.code != "200"
  puts "Error Code: " + res.code
  raise res.body
end

puts "Published Version: " + atom_version
