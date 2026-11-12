require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "#local_badge" do
    it "近所歴が空欄ならバッチは表示されない" do
      post = build(:post, local_years_at_post: nil)
      expect(post.local_badge).to be_nil
    end

    it "近所歴が1年未満なら1年未満と表示" do
      post = build(:post, local_years_at_post: 0)
      expect(post.local_badge).to eq("近所歴1年未満")
    end

    it "近所歴が年数ありなら年数を表示" do
      post = build(:post, local_years_at_post: 3)
      expect(post.local_badge).to eq("近所歴3年")
    end
  end

  describe "#snapshot_local_years" do
    let(:user) { create(:user) }

    it "投稿者がいないなら表示されない" do
      post = create(:post, user: nil)
      expect(post.local_years_at_post).to be_nil
    end

    it "居住地が一致しないなら表示されない" do
      build(:residence, user: user, prefecture: "東京都", city: "江東区").save(validate: false)
      post = create(:post, user: user)
      expect(post.local_years_at_post).to be_nil
    end

    it "居住地が一致して居住歴が3年なら" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2023, 1, 1))
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(3)
      end
    end

    it "同じ居住地が2つ以上あれば居住歴を合算する" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2020, 1, 1), ended_on: Date.new(2021, 6, 30))
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2025, 2, 1), ended_on: nil)
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(3)
      end
    end

    it "居住歴が1年未満なら0" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2026, 2, 1), ended_on: nil)
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(0)
      end
    end

    it "過去の居住地のみ一致するなら居住歴表示" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2023, 1, 1), ended_on: Date.new(2025, 1, 30))
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(2)
      end
    end
  end

  describe "座標からの地名取得" do
    after do
      [[21.03, 105.85], [10.0, 100.0], [20.0, 110.0]].each do |q|
        Geocoder::Lookup::Test.delete_stub(q)
      end
    end
    it "先頭に日本以外の結果が来たなら日本の結果を採用" do
      Geocoder::Lookup::Test.add_stub(
        [21.03, 105.85], 
        [
          {'coordinates' => [21.03, 105.85], 'state' => 'Hà Nội', 'city' => 'Phúc Thịnh', 'country_code' => 'VN'},
          {'coordinates' => [21.03, 105.85], 'state' => '大阪府', 'city' => '大阪市', 'country_code' => 'JP'}
        ]
      )
      post = create(:post, latitude: 21.03, longitude: 105.85)
      expect(post.prefecture).to eq("大阪府")
      expect(post.city).to eq("大阪市")
    end

    it "cityが空なら次の結果を採用" do
      Geocoder::Lookup::Test.add_stub(
        [10.0, 100.0], 
        [
          {'coordinates' => [10.0, 100.0], 'state' => '福岡県', 'city' => nil, 'country_code' => 'JP'},
          {'coordinates' => [10.0, 100.0], 'state' => '大阪府', 'city' => '大阪市', 'country_code' => 'JP'}
        ]
      )
      post = create(:post, latitude: 10.0, longitude: 100.0)
      expect(post.prefecture).to eq("大阪府")
      expect(post.city).to eq("大阪市")
    end

    it "日本の結果がない時は指定値のまま" do
      Geocoder::Lookup::Test.add_stub(
        [20.0, 110.0], 
        [
          {'coordinates' => [20.0, 110.0], 'state' => 'Hà Nội', 'city' => 'Phúc Thịnh', 'country_code' => 'VN'}
        ]
      )
      post = create(:post, prefecture: "東京都", city: "江東区", latitude: 20.0, longitude: 110.0)
      expect(post.prefecture).to eq("東京都")
      expect(post.city).to eq("江東区")
    end
  end

  describe "タグ数制限" do
    it "タグが10個なら成功" do
      tag_names = (1..10).map { |i| "タグ#{i}" }.join(",")
      post = build(:post, tag_names: tag_names)
      expect(post.valid?).to eq(true)
    end

    it "タグが11個ならエラー" do
      tag_names = (1..11).map { |i| "タグ#{i}" }.join(",")
      post = build(:post, tag_names: tag_names)
      expect(post.valid?).to eq(false)
      expect(post.errors[:tag_names]).to be_present
    end

    it "タグ数が未指定なら成功" do
      expect(build(:post).valid?).to eq(true)
    end
  end

  describe ".visible_to" do
    let(:member) { create(:user) }
    let(:outsider) { create(:user) }
    let(:group_a) { create(:group) }
    let(:group_b) { create(:group) }
    let(:admin) { create(:user, is_admin: true) }
    let!(:post_a) { create(:post, group: group_a) }
    let!(:post_b) { create(:post, group: group_b) }
    let!(:public_post) { create(:post) }

    before do
      create(:group_membership, user: member, group: group_a)
    end

    it "未ログインなら全体公開のみ" do
      expect(Post.visible_to(nil)).to contain_exactly(public_post)
    end

    it "メンバーなら全体公開と所属グループ" do
      expect(Post.visible_to(member)).to contain_exactly(public_post, post_a)
    end

    it "メンバーでないなら全体公開のみ" do
      expect(Post.visible_to(outsider)).to contain_exactly(public_post)
    end

    it "管理者なら全ての投稿" do
      expect(Post.visible_to(admin)).to contain_exactly(public_post, post_a, post_b)
    end
  end

  describe "グループ所属の検証" do
    let(:group) { create(:group) }
    let(:member) { create(:user) }
    let(:outsider) { create(:user) }

    before do
      create(:group_membership, user: member, group: group)
    end

    it "所属グループへの投稿は出来る" do
      group_post = build(:post, user: member, group: group)
      expect(group_post.valid?).to eq(true)
    end

    it "所属していないグループへの投稿は出来ない" do
      group_post = build(:post, user: outsider, group: group)
      expect(group_post.valid?).to eq(false)
      expect(group_post.errors[:group_id]).to be_present
    end

    it "全体公開は出来る" do
      public_post = build(:post, user: outsider, group: nil)
      expect(public_post.valid?).to eq(true)
    end

    it "投稿者無しは出来る" do
      no_user_post = build(:post, user: nil, group: group)
      expect(no_user_post.valid?).to eq(true)
    end
  end

  describe ".own_or_visible_to" do
    include_context "グループ投稿のデータ"

    let(:leaver) { create(:user) }

    it "全体公開の投稿が含まれる" do
      expect(Post.own_or_visible_to(outsider)).to include(public_post)
    end

    it "未所属の人には、他人のグループ投稿が含まれない" do
      expect(Post.own_or_visible_to(outsider)).not_to include(group_post)
    end

    it "参加者のグループの投稿が含まれる" do
      expect(Post.own_or_visible_to(member)).to include(group_post)
    end

    context "グループを退会した本人の時" do
      it "自分の投稿は含まれるが、visible_toには含まれない" do
        membership = create(:group_membership, user: leaver, group: group)
        leaver_post = create(:post, user: leaver, group: group)
        membership.destroy
        leaver.reload

        expect(Post.own_or_visible_to(leaver)).to include(leaver_post)
        expect(Post.own_or_visible_to(leaver)).not_to include(group_post)
        expect(Post.visible_to(leaver)).not_to include(leaver_post)
      end
    end

    it "未ログイン(nil)なら全体公開のみ" do
      expect(Post.own_or_visible_to(nil)).to include(public_post)
      expect(Post.own_or_visible_to(nil)).not_to include(group_post)
    end
  end

  describe "#group_info_visible_to?" do
    include_context "グループ投稿のデータ"
    let(:leaver) { create(:user) }

    it "全体公開の投稿なら、誰にでも true" do
      expect(public_post.group_info_visible_to?(outsider)).to be true
      expect(public_post.group_info_visible_to?(nil)).to be true
    end

    it "グループの参加者なら true" do
      expect(group_post.group_info_visible_to?(member)).to be true
    end

    it "管理者なら true" do
      admin_user = create(:user, :admin)
      expect(group_post.group_info_visible_to?(admin_user)).to be true
    end

    it "グループに入っていない人なら false" do
      expect(group_post.group_info_visible_to?(outsider)).to be false
    end

    it "グループを退会した本人なら false" do
      membership = create(:group_membership, user: leaver, group: group)
      leaver_post = create(:post, user: leaver, group: group)
      membership.destroy
      leaver.reload
      expect(leaver_post.group_info_visible_to?(leaver)).to be false
    end

    it "未ログイン（nil）なら、グループ投稿は false" do
      expect(group_post.group_info_visible_to?(nil)).to be false
    end
  end

  describe "#editable_by?" do
    include_context "グループ投稿のデータ"
    let(:leaver) { create(:user) }
    
    it "全体公開なら true" do
      expect(public_post.editable_by?(nil)).to be true
    end

    it "グループの参加者なら true" do
      expect(group_post.editable_by?(member)).to be true
    end

    it "グループに入っていない人なら false" do
      expect(group_post.editable_by?(outsider)).to be false
    end

    it "グループを退会した本人なら false" do
      membership = create(:group_membership, user: leaver, group: group)
      leaver_post = create(:post, user: leaver, group: group)
      membership.destroy
      leaver.reload
      expect(leaver_post.editable_by?(leaver)).to be false
    end

    it "未ログインの人（nil）なら false" do
      expect(group_post.editable_by?(nil)).to be false
    end

    it "グループに入っていない管理者なら false" do
      admin_user = create(:user, :admin)
      expect(group_post.editable_by?(admin_user)).to be false
    end
  end

end
