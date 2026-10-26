Geocoder.configure(lookup: :test, ip_lookup: :test)
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'coordinates' => [35.18, 136.9],
      'state' => '愛知県',
      'city' => '名古屋市',
      'country_code' => 'JP'
    }
  ]
)