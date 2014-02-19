# -*- coding:utf-8 -*-
# How to use
# 
# bundle exec ruby ./archiber.rb -u -g 339881266150122 -o ./user.json

require 'bundler/setup'

require 'optparse'
require 'fb_graph'
require 'yaml'
require 'json'

ACCESS_TOKEN = ENV['ACCESS_TOKEN']
raise "ACCESS_TOKEN not found" if ACCESS_TOKEN.nil? || ACCESS_TOKEN.empty?

isUserMode = true
outFile = nil
groupId = nil
OptionParser.new do | parser | 
	parser.on('-g group id', '--group_id group id') { | gid | groupId = gid }
	parser.on('-u', '--user') { | boolean | isUserMode = true }
	parser.on('-p', '--post') { | boolean | isUserMode = false }
	parser.on('-o output file path', '--out output file path') { | val | outFile = val }
	parser.parse!(ARGV)
end

if outFile.nil? || groupId.nil?
	puts "-o, --out で出力先ファイルを指定してください"
	puts "-g, --group_id でgroup idを指定してください"	
	exit 1
end

puts "#{groupId}の情報を取得します"
group =  FbGraph::Group.fetch(groupId, access_token: ACCESS_TOKEN)
puts "name : #{group.name} , updated_time : #{group.updated_time}"

if isUserMode then

	members = group.members
	puts "members count is #{members.length}"
	File.open(outFile, "w") do |file| 
		file.write(JSON.dump(members))
	end

else
	allFeeds = []
	feeds = group.feed(limit: 250)
	p "#{feeds.length}件取得"

	begin
		allFeeds.concat(feeds)
		feeds = feeds.next
		p "#{feeds.length}件取得"
	end while !feeds.nil? && !feeds.empty?

	puts "全投稿件数 : #{allFeeds.length}"
	File.open(outFile, 'w') do | file | 
		file.write(JSON.dump(allFeeds))
	end

end
