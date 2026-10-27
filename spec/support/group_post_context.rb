RSpec.shared_context "グループ投稿のデータ" do
  let(:group) { create(:group) }
  let(:member) { create(:user) }
  let(:outsider) { create(:user) }
  let(:author) { create(:user) }
  let!(:public_post) { create(:post, title: "public_post", user: author) }
  let!(:group_post) { create(:post, title: "group_only", description: "secret_keyword", group: group, user: author) }
  
  before do
    create(:group_membership, user: member, group: group)
  end
end