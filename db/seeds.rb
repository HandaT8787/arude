# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Faker::Config.locale = :ja

bio_samples = [
  "近所の穴場スポット探しにハマっています",
  "休日はふらっと散歩に出かけるのが好きです",
  "写真映えする景色を探して歩いています",
  "静かな場所でゆっくり過ごすのが好きです",
  "子どもと一緒に近くの公園巡りをしています",
  "地元にまだまだ知らない場所があると気づかされます"
]

locations = [
  { prefecture: "東京都", city: "千代田区", lat: 35.681236, lng: 139.767125 },
  { prefecture: "大阪府", city: "大阪市", lat: 34.702485, lng: 135.495951 },
  { prefecture: "愛知県", city: "名古屋市", lat: 35.170915, lng: 136.881537 },
  { prefecture: "北海道", city: "札幌市", lat: 43.062096, lng: 141.354376 },
  { prefecture: "福岡県", city: "福岡市", lat: 33.590355, lng: 130.401716 },
  { prefecture: "滋賀県", city: "大津市", lat: 35.004531, lng: 135.868590 },
]

10.times do |i|
  location = locations.sample
  user = User.create!(
    name: Faker::Name.name,
    username: "#{Faker::Internet.username(specifier: 2..8).gsub(".", "_")}_#{i}",
    email_address: "user#{i}@example.com",
    password: "password123",
    bio: bio_samples.sample
  )
  user.move_to!(prefecture: location[:prefecture], city: location[:city])
end

users = User.all

post_samples = [
  { title: "静かな水辺のベンチ", description: "夕日がきれいでゆっくりとした時間を過ごせます", category: "ベンチ" },
  { title: "隠れた散歩道", description: "緑が多く季節ごとの変化を楽しめます", category: "散歩スポット" },
  { title: "小さな神社", description: "静かで落ち着いた雰囲気があります", category: "神社・歴史" },
  { title: "写真映えする公園", description: "花や木々が美しく写真を撮るのにおすすめです", category: "写真スポット" },
  { title: "地元で人気の自然スポット", description: "自然の中でリフレッシュできる場所です", category: "自然" },
  { title: "眺めの良い高台", description: "街並みを見渡せる隠れたスポットです", category: "景色" },
]



20.times do |i|
  sample = post_samples.sample
  location = locations.sample
  Post.create!(
    title: sample[:title],
    description: sample[:description],
    category: sample[:category],
    latitude: location[:lat] + rand(-0.05..0.05),
    longitude: location[:lng] + rand(-0.05..0.05),
    user: users.sample
  )
end