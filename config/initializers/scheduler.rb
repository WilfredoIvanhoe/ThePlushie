require 'rufus-scheduler'
require 'uri'
require 'net/http'
require 'net/https'
require 'date'

s = Rufus::Scheduler.singleton

s.every '5s' do 
	post = Post.order(f_id: :desc).limit(1)
	puts post[0].f_id
=begin
	x = 1
	post_req = lambda { 
		uri = URI.parse("https://android.googleapis.com/gcm/send")
		https = Net::HTTP.new(uri.host,uri.port)
		https.use_ssl = true
		req = Net::HTTP::Post.new(uri.path)
		req.add_field('Authorization', 'key=AIzaSyBVZc7qt_OMU_MBvxj8-bGpNUb1PlF-eL8')
		req.add_field("Content-Type", "application/json")
		req.body = "{
		\"to\": \"/topics/global\",
			\"data\": {
				\"title\": \"Amaya\",
				\"message\": \"Mira, se contar: #{x}\"
				}	
		}"
		res = https.request(req)
		puts res.body
	}
	post_req.call	
	x = x + 1
=end

end