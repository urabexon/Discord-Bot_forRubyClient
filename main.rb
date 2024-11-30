require "./src/RIN.rb"
require "json"

rin_config = open("./config.json") do |io|
	JSON.load(io)
end

rin = RIN.new(rin_config['Token'], rin_config['Prefix'])
rin.run