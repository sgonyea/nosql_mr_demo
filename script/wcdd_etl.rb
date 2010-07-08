require 'rubygems'
require 'json'
require 'riak'

# ActiveSupport::JSON.backend = 'Yajl'

client      = Riak::Client.new
@buckets    = {}
links       = {}
types       = [:answers,:comments,:posts,:users]

types.each do |type|
  @buckets[type]  = client[type.to_s]
  links[type]     = Hash.new {|h,k| h[k] = [] }
end

wcdd_bucket = client["wcdd"]

wcdd_bucket.allow_mult = true

@buckets[:answers] = @buckets[:posts]

# Load the most dependent stuff first so you can link back later:
# 1) comments
# 2) answers
# 3) posts
# 4) users
def load_data_for(type)
  puts "Loading the #{type} from #{type}.json. This may take a while!"

  raw_data  = JSON.parse(File.read(File.join("sample_data","Windy-City-DB-Dataset","data","#{type}.json")))
  bucket    = @buckets[type]

  raw_data[type.to_s].each do |item|
    key               = Riak::Key.new(bucket, item['Id'])
    key.content.value = item

    yield key, item if block_given?

    key.save(:w => 1, :return_body => false)
    print "."; $stdout.flush
  end
  puts  
end

load_data_for(:comments) do |key, json|
  user, post        = json['UserId'], json['PostId']
  content           = key.content
  content.link_key({
    :user => @buckets[:users][user],
    :post => @buckets[:posts][post]
  })
  links[:users][user] << {:comment => key.to_link}
  links[:posts][post] << {:comment => key.to_link}

  c         = Riak::Key.new(wcdd_bucket, :comments.to_s).content
  c.value = user
  c.save(:return_body => false)
end

load_data_for(:answers) do |key, json|
  user, post        = json['OwnerUserId'], json['ParentId']
  content           = key.content
  content.link_key({
    :owner  => @buckets[:users][user],
    :parent => @buckets[:posts][post]
  })
  content.links.merge({:posts => links[:posts][key.name]})
  links[:users][user] << {:answer => key.to_link}
  links[:posts][post] << {:answer => key.to_link}

  c               = Riak::Key.new(wcdd_bucket, :answers.to_s).content
  c.value = user
  c.save(:return_body => false)
end

load_data_for(:posts) do |key, json|
  user              = json['OwnerUserId']
  content           = key.content
  content.link_key({
    :owner  => @buckets[:users][user]
  })
  content.links.merge({:posts => links[:posts][key.name]})
  links[:users][user] << {:question => key.to_link}

  c               = Riak::Key.new(wcdd_bucket, :posts.to_s).content
  c.value = user
  c.save(:return_body => false)
end

load_data_for(:users) do |key, json|
  content = key.content
  content.links.merge({:users => links[:users][key.name]})

  c       = Riak::Key.new(wcdd_bucket, :users.to_s).content
  c.value = key.name
  c.save(:return_body => false)
end
