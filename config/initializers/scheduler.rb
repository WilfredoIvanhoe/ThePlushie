require 'rufus-scheduler'
require 'uri'
require 'net/http'
require 'net/https'
require 'date'
require 'json'

s = Rufus::Scheduler.singleton
def send_notif(message)
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
			\"message\": \"#{message}\"
			}	
	}"
	res = https.request(req)
	puts res.body
end
s.every '30s' do 
	post = Post.order(f_id: :desc).limit(1)[0]
	uri = URI(URI.escape 'https://graph.facebook.com/NeroFledermaus/feed?access_token=179212699090439|yOxoAMG_SOjIs3c5jkldeJDSSgw')
	Net::HTTP.start(uri.host, uri.port,
		:use_ssl => uri.scheme == 'https') do |http|
		request = Net::HTTP::Get.new uri

		response = http.request request
		f_posts = JSON.parse response.body

		f_last_post = f_posts['data'][0]

		puts "#{f_last_post['id']} == #{post.f_id}"

		unless f_last_post['id'].eql? post.f_id
			if f_last_post.has_key?('story')
				Post.create(message: f_last_post['story'], created_time: f_last_post['created_time'], f_id: f_last_post['id'] )
				send_notif(f_last_post['story'])
			else
				Post.create(message: f_last_post['message'], created_time: f_last_post['created_time'], f_id: f_last_post['id'] )
				send_notif(f_last_post['message'])
			end
		end
	end
end
